module badApple_top (
   // Clocking and intputs
   input  wire          CLOCK_50,
   input  wire  [3:0]   KEY,            // push buttons on the De1Soc

   // Data Aquisition
   input  logic [39:0]   GPIO_0,         // MISO
   output logic [39:0]   GPIO_1,         // MOSI, chip_select, SPI_clk

   // VGA
   output wire  [7:0]   VGA_R,          // to DAC 
   output wire  [7:0]   VGA_G,          // to DAC 
   output wire  [7:0]   VGA_B,          // to DAC 
   output wire          VGA_CLK,        // to DAC
   output wire          VGA_SYNC_N,     // to DAC 
   output wire          VGA_BLANK_N,    // to DAC 
   output wire          VGA_VS,         // to VGA
   output wire          VGA_HS,         // to VGA


   // Audio



   // Debugging
   output logic [9:0]  LEDR
);


    // Signal aliases

    logic reset, INIATE, MOSI, chip_select;
    logic CLK_40, SPI_clk, locked;

    assign reset     = ~KEY[0];       // input
    assign INITATE   = ~KEY[1];       // input
    assign MISO      = GPIO_0[0];     // input
    assign GPIO_1[1] = MOSI;          // output
    assign GPIO_1[2] = chip_select;   // output
    assign GPIO_1[3] = SPI_clk;       // output



    /////////////////////////////////
    //          Parameters         //
    /////////////////////////////////






    /////////////////////////////////
    //       Clock Generation      //
    /////////////////////////////////


    // clk enable signals are generated as well as regular clocks 
    // This is to keep logic inside the same clock domain within the FPGA
    // RAM read and write in video banks is done via a dedicated clock mux
    // This is indented to be the only other clock domain

    wire SPI_clk_en, audio_clk_en;

    clk_en_gen CLK_EN_GEN (
        .CLK_40(CLK_40),
        .reset(reset),
        .SPI_clk_en(SPI_clk_en),
        .audio_clk_en(audio_clk_en)
    );

    VGA_40MHz clock_generation (
            .refclk(CLOCK_50),
            .rst(reset),
            .outclk_0(CLK_40),
            .outclk_1(SPI_clk),
            .locked(locked)
    );


    /////////////////////////////////
    //       Data Acquisition      //
    /////////////////////////////////



    // Instantiate data aquisition FSM
    DATA_FSM DATA_FSM (
        .CLK_40 (CLK_40),
        .SPI_clk_en(SPI_clk_en),
        .reset (reset),

        .start(start),
        .frame_done(frame_done),
        .video_bank_full(bank_full),
        .write_video(write_video)
    );


    /////////////////////////////////
    //        Video Modules        //
    /////////////////////////////////

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
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_VS(VGA_VS),
        .VGA_HS(VGA_HS)
    );



    /////////////////////////////////
    //        Audio Modules        //
    /////////////////////////////////

    // Instantiate audio FIFO



    // Instantiate audio controller
       




    // top level clock enable generator
    // contains 1Mhz SPI clock and 8kHz audio clock 

endmodule