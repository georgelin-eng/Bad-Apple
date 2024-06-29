`timescale 10ns/100ps

module FSM_tb ();

    logic CLK_40, SPI_clk, reset;

    logic start, frame_done, parse_done, video_bank_full, audio_bank_full;
    logic MISO, MOSI, chip_select;
    logic write_video, write_audio;

    logic [7:0] VGA_R, VGA_B, VGA_G;

    logic sending_data;

    // Instantiate data aquisition FSM
    DATA_FSM DATA_FSM (
        .CLK_40 (CLK_40),
        .SPI_clk_en(SPI_clk_en),
        .reset (reset),

        .start(start),
        .frame_done(frame_done),
        .video_bank_full(video_bank_full),
        .write_video(write_video),
        .write_audio(write_audio),
        .audio_bank_full(audio_bank_full),

        .MISO(MISO),
        .MOSI(MOSI),
        .chip_select(chip_select)
    );
    

    clk_en_gen CLK_EN_GEN (
        .CLK_40(CLK_40),
        .reset(reset),
        .SPI_clk_en(SPI_clk_en),
        .audio_clk_en(audio_clk_en)
    );
    
    video_top VIDEO_CONTROLLER (
        .CLK_40(CLK_40),
        .SPI_clk(SPI_clk),
        .reset(reset),
        .video_bank_we(write_video),
        .SPI_clk_en(SPI_clk_en),
        .MISO(MISO),
        .bank_full(video_bank_full),
        .frame_done(frame_done),

        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_CLK(VGA_CLK),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_VS(VGA_VS),
        .VGA_HS(VGA_HS)
    );


    task automatic wait_us(input integer x);
        #(100*x);
        $display("waited %d us", x);
    endtask //automatic


    reg[7:0] data_header = 8'b11111111;
    task static send_data_header();
        sending_data = 0;
        for (int i = 7; i >= 0; i=i-1) begin
            @(posedge SPI_clk) begin
                MISO = data_header[i];
            end
        end   


        #100;
        MISO = 1'b0; // set MISO line back to zero
        sending_data = 1;
    endtask

    initial begin
        sending_data = 0;
        // reset sequence
        MISO = 0;
        reset = 1;
        @ (posedge CLK_40);
        reset = 0; # 5; 
        
        wait_us(10);
        start = 1; 
        wait_us(2);
        start = 0;

        wait_us(200); // random value that's slightly large

       send_data_header ();

        wait_us(1000);

        @(posedge SPI_clk) audio_bank_full = 1; #100;
        @(posedge SPI_clk) audio_bank_full = 0;

        wait_us(1500);

        send_data_header();       

        wait_us(1500);

        $stop;
    end


    initial forever begin
        CLK_40 = 0; #1.25;
        CLK_40 = 1; #1.25;
    end


    initial forever begin
        SPI_clk = 1; #50;
        SPI_clk = 0; #50;
    end

    initial forever begin
        # 100;

        if (sending_data) begin
            MISO = $random %2; 
        end
    end

endmodule