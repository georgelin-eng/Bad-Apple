// VGA_800x600.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module VGA_800x600 (
		input  wire  ref_clk_clk,        //      ref_clk.clk
		input  wire  ref_reset_reset,    //    ref_reset.reset
		output wire  reset_source_reset, // reset_source.reset
		output wire  vga_clk_clk         //      vga_clk.clk
	);

	VGA_800x600_video_pll_0 video_pll_0 (
		.ref_clk_clk        (ref_clk_clk),        //      ref_clk.clk
		.ref_reset_reset    (ref_reset_reset),    //    ref_reset.reset
		.vga_clk_clk        (vga_clk_clk),        //      vga_clk.clk
		.reset_source_reset (reset_source_reset)  // reset_source.reset
	);

endmodule
