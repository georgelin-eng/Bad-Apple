//////////////////////////////////
// Scaling factor : divide by 4 //
// Size           : 15 frames   //
//////////////////////////////////


module video_bank # (
    parameter WIDTH    =  640,
    parameter HEIGHT   =  480,
    parameter X_WIDTH  = WIDTH/4,
    parameter Y_HEIGHT = HEIGHT/4,

    parameter X_ADDRW = $clog2(WIDTH),
    parameter Y_ADDRW = $clog2(HEIGHT),
    parameter X_ADDRW_SCALED = $clog2(X_WIDTH),
    parameter Y_ADDRW_SCALED = $clog2(Y_HEIGHT)
)
(
    input wire                          CLK_40,
    input wire                          read_pixel_clk_en, // read clock
    input wire                          SPI_clk_en,        // write clock
    input wire                          reset,
    input wire                          write_enable,      // write enable to the bank
    input wire [X_ADDRW-1:0]            VGA_x_pos,         // updates every 0.391MHz
    input wire [Y_ADDRW-1:0]            VGA_y_pos,         // updates every 0.391MHz
    input wire [X_ADDRW_SCALED-1:0]     mem_x_pos,         // updates every 1MHz
    input wire [Y_ADDRW_SCALED-1:0]     mem_y_pos,         // updates every 1MHz 
    input wire                          data_in,
    output wire                         data_out,
    output logic                        bank_read_done    // set when the contents of the buffer have been fully read. Used to switch modes
);

    // We never write and read to a bank at the same time so we choose which current x and y value to use
    // based on if we're reading or writing to the bank
    wire [X_ADDRW_SCALED-1:0] x_pos;
    wire [X_ADDRW_SCALED-1:0] y_pos;
    wire [X_ADDRW_SCALED-1:0] VGA_x_pos_scaled;
    wire [Y_ADDRW_SCALED-1:0] VGA_y_pos_scaled;

    assign VGA_x_pos_scaled = VGA_x_pos >> 2; // this calculation should be moved inside the video bank 
    assign VGA_y_pos_scaled = VGA_y_pos >> 2;

    assign x_pos      = write_enable ? mem_x_pos  : VGA_x_pos_scaled;
    assign y_pos      = write_enable ? mem_y_pos  : VGA_y_pos_scaled;

    // selecting between clocks needs to be done with a deticated clock mux and not regular combinational logic 
    clock_mux #(.num_clocks(2)) CLOCK_MUX ({SPI_clk_en, read_pixel_clk_en}, {2'b1 << write_enable}, clk_enable);

    // On every tick of SPI clock enable (1MHz), data should be written into a bank
    // The last pixel logic depends on whether the video block is in read or write mode
    logic last_pixel;
    always_comb begin
        if (write_enable) 
            last_pixel = (mem_x_pos == X_WIDTH-1) && (mem_y_pos == Y_HEIGHT-1);
        else 
            last_pixel = (VGA_y_pos == HEIGHT-1) && (VGA_x_pos == WIDTH-1); 
    end


    /////////////////////////////////
    //        FSM Controller       //
    /////////////////////////////////
    reg [3:0] bank_counter;
    reg [14:0] video_buffer_we;
    video_bank_FSM FSM (
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_enable(clk_enable),
        .last_pixel(last_pixel),      
        .write_enable(write_enable),     // lets the FSM know if we're meant to be writing or reading into the bank 
        
        .bank_counter(bank_counter),
        .video_buffer_we(video_buffer_we),
        .bank_read_done(bank_read_done)
    );



    /////////////////////////////////
    //       Memory Block          //
    /////////////////////////////////

    // Instantiate 15 video buffers each with video_buffer_we
    wire [14:0] video_buff_data;                        // stores the video data from each of the video buffer units
    assign data_out = video_buff_data[bank_counter];    // chooses which correct pixel based on current buffer with a mux


    genvar i;
    generate
        for (i=0; i<=14; i=i+1) begin : video_buffers
        video_buffer #(
            .WIDTH(X_WIDTH),
            .HEIGHT(Y_HEIGHT)
        )VIDEO_BUFFER (
            .system_clk(CLK_40),
            .clk_write(SPI_clk_en),
            .clk_read(read_pixel_clk_en),              // the << 2 on x and y already account for this
            .we(video_buffer_we[i]),   // a single buffer will have a write enable high
            .addr_write_x(x_pos),      // will always be writing using mem addr
            .addr_write_y(y_pos),
            .addr_read_x(x_pos),
            .addr_read_y(y_pos),
            .data_in(data_in),
            .data_out(video_buff_data[i]) // every buffer outputs to a register 
        );
    end 
    endgenerate


