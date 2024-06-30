module FSM_top(
    input CLK_40,
    input reset,
    input init,
    input MISO
);

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

    clock_mux #(.num_clocks(2)) CLOCK_EN_MUX1 ({SPI_clk_en, CLK_40}, {2'b1 << write_bank1}, clk_enable1);
    clock_mux #(.num_clocks(2)) CLOCK_EN_MUX2 ({SPI_clk_en, CLK_40}, {2'b1 << write_bank2}, clk_enable2);

    video_bank_FSM BANK1 (
        .CLK_40(CLK_40),
        .reset (reset),
        .clk_enable(clk_enable1),
        .video_data_ready(video_data_ready),
        .write_enable(write_bank1),
        .read_enable(read_bank1),

        .video_buffer_we(),
        .bank_counter(),
        .bank_read_done()
    );

    video_bank_FSM BANK2 (
        .CLK_40(CLK_40),
        .reset (reset),
        .clk_enable(clk_enable2),
        .video_data_ready(video_data_ready),
        .write_enable(write_bank2),
        .read_enable(read_bank2),

        .video_buffer_we(),
        .bank_counter(),
        .bank_read_done()
    );
        

    clk_en_gen CLK_EN_GEN (
        .CLK_40(CLK_40),
        .reset(reset),
        .SPI_clk_en(SPI_clk_en),
        .audio_clk_en(audio_clk_en)
    );


endmodule

`timescale 10ns/100ps
module top_FSM_tb();

    logic CLK_40, SPI_clk, init, reset;
    logic MISO, sending_data;


    FSM_top DUT (
        .CLK_40(CLK_40),
        .reset(reset),
        .init(init),
        .MISO(MISO)
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
        
        wait_us(250);
        init = 1; 
        wait_us(2);
        init = 0;

        wait_us(20); // random value that's slightly large

        send_data_header ();
        wait_us(2000);
        send_data_header ();
        wait_us(2000);
        send_data_header ();  
        wait_us(2000);
       
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

endmodule