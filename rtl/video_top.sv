module video_top (
    input wire CLK_40, reset,
    input wire SPI_clk_en, audio_clk_en, read_pixel_clk_en;
    input wire pixel_data_out;
    input wire MISO; 
    input wire video_bank_we;
    input reg  video_bank_sel;
    input reg  write_enable;
    input reg  data_in;
    input wire bank1_out, bank2_out;
    input reg  bank_read_done1, bank_read_done2;
);


    //////////////////////////////////
    //       video parameters       //
    //////////////////////////////////

    //Define parameters
    parameter RESOLUTION = "800x600";
    parameter SCREEN_WIDTH   = 32;
    parameter SCREEN_HEIGHT  = 24;
    parameter X_WIDTH = SCREEN_WIDTH / 4;    // for memory bank
    parameter Y_HEIGHT = SCREEN_HEIGHT / 4;  // for memory bank

    // Full parameter widths used for for keep track of pixel position on the screen
    parameter X_ADDRW = $clog2(SCREEN_WIDTH)  ;
    parameter Y_ADDRW = $clog2(SCREEN_HEIGHT) ;

    // scaled down versioned
    parameter X_ADDRW_SCALED = $clog2(X_WIDTH);
    parameter Y_ADDRW_SCALED = $clog2(Y_HEIGHT);

    // Tracking scan line screen position for the frame being displayed
    wire [X_ADDRW - 1:0]        VGA_x_pos;
    wire [Y_ADDRW - 1:0]        VGA_y_pos;
    wire [X_ADDRW_SCALED - 1:0] VGA_x_pos_scaled;
    wire [Y_ADDRW_SCALED - 1:0] VGA_y_pos_scaled;

    // Tracking memory position for the frame being written into memory
    wire [X_ADDRW_SCALED - 1:0] mem_x_pos;
    wire [Y_ADDRW_SCALED - 1:0] mem_y_pos;



    //////////////////////////////
    //       Data Path          //
    //////////////////////////////

    assign VGA_x_pos_scaled = VGA_x_pos >> 2; // this calculation should be moved inside the video bank 
    assign VGA_y_pos_scaled = VGA_y_pos >> 2;


    assign video_bank1_we = write_enable && ~video_bank_sel;
    assign video_bank2_we = write_enable &&  video_bank_sel;
    assign pixel_color    = video_bank_sel ? bank1_out : bank2_out; // this will select which bank to read from for pixel color


    // Assign the value of video_bank_sel based ON TRANSITION only
    // Video transition logic (based on pixel timings and counting)
    // registered output logic
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            video_bank_sel <= 1'b0;
        end else begin
            if (read_pixel_clk_en) begin // video bank selection transition happens on pixel read.   
                if (bank_read_done1 || bank_read_done2) begin
                    video_bank_sel <= ~video_bank_sel;
                end
            end
        end
    end



    ///////////////////////////////////
    //      Block level modules      //
    ///////////////////////////////////

    // Instantiate the video_bank module. It should have a size of 200x150 as well
    video_bank #(
        .WIDTH(SCREEN_WIDTH),
        .HEIGHT(SCREEN_HEIGHT)
    ) VIDEO_BANK1 (
        // Connect module ports
        .CLK_40(CLK_40),
        .read_pixel_clk_en(read_pixel_clk_en),
        .SPI_clk_en(SPI_clk_en),
        .reset(reset),
        .write_enable(video_bank1_we),
        .VGA_x_pos(VGA_x_pos),
        .VGA_y_pos(VGA_y_pos),
        .mem_x_pos(mem_x_pos),
        .mem_y_pos(mem_y_pos),
        .data_in(data_in),
        .data_out(bank1_out),
        .bank_read_done(bank_read_done1)
    );

    // Instantiate the video_bank module. It should have a size of 200x150 as well
    video_bank #(
        .WIDTH(SCREEN_WIDTH),
        .HEIGHT(SCREEN_HEIGHT)
    ) VIDEO_BANK2 (
        // Connect module ports
        .CLK_40(CLK_40),
        .SPI_clk_en(SPI_clk_en),
        .read_pixel_clk_en(read_pixel_clk_en),
        .reset(reset),
        .write_enable(video_bank2_we),
        .VGA_x_pos(VGA_x_pos),
        .VGA_y_pos(VGA_y_pos),
        .mem_x_pos(mem_x_pos),
        .mem_y_pos(mem_y_pos),
        .data_in(data_in),
        .data_out(bank2_out),
        .bank_read_done(bank_read_done2)
    );

    // VGA screen position tracker
    screenPositionTracker #(
        .X_LINE_WIDTH(SCREEN_WIDTH),
        .Y_LINE_WIDTH(SCREEN_HEIGHT)
    ) VGA_screen_pos (
        // Connect module ports
        .CLK_40(CLK_40),
        .reset(reset),
        .clk_en(read_pixel_clk_en), // logic one
        .x_pos(VGA_x_pos),
        .y_pos(VGA_y_pos)
    );

    // memory address tracker for writting in data
    // memory size is 200x150 since we're displaying in a 4x scale on x and y 
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

    // Instantiate the clk_en_gen module
    clk_en_gen CLK_EN_GEN (
        .CLK_40(CLK_40),
        .reset(reset),
        .read_pixel_clk_en(read_pixel_clk_en),
        .SPI_clk_en(SPI_clk_en),
        .audio_clk_en(audio_clk_en)
    );


endmodule
