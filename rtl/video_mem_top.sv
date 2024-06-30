
module video_mem_top #(
    parameter WIDTH = 10,
    parameter HEIGHT = 20,
    parameter WHOLE_LINE  = 1056,
    parameter WHOLE_FRAME = 628,
    parameter X_ADDRW = $clog2(WIDTH),
    parameter Y_ADDRW = $clog2(HEIGHT),
    parameter ADDRW   = $clog2(WIDTH*HEIGHT)
)(
    input logic               clk,
    input logic [3:0]         bank_counter,
    input logic [X_ADDRW-1:0] x_pos, 
    input logic [Y_ADDRW-1:0] y_pos,
    input logic               data_in,
    input logic               we,
    
    output logic              pixel_color
);

    // We do a linear address calculation but avoid the use of multiply
    // address = y*WIDTH + x
    // For 200x150, 200 can be written as (128+64+8)
    // The new memory address becomes 
    // (y*128) + (y*64) + (y*8) + x

    // wire [ADDRW-1:0] pixel_addr = y_pos*WIDTH + x_pos; // simulation only so I keep this fast
    wire [14:0] pixel_addr = ({1'b0, y_pos, 7'b0} + {1'b0, y_pos, 6'b0} + {1'b0, y_pos, 3'b0} + {1'b0, x_pos});

    // wire [14:0] pixel_addr = y_pos*'d200 + x_pos;

    videoRam #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT)
    )VIDEO_RAM (
        .clk(clk),
        .mem_block_sel(bank_counter),
        .data_in(data_in),
        .pixel_addr(pixel_addr),
        .we(we),
        .data_out_after_sel(pixel_color)  // output 
    );
	 
endmodule