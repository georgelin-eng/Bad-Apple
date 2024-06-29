
// FSM states
// IDLE      -> REQ_V       : default state. Transition if with init. button is pressed or current video frame has finished displaying
// REQ_V     -> PARSE_V     : send a data data request to slave, transition once the request has been sent
// PARSE_V   -> RECEIVE_V   : continuously check MISO line for the video data header. Stay in this state until packet parse condition is met
// RECEIVE_V -> REQ_A       : transition after video frames have been received
// REQ_A     -> PARSE_A     : continuously check MISO line for the audio data header. Stay in this state until packet parse condition is met
// RECEIVE_A -> IDLE        : transition after audio has been received


// Control registers don't need to be set. We instead configure the verilog to act in a certain mode. Change software side to fit this.
// Note: Correct timing on the frame_done signal will ensure that neither video or audio buffer overflows

`define DATA_CMD 8'hAA
`define DATA_HEADER 8'b11111111

module DATA_FSM (
    input  wire     CLK_40,
    input  wire     SPI_clk_en, // FSM operations are controlled on the SPI clock
    input  wire     reset,


    // video data control signals
    input  wire     start,            // initiated by a button press
    input  wire     frame_done,       // signal that will come from the memory bank being read
    input  wire     video_bank_full,  // signal that will come from the memory bank being written
    output reg      write_video,


    // SPI signals
    input  wire     MISO,             // MISO
    output logic    MOSI,             // MOSI
    output logic    chip_select,      // SS

    // Audio data control signals
    input  wire     audio_bank_full,
    output reg      write_audio
);
    typedef enum logic [2:0] {IDLE, REQ, PARSE, RECEIVE_V, RECEIVE_A, XX} statetype;
    statetype state, nextstate;


    // Internal signals for managing SPI communications
    // Configuring SPI to use 8 bit words
    reg [7:0]  CMD = `DATA_CMD;
    reg [7:0]  CMD_BUFF;             // Output - This will be set to either video or audio command in the FSM 
    reg [7:0]  DATA_HEADER_BUFF;     // Input - buffer to store the MISO data when in parse modes
    reg [15:0] AUDIO_BUFF;          // Input - buffer to store the MISO data for audio. If might be a diff. size than the data header



    integer i, j, k;
    /////////////////////////////
    //      Shift Register     //
    /////////////////////////////

    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            DATA_HEADER_BUFF <= 'b0;
            AUDIO_BUFF        <= 'b0;   
        end else if (SPI_clk_en) begin
            AUDIO_BUFF[0]        <= MISO;
            DATA_HEADER_BUFF[0]  <= MISO;

            for (i = 1; i <= 7; i = i+1) begin
                DATA_HEADER_BUFF[i] <= DATA_HEADER_BUFF[i-1];
            end

            for (j = 1; j <= 15; j = j+1) begin
                AUDIO_BUFF[i] <= AUDIO_BUFF[i-1];
            end
        end
    end

    logic       request_sent_done, parse_done;
    logic [7:0] DATA_HEADER_XNOR_BUFF;
    logic [3:0] num_match;
    logic [3:0] cmd_bit_count;


    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset)           state <= IDLE; 
        else                 state <= nextstate;
    end


    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE      : if (start | frame_done)  nextstate = REQ;
                        else                     nextstate = IDLE;     // idle basically means just display video without sending requests / doing writing
            REQ       : if (request_sent_done)   nextstate = PARSE;
                        else                     nextstate = REQ;
            PARSE     : if (parse_done)          nextstate = RECEIVE_V;
                        else                     nextstate = PARSE;             
            RECEIVE_V : if (video_bank_full)     nextstate = RECEIVE_A;
                        else                     nextstate = RECEIVE_V;
            RECEIVE_A : if (audio_bank_full)     nextstate = IDLE;
                        else                     nextstate = RECEIVE_A;
        endcase
    end



    // registered output logic
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            write_video    <= 1'b0;
            write_audio    <= 1'b0;
            CMD            <= 8'b0;
            cmd_bit_count  <=  'b0;
            chip_select    <= 1'b1; // chip_select is high as default and active low for communications
            DATA_HEADER_XNOR_BUFF <= 8'b0;
        end 
        else if (SPI_clk_en) 
        begin
            write_video       <= 1'b0;  // defaults. Set only the signals that change and they are registered. 
            write_audio       <= 1'b0;
            CMD               <= 8'b0;
            MOSI              <= 1'b0;
            chip_select       <= 1'b1;
            parse_done        <= 1'b0;
            request_sent_done <= 1'b0;
            DATA_HEADER_XNOR_BUFF <= 8'b0;

            case(nextstate)
                REQ      : begin 
                                CMD         <= `DATA_CMD;
                                chip_select <= 1'b0;

                                cmd_bit_count <= cmd_bit_count + 1; // increment in sync with SPI clock
                                if (cmd_bit_count < 8) begin
                                    MOSI <= CMD[cmd_bit_count];
                                end

                                if (cmd_bit_count == 8) begin
                                    cmd_bit_count <= 'b0;
                                    request_sent_done <= 1'b1;
                                end
                             end

                PARSE    : begin 
                                chip_select <= 1'b0;
                                DATA_HEADER_XNOR_BUFF <= ~(DATA_HEADER_BUFF ^ `DATA_HEADER);

                                num_match = DATA_HEADER_XNOR_BUFF[0] + 
                                            DATA_HEADER_XNOR_BUFF[1] +
                                            DATA_HEADER_XNOR_BUFF[2] +
                                            DATA_HEADER_XNOR_BUFF[3] +
                                            DATA_HEADER_XNOR_BUFF[4] +
                                            DATA_HEADER_XNOR_BUFF[5] +
                                            DATA_HEADER_XNOR_BUFF[6] +
                                            DATA_HEADER_XNOR_BUFF[7];

                                parse_done <=(num_match >= 7);  // allows one single bit to be wrong
                             end

                RECEIVE_V  : begin 
                                chip_select <= 1'b0;
                                write_video <= 1'b1;
                            end

                RECEIVE_A  : 
                            begin
                                chip_select <= 1'b0;
                                write_audio <= 1'b1;
                            end
            endcase
        end
    end

endmodule