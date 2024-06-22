////
//module badApple_top (
//    // Clocking and intputs
//    input  wire          CLOCK_50,
//    input  wire  [3:0]   KEY,            // push buttons on the De1Soc
//
//    // Data Aquisition
//    input wire   [39:0]  GPIO_0,
//
//    // VGA
//    output wire  [7:0]   VGA_R,          // to DAC 
//    output wire  [7:0]   VGA_G,          // to DAC 
//    output wire  [7:0]   VGA_B,          // to DAC 
//    output wire          VGA_CLK,        // to DAC
//    output wire          VGA_SYNC_N,     // to DAC 
//    output wire          VGA_BLANK_N,    // to DAC 
//    output wire          VGA_VS,         // to VGA
//    output wire          VGA_HS,         // to VGA
//
//
//    // Audio
//    
//
//
//
//    // Debugging
//    output logic [9:0]  LEDR
//);
//    // Signal aliases
//    assign reset = ~KEY[0];
//
//
//
//    /////////////////////////////////
//    //          Parameters         //
//    /////////////////////////////////
//
//
//
//    /////////////////////////////////
//    //       Data Acquisition      //
//    /////////////////////////////////
//
//
//
//    // Instantiate data aquisition FSM
//    DATA_FSM DATA_FSM (
//        .CLK_50 (CLOCK_50),
//        .reset (reset),
//        .frame_done(frame_done)
//    );
//
//
//
//    /////////////////////////////////
//    //        Video Modules        //
//    /////////////////////////////////
//
//    wire write_video, video_bank_sel;     // Data acquisition FSM video control signals
//    wire video_bank1_we, video_bank2_we;
//    wire bank1_full, bank2_full;
//    wire bank1_out, bank2_out;
//    wire pixel_color;
//
//    assign video_bank1_we = write_video && ~video_bank_sel;
//    assign video_bank2_we = write_video &&  video_bank_sel;
//    assign frame_done = bank1_full || bank2_full;
//    assign pixel_color = video_bank_sel ? bank1_out : bank2_out; // this will select which bank to read from for pixel color
//
//    screenPositionTracker  #(
//        .X_DATA_WIDTH(X_DATA_WIDTH),
//        .Y_DATA_WIDTH(Y_DATA_WIDTH),
//        .X_LINE_WIDTH(X_LINE_WIDTH),
//        .Y_LINE_WIDTH(Y_LINE_WIDTH)
//    ) VGA_SCREEN_POS (
//        .CLK_50 (CLOCK_50),
//        .reset(reset),
//        .clk_en(pixel_clk), // TODO Change this to be "clock_enable"
//        .x_pos(VGA_x_pos),  // controls which spot in memory to read from
//        .y_pos(VGA_y_pos)   // contorls whcih spot in memory to read from 
//    );
//
//    screenPositionTracker  #(
//        .X_DATA_WIDTH(X_DATA_WIDTH),
//        .Y_DATA_WIDTH(Y_DATA_WIDTH),
//        .X_LINE_WIDTH(X_LINE_WIDTH),
//        .Y_LINE_WIDTH(Y_LINE_WIDTH)
//    ) VIDEO_MEM_POS (
//        .CLK_50 (CLOCK_50),
//        .reset(reset),
//        .clk_en(SPI_clock_enable),
//        .x_pos(mem_x_pos), // controls which spot in memory to write to 
//        .y_pos(mem_y_pos)  // controls which spot in memory to write to 
//    );
//
//    // Instantiate 2 copies of the video bank
//   video_bank VIDEO_BANK_1 (
//        .write_enable(video_bank1_we),
//        .bank_full   (bank1_full), 
//        .data_out    (bank1_out)
//
//   );
//
//   video_bank VIDEO_BANK_2 (
//        .write_enable(video_bank2_we),
//        .bank_full   (bank2_full), 
//        .data_out    (bank2_out)
//   );
//
//    // Instantiate VGA video controller
//    // Will require read from a video bank every 0.390625MHz
//
//
//
//
//
//
//
//    /////////////////////////////////
//    //        Audio Modules        //
//    /////////////////////////////////
//
//    // Instantiate audio FIFO
//
//
//
//    // Instantiate audio controller
//
//    
//
//
//
//
//    // top level clock enable generator
//    // contains 1Mhz SPI clock and 8kHz audio clock 
//endmodule