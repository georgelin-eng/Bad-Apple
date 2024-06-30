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

    logic reset, INIATE, MOSI, MISO, chip_select;
    logic CLK_40, SPI_clk, locked;
    logic read_bank1, read_bank2;
    logic mem_clk;

    assign reset     = ~KEY[0];       // input
    assign init      = ~KEY[1];       // input
    // assign MISO      = GPIO_0[0];     // input
    assign MISO      = 1'b1;          // get out of write state just for video playback testing
    assign GPIO_1[1] = MOSI;          // output
    assign GPIO_1[2] = chip_select;   // output
    assign GPIO_1[3] = SPI_clk;       // output

	 assign LEDR[0] = reset;
	 assign LEDR[1] = init;
     assign LEDR[2] = read_bank1 | read_bank2;
    //  assign LEDR[3] = read_bank2;
	 
	 // Debug
	 assign GPIO_1[4] = VGA_VS;
	 assign GPIO_1[5] = VGA_HS;
	 assign GPIO_1[6] = VGA_CLK;
	 assign GPIO_1[7] = VGA_SYNC_N;
	 assign GPIO_1[8] = VGA_BLANK_N;
	 assign GPIO_1[9] = VGA_R;
	 assign GPIO_1[10] = VGA_G;
	 assign GPIO_1[11] = VGA_B;
     assign GPIO_1[12] = mem_clk; // in theory should always look like VGA_CLK
	 logic clk_debug;
     logic [3:0] bank_counter;
     assign LEDR [7:4] = bank_counter;

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


    debug_clk_gen DEBUG_CLK (
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_debug(clk_debug)
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

    MODE_FSM MODE_FSM (
        .CLK_40(CLK_40),
        .reset (reset),
        .init(init),
        
        .switch_mode(start_req),
        .read_bank1 (read_bank1),
        .read_bank2 (read_bank2),
        .write_bank1 (write_bank1),
        .write_bank2 (write_bank2)
    );
    

    // Instantiate data aquisition FSM
   DATA_FSM DATA_FSM (
        .CLK_40 (CLK_40),
        .SPI_clk_en(SPI_clk_en),
        .reset (reset),
        .init(init),

        .start_req(start_req),
        .video_data_ready(video_data_ready),
        .audio_data_ready(audio_data_ready),

        .MISO(MISO),
        .MOSI(MOSI),
        .chip_select(chip_select),

        .write_audio ()
    );

    /////////////////////////////////
    //        Video Modules        //
    /////////////////////////////////

    video_top VIDEO_CONTROLLER (
        .CLK_40(CLK_40),
        .SPI_clk(SPI_clk),
        .reset(reset),
        .read_bank1 (read_bank1),
        .read_bank2 (read_bank2),
        .chip_select(chip_select),
        .video_data_ready(video_data_ready),

        .SPI_clk_en(SPI_clk_en),
        .MISO(MISO),

        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_CLK(VGA_CLK),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_VS(VGA_VS),
        .VGA_HS(VGA_HS),
        .bank_counter(bank_counter),
        .mem_clk(mem_clk)
    );


    /////////////////////////////////
    //        Audio Modules        //
    /////////////////////////////////

    // Instantiate audio FIFO



    // Instantiate audio controller
       




    // top level clock enable generator
    // contains 1Mhz SPI clock and 8kHz audio clock 

endmodule