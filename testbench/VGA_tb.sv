`timescale 10ns/10ns
module tb ();

    reg         clk_50, reset;
    wire        pixel_clk, hsync_n, vsync_n;
    wire        sync, blank;
    wire  [7:0] R, G, B;

    // The two resolutions supported
//  parameter RESOLUTION = "800x600";    // memory will be 200 x 150 -> 450kb/s @ 15Hz
    parameter RESOLUTION = "640x480";    // memory will be 160 x 120 -> 288kb/s @ 15Hz


    VGA_top # (
        .RESOLUTION(RESOLUTION)
    ) DUT (
        .CLOCK_50(clk_50),
        .KEY ({~reset,3'b0}),
        .VGA_R(R),
        .VGA_G(G),
        .VGA_B(B),
        .VGA_CLK(pixel_clk),
        .VGA_SYNC_N(sync),
        .VGA_BLANK_N(blank),
        .VGA_VS(vsync_n),
        .VGA_HS(hsync_n)
    );

    parameter line_time  =      4    * ((RESOLUTION == "640x480") ? 800 : 1056)  ;
    parameter frame_time = line_time * ((RESOLUTION == "640x480") ? 525 : 628)   ;

    parameter num_frames = 3;
    parameter num_lines = 3;
    parameter scaling = 1.05; // used to see a little past 

    parameter sim_time = (num_frames * frame_time + num_lines * line_time) * scaling;
    // initial blocks
    initial begin
        reset = 1;
        @ (posedge clk_50);
        reset = 0;
        
        #(sim_time);

        $stop;
    end

    // One clock cycle should last for 20ns, each delay is 1 time unit. 
    initial forever begin
        clk_50 = 1; #1;
        clk_50 = 0; #1;
    end




endmodule