
`timescale 1ns/100ps
`include "../rtl/params.sv"
module FSM_tb ();

    logic CLK_40, SPI_clk, reset, init, vid_start;
    logic SPI_clk_CDC;
    logic data_write_clk_CDC;

    logic MISO, MOSI, chip_select;
    logic MISO_CDC;
    logic write_video, write_audio;

    logic [7:0] VGA_R, VGA_B, VGA_G;

    logic sending_data;
    logic send_video_data;
    logic data;
    integer file1, file2;

    parameter MEM_SIZE = `VIDEO_MEM_CELL_COUNT;

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

    reg [MEM_SIZE-1:0] DATA_BUFF;
    logic get_data_en;

    always_ff @ (posedge CLK_40) begin
        get_data_en <= video_data_ready & data_clk_rising_edge;
    end
    
    always_ff @ (posedge CLK_40) begin
        if (get_data_en) begin
            DATA_BUFF <= {DATA_BUFF[MEM_SIZE-2:0], received_bit};
        end
    end

    // Instantiate data aquisition FSM
    // DATA_FSM DATA_FSM (
    //     .CLK_40 (CLK_40),
    //     .SPI_clk_en(SPI_clk_en),
    //     .reset (reset),
    //     .init(init),

    //     .start_req(start_req),
    //     .video_data_ready(video_data_ready),
    //     .audio_data_ready(audio_data_ready),

    //     .MISO(MISO),
    //     .MOSI(MOSI),
    //     .chip_select(chip_select),

    //     .write_audio ()
    // );

    //  MODE_FSM MODE_FSM (
    //     .CLK_40(CLK_40),
    //     .reset (reset),
    //     .init(init),
        
    //     .switch_mode(start_req),
    //     .read_bank1 (read_bank1),
    //     .read_bank2 (read_bank2),
    //     .write_bank1 (write_bank1),
    //     .write_bank2 (write_bank2)
    // );
    

    // clk_en_gen CLK_EN_GEN (
    //     .CLK_40(CLK_40),
    //     .reset(reset),
    //     .SPI_clk_en(SPI_clk_en),
    //     .audio_clk_en(audio_clk_en)
    // );
    
    // video_top VIDEO_CONTROLLER (
    //     .CLK_40(CLK_40),
    //     .SPI_clk(SPI_clk),
    //     .reset(reset),
    //     .read_bank1 (read_bank1),
    //     .read_bank2 (read_bank2),
    //     .chip_select(chip_select),
    //     .video_data_ready(video_data_ready),

    //     .SPI_clk_en(SPI_clk_en),
    //     .MISO(MISO),

    //     .VGA_R(VGA_R),
    //     .VGA_G(VGA_G),
    //     .VGA_B(VGA_B),
    //     .VGA_CLK(VGA_CLK),
    //     .VGA_SYNC_N(VGA_SYNC_N),
    //     .VGA_BLANK_N(VGA_BLANK_N),
    //     .VGA_VS(VGA_VS),
    //     .VGA_HS(VGA_HS)
    // );

    function signed [10:0] jitter(input [10:0] x);
        integer temp;
        begin
            // Generate a random number and scale it to the range -x to x
            temp = $random % (2*x + 1);  // Random number between 0 and 2x
            jitter =(temp - x);  // Shift to -x to x
            return jitter;
        end
    endfunction

    task automatic wait_us(input integer x);
        #(1000*x);
        $display("waited %d us", x);
    endtask //automatic

    task automatic send_data(input logic [7:0] data);
        sending_data = 1;  // Assuming sending_data is a signal or variable defined elsewhere
        for (int i = 7; i >= 0; i = i - 1) begin
            @(negedge SPI_clk_CDC);
            MISO_CDC <= data[i];  // Use non-blocking assignment for MISO_CDC
        end
        sending_data = 0;  // Assuming you're clearing sending_data after sending data
    endtask

     task static send_video_payload ();
        wait_us($urandom_range(10, 50)); // this should simulate how long it takes PC to send data over
        send_data (8'h00);
        send_data (8'hFF);

        // 15 frames * 48 bits per frame 
        for (int i = 0; i < 15; i = i + 1) begin
            send_data (8'hBB); 
            send_data (8'hA0);
            send_data (8'hD2);
            send_data (8'hBB); 
            send_data (8'hA0);
            send_data (8'hD2);
        end

        send_data (8'h00); 
        send_data (8'h00); 
        send_data (8'h00); 
        @ (posedge (FSM_TOP.MODE_FSM.switch_mode));

    endtask


    initial begin
        sending_data = 0;
        reset = 0;
        wait_us(10);
        // reset sequence
        reset = 1;
        wait_us(1);
        reset = 0; # 50; 
        wait_us(1);
        reset = 1;
        wait_us(2);
        reset =0;
        wait_us(3);
        reset = 1;
        wait_us(50);
        reset = 0;
        $display(`MODE_SWITCH_THRESHOLD);

        wait_us(2);
        init = 1; 
        wait_us(2);
        init = 0;
        // MISO = 1'b1;

        wait_us(20);

        // @ (posedge (FSM_TOP.MODE_FSM.pause_en));

        @ (posedge (FSM_TOP.MODE_FSM.startup_done));

        send_video_payload();

        wait_us(10);

        $stop;
    end


    initial forever begin
        CLK_40 = 0; #12.5;
        CLK_40 = 1; #12.5;
    end



    ///////////////////////////////////////
    //        SPI clock Generation       //
    ///////////////////////////////////////
    initial begin
        automatic integer jitter_amount = 150; // This is 10% jitter which is quite high
        automatic integer jitter1 = jitter(jitter_amount/2);
        automatic integer jitter2 = jitter(jitter_amount/2);
        #200;  

        SPI_clk_CDC = 1; #(500 + jitter1);
        SPI_clk_CDC = 0; #(500 - jitter1 +  jitter2); // jitter applied to falling edge or normal clock

        forever begin
            if (sending_data) begin
                jitter1 = jitter(jitter_amount/2);
                SPI_clk_CDC = 1; #(500 - jitter2 + jitter1); 
                jitter2 = jitter(jitter_amount/2);
                SPI_clk_CDC = 0; #(500 - jitter1 + jitter2);
            end
            else begin
                SPI_clk_CDC = 0; #1000;
            end
        end
    end


    initial forever begin
        # 14.6;
        data_write_clk_CDC = 1; #500;
        data_write_clk_CDC = 0; #500;
    end


    ///////////////////////////////
    //        File Checker       //
    ///////////////////////////////

    // initial begin
    //     // Open a file to write
    //     file1 = $fopen("C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\testbench\\MISO_CDC_data.txt", "w");
    //     MISO_CDC = 1'b0;
    //     forever begin
    //         @ (negedge SPI_clk_CDC);
    //         if (~sending_data) begin
    //             MISO_CDC = 1'b0;
    //         end
    //         $fwrite(file1, "%b\n", MISO_CDC);
    //     end
    // end

    // initial begin
    //     file2 = $fopen("C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\testbench\\sampled_data.txt", "w");

    //     forever begin
    //         @ (posedge FSM_TOP.data_write_clk) begin 
    //             $fwrite(file2, "%b\n", data);
    //         end
    //     end
    // end


    

endmodule