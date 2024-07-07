module FSM_top (
    input CLK_40,
    input reset,
    input init,
    input vid_start,
    input MISO_CDC,
    input SPI_clk_CDC,               // _CDC means that CDC still needs to be dealt with
    input data_write_clk_CDC,

    output logic received_bit,
    output logic video_data_ready,
    output logic data_clk_rising_edge,
    output logic SPI_clk_rising_edge,
    output logic chip_select
);

    /////////////////////////////
    //          CDC            //
    /////////////////////////////

    dff_sync2 SPI_CLK (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(SPI_clk_CDC),        // clock domain that you're coming from
        .data_out(SPI_clk)            // new data that's now in target clock domain
    );

    dff_sync2 DATA_WRITE_CLK (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(data_write_clk_CDC), // clock domain that you're coming from
        .data_out(data_write_clk)     // new data that's now in target clock domain
    );
    
    dff_sync2 DATA (
        .clk(CLK_40),                 // target clock domain
        .reset(reset),
        .data_in(MISO_CDC),           // clock domain that you're coming from
        .data_out(MISO)               // new data that's now in target clock domain
    );

    //////////////////////// 
    //        FSM         //
    //////////////////////// 

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

    logic start_req;
    assign start_req = switch_mode || start_data_FSM;

    DATA_FSM DATA_FSM (
        .CLK_40(CLK_40),
        .SPI_clk(SPI_clk), // Inside the 40MHz clock domain
        .SPI_clk_CDC(SPI_clk_CDC),
        .data_write_clk(data_write_clk), // Inside the 40MHz clock domain
        .data_write_clk_CDC(data_write_clk_CDC),
        .reset(reset),
        .SPI_clk_rising_edge(SPI_clk_rising_edge),
        .data_clk_rising_edge(data_clk_rising_edge),
        .data_clk_falling_edge(data_clk_falling_edge),
        .start_req(start_req),
        .video_data_ready(video_data_ready),
        .audio_data_ready(audio_data_ready),

        .MISO(MISO),
        .chip_select(chip_select),

        .received_bit(received_bit)
    );

    // logic VGA_en;
    // logic pixel_color;
    // logic pixel_data_out;

    // wire [7:0] VGA_R, VGA_B, VGA_G;

    // assign pixel_data_out = received_bit;

    // assign VGA_en = VGA_startup_en || (read_bank1 || read_bank2);

    // always_comb begin
    //     if (VGA_startup_en) pixel_color = 1'b1;
    //     else                pixel_color = pixel_data_out;
    // end

    // VGA_top VGA_top (
    //         .CLK_40(CLK_40),
    //         .reset(reset),
    //         .pixel_color(pixel_color), // input to VGA controller to display
    //         .count_en(VGA_en),
    //         .VGA_R(VGA_R),
    //         .VGA_G(VGA_G),
    //         .VGA_B(VGA_B),
    //         .VGA_CLK(VGA_CLK),
    //         .VGA_SYNC_N(VGA_SYNC_N),
    //         .VGA_BLANK_N(VGA_BLANK_N),
    //         .VGA_VS(VGA_VS),
    //         .VGA_HS(VGA_HS),
    //         .ACTIVE(ACTIVE)
    //     );


endmodule  