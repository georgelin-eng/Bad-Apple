`include "params.sv"
module video_top (
    input logic          CLK_40, 
    input logic          data_write_clk,
    input logic          data_clk_rising_edge,
    input logic          reset,
    input logic          read_bank1,
    input logic          read_bank2,
    input logic          chip_select,         // used to pre-empitvely switch to SPI clock on the expectation of incoming data
    input logic          video_data_ready,
    input logic          VGA_en,
    input logic          VGA_startup_en,      // sets pixel color to pure white in the VGA startup/sync mode

    input logic          received_bit,        // incoming data

    // VGA
    output wire  [7:0]   VGA_R,          // to DAC 
    output wire  [7:0]   VGA_G,          // to DAC 
    output wire  [7:0]   VGA_B,          // to DAC 
    output wire          VGA_CLK,        // to DAC, clock signal
    output wire          VGA_SYNC_N,     // to DAC, Active low for sync
    output wire          VGA_BLANK_N,    // to DAC, Active low for blanking
    output wire          VGA_VS,         // to VGA, Active high for sync
    output wire          VGA_HS          // to VGA, Active high for sync

);

    //////////////////////////////////
    //       video parameters       //
    //////////////////////////////////

    //Define parameters
    parameter mode       = `MODE;
    parameter RESOLUTION = "800x600";

    parameter WHOLE_LINE            = (mode == "NORMAL") ? 1056 : 40 ;
    parameter WHOLE_FRAME           = (mode == "NORMAL") ? 628  : 32 ;
    parameter ACTIVE_SCREEN_WIDTH   = (mode == "NORMAL") ? 800  : 32 ;
    parameter ACTIVE_SCREEN_HEIGHT  = (mode == "NORMAL") ? 600  : 24 ;

    parameter X_WIDTH  = ACTIVE_SCREEN_WIDTH / 4;    // for memory bank
    parameter Y_HEIGHT = ACTIVE_SCREEN_HEIGHT / 4;  // for memory bank

    // Full parameter widths used for for keep track of pixel position on the screen
    parameter X_ADDRW = $clog2(WHOLE_LINE)  ;
    parameter Y_ADDRW = $clog2(WHOLE_FRAME) ;

    // scaled down versioned
    parameter X_ADDRW_SCALED = $clog2(X_WIDTH);
    parameter Y_ADDRW_SCALED = $clog2(Y_HEIGHT);

    // Tracking scan line screen position for the frame being displayed
    wire [X_ADDRW - 1:0]        VGA_x_pos;
    wire [Y_ADDRW - 1:0]        VGA_y_pos;

    // Tracking memory position for the frame being written into memory
    wire [X_ADDRW_SCALED - 1:0] mem_x_pos;
    wire [Y_ADDRW_SCALED - 1:0] mem_y_pos;


    //////////////////////////////
    //       Data Path          //
    //////////////////////////////
    logic bank1_out, bank2_out;
    logic ACTIVE;

    assign pixel_data_out = read_bank1 ? bank1_out : bank2_out; // Pixel color read from memory

    ///////////////////////////////////
    //         Video Memory          //
    ///////////////////////////////////

    // Instantiate the video_bank module. It should have a size of 200x150 as well
    video_bank #(
        .WHOLE_LINE(WHOLE_LINE),
        .WHOLE_FRAME(WHOLE_FRAME),
        .WIDTH(ACTIVE_SCREEN_WIDTH),
        .HEIGHT(ACTIVE_SCREEN_HEIGHT)
    ) VIDEO_BANK1 (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .read_pixel_clk_en(CLK_40),
        .data_write_clk(data_write_clk),
        .data_clk_rising_edge(data_clk_rising_edge),
        .read_enable(read_bank1),
        .chip_select(chip_select),
        .video_data_ready(video_data_ready),
        .VGA_x_pos(VGA_x_pos),
        .VGA_y_pos(VGA_y_pos),
        .mem_x_pos(mem_x_pos),
        .mem_y_pos(mem_y_pos),
        .data_in(received_bit),
        .active(ACTIVE),
        .data_out(bank1_out)
    );

    // Instantiate the video_bank module. It should have a size of 200x150 as well
    video_bank #(
        .WHOLE_LINE(WHOLE_LINE),
        .WHOLE_FRAME(WHOLE_FRAME),
        .WIDTH(ACTIVE_SCREEN_WIDTH),
        .HEIGHT(ACTIVE_SCREEN_HEIGHT)
    ) VIDEO_BANK2 (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .read_pixel_clk_en(CLK_40), // not set to logic 1 due the way the clock mux works
        .data_write_clk(data_write_clk),
        .data_clk_rising_edge(data_clk_rising_edge),
        .read_enable(read_bank2),
        .chip_select(chip_select),
        .video_data_ready(video_data_ready),
        .VGA_x_pos(VGA_x_pos),
        .VGA_y_pos(VGA_y_pos),
        .mem_x_pos(mem_x_pos),
        .mem_y_pos(mem_y_pos),
        .data_in(received_bit),
        .active(ACTIVE),
        .data_out(bank2_out)
    );


    //////////////////////////////////
    //    Memory Address Tracking   //
    //////////////////////////////////

    // Tracking current screen position for read operations
    // Generate a 1056 x 628 position tracker for memory read operations
    screenPositionTracker #(
        .X_LINE_WIDTH(WHOLE_LINE),
        .Y_LINE_WIDTH(WHOLE_FRAME)
    ) VGA_screen_pos (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_en(1'b1),  
        .count_en(read_bank1 | read_bank2),  // this is so that the screen isn't read while in MODE_FSM : IDLE 
        .x_pos(VGA_x_pos),
        .y_pos(VGA_y_pos)
    );

    // Tracing screen position for write operations based on SPI clock 
    // Generate 200x150 position tracker for memory write operations
    screenPositionTracker #(
        .X_LINE_WIDTH(X_WIDTH),
        .Y_LINE_WIDTH(Y_HEIGHT)
    ) mem_pos_tracker (
        // Connect module ports
        .CLK_40(CLK_40),
        .clk_en(data_clk_rising_edge),     // I need it to increment another time
        .count_en(video_data_ready),       // only start the count once writing starts
        .reset(reset),
        .x_pos(mem_x_pos),
        .y_pos(mem_y_pos)
    );

    //////////////////////////////
    //       VGA Controller     //
    //////////////////////////////
    logic pixel_color;
    always_comb begin
        if (VGA_startup_en) pixel_color = 1'b1;
        else                pixel_color = pixel_data_out;
    end

    VGA_top VGA_controller (
            .CLK_40(CLK_40),
            .reset(reset),
            .pixel_color(pixel_color),  // input to VGA controller to display
            .count_en(VGA_en),
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .VGA_CLK(VGA_CLK),
            .VGA_SYNC_N(VGA_SYNC_N),
            .VGA_BLANK_N(VGA_BLANK_N),
            .VGA_VS(VGA_VS),
            .VGA_HS(VGA_HS),
            .ACTIVE(ACTIVE)
        );

endmodule
