// Either DDR3 (1GB) or the 64MB SDRAM


module SDRAM_controller (

)


endmodule
// https://www.intel.com/content/www/us/en/docs/programmable/683082/21-3/inferring-ram-functions-from-hdl-code.html
// Inferring block RAM from HDL code
// Requirements
// - memory reads should happen with an always block driven by a clock
// - resets are not supported
// 

module block_RAM (
    output  reg [15:0]  DRAM_DQ,
    output  reg [12:0]  DRAM_ADDR,
    output  reg [1:0]   DRAM_BA,
    output  reg         DRAM_CLK,
    output  reg         DRAM_LDQM,
    output  reg         DRAM_UDQM,
    output  reg         DRAM_WE_N,
    output  reg         DRAM_CAS_N,
    output  reg         DRAM_RAS_N,
    output  reg         DRAM_CS_N
);



endmodule






// Intel example of a dual port ram operated on a single clock
module true_dual_port_ram_single_clock
#(  parameter DATA_WIDTH=640, 
    parameter ADDR_WIDTH=480
)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] = data_a;
		end
		q_a <= ram[addr_a];
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
		begin
			ram[addr_b] = data_b;
		end
		q_b <= ram[addr_b];
	end

endmodule