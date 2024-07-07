module data_translater (
   // Clocking and intputs
   input  wire          CLOCK_50,
   input  wire  [3:0]   KEY,            // push buttons on the De1Soc

   // Data Aquisition
   input  logic [39:0]   GPIO_0,         // MISO, SPI_clk
   output logic [39:0]   GPIO_1,         // chip_select
   output logic [9:0]    LEDR,
   output logic [6:0]    HEX0,           // 7-segment display 0
   output logic [6:0]    HEX1,           // 7-segment display 1 
   output logic [6:0]    HEX2,           // 7-segment display 2 
   output logic [6:0]    HEX3,           // 7-segment display 3
   output logic [6:0]    HEX4,           // 7-segment display 4 
   output logic [6:0]    HEX5            // 7-segment display 5 
);

    logic SPI_clk_CDC, data_write_clk_CDC;
    logic SPI_clk, data_write_clk;
    logic MISO_CDC;
    logic chip_select;
    reg   [23:0] DATA_BUFF;
    logic MISO;
    assign SPI_clk_CDC = GPIO_0[0];  // input ***** I think this might be what's causing issues. Can't even blink an LED with this clock
    assign MISO_CDC    = GPIO_0[1];  // input 


    assign reset     = ~KEY[0];       // input
    assign init      = ~KEY[1];       // input
    assign vid_start = ~KEY[2];       // input 

    assign GPIO_1[0] = chip_select;   // output

    ////////////////////////////////////////////////
    
    assign GPIO_1[1] = chip_select;
    assign GPIO_1[2] = SPI_clk;
    assign GPIO_1[3] = data_write_clk_CDC;
    assign GPIO_1[4] = data_write_clk;

    dff_sync2 SPI_CLK (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(SPI_clk_CDC),        // clock domain that you're coming from
        .data_out(SPI_clk)            // new data that's now in target clock domain
    );

    dff_sync2 DATA_CLK (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(data_write_clk_CDC),        // clock domain that you're coming from
        .data_out(data_clk)            // new data that's now in target clock domain
    );

    VGA_40MHz clock_generation (
            .refclk(CLOCK_50),
            .rst(reset),
            .outclk_0(CLK_40),
            .outclk_1(data_write_clk_CDC),
            .locked(locked)
    );

    dff_sync2 DATA_WRITE_CLK (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(data_write_clk_CDC), // clock domain that you're coming from
        .data_out(data_write_clk)     // new data that's now in target clock domain
    );

    FSM_top FSM_TOP (
        .CLK_40(CLK_40),
        .reset(reset),
        .init(init),
        .vid_start(vid_start),
        .MISO_CDC(MISO_CDC),
        .SPI_clk_CDC(SPI_clk_CDC),
        .data_write_clk_CDC(data_write_clk_CDC),
        .received_bit(received_bit),
        .video_data_ready(video_data_ready),
        .SPI_clk_rising_edge(SPI_clk_rising_edge),
        .data_clk_rising_edge(data_clk_rising_edge),
        .chip_select(chip_select)
    );


    debug_clk_gen DEBUG_CLK (
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_debug(clk_debug)
    );

    /////////////////////////////////////
    //   Registering my output data    //
    /////////////////////////////////////

    logic get_data_en;

    always_ff @ (posedge CLK_40) begin
        get_data_en <= video_data_ready & data_clk_rising_edge;
    end
    
    always_ff @ (posedge CLK_40) begin
        if (get_data_en) begin
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