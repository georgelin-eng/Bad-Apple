`timescale 1ns/100ps
`include "../rtl/params.sv"
module FSM_tb ();

    logic CLK_40, SPI_clk, reset, init;

    logic MISO, MOSI, chip_select;
    logic write_video, write_audio;

    logic [7:0] VGA_R, VGA_B, VGA_G;

    logic sending_data;

    // Instantiate data aquisition FSM
    DATA_FSM DATA_FSM (
        .CLK_40 (CLK_40),
        .SPI_clk_en(SPI_clk_en),
        .reset (reset),
        .init(init),

        .start_req(start_req),
        .video_data_ready(video_data_ready),
        .audio_data_ready(audio_data_ready),

        .MISO(MISO),
        .MOSI(MOSI),
        .chip_select(chip_select),

        .write_audio ()
    );

     MODE_FSM MODE_FSM (
        .CLK_40(CLK_40),
        .reset (reset),
        .init(init),
        
        .switch_mode(start_req),
        .read_bank1 (read_bank1),
        .read_bank2 (read_bank2),
        .write_bank1 (write_bank1),
        .write_bank2 (write_bank2)
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
        .read_bank1 (read_bank1),
        .read_bank2 (read_bank2),
        .chip_select(chip_select),
        .video_data_ready(video_data_ready),

        .SPI_clk_en(SPI_clk_en),
        .MISO(MISO),

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
        #(1000*x);
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


        #1000;
        MISO = 1'b0; // set MISO line back to zero
        sending_data = 1;
    endtask

    initial begin
        sending_data = 0;
        // reset sequence
        MISO = 0;
        reset = 1;
        @ (posedge CLK_40);
        reset = 0; # 50; 
        $display(`MODE_SWITCH_THRESHOLD);
        wait_us(20);
        init = 1; 
        wait_us(2);
        init = 0;
        MISO = 1'b1;

        wait_us(100); // random value that's slightly large

        // send_data_header ();
        wait_us(20000);

        // send_data_header();       
        // wait_us(2000);

        $stop;
    end


    initial forever begin
        CLK_40 = 0; #12.5;
        CLK_40 = 1; #12.5;
    end


    initial forever begin
        SPI_clk = 1; #500;
        SPI_clk = 0; #500;
    end

    initial forever begin
        # 1000;

        if (sending_data) begin
            MISO = $random %2; 
        end
    end

endmodule