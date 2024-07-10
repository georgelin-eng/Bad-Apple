`timescale 1ns/100ps
`include "../rtl/params.sv"
module top_tb ();

    logic CLK_40, SPI_clk, reset, init;
    logic SPI_clk_CDC;
    logic MISO_CDC;

    logic MISO, MOSI, chip_select;
    logic write_video, write_audio;

    logic [7:0] VGA_R, VGA_B, VGA_G;

    logic sending_data;
    logic [39:0] GPIO_0;


    assign GPIO_0[0] = SPI_clk_CDC;
    assign GPIO_0[1] = MISO_CDC;

    badApple_top DUT (
        .GPIO_0(GPIO_0)
    );

   function signed [10:0] jitter(input [10:0] x);
        integer temp;
        begin
            // Generate a random number and scale it to the range -x to x
            temp = $random % (2*x + 1);  // Random number between 0 and 2x
            jitter =(temp - x);  // Shift to -x to x
            return jitter;
        end
    endfunction

    task automatic wait_ns (input integer x);
        #(x);
    endtask

    task automatic wait_us(input integer x);
        #(1000*x);
        $display("waited %d us", x);
    endtask //automatic

    task automatic send_data(input logic [7:0] data);
        sending_data = 1;  // Assuming sending_data is a signal or variable defined elsewhere

        if ($urandom_range(1,10) % 2) wait_ns($urandom_range(200,300));

        for (int i = 7; i >= 0; i = i - 1) begin
            @(negedge SPI_clk_CDC);
            MISO_CDC = data[i];  // Use non-blocking assignment for MISO_CDC
        end
        sending_data = 0;  // Assuming you're clearing sending_data after sending data
    endtask

    task static send_video_payload ();
        wait_us($urandom_range(20, 60)); // this should simulate how long it takes PC to send data over
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'h00);
        send_data (8'hFF);

        // 15 frames * 48 bits per frame 
        for (int i = 0; i < 15; i = i + 1) begin
            send_data (8'hBB);
            wait_us($urandom_range(1, 3)); // this should simulate how long it takes PC to send data over
            send_data (8'hA0);
            send_data (8'hD2);
            send_data (8'hBB);
            wait_us($urandom_range(1, 2)); // this should simulate how long it takes PC to send data over
            send_data (8'hA0);
            send_data (8'hD2);

        end
        send_data (8'h00); 
        send_data (8'h00); 
        @ (posedge (DUT.MODE_FSM.switch_mode));

    endtask

    reg [0:0] mem_contents [15:1] [47:0];

    task static check_mem_contents();
        @ (posedge DUT.MODE_FSM.read_bank1 or posedge DUT.MODE_FSM.read_bank2);
        if (DUT.MODE_FSM.read_bank1) begin
            $display("        Bank 1 Contents");
            mem_contents [1] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM1.mem;
            mem_contents [2] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM2.mem;
            mem_contents [3] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM3.mem;
            mem_contents [4] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM4.mem;
            mem_contents [5] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM5.mem;
            mem_contents [6] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM6.mem;
            mem_contents [7] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM7.mem;
            mem_contents [8] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM8.mem;
            mem_contents [9] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM9.mem;
            mem_contents [10] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM10.mem;
            mem_contents [11] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM11.mem;
            mem_contents [12] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM12.mem;
            mem_contents [13] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM13.mem;
            mem_contents [14] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM14.mem;
            mem_contents [15] = DUT.VIDEO_CONTROLLER.VIDEO_BANK1.VIDEO_MEM.VIDEO_RAM.MEM15.mem;
        end else begin
            $display("        Bank 2 Contents");
            mem_contents [1] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM1.mem;
            mem_contents [2] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM2.mem;
            mem_contents [3] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM3.mem;
            mem_contents [4] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM4.mem;
            mem_contents [5] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM5.mem;
            mem_contents [6] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM6.mem;
            mem_contents [7] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM7.mem;
            mem_contents [8] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM8.mem;
            mem_contents [9] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM9.mem;
            mem_contents [10] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM10.mem;
            mem_contents [11] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM11.mem;
            mem_contents [12] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM12.mem;
            mem_contents [13] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM13.mem;
            mem_contents [14] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM14.mem;
            mem_contents [15] = DUT.VIDEO_CONTROLLER.VIDEO_BANK2.VIDEO_MEM.VIDEO_RAM.MEM15.mem;
        end

        $display("        MSB <-- Sent last                                                                                                             sent first --> LSB");
        $display("ref:    '{0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1}");
        $display("mem1:   %p", mem_contents [1]);
        $display("mem2:   %p", mem_contents [2]);
        $display("mem3:   %p", mem_contents [3]);
        $display("mem4:   %p", mem_contents [4]);
        $display("mem5:   %p", mem_contents [5]);
        $display("mem6:   %p", mem_contents [6]);
        $display("mem7:   %p", mem_contents [7]);
        $display("mem8:   %p", mem_contents [8]);
        $display("mem9:   %p", mem_contents [9]);
        $display("mem10:  %p", mem_contents [10]);
        $display("mem11:  %p", mem_contents [11]);
        $display("mem12:  %p", mem_contents [12]);
        $display("mem13:  %p", mem_contents [13]);
        $display("mem14:  %p", mem_contents [14]);
        $display("mem15:  %p", mem_contents [15]);
        $display("===========================================================================================================================================================");
        $display();
    endtask


    ///////////////////////////////////////
    //       Simulating Frame Send       //
    ///////////////////////////////////////


    initial begin

        
        sending_data = 0;
        force DUT.reset = 0;
        wait_us(10);


        // Reset Sequence:
        // Here push button behaviour is simulated to test what happens in a 
        // more realistic sequence
        force DUT.reset = 1;
        wait_us(1);
        force DUT.reset = 0; # 50; 
        wait_us(1);
        force DUT.reset = 1;
        wait_us(2);
        force DUT.reset =0;
        wait_us(3);
        force DUT.reset = 1;
        wait_us(50);
        force DUT.reset = 0;

        wait_us(2);
        force DUT.init = 1; 
        wait_us(2);
        force DUT.init = 0;
        MISO_CDC = 0;



        // Test case consists of sending video frames modelled after the behaviour of 
        // the python code. A video payload is sent in the following format:
        // 0x00, 0x00, 0xFF : 0xFF is the data header and then the DATA FSM synchronizes to it
        // The actual data payload consisting of a string of bits that's the same size of memory
        // For the debugging mode configured, that is 48 bits. This payload is repeated x15 for each frame
        // to simulate a full video send
        // At the end of the video send, wait for the bank being read to switch and then read memory contents
        // This is controlled via the internal read_bank signal

        @ (posedge (DUT.MODE_FSM.startup_done));
        send_video_payload();
        check_mem_contents();

        @ (negedge (DUT.DATA_FSM.chip_select))
        send_video_payload();
        check_mem_contents();
        
        @ (negedge (DUT.DATA_FSM.chip_select))
        send_video_payload();
        check_mem_contents();

        // @ (negedge (DUT.DATA_FSM.chip_select))
        // send_video_payload();
        // check_mem_contents();

        // @ (negedge (DUT.DATA_FSM.chip_select))
        // send_video_payload();
        // check_mem_contents();

        // @ (negedge (DUT.DATA_FSM.chip_select))
        // send_video_payload();
        // check_mem_contents();

        // @ (negedge (DUT.DATA_FSM.chip_select))
        // send_video_payload();
        // check_mem_contents();
        // wait_us(10);

        $stop;


    end


    initial forever begin
        force DUT.CLK_40 = 0; #12.5;
        force DUT.CLK_40 = 1; #12.5;
    end


    ///////////////////////////////////////
    //         Data Clock Generation     //
    ///////////////////////////////////////

    // initial forever begin
    //     automatic integer data_jitter_amount = 10; // This is 10% jitter which is quite high
    //     automatic integer data_jitter1 = jitter(data_jitter_amount/2);
    //     automatic integer data_jitter2 = jitter(data_jitter_amount/2);
    //     #25.1;

    //     force DUT.data_write_clk_CDC = 1; #(500 + data_jitter1);
    //     force DUT.data_write_clk_CDC = 0; #(500 - data_jitter1 +  data_jitter2); // jitter applied to falling edge or normal clock

    //     forever begin
    //         data_jitter1 = jitter(data_jitter_amount/2);
    //         force DUT.data_write_clk_CDC = 1; #(500 - data_jitter2 + data_jitter1); 

    //         data_jitter2 = jitter(data_jitter_amount/2);
    //         force DUT.data_write_clk_CDC = 0; #(500 - data_jitter1 + data_jitter2); 
            
    //     end
    // end


    ///////////////////////////////////////
    //        SPI clock Generation       //
    ///////////////////////////////////////

    initial begin
        automatic integer jitter_amount = 100; // This is 10% jitter which is quite high
        automatic integer jitter1 = jitter(jitter_amount/2);
        automatic integer jitter2 = jitter(jitter_amount/2);
        #560;  

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


    initial begin
        wait_us(20000);
        $display("*** ERROR: Hit automatic timeout!");
        $stop;
    end
endmodule