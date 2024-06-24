module video_top (
    input logic          CLK_40, 
    input logic          SPI_clk,
    input logic          reset,
    input logic          video_bank_we,

    input logic          SPI_clk_en,          // writing into video bank

    input logic          MISO,                // incoming data

    output logic         bank_full,           // lets the data FSM transition states

    // VGA
     output wire  [7:0]  VGA_R,          // to DAC 
    output wire  [7:0]   VGA_G,          // to DAC 
    output wire  [7:0]   VGA_B,          // to DAC 
    output wire          VGA_CLK,        // to DAC, clock signal
    output wire          VGA_SYNC_N,     // to DAC, Active low for sync
    output wire          VGA_BLANK_N,    // to DAC, Active low for blanking
    output wire          VGA_VS,         // to VGA, Active high for sync
    output wire          VGA_HS          // to VGA, Active high for sync


    // // Debugging
    // output logic [19:0]  GPIO_0,         
    // output logic [9:0]   LEDR,         
    // output logic         clk_debug   
);

    //////////////////////////////////
    //       video parameters       //
    //////////////////////////////////

    //Define parameters
    parameter RESOLUTION = "800x600";

    parameter WHOLE_LINE            = 1056;
    parameter WHOLE_FRAME           = 628;
    parameter ACTIVE_SCREEN_WIDTH   = 800;
    parameter ACTIVE_SCREEN_HEIGHT  = 600;

    parameter X_WIDTH  = ACTIVE_SCREEN_WIDTH / 4;    // for memory bank
    parameter Y_HEIGHT = ACTIVE_SCREEN_HEIGHT / 4;  // for memory bank

    // Full parameter widths used for for keep track of pixel position on the screen
    parameter X_ADDRW = $clog2(ACTIVE_SCREEN_WIDTH)  ;
    parameter Y_ADDRW = $clog2(ACTIVE_SCREEN_HEIGHT) ;

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
	logic data_in;
    logic video_bank_sel;
    logic bank_read_done1, bank_read_done2;
	logic video_bank1_we, video_bank2_we;
    logic bank1_out, bank2_out;
    logic bank1_full, bank2_full;
    logic ACTIVE;

    assign video_bank1_we = video_bank_we && ~video_bank_sel;
    assign video_bank2_we = video_bank_we &&  video_bank_sel;
    assign pixel_data_out = video_bank_sel ? bank1_out : bank2_out; // Pixel color read from memory
    assign bank_full      = bank1_full || bank2_full;
    assign data_in = MISO;

    // Transition to a new video bank when we've finished reading from the current selection
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            video_bank_sel <= 1'b0;
        end else begin
            if (bank_read_done1 || bank_read_done2) video_bank_sel <= ~video_bank_sel;
        end
    end

    ///////////////////////////////////
    //         Video Memory          //
    ///////////////////////////////////

    // Instantiate the video_bank module. It should have a size of 200x150 as well
    video_bank #(
        .X_WIDTH(X_WIDTH),
        .Y_HEIGHT(Y_HEIGHT)
    ) VIDEO_BANK1 (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .read_pixel_clk(CLK_40),
        .SPI_clk(SPI_clk),
        .write_enable(video_bank1_we),
        .VGA_x_pos(VGA_x_pos),
        .VGA_y_pos(VGA_y_pos),
        .mem_x_pos(mem_x_pos),
        .mem_y_pos(mem_y_pos),
        .data_in(data_in),
        .active(ACTIVE),
        .data_out(bank1_out),
        .bank_read_done(bank_read_done1),
        .bank_full(bank1_full)
    );

    // Instantiate the video_bank module. It should have a size of 200x150 as well
    video_bank #(
        .X_WIDTH(X_WIDTH),
        .Y_HEIGHT(Y_HEIGHT)
    ) VIDEO_BANK2 (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .read_pixel_clk(CLK_40), // not set to logic 1 due the way the clock mux works
        .SPI_clk(SPI_clk),
        .write_enable(video_bank2_we),
        .VGA_x_pos(VGA_x_pos),
        .VGA_y_pos(VGA_y_pos),
        .mem_x_pos(mem_x_pos),
        .mem_y_pos(mem_y_pos),
        .data_in(data_in),
        .active(ACTIVE),
        .data_out(bank2_out),
        .bank_read_done(bank_read_done2),
        .bank_full(bank2_full)
    );


    //////////////////////////////////
    //    Memory Address Tracking   //
    //////////////////////////////////

    // Tracking current screen position for read operations
    screenPositionTracker #(
        .X_LINE_WIDTH(WHOLE_LINE),
        .Y_LINE_WIDTH(WHOLE_FRAME)
    ) VGA_screen_pos (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_en(1'b1),  
        .x_pos(VGA_x_pos),
        .y_pos(VGA_y_pos)
    );

    // Tracing screen position for write operations based on SPI clock 
    screenPositionTracker #(
        .X_LINE_WIDTH(X_WIDTH),
        .Y_LINE_WIDTH(Y_HEIGHT)
    ) mem_pos_tracker (
        // Connect module ports
        .CLK_40(CLK_40),
        .clk_en(SPI_clk_en),
        .reset(reset),
        .x_pos(mem_x_pos),
        .y_pos(mem_y_pos)
    );

    //////////////////////////////
    //       VGA Controller     //
    //////////////////////////////;

    VGA_top VGA_controller (
            .CLK_40(CLK_40),
            .pixel_color(pixel_data_out), // input to VGA controller to display
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
