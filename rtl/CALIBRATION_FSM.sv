`include "params.sv"

module sync_FIFO #(
    parameter DEPTH = 128, 
    parameter DWIDTH = 1
)
(

    input                   reset,
    input                   CLK_40,
    input                   write_clk, // on posedge SPI_clk
    input                   read_clk,  // on posedge data_write_clk
    input                   read_en,   
    input                   write_en,
    input      [DWIDTH-1:0] din,
    output reg [DWIDTH-1:0] dout,
    output                  empty,
    output                  full
);

    reg [$clog2(DEPTH)-1:0] write_ptr;
    reg [$clog2(DEPTH)-1:0] read_ptr;

    reg [DWIDTH-1:0] FIFO [DEPTH];


    always_ff @ (posedge write_clk) begin
	    if (reset) write_ptr <= 0; 
        else if (write_en & !full) begin
            FIFO[write_ptr] <= din;
            write_ptr <= write_ptr + 1;
        end
    end

    always_ff @ (posedge read_clk) begin
	    if (reset) read_ptr <= 0;
        else if (read_en & ! empty) begin
            dout <= FIFO [read_ptr];
            read_ptr <= read_ptr + 1;
        end
    end

    assign full = (write_ptr + 1) == read_ptr;
    assign empty = write_ptr == read_ptr;
    
endmodule