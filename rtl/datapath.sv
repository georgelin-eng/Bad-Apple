module data_path (

);

    // Tracking scan line screen position for the frame being displayed
    wire [X_ADDRW - 1:0]        VGA_x_pos;
    wire [Y_ADDRW - 1:0]        VGA_y_pos;
    wire [X_ADDRW_SCALED - 1:0] VGA_x_pos_scaled;
    wire [Y_ADDRW_SCALED - 1:0] VGA_y_pos_scaled;

    // Tracking memory position for the frame being written into memory
    wire [X_ADDRW_SCALED - 1:0] mem_x_pos;
    wire [Y_ADDRW_SCALED - 1:0] mem_y_pos;

    assign VGA_x_pos_scaled = VGA_x_pos >> 2;
    assign VGA_y_pos_scaled = VGA_y_pos >> 2;


    assign video_bank1_we = write_enable && ~video_bank_sel;
    assign video_bank2_we = write_enable &&  video_bank_sel;
    assign pixel_color    = video_bank_sel ? bank1_out : bank2_out; // this will select which bank to read from for pixel color




endmodule