`include "params.sv"
// VGA module

// Specs
// - 25.175MHz clock - 640x480 at 60Hz <-- The De1Soc has a 50Mhz regulator. Use a 1 bit counter to generate the clk frequency
// - (640 + 16 + 96 + 48) x (480 + 10 + 2 + 33) = 800 * 525 @ 60Hz ~ 25.2MHz
// https://www.fpga4fun.com/VGA.html

// Synchronization
// - HSYNC : horizontal synchronization : negative pulse for new scanline
// - VSYNC : vertical synchronization   : negative pulse for new frame

module VGA_top (
    input                CLK_40,
    input  logic         reset,
    input  logic         pixel_color,
    input  logic         count_en,

    output logic  [7:0]  VGA_R,          // to DAC 
    output logic  [7:0]  VGA_G,          // to DAC 
    output logic  [7:0]  VGA_B,          // to DAC 
    output wire          VGA_CLK,        // to DAC, clock signal
    output wire          VGA_SYNC_N,     // to DAC, Active low for sync
    output wire          VGA_BLANK_N,    // to DAC, Active low for blanking
    output wire          VGA_VS,         // to VGA, Active high for sync
    output wire          VGA_HS,         // to VGA, Active high for sync

    output logic         ACTIVE          // to video bank
);

    parameter h_front_porch = (`MODE == "NORMAL") ? 40  : 2 ;
    parameter h_synch_pulse = (`MODE == "NORMAL") ? 128 : 3 ;
    parameter h_back_porch  = (`MODE == "NORMAL") ? 88  : 3 ;
    parameter v_front_porch = (`MODE == "NORMAL") ? 1   : 2 ;
    parameter v_synch_pulse = (`MODE == "NORMAL") ? 4   : 4 ;
    parameter v_back_porch  = (`MODE == "NORMAL") ? 23  : 2 ;
    parameter h_area        = (`MODE == "NORMAL") ? 800 : 32; // in mem -> 8
    parameter v_area        = (`MODE == "NORMAL") ? 600 : 24; // in mem -> 6

    // This this will be used to determine default parameters for two different resolutions so that this design can be designed for both 640x480 and 800x600 resolutions. 
    parameter X_LINE_WIDTH = h_area + h_front_porch + h_synch_pulse + h_back_porch;
    parameter Y_LINE_WIDTH = v_area + v_front_porch + v_synch_pulse + v_back_porch;
    parameter X_DATA_WIDTH = $clog2(X_LINE_WIDTH);
    parameter Y_DATA_WIDTH = $clog2(Y_LINE_WIDTH);

    wire hsync_n, vsync_n;
    wire h_BLANK, v_BLANK;

    wire [X_DATA_WIDTH-1:0] x_pos;
    wire [Y_DATA_WIDTH-1:0] y_pos;

    assign VGA_CLK = CLK_40;

    assign VGA_HS = hsync_n; // Active high
    assign VGA_VS = vsync_n; // Active high

    assign ACTIVE      = VGA_BLANK_N;           // Idea is to AND it (so positive is active)
    assign VGA_BLANK_N = ~(v_BLANK || h_BLANK); // Active low 
    assign VGA_SYNC_N  = ~(VGA_HS || VGA_VS);   // Active low

    // Basic color generation test 
    always_comb begin
        if (VGA_BLANK_N) begin
            VGA_R = ((pixel_color) ? 8'd255 : 8'd90); 
            VGA_G = ((pixel_color) ? 8'd180 : 8'd0) ; 
            VGA_B = ((pixel_color) ? 8'd255 : 8'd90); 
        end
        else begin
            VGA_R = 8'd0;
            VGA_G = 8'd0;
            VGA_B = 8'd0;
        end
    end

    screenPositionTracker  #(
        .X_LINE_WIDTH(X_LINE_WIDTH),
        .Y_LINE_WIDTH(Y_LINE_WIDTH)
    ) SCREEN_POS (
        .CLK_40 (CLK_40),
        .reset(reset),
        .clk_en(1'b1), // CLK_40 is the pixel clock. Leave as 1
        .count_en(count_en),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );

    hsync_gen #(
        .X_LINE_WIDTH(X_LINE_WIDTH),
        .h_front_porch(h_front_porch),
        .h_synch_pulse(h_synch_pulse),
        .h_back_porch(h_back_porch),
        .h_area(h_area)
    ) HSYNC_GEN (
        .CLK_40 (CLK_40),
        .pixel_clk (1'b1),
        .reset (reset),
        .x_pos(x_pos),

        // outputs
        .hsync_n(hsync_n),
        .h_BLANK (h_BLANK)
    );

    vsync_gen #(
        .X_LINE_WIDTH(X_LINE_WIDTH),
        .Y_LINE_WIDTH(Y_LINE_WIDTH),
        .v_front_porch(v_front_porch),
        .v_synch_pulse(v_synch_pulse),
        .v_back_porch(v_back_porch),
        .v_area(v_area)
    ) VSYNC_GEN (
        .CLK_40 (CLK_40),
        .pixel_clk(1'b1),
        .reset (reset),
        .x_pos(x_pos),
        .y_pos(y_pos),

        // outputs
        .vsync_n(vsync_n),
        .v_BLANK(v_BLANK)
    );
  endmodule