`timescale 10ns/10ns
module tb ();

    reg         clk_50, reset;
    wire        pixel_clk, hsync_n, vsync_n;
    wire        sync, blank;
    wire  [7:0] R, G, B;


    VGA_top  DUT (
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

    parameter line_time  = 2 * 2 * 800;
    parameter frame_time = line_time * 525;
    // initial blocks
    initial begin
        reset = 1;
        @ (posedge clk_50);
        reset = 0;
        
        // Initialize memory?

        #(line_time * 10);
        @ (negedge vsync_n);
        #(frame_time/2);
        #(line_time * 2);
        # 100;
        $stop;
    end

    // One clock cycle should last for 20us, each delay is 1 time unit. 
    initial forever begin
        clk_50 = 1; #1;
        clk_50 = 0; #1;
    end




endmodule