endmodule


// Write into this video buffer on a 1Mhz clock
// Read this buffer at effectively 6.25MHz
// Inferred memory cannot have resets in them. 
module video_buffer #(
    parameter WIDTH   =  160,          // should be 160
    parameter HEIGHT  =  120,          // should be 120
    parameter X_ADDRW = $clog2(WIDTH),  
    parameter Y_ADDRW = $clog2(HEIGHT)
)
(
    input wire logic               system_clk,
    input wire logic               clk_write,     // write clock (port a)
    input wire logic               clk_read,      // read clock (port b)
    input wire logic               we,            // write enable (port a)
    input wire logic [X_ADDRW-1:0] addr_write_x,  // write address (port a)
    input wire logic [Y_ADDRW-1:0] addr_write_y,  // write address (port a)
    input wire logic [X_ADDRW-1:0] addr_read_x,   // read address (port b)
    input wire logic [Y_ADDRW-1:0] addr_read_y,   // read address (port b)
    input wire logic               data_in,       // data in (port a)
    output     logic               data_out       // data out (port b)
);

    // Default for 640x480 is a 160x120 block of memory
    logic [WIDTH-1:0] memory [HEIGHT];

    // Reading from this buffer is continuous. Writing is not. 

    // Port A: Sync Write
    always_ff @(posedge system_clk) begin
        if (clk_write) begin
            if (we) memory[addr_write_y][addr_write_x] <= data_in;
        end
    end

    // Port B: Sync Read
    always_ff @(posedge system_clk) begin
        if (clk_read) begin
            data_out <= memory[addr_read_y][addr_read_x];
        end
    end

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
    
    output reg   [3:0]  bank_counter,
    output logic [14:0] video_buffer_we,
    output logic        bank_read_done
);

    ///////////////////////////////////
    //     Memory block selection    //
    ///////////////////////////////////

    logic bank_full;

    // shift the value of bank_counter to create a one hot code for write enable on each video buffer
    // to choose between N buffers, shift by N-1
    assign video_buffer_we = (1 << bank_counter  & {15{write_enable & ~bank_full}} ); // bitwise AND with write_enable only if the bank isn't full


    // will increment the value of bank_counter then reset at 15
    // once the buffer and the bank is full set a signal. This will go back to zero on the next clock cycle
    always_ff @ (posedge CLK_40) begin : bank_counter_increment 
        if (reset) begin 
            bank_counter   <= 0;
            bank_read_done <= 0;
            bank_full      <= 0;
        end else if (clk_enable) begin
                bank_read_done    <= 0;
                if (last_pixel & ~bank_full) begin // a pixel is read 4x, this is a bug right now
                    bank_counter <= bank_counter + 1;
                    if (bank_counter == 14) begin
                        bank_counter   <= 0;
                        bank_read_done <= 1 & ~write_enable;
                    end
                end
        end
    end



    /////////////////////////////////// 
    //        FSM Controller         //
    ///////////////////////////////////

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
            IDLE        : if (write_enable)                     nextstate = WRITE;
                          else                                  nextstate = READ;
            WRITE       : if (bank_counter == 14 && last_pixel) nextstate = WRITE_DONE;
                          else                                  nextstate = WRITE;
            WRITE_DONE  : if (~write_enable)                    nextstate = READ;    // if the mode is 'READ', write_enable will be 0
                          else                                  nextstate = WRITE_DONE;
            READ        : if (bank_read_done)                   nextstate = WRITE;
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
endmodule