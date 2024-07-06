
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

    logic sending_header;
    logic send_video_data;
    logic data;
    integer file1, file2;


    FSM_top FSM_TOP (
        .CLK_40(CLK_40),
        .reset(reset),
        .init(init),
        .vid_start(vid_start),
        .MISO_CDC(MISO_CDC),
        .SPI_clk_CDC(SPI_clk_CDC),
        .data_write_clk_CDC(data_write_clk_CDC),
        .data(data)
    );


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

    reg[7:0] data_header = 8'b11111111;
    task static send_data_header();
        sending_header = 1;
        for (int i = 7; i >= 0; i=i-1) begin
            @(negedge SPI_clk_CDC) begin
                MISO_CDC = data_header[i];
            end
        end   

        sending_header = 0;
    endtask // static

    initial begin
        sending_header = 0;
        
        // reset sequence
        reset = 1;
        @ (posedge CLK_40);
        wait_us(1);
        reset = 0; # 50; 
        $display(`MODE_SWITCH_THRESHOLD);

        wait_us(2);
        init = 1; 
        wait_us(2);
        init = 0;
        // MISO = 1'b1;

        wait_us(20);

        @ (posedge (FSM_TOP.MODE_FSM.pause_en));
        wait_us(20);
        vid_start = 1'b1;
        @ (posedge (FSM_TOP.MODE_FSM.pause_done));
        wait_us($urandom_range(25, 100));
        send_data_header ();
        send_video_data = 1'b1;
        wait_us(2050);

        $stop;
    end


    initial forever begin
        CLK_40 = 0; #12.5;
        CLK_40 = 1; #12.5;
    end

    initial begin
        automatic integer jitter_amount = 250; // This is 10% jitter which is quite high
        automatic integer jitter1 = jitter(jitter_amount/2);
        automatic integer jitter2 = jitter(jitter_amount/2);
        #500;  

        SPI_clk_CDC = 1; #(500 + jitter1);
        SPI_clk_CDC = 0; #(500 - jitter1 +  jitter2); // jitter applied to falling edge or normal clock

        forever begin
            jitter1 = jitter(jitter_amount/2);
            SPI_clk_CDC = 1; #(500 - jitter2 + jitter1); 
            jitter2 = jitter(jitter_amount/2);
            SPI_clk_CDC = 0; #(500 - jitter1 + jitter2);
        end
    end


    initial forever begin
        data_write_clk_CDC = 1; #500;
        data_write_clk_CDC = 0; #500;
    end


    ///////////////////////////////
    //        File Checker       //
    ///////////////////////////////

    initial begin
        // Open a file to write
        file1 = $fopen("C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\testbench\\MISO_CDC_data.txt", "w");
        MISO_CDC = 1'b0;
        forever begin
            @ (negedge SPI_clk_CDC);
            if (~sending_header) begin
               if (send_video_data) MISO_CDC = $random % 2;
               else MISO_CDC = 0; 
            end
            $fwrite(file1, "%b\n", MISO_CDC);
        end
    end

    initial begin
        file2 = $fopen("C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\testbench\\sampled_data.txt", "w");

        forever begin
            @ (posedge FSM_TOP.data_write_clk) begin 
                $fwrite(file2, "%b\n", data);
            end
        end
    end


    

endmodule