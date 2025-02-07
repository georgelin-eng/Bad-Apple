`include "params.sv"

// FSM states
// IDLE      -> REQ_V       : default state. Transition if with init. button is pressed or current video frame has finished displaying
// REQ_V     -> PARSE_V     : send a data data request to slave, transition once the request has been sent
// PARSE_V   -> RECEIVE_V   : continuously check MISO line for the video data header. Stay in this state until packet parse condition is met
// RECEIVE_V -> REQ_A       : transition after video frames have been received
// REQ_A     -> PARSE_A     : continuously check MISO line for the audio data header. Stay in this state until packet parse condition is met
// RECEIVE_A -> IDLE        : transition after audio has been received


// Control registers don't need to be set. We instead configure the verilog to act in a certain mode. Change software side to fit this.
// Note: Correct timing on the frame_done signal will ensure that neither video or audio buffer overflows

module DATA_FSM (
    input  wire     CLK_40,
    input  wire     SPI_clk,
    input  wire     SPI_clk_CDC,
    input  wire     data_write_clk,
    input  wire     data_write_clk_CDC,
    input  wire     SPI_clk_rising_edge, 
    input  wire     SPI_clk_falling_edge, 
    input  wire     data_clk_rising_edge,
    input  wire     data_clk_falling_edge,
    input  wire     reset,

    // video data control signals
    input  logic     start_req,  // set every ~1s in MODE_FSM as switch_mode
    output logic     video_data_ready,
    output logic     audio_data_ready,


    // SPI signals
    input  wire     MISO,             // MISO
    output logic    chip_select,      // SS

    // Audio data control signals
    output logic    received_bit      // received data that is to be used by video
);
    // Internal signals for managing SPI communications
    // An incoming bit is buffered into a FIFO then read out on the positive edge of the data_write_clk
    // Received bits are fed into a packet header buffer to process an incoming data packet 
    // which will contain the video and audio data
    // This is necessary since the way to communicate from the PC that data is ready will have inconsistent timing
    // due to software limitations. Instead data is preceded by xFF which will be parsed
    reg       [7:0]       DATA_HEADER_BUFF;     // Input - buffer to store the MISO data when in parse modes
    reg       [15:0]      AUDIO_BUFF;          // Input - buffer to store the MISO data for audio. If might be a diff. size than the data header
    logic                 parse_done, parse_en, wait_en, cal_en, cal_done;
    logic                 video_early_transition, video_sync_counter_early_en;

    /////////////////////////////
    //      Shift Register     //
    /////////////////////////////

    always_ff @ (posedge CLK_40) begin
        if (reset || parse_done) begin // flush the data header buff after a parse is done
            DATA_HEADER_BUFF  <= 'b0;
            AUDIO_BUFF        <= 'b0;   
        end else begin
            if (parse_en) begin
                if (data_clk_falling_edge) begin
                    DATA_HEADER_BUFF <= {DATA_HEADER_BUFF[6:0], received_bit};
                    AUDIO_BUFF       <= {AUDIO_BUFF [14:0], received_bit};
                end
            end 
            else begin
                DATA_HEADER_BUFF <= 'b0;
            end
            
        end
    end


    /////////////////////////////
    //           FSM           //
    /////////////////////////////


    typedef enum logic [3:0] {IDLE, WAIT_SPI, FILL_FIFO, PARSE, RECEIVE_V, FINISH_V, RECEIVE_A, EMPTY_FIFO, XX} statetype;
    statetype state, nextstate;
    
    logic       fill_FIFO;
    logic       settle_done, sync_FIFO_done;
    logic       FIFO_empty, FIFO_full;
    logic       FIFO_read_en, FIFO_write_en;
    logic [7:0] DATA_HEADER_XNOR_BUFF;
    logic [3:0] num_match;
    logic [3:0] cmd_bit_count;
    logic       video_bank_full;
    logic       audio_bank_full;


    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset)  state <= IDLE; 
        else        state <= nextstate;
    end


    // This is added so that my state transitions will only happen on the data_clk
    logic wait_spi_transition;
    logic wait_spi_transition_latched;
    always_ff @( posedge CLK_40 ) begin 
        if (reset) begin
            wait_spi_transition_latched <= 1'b0;
            wait_spi_transition         <= 1'b0;
        end
        else if (SPI_clk_rising_edge) begin 
            wait_spi_transition_latched <= 1'b1;
        end
        else if (SPI_clk_falling_edge & wait_spi_transition) begin
            wait_spi_transition_latched <= 1'b0;
            wait_spi_transition         <= 1'b0;
        end
        
        if (data_clk_rising_edge & wait_spi_transition_latched) begin
            wait_spi_transition <= 1'b1;
        end
    end

    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE      : if (start_req)              nextstate = WAIT_SPI;
                        else                        nextstate = IDLE;     // idle basically means just display video without sending requests / doing writing
            WAIT_SPI  : if (wait_spi_transition)    nextstate = FILL_FIFO;
                        else                        nextstate = WAIT_SPI;
            FILL_FIFO : if (sync_FIFO_done)         nextstate = PARSE;
                        else                        nextstate = FILL_FIFO;
            PARSE     : if (parse_done)             nextstate = RECEIVE_V;
                        else                        nextstate = PARSE;             
            RECEIVE_V : if (video_bank_full)        nextstate = EMPTY_FIFO;
                        else                        nextstate = RECEIVE_V;
            // RECEIVE_A : if (audio_bank_full)     nextstate = EMPTY_FIFO;
                        // else                     nextstate = RECEIVE_A;
            EMPTY_FIFO: if (FIFO_empty)             nextstate = IDLE;
                        else                        nextstate = EMPTY_FIFO;
        endcase
    end

    // registered output logic
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            parse_en       <=  1'b0;
            fill_FIFO      <=  1'b0;
            cmd_bit_count  <=  'b0;
            chip_select    <= 1'b1; // chip_select is high as default and active low for communications
            DATA_HEADER_XNOR_BUFF <= 8'b0;
        end 
        else if (data_clk_rising_edge) // should happen aligned with the data_write_clk
        begin
            parse_en          <= 1'b0;
            video_data_ready  <= 1'b0;  // defaults. Set only the signals that change and they are registered. 
            audio_data_ready  <= 1'b0;
            parse_done        <= 1'b0;
            FIFO_write_en     <= 1'b0;
            FIFO_read_en      <= 1'b0;
            fill_FIFO         <= 1'b0;
            chip_select       <= 1'b1; // active low
            video_sync_counter_early_en <= 1'b0;

            DATA_HEADER_XNOR_BUFF <= 8'b0;
            num_match <= 4'b0;

            case(nextstate)
                WAIT_SPI  : chip_select   <= 1'b0;

                FILL_FIFO : begin 
                                FIFO_write_en <= 1'b1;  // write but don't read
                                fill_FIFO     <= 1'b1;
                                chip_select   <= 1'b0;
                            end 

                PARSE     : begin
                                FIFO_write_en <= 1'b1;  // write but don't read
                                FIFO_read_en  <= 1'b1;
                                parse_en      <= 1'b1;
                                chip_select   <= 1'b0;

                                DATA_HEADER_XNOR_BUFF <= ~(DATA_HEADER_BUFF ^ `DATA_HEADER);

                                num_match <= DATA_HEADER_XNOR_BUFF[0] + 
                                             DATA_HEADER_XNOR_BUFF[1] +
                                             DATA_HEADER_XNOR_BUFF[2] +
                                             DATA_HEADER_XNOR_BUFF[3] +
                                             DATA_HEADER_XNOR_BUFF[4] +
                                             DATA_HEADER_XNOR_BUFF[5] +
                                             DATA_HEADER_XNOR_BUFF[6] +
                                             DATA_HEADER_XNOR_BUFF[7];

                                parse_done <=(num_match >= 4); // higher to sample later
                             end

                RECEIVE_V : begin 
                                chip_select <= 1'b0;
                                video_sync_counter_early_en <= 1'b1;
                                video_data_ready <= 1'b1;
                                FIFO_write_en <= 1'b1;
                                FIFO_read_en <= 1'b1;
                            end

                RECEIVE_A : begin
                                chip_select <= 1'b0;
                                audio_data_ready <= 1'b1;
                                FIFO_write_en <= 1'b1;
                                FIFO_read_en <= 1'b1;
                            end

                EMPTY_FIFO: FIFO_read_en <= 1'b1; // read until empty
            endcase
        end
    end

    ///////////////////////////////////////////


    delay_reset #(.N(80)) 
    delay_reset (
        .clk(CLK_40),
        .rst(reset),
        .delayed_rst(delayed_rst)
    );

    // registering the enable signals
    // (* syn_preserve = 1 *) reg FIFO_write_en_SPI_clk;
    // (* syn_preserve = 1 *) reg FIFO_read_en_data_clk;

    // always_ff @ (posedge CLK_40) begin
    //     FIFO_write_en_SPI_clk <= FIFO_write_en & SPI_clk_rising_edge;   // keep so data is written at a good time
    //     FIFO_read_en_data_clk <= FIFO_read_en & data_clk_falling_edge;  // read out so that it can be sampled on the posedge
    // end

    logic FIFO_write_en_SPI_clk;
    logic FIFO_read_en_data_clk;
    assign FIFO_write_en_SPI_clk = FIFO_write_en & SPI_clk_rising_edge;
    assign FIFO_read_en_data_clk = FIFO_read_en & data_clk_falling_edge;

    sync_FIFO SYNC_FIFO (
        .CLK_40(CLK_40),
        .reset(delayed_rst),
        .write_clk(CLK_40),
        .write_en(FIFO_write_en_SPI_clk),
        .read_clk(CLK_40), // should probably be either _CDC version or a clk that's 50% phase shifted to data_write_clk
        .read_en(FIFO_read_en_data_clk), // data comes out of FIFO on falling edge and will be written on pos edge
        .din(MISO),
        .dout(received_bit),
        .empty(FIFO_empty),
        .full(FIFO_full)
    );


   (* syn_preserve = 1 *) reg [19:0] video_write_sync_counter;

    // Switch Mode Counter Behaviour
    // An enable signal will be generated after each memory cell is filled
    // This enable signal will be on for one clock cycle and the FSM will
    // switch modes on the positive edge of the next clock cycle

    // RECEIVE_V -> EMPTY FIFO delay will be 2 clock cycles from the rising edge of data_clk
    // video_data_ready will go low on the next rising edge of data_clk

    (* syn_preserve = 1 *) reg video_sync_count_inc_en; 
    always_ff @ (posedge CLK_40) begin
       video_sync_count_inc_en <= (video_data_ready | parse_done) & data_clk_rising_edge;
    end

    always_ff @ (posedge CLK_40) begin
        if (reset) 
            video_write_sync_counter <= 'b0;
        else 
            if (video_sync_count_inc_en) begin
            video_write_sync_counter <= video_write_sync_counter + 1;
                if (video_write_sync_counter == (`VIDEO_MEM_CELL_COUNT - 1)) begin // seems to end up missing the video_bank_full?
                    video_bank_full          <= 1'b1;
                    video_write_sync_counter <= 'b0;
                end
            end
            else if (video_bank_full) video_bank_full <= 1'b0; 
            else if (chip_select)     video_write_sync_counter <= 'b0;
    end

    // FIFO delay amount 
    counter  #( .THRESHOLD(`FIFO_BUFF_AMOUNT))  
    FIFO_FILL_COUNTER (
        .clk(CLK_40),
        .reset(reset),
        .count_en(fill_FIFO),
        .clk_en(data_clk_rising_edge),
        .enable_signal(sync_FIFO_done)
    );

endmodule


module delay_reset #(parameter N = 4) (
    input clk,
    input rst,
    output reg delayed_rst
);

    // Define the shift register as an array of flip-flops
    reg [N-1:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // When rst is asserted, initialize the shift register
            shift_reg <= {N{1'b1}};
            delayed_rst <= 1'b1;
        end else begin
            // Shift the register and update the delayed_rst signal
            shift_reg <= {shift_reg[N-2:0], 1'b0};
            delayed_rst <= shift_reg[N-1];
        end
    end
endmodule