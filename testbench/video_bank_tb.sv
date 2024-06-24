`timescale 10ns/100ps

module video_bank_tb ();
// Testing the operation of the data bank

    reg CLK_40;
    reg reset;
    reg video_bank_we;
    reg data_in;
    
    wire read_pixel_clk_en, SPI_clk_en;
    wire pixel_data_out;
    wire audio_clk_en;

    parameter SCREEN_WIDTH   = 32;
    parameter SCREEN_HEIGHT  = 24;
    parameter X_WIDTH = SCREEN_WIDTH / 4;    // for memory bank
    parameter Y_HEIGHT = SCREEN_HEIGHT / 4;  // for memory bank

    video_top VIDEO_CONTROL (
        .CLK_40(CLK_40),
        .reset(reset),
        .video_bank_we(video_bank_we),
        .read_pixel_clk_en(read_pixel_clk_en),
        .SPI_clk_en(SPI_clk_en),
        .MISO(data_in),
        .pixel_data_out(pixel_data_out)
    );


    // Instantiate the clk_en_gen module
    clk_en_gen CLK_EN_GEN (
        .CLK_40(CLK_40),
        .reset(reset),
        .read_pixel_clk_en(read_pixel_clk_en),
        .SPI_clk_en(SPI_clk_en),
        .audio_clk_en(audio_clk_en)
    );


    //////////////////////////////////
    //          Simulation          //
    //////////////////////////////////

    parameter line_time_for_write  =       40            *  X_WIDTH ; // 1 pixel clk iteration = 
    parameter frame_time_for_write = line_time_for_write *  SCREEN_HEIGHT ;

    parameter num_frames = 32;
    parameter num_lines = 1.25;
    parameter scaling = 1.00; // used to see a little past 

    parameter sim_time = (num_frames * frame_time_for_write + num_lines * line_time_for_write) * scaling;

    parameter spi_clk_time = 100;

    string mode;

    // initial blocks
    initial begin
        reset = 1;
        // Write one frame into memory
        video_bank_we = 1;
        @ (posedge CLK_40);
        reset = 0; # 5;


        #(sim_time);

        $stop;
    end

    // Data generation at 1Mhz to sync with SPI_clk
    initial forever begin
        data_in = $random % 2; #100;

    end

    initial forever begin
        CLK_40 = 1; #1.25;
        CLK_40 = 0; #1.25;

        mode = video_tb.VIDEO_CONTROL.video_bank_sel ? "bank 1 read" : "bank 1 write";
    end
endmodule