`timescale 10ns/100ps

module video_tb ();

    // Test video playback on the main top level module
    logic CLK_40, SPI_clk, reset;
    logic write_video;
    wire SPI_clk_en, audio_clk_en;
    logic MISO;

    logic [7:0] VGA_R, VGA_G, VGA_B;

    clk_en_gen CLK_EN_GEN (
        .CLK_40(CLK_40),
        .reset(reset),
        .SPI_clk_en(SPI_clk_en),
        .audio_clk_en(audio_clk_en)
    );
   
    video_top VIDEO_CONTROLLER (
        .CLK_40(CLK_40),
        .SPI_clk(SPI_clk),
        .reset(reset),
        .video_bank_we(write_video),
        .SPI_clk_en(SPI_clk_en),
        .bank_full(bank_full),
        .MISO(MISO),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_CLK(VGA_CLK),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_VS(VGA_VS),
        .VGA_HS(VGA_HS)
    );
    
    /*
    *    Test Cases
    *        Initiate video write
    *
    *
    *
    *
    *
    *
    */


    parameter num_us = 250;

    initial begin

        // reset sequence
        write_video = 0;
        reset = 1;
        @ (posedge CLK_40);
        reset = 0; # 5; 
        
        #(100* num_us);

        $stop;
    end



    initial forever begin
        CLK_40 = 1; #1.25;
        CLK_40 = 0; #1.25;
    end

    initial forever begin
        // MISO = $random %2;
        SPI_clk = 0; #50;
        SPI_clk = 1; #50;

    end


endmodule