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
    input wire                          read_pixel_clk_en,   
    input wire                          SPI_clk,
    input wire                          SPI_clk_en,          
    input wire                          reset,
    input wire                          read_enable,       // keep in IDLE modes
    input wire                          write_enable,      // write enable to the bank
    input wire [X_ADDRW-1:0]            VGA_x_pos,         // updates every 0.391MHz
    input wire [Y_ADDRW-1:0]            VGA_y_pos,         // updates every 0.391MHz
    input wire [X_MEM_ADDRW-1:0]        mem_x_pos,         // updates every 1MHz
    input wire [Y_MEM_ADDRW-1:0]        mem_y_pos,         // updates every 1MHz 
    input wire                          data_in,
    input logic                         active,            // to ensure that we don't read from a inaccessible memory location

    output wire                         data_out,
    output logic                        bank_full,        // 1 for the entirety of write done for this video bank
    output logic                        bank_read_done    // set when the contents of the buffer have been fully read. Used to switch modes
);

    // We never write and read to a bank at the same time so we choose which current x and y value to use
    // based on if we're reading or writing to the bank
    wire [X_MEM_ADDRW-1:0]    x_pos;  // 
    wire [Y_MEM_ADDRW-1:0]    y_pos;
    wire [X_ADDRW_SCALED-1:0] VGA_x_pos_scaled;
    wire [Y_ADDRW_SCALED-1:0] VGA_y_pos_scaled;
	 
	logic clk_enable, mem_clk;

    assign VGA_x_pos_scaled = VGA_x_pos >> 2; // this calculation is used to create the x4 scaling factor
    assign VGA_y_pos_scaled = VGA_y_pos >> 2;


    // Address selected based on whether we're reading or writing from memory
    // Additionally, we check if the signal is active so that VGA x and y will be within bounds for the memory read
    // If in blanking region, they will read from (0,0)
    assign x_pos      = read_enable ? VGA_x_pos_scaled & {(X_ADDRW_SCALED){active}} : mem_x_pos; 
    assign y_pos      = read_enable ? VGA_y_pos_scaled & {(Y_ADDRW_SCALED){active}} : mem_y_pos; 

    // selecting between clocks needs to be done with a dedicated clock mux and not regular combinational logic 
    clock_mux #(.num_clocks(2)) CLOCK_EN_MUX ({SPI_clk_en, read_pixel_clk_en}, {2'b1 << ~read_enable}, clk_enable);
    clock_mux #(.num_clocks(2)) CLOCK_MUX    ({SPI_clk,      CLK_40         }, {2'b1 << ~read_enable}, mem_clk);

    // The last_pixel logic depends on whether the video block is in read or write mode
    // we use either the x,y generated values generated by the mem location tracker or the
    // current VGA pixel position
    // the scaled down version of x and y is not used for last pixel logic as this causes
    // a bug where bank_counter increments 4 times instead of once when the last pixel is reached
    logic last_pixel;
    always_comb begin
        if (read_enable) 
            last_pixel = (VGA_y_pos == HEIGHT-1) && (VGA_x_pos == WIDTH-1); 
        else 
            last_pixel = (mem_x_pos == X_WIDTH-1) && (mem_y_pos == Y_HEIGHT-1);
    end

    /////////////////////////////////
    //        FSM Controller       //
    /////////////////////////////////
    reg [3:0] bank_counter;
    // reg [14:0] video_buffer_we;
    logic video_buffer_we;
    video_bank_FSM FSM (
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_enable(clk_enable),
        .last_pixel(last_pixel),      
        .write_enable(write_enable),     // lets the FSM know if we're meant to be writing or reading into the bank 
        .read_enable(read_enable),

        .bank_full(bank_full),
        .bank_counter(bank_counter),
        .video_buffer_we(video_buffer_we),
        .bank_read_done(bank_read_done)
    );

    /////////////////////////////////
    //       Memory Block          //
    /////////////////////////////////

    // It's assumed that the x and y is in the active region
    // e.g. will be between 200x150
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
        .we(video_buffer_we),
        .pixel_color(data_out)
    );
  
endmodule


// FSM states
// IDLE       -> WRITE      : Initial state. Transition when button is pressed to initiate data
// WRITE      -> WRITE_DONE : Go into this data once we've filled the buffer
// WRITE_DONE -> READ       : Don't write into memory, reset bank count. Stay until mode switches 
// READ       -> WRITE      : Transition once you've reached the last pixel of the last mem block

module video_bank_FSM (
    input wire    CLK_40,
    input wire    reset,
    input wire    clk_enable,
    input wire    last_pixel,      
    input wire    write_enable,     // lets the FSM know if we're meant to be writing or reading into the bank 
    input wire    read_enable,
    output logic   bank_full,

    output logic        video_buffer_we,
    output reg   [3:0]  bank_counter,
    // output logic [14:0] video_buffer_we,
    output logic        bank_read_done
);

    /////////////////////////////////// 
    //        FSM Controller         //
    ///////////////////////////////////

    logic [1:0]     frame_counter; // The same frame should be read 4x

    typedef enum logic [2:0] {IDLE, WRITE, WRITE_DONE, READ, XX} statetype;
    statetype state, nextstate;

    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset)           state <= IDLE;
        else if (clk_enable) state <= nextstate;
    end

    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE        : if (read_enable == 1)                 nextstate = READ;
                          else if (write_enable)                nextstate = WRITE;
                          else                                  nextstate = IDLE;
            WRITE       : if (bank_counter == 14 && last_pixel) nextstate = WRITE_DONE;
                          else                                  nextstate = WRITE;
            WRITE_DONE  : if (read_enable)                      nextstate = READ;    // if the mode is 'READ', write_enable will be 0
                          else                                  nextstate = WRITE_DONE;
            READ        : if (bank_read_done)                   nextstate = IDLE;
                          else                                  nextstate = READ;
        endcase
    end

    // registered output logic
    always_ff @ (posedge CLK_40) begin
        if (reset) 
            bank_full <= 0;
        else begin
            if (clk_enable) begin
                bank_full <= 0;
                case(nextstate)
                    WRITE_DONE  : bank_full <= 1;
                endcase
            end
        end
    end


    ///////////////////////////////////
    //     Memory block selection    //
    ///////////////////////////////////

    // shift the value of bank_counter to create a one hot code for write enable on each video buffer
    // to choose between N buffers, shift by N-1
    // assign video_buffer_we = (1 << bank_counter  & {15{write_enable & ~bank_full}} ); // bitwise AND with write_enable only if the bank isn't full

    assign video_buffer_we = write_enable & ~bank_full;

    // will increment the value of bank_counter then reset at 15
    // once the buffer and the bank is full set a signal. This will go back to zero on the next clock cycle
    always_ff @ (posedge CLK_40) begin : bank_counter_increment 
        if (reset) begin 
            bank_counter   <= 0;
            bank_read_done <= 0;
            frame_counter  <= 0;             // only use frame_counter IF we're in the READ mode
        end else if (clk_enable) begin
                bank_read_done    <= 0;
                if (last_pixel) begin  // removed ~ bank_full which I think was intented to keep bank counter from
                    frame_counter <= frame_counter + 1'b1;

                    if ((frame_counter == 3) || (state == WRITE)) begin // if in WRITE mode, ignore frame counter. 
                        frame_counter <= 0;
                        bank_counter  <= bank_counter + 1'b1;
                        if (bank_counter == 'd14) begin
                            bank_counter   <= 0;
                            bank_read_done <= 1'b1 & ~write_enable;
                        end
                    end
                end
        end
    end

  
endmodule