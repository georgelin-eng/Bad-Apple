`include "params.sv"
//////////////////////////////////
// Scaling factor : divide by 4 //
// Size           : 15 frames   //
//////////////////////////////////


module video_bank # (
    parameter WHOLE_LINE  = 1056,
    parameter WHOLE_FRAME = 628,
    parameter WIDTH       =  800, // Active
    parameter HEIGHT      =  600, // Active
    parameter X_WIDTH     = WIDTH/4,
    parameter Y_HEIGHT    = HEIGHT/4,

    parameter X_ADDRW = $clog2(WHOLE_LINE),  // this should be full data width to store value of VGA pixel position
    parameter Y_ADDRW = $clog2(WHOLE_FRAME),
    parameter X_ADDRW_SCALED = $clog2(WHOLE_LINE/4),
    parameter Y_ADDRW_SCALED = $clog2(WHOLE_FRAME/4),
    parameter X_MEM_ADDRW = $clog2(X_WIDTH),
    parameter Y_MEM_ADDRW = $clog2(Y_HEIGHT)
)
(
    input wire                          CLK_40,
    input wire                          reset,
    input wire                          read_pixel_clk_en,   
    input wire                          data_write_clk,
    input wire                          data_clk_rising_edge,
    input wire                          read_enable,       // keep in IDLE modes
    input wire                          chip_select,      // write enable to the bank
    input wire                          video_data_ready,
    input wire [X_ADDRW-1:0]            VGA_x_pos,         // updates every 0.391MHz
    input wire [Y_ADDRW-1:0]            VGA_y_pos,         // updates every 0.391MHz
    input wire [X_MEM_ADDRW-1:0]        mem_x_pos,         // updates every 1MHz
    input wire [Y_MEM_ADDRW-1:0]        mem_y_pos,         // updates every 1MHz 
    input wire                          data_in,
    input logic                         active,            // to ensure that we don't read from a inaccessible memory location

    output wire                         data_out
);

    // We never write and read to a bank at the same time so we choose which current x and y value to use
    // based on if we're reading or writing to the bank
    (* syn_preserve = 1 *) reg [X_MEM_ADDRW-1:0]    x_pos;  
    (* syn_preserve = 1 *) reg [Y_MEM_ADDRW-1:0]    y_pos;
    wire [X_ADDRW_SCALED-1:0] VGA_x_pos_scaled;
    wire [Y_ADDRW_SCALED-1:0] VGA_y_pos_scaled;
	 
    assign VGA_x_pos_scaled = VGA_x_pos >> 2; // this calculation is used to create the x4 scaling factor
    assign VGA_y_pos_scaled = VGA_y_pos >> 2;


    // 0 -> CLK_40     
    // 1 -> SPI_clk_en 
    // selecting between clocks needs to be done with a dedicated clock mux and not regular combinational logic 

    `ifndef ONLY_40MHz_CLOCK_DOMAIN
        clock_mux #(.num_clocks(2)) CLOCK_MUX ({data_write_clk, CLK_40}, {2'b1 << (~chip_select & ~read_enable)}, mem_clk);
    `endif

    // Address selected based on whether we're reading or writing from memory
    // Additionally, we check if the signal is active so that VGA x and y will be within bounds for the memory read
    // If in blanking region, they will read from (0,0) which prevents illegal memory reads
    // at this stage, maybe pipeline this instead actually:
    assign x_pos      = read_enable ? VGA_x_pos_scaled : mem_x_pos; 
    assign y_pos      = read_enable ? VGA_y_pos_scaled : mem_y_pos; 

    // The last_pixel logic depends on whether the video block is in read or write mode
    // we use either the x,y generated values generated by the mem location tracker or the
    // current VGA pixel position
    // the scaled down version of x and y is not used for last pixel logic as this causes
    // a bug where bank_counter increments 4 times instead of once when the last pixel is reached

    reg last_pixel, last_pixel_latched;
    always_ff @ (posedge CLK_40) begin
        if (read_enable)
            last_pixel <= (VGA_y_pos == HEIGHT-1) && (VGA_x_pos == WIDTH-1); 
        else begin
            last_pixel <= (mem_x_pos == X_WIDTH-1) && (mem_y_pos == Y_HEIGHT-1); 
            last_pixel_latched <= 1'b0;

            if (last_pixel) last_pixel_latched <= 1'b1;
        end
    end

    // logic last_pixel;
    // always_comb begin
    //     if (read_enable) 
    //         last_pixel = (VGA_y_pos == HEIGHT-1) && (VGA_x_pos == WIDTH-1); 
    //     else 
    //         last_pixel = (mem_x_pos == X_WIDTH-1) && (mem_y_pos == Y_HEIGHT-1);
    // end

    /////////////////////////////////
    //        FSM Controller       //
    /////////////////////////////////

    logic [3:0] bank_counter;

    `ifndef ONLY_40MHz_CLOCK_DOMAIN
        video_bank_FSM FSM (
            .clk(mem_clk),
            .clk_en(1'b1),
            .reset(reset),
            .video_data_ready(video_data_ready),
            .last_pixel(last_pixel),      
            .read_enable(read_enable),

            .bank_counter(bank_counter)
        );
    `else 
        logic data_clk_en;

        always_comb begin  
            data_clk_en = (~chip_select & ~read_enable) ? data_clk_rising_edge : CLK_40;
        end

        video_bank_FSM FSM (
            .clk(CLK_40),
            .clk_en(data_clk_en),
            .reset(reset),
            .video_data_ready(video_data_ready),
            .last_pixel(last_pixel & ~last_pixel_latched),      
            .read_enable(read_enable),

            .bank_counter(bank_counter)
        );
    `endif 

    /////////////////////////////////
    //       Memory Block          //
    /////////////////////////////////

    // It's assumed that the x and y is in the active region
    // write_enable is controlled with video_data_ready
    // as as mem_pos counter since before
    // pixel_addr = 0 was being skipped
    `ifndef ONLY_40MHz_CLOCK_DOMAIN
        video_mem_top #(
            .WIDTH(X_WIDTH),
            .HEIGHT(Y_HEIGHT),
            .WHOLE_LINE(WHOLE_LINE),
            .WHOLE_FRAME(WHOLE_FRAME)
        )VIDEO_MEM (
            .clk(mem_clk),
            .bank_counter(bank_counter),
            .x_pos(x_pos),
            .y_pos(y_pos),
            .data_in(data_in),
            .we(video_data_ready & ~read_enable),  
            .pixel_color(data_out)
        );
    `else // using 40Mhz clock domain
        video_mem_top #(
            .WIDTH(X_WIDTH),
            .HEIGHT(Y_HEIGHT),
            .WHOLE_LINE(WHOLE_LINE),
            .WHOLE_FRAME(WHOLE_FRAME)
        )VIDEO_MEM (
            .clk(CLK_40),
            .bank_counter(bank_counter),
            .x_pos(x_pos),
            .y_pos(y_pos),
            .data_in(data_in),
            .we(video_data_ready & ~read_enable & data_clk_rising_edge),  // write controlled by rising edge which is in 40Mhz domain
            .pixel_color(data_out)
        );
    `endif 
endmodule


// FSM states
// IDLE       -> WRITE      : Initial state. Transition when button is pressed to initiate data
// WRITE      -> WRITE_DONE : Go into this data once we've filled the buffer
// WRITE_DONE -> READ       : Don't write into memory, reset bank count. Stay until mode switches 
// READ       -> WRITE      : Transition once you've reached the last pixel of the last mem block

module video_bank_FSM (
    input wire    clk,
    input wire    clk_en,
    input wire    reset,
    input wire    video_data_ready,
    input wire    read_enable,
    input wire    last_pixel,

    output reg   [3:0]  bank_counter
);

    /////////////////////////////////// 
    //        FSM Controller         //
    ///////////////////////////////////

    logic [1:0]     frame_counter; // The same frame should be read 4x

    typedef enum logic [2:0] {IDLE, WRITE, WRITE_DONE, READ, XX} statetype;
    statetype state, nextstate;

    // State register
    always_ff @( posedge clk ) begin 
        if (reset)    state <= IDLE;
        else          state <= nextstate;
    end

    // // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE        : if (read_enable)           nextstate = READ;
                          else if (video_data_ready) nextstate = WRITE;
                          else                       nextstate = IDLE;
            WRITE       : if (video_data_ready)      nextstate = WRITE;
                          else                       nextstate = IDLE;
            READ        : if (read_enable)           nextstate = READ;
                          else                       nextstate = IDLE;
        endcase
    end

    ///////////////////////////////////
    //     Memory block selection    //
    ///////////////////////////////////

    // shift the value of bank_counter to create a one hot code for write enable on each video buffer
    // to choose between N buffers, shift by N-1
    // assign video_buffer_we = (1 << bank_counter  & {15{write_enable & ~bank_full}} ); // bitwise AND with write_enable only if the bank isn't full
    // will increment the value of bank_counter then reset at 15
    // once the buffer and the bank is full set a signal. This will go back to zero on the next clock cycle
    always_ff @ (posedge clk) begin : bank_counter_increment 
        if (reset) begin 
            bank_counter   <= 0;
            frame_counter  <= 0;             // only use frame_counter IF we're in the READ mode
        end 
        else begin
            if (last_pixel) begin  // removed ~ bank_full which I think was intented to keep bank counter from
                frame_counter <= frame_counter + 1'b1;

                if ((frame_counter == 3) || (state == WRITE)) begin // if in WRITE mode, ignore frame counter. 
                    frame_counter <= 0;
                    bank_counter  <= bank_counter + 1'b1;
                    if (bank_counter == 'd14) begin
                        bank_counter   <= 0;
                    end
                end
            end
        end
    end

  
endmodule