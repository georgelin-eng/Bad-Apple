// VGA module

// Specs
// - 25.175MHz clock - 640x480 at 60Hz <-- The De1Soc has a 50Mhz regulator. Use a 1 bit counter to generate the clk frequency
// - (640 + 16 + 96 + 48) x (480 + 10 + 2 + 33) = 800 * 525 @ 60Hz ~ 25.2MHz
// https://www.fpga4fun.com/VGA.html

// Synchronization
// - HSYNC : horizontal synchronization : negative pulse for new scanline
// - VSYNC : vertical synchronization   : negative pulse for new frame

module VGA_top (
    input                CLOCK_50,
    input  wire  [3:0]   KEY,            // push buttons on the De1Soc
    output wire  [7:0]   VGA_R,          // to DAC 
    output wire  [7:0]   VGA_G,          // to DAC 
    output wire  [7:0]   VGA_B,          // to DAC 
    output wire          VGA_CLK,        // to DAC
    output wire          VGA_SYNC_N,     // to DAC 
    output wire          VGA_BLANK_N,    // to DAC 
    output wire          VGA_VS,         // to VGA
    output wire          VGA_HS,         // to VGA
    output wire  [9:0]   LEDR,           // debug
    output wire          clk_debug       // debug
);
//  parameter RESOLUTION = "800x600";    // memory will be 200 x 150 -> 450kb/s @ 15Hz
    parameter RESOLUTION = "640x480";    // memory will be 160 x 120 -> 288kb/s @ 15Hz



    // Blank porch and synch porch assignments for these resolutions at 60Hz. 
    parameter h_front_porch = (RESOLUTION == "640x480")  ? 16 : 40;
    parameter h_synch_pulse = (RESOLUTION == "640x480")  ? 96 : 128;
    parameter h_back_porch  = (RESOLUTION == "640x480")  ? 48 : 88;
    parameter v_front_porch = (RESOLUTION == "640x480")  ? 10 : 1;
    parameter v_synch_pulse = (RESOLUTION == "640x480")  ? 2 :  4;
    parameter v_back_porch  = (RESOLUTION == "640x480")  ? 33 : 23;

    parameter h_area        = (RESOLUTION == "640x480")  ? 640 : 800;
    parameter v_area        = (RESOLUTION == "640x480")  ? 480 : 600;

    // This this will be used to determine default parameters for two different resolutions so that this design can be designed for both 640x480 and 800x600 resolutions. 
    parameter X_LINE_WIDTH = h_area + h_front_porch + h_synch_pulse + h_back_porch;
    parameter Y_LINE_WIDTH = v_area + v_front_porch + v_synch_pulse + v_back_porch;
    parameter X_DATA_WIDTH = $clog2(X_LINE_WIDTH) - 1;
    parameter Y_DATA_WIDTH = $clog2(Y_LINE_WIDTH) - 1;

    wire pixel_clk;
    wire hsync_n, vsync_n;
    wire h_BLANK, v_BLANK;

    wire [X_DATA_WIDTH:0] x_pos;
    wire [Y_DATA_WIDTH:0] y_pos;

    assign VGA_CLK = pixel_clk;

    assign VGA_HS = ~hsync_n;
    assign VGA_VS = ~vsync_n;

    assign VGA_BLANK_N = ~(v_BLANK || h_BLANK); 
    assign VGA_SYNC_N  = VGA_HS && VGA_VS;

    assign VGA_R = VGA_BLANK_N ? 8'd255 : 8'd0; 
    assign VGA_G = VGA_BLANK_N ? 8'd255 : 8'd0; 
    assign VGA_B = VGA_BLANK_N ? 8'd255 : 8'd0; 

    assign reset = ~KEY[3];
    assign LEDR = {reset, {8'b0}};

    // instantiating clock generation circuits
    pixel_clk_gen PIXEL_CLK_GEN (
        .CLK_50 (CLOCK_50),
        .reset (reset),
        .pixel_clk(pixel_clk)
    );


    debug_clk_gen DEBUG_CLK_GEN (
        .CLK_50 (CLOCK_50),
        .reset (reset),
        .clk_debug(clk_debug)
    );


    screenPositionTracker  #(
        .X_DATA_WIDTH(X_DATA_WIDTH),
        .Y_DATA_WIDTH(Y_DATA_WIDTH),
        .X_LINE_WIDTH(X_LINE_WIDTH),
        .Y_LINE_WIDTH(Y_LINE_WIDTH)
    ) SCREEN_POS (
        .CLK_50 (CLOCK_50),
        .reset(reset),
        .pixel_clk(pixel_clk),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );


    hsyn_clk_enable_gen HSYNC_GEN (
        .CLK_50 (CLOCK_50),
        .pixel_clk (pixel_clk),
        .reset (reset),
        .hsync_n(hsync_n),
        .h_BLANK (h_BLANK),
        .hsync_clk_enable (hsync_clk_enable)
    );

    vsync_clk_enable_gen VSYNC_GEN (
        .CLK_50 (CLOCK_50),
        .reset (reset),
        .hsync_clk_enable(hsync_clk_enable),
        .vsync_n(vsync_n),
        .v_BLANK(v_BLANK)
    );


endmodule