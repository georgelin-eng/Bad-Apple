`timescale 10ns/100ps

module video_tb ();
// Testing the operation of the data bank

    reg         CLK_40, reset;
    wire        SPI_clk_en, audio_clk_en, read_pixel_clk_en;
    wire        pixel_data_out;
    wire        MISO; 
    wire        video_bank_we;
    reg         video_bank_sel;
    reg         write_enable;
    reg         data_in;
    wire        bank1_out, bank2_out;
    reg         bank_read_done1, bank_read_done2;


    // Define parameters
    parameter RESOLUTION = "800x600";
    parameter SCREEN_WIDTH   = 32;
    parameter SCREEN_HEIGHT  = 24;
    parameter X_WIDTH = SCREEN_WIDTH / 4;   // for memory bank
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

    assign VGA_x_pos_scaled = VGA_x_pos >> 2; // this calculation should be moved inside the video bank 
    assign VGA_y_pos_scaled = VGA_y_pos >> 2;


    assign video_bank1_we = write_enable && ~video_bank_sel;
    assign video_bank2_we = write_enable &&  video_bank_sel;
    assign pixel_color    = video_bank_sel ? bank1_out : bank2_out; // this will select which bank to read from for pixel color


    //////////////////////////////
    //       Data Path          //
    //////////////////////////////


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

    // wire pixel_clk, SPI_clk, locked;
    // VGA_40MHz clock_generation (
    //     .refclk(CLK_40),
    //     .rst(reset),
    //     .outclk_0(pixel_clk),
    //     .outclk_1(SPI_clk),
    //     .locked(locked)
    // );




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
        write_enable = 1;
        @ (posedge CLK_40);
        reset = 0; # 5;


        #(sim_time);

        $stop;
    end

    // This is my event tracker that will print to a log file
    initial forever begin 
        @ (posedge SPI_clk_en) begin
            automatic int x = video_tb.VIDEO_BANK1.x_pos;
            automatic int y = video_tb.VIDEO_BANK1.y_pos;

            // obtain the memory data that's just been written
            automatic int data_written = video_tb.VIDEO_BANK1.video_buffers[0].VIDEO_BUFFER.data_out;


            // prints the current display
            // $display("%0t | x = %d | y = %d | data out = %d", $time, x, y, data_written);           

            @ (posedge bank_read_done2)
                $display("%0t | bank1 = %d | bank2 = %d | spi_clk = %d", $time, bank_read_done1, bank_read_done2, SPI_clk_en);           
        end

    end

    // Data generation at 1Mhz to sync with SPI_clk
    initial forever begin
        data_in = $random % 2; #100;

    end

    initial forever begin
        CLK_40 = 1; #1.25;
        CLK_40 = 0; #1.25;

        mode = video_bank_sel ? "bank 1 read" : "bank 1 write";
    end
endmodule