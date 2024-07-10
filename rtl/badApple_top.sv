`include "params.sv"
module badApple_top (
   // Clocking and intputs
   input  wire          CLOCK_50,
   input  wire  [3:0]   KEY,            // push buttons on the De1Soc

   // Data Aquisition
   input  logic [39:0]   GPIO_0,         // MISO, SPI_clk
   output logic [39:0]   GPIO_1,         // chip_select

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
   output logic [9:0]    LEDR, 

   output logic [6:0]    HEX0,           // 7-segment display 0
   output logic [6:0]    HEX1,           // 7-segment display 1 
   output logic [6:0]    HEX2,           // 7-segment display 2 
   output logic [6:0]    HEX3,           // 7-segment display 3
   output logic [6:0]    HEX4,           // 7-segment display 4 
   output logic [6:0]    HEX5            // 7-segment display 5 
);

    /////////////////////////////////    
    //   Input and output Signals  //
    /////////////////////////////////
    logic chip_select;
    assign reset       = ~KEY[0];       // input
    assign init        = ~KEY[1];       // input
    assign vid_start   = ~KEY[2];       // input 

    assign SPI_clk_CDC = GPIO_0[0];     // input
    assign MISO_CDC    = GPIO_0[1];     // input 


    assign GPIO_1[0]   = chip_select;   // output


    /////////////////////////////////
    //       Clock Generation      //
    /////////////////////////////////
    
    `ifndef DEBUG_ON
        VGA_40MHz clock_generation (
                .refclk(CLOCK_50),
                .rst(reset),
                .outclk_0(CLK_40),
                .outclk_1(data_write_clk_CDC),
                .locked(locked)
        );
        clk_divider  #( .divisor (`FRAME_PIXEL_COUNT / 32) ) DEBUG_CLK 
        (
            .CLK_40(CLK_40),
            .reset(reset),
            .clk_out(clk_debug)
        );
    `endif 

    clk_divider # (.divisor(20)) DATA_CLK_GEN
    (
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_out(data_write_clk)
    );

    /////////////////////////////////
    //    Clock Domain Crossing    //
    /////////////////////////////////

    // Here the SPI and data clocks are oversampled and brought into the
    // 40MHz clock domain 

    dff_sync2 SPI_CLK (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(SPI_clk_CDC),        // clock domain that you're coming from
        .data_out(SPI_clk)            // new data that's now in target clock domain
    );

     dff_sync2 DATA (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(MISO_CDC),           // clock domain that you're coming from
        .data_out(MISO)               // new data that's now in target clock domain
    );

    /////////////////////////////////
    //       Edge Detection        //
    /////////////////////////////////
    edge_detect SPI_edge (
        .sample_clk(CLK_40),
        .reset(reset),
        .target_data(SPI_clk),
        .rising_edge(SPI_clk_rising_edge),
        .falling_edge(SPI_clk_falling_edge)
    );

   edge_detect data_clk_edge (
        .sample_clk(CLK_40),
        .reset(reset),
        .target_data(data_write_clk),
        .rising_edge(data_clk_rising_edge),
        .falling_edge(data_clk_falling_edge)
    );


    /////////////////////////////////
    //       Data Acquisition      //
    /////////////////////////////////
    MODE_FSM MODE_FSM (
        .CLK_40(CLK_40),
        .reset (reset),
        .init(init),
        .vid_start(vid_start),
        
        .switch_mode(switch_mode),
        .start_data_FSM(start_data_FSM),
        .read_bank1 (read_bank1),
        .read_bank2 (read_bank2),
        .VGA_startup_en (VGA_startup_en),
        .pause_en(pause_en)
    );
    
    DATA_FSM DATA_FSM (
        .CLK_40(CLK_40),
        .SPI_clk(SPI_clk), // Inside the 40MHz clock domain
        .SPI_clk_CDC(SPI_clk_CDC),
        .data_write_clk(data_write_clk), // Inside the 40MHz clock domain
        .data_write_clk_CDC(data_write_clk_CDC),
        .reset(reset),
        .SPI_clk_rising_edge(SPI_clk_rising_edge),
        .SPI_clk_falling_edge(SPI_clk_falling_edge),
        .data_clk_rising_edge(data_clk_rising_edge),
        .data_clk_falling_edge(data_clk_falling_edge),
        .start_req(start_req),
        .video_data_ready(video_data_ready),
        .audio_data_ready(audio_data_ready),

        .MISO(MISO),
        .chip_select(chip_select),

        .received_bit(received_bit)
    );

    /////////////////////////////////
    //        Video Modules        //
    /////////////////////////////////

 
    video_top VIDEO_CONTROLLER (
        .CLK_40(CLK_40),
        .data_write_clk(data_write_clk),
        .data_clk_rising_edge(data_clk_rising_edge),
        .reset(reset),
        .read_bank1 (read_bank1),
        .read_bank2 (read_bank2),
        .chip_select(chip_select),
        .video_data_ready(video_data_ready),
        .VGA_en(VGA_en), 
        .VGA_startup_en(VGA_startup_en), 
        .received_bit(received_bit),

        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_CLK(VGA_CLK),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_VS(VGA_VS),
        .VGA_HS(VGA_HS)
    );

    /////////////////////////////////
    //       Video Data Path       //
    /////////////////////////////////

    assign VGA_en = VGA_startup_en || (read_bank1 || read_bank2);
    assign start_req = switch_mode || start_data_FSM;


    /////////////////////////////////
    //        Audio Modules        //
    /////////////////////////////////

    // Instantiate audio FIFO



    // Instantiate audio controller
       




    // top level clock enable generator
    // contains 1Mhz SPI clock and 8kHz audio clock 

    /////////////////////////////////
    //         Debugging           //
    /////////////////////////////////

    reg   [23:0] DATA_BUFF;

    always_ff @ (posedge data_write_clk) begin // seems like this can work but not using the deticated clocking resources
        if (video_data_ready) begin
            DATA_BUFF <= {DATA_BUFF[22:0], received_bit};
        end
    end

    // Extract 4-bit nibbles from DATA_BUFF
    wire [3:0] nibble0 = DATA_BUFF[3:0];
    wire [3:0] nibble1 = DATA_BUFF[7:4];
    wire [3:0] nibble2 = DATA_BUFF[11:8];
    wire [3:0] nibble3 = DATA_BUFF[15:12];
    wire [3:0] nibble4 = DATA_BUFF[19:16];
    wire [3:0] nibble5 = DATA_BUFF[23:20];

    // Instantiate hex_to_7segment modules for each display
    hex_to_7segment u0 (.hex_digit(nibble0), .segments(HEX0));
    hex_to_7segment u1 (.hex_digit(nibble1), .segments(HEX1));
    hex_to_7segment u2 (.hex_digit(nibble2), .segments(HEX2));
    hex_to_7segment u3 (.hex_digit(nibble3), .segments(HEX3));
    hex_to_7segment u4 (.hex_digit(nibble4), .segments(HEX4));
    hex_to_7segment u5 (.hex_digit(nibble5), .segments(HEX5));


endmodule