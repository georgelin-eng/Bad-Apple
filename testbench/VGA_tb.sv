`timescale 10ns/10ns
module tb ();

    reg         clk_50, reset;
    wire        pixel_clk, hsync_n, vsync_n;
    wire        h_sync, v_sync;
    wire        hsync_clk_enable;
    wire [7:0]  R_dac, B_dac, G_dac;

    // instantiating clock generation circuits
    pixel_clk_gen PIXEL_CLK_GEN (
        .clk_50 (clk_50),
        .reset (reset),
        .pixel_clk(pixel_clk)
    );

    hsyn_clk_enable_gen HSYNC_GEN (
        .clk_50 (clk_50),
        .pixel_clk (pixel_clk),
        .reset (reset),
        .hsync_n(hsync_n),
        .hsync_clk_enable (hsync_clk_enable)
    );

    vsync_clk_enable_gen VSYNC_GEN (
        .clk_50 (clk_50),
        .reset (reset),
        .hsync_clk_enable(hsync_clk_enable),
        .vsync_n(vsync_n)
    );

    VGA_controller DUT (
        .pixel_clk (pixel_clk),
        .reset (reset),
        .hsync_n (hsync_n),
        .vsync_n(vsync_n),
        .h_sync (h_sync),
        .v_sync (v_sync),
        .R_dac (R_dac),
        .G_dac (G_dac),
        .B_dac (B_dac)
    );

    parameter line_time  = 2 * 2 * 800;
    parameter frame_time = line_time * 525;
    // initial blocks
    initial begin
        reset = 1;
        @ (posedge clk_50);
        reset = 0;

        #(line_time * 10);
        @ (negedge v_sync);
        #(line_time * 10);
        # 100;
        $stop;
    end

    // One clock cycle should last for 20us, each delay is 1 time unit. 
    initial forever begin
        clk_50 = 1; #1;
        clk_50 = 0; #1;
    end




endmodule