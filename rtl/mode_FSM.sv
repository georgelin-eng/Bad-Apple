`include "params.sv"

module MODE_FSM(
    input CLK_40,
    input reset,
    input init,       // asynch - button press
    input vid_start,  // asynch - button press

    // control signals
    output logic switch_mode,
    output logic start_data_FSM,
    output logic read_bank1,
    output logic read_bank2,
    output logic VGA_startup_en,
    output logic pause_en
);

    typedef enum logic [3:0] {  IDLE, 
                                VGA_STARTUP, 
                                BADAPPLE_OS, 
                                PAUSE_SCREEN_ASYNC,
                                PAUSE_SCREEN_SYNC, 
                                READ_B1_WRITE_B2, 
                                READ_B2_WRITE_B1,
                                XX
                            } statetype;

    statetype state, nextstate;

    // Internal control signal
    logic        count_en;
    logic        startup_done, OS_done, pause_done;
    logic [31:0] pixel_count;

    // Testing purposes
    assign OS_done = 1'b1;

    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset) state <= IDLE;
        else       state <= nextstate;
    end

    // next state logic
    // Startup: IDLE -> PHASE_CAL -> VGA_STARTUP -> BADAPPLE_OS -> PAUSE_SCREEN
    // Playing video: Switch betweenREAD_B1_WRITE_B2 and READ_B2_WRITE_B1
    // From VGA_STARTUP and onwards, VGA is on so make sure screen position is kept accurate
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE               :if (init)         nextstate = VGA_STARTUP;
                                else              nextstate = IDLE;

            // Startup States
            VGA_STARTUP        :if (startup_done) nextstate = READ_B1_WRITE_B2;
                                else              nextstate = VGA_STARTUP;
            // BADAPPLE_OS        :if (OS_done)      nextstate = PAUSE_SCREEN_ASYNC;
                                // else              nextstate = BADAPPLE_OS;
            // PAUSE_SCREEN_ASYNC :if (vid_start)    nextstate = PAUSE_SCREEN_SYNC;
            //                     else              nextstate = PAUSE_SCREEN_ASYNC;
            // PAUSE_SCREEN_SYNC  :if (pause_done)   nextstate = READ_B1_WRITE_B2;
            //                     else              nextstate = PAUSE_SCREEN_SYNC;

            // Main Video Playing States
            READ_B1_WRITE_B2 : if (switch_mode)   nextstate = READ_B2_WRITE_B1;
                               else               nextstate = READ_B1_WRITE_B2;
            READ_B2_WRITE_B1 : if (switch_mode)   nextstate = READ_B1_WRITE_B2;   
                               else               nextstate = READ_B2_WRITE_B1;   
        endcase
    end



    // registered output logic
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            read_bank1 <= 0;
            read_bank2 <= 0;
            count_en    <= 0;
            VGA_startup_en <= 0;
        end 
        else begin
            read_bank1 <= 0;
            read_bank2 <= 0;
            count_en    <= 0;
            VGA_startup_en <= 0;
            pause_en <= 0;
            case(nextstate)
                VGA_STARTUP       : VGA_startup_en <= 1'b1;
                BADAPPLE_OS       : VGA_startup_en <= 1'b1;
                PAUSE_SCREEN_ASYNC: begin 
                                        pause_en <= 1'b1;  
                                        VGA_startup_en <= 1'b1;
                                    end
                PAUSE_SCREEN_SYNC : begin 
                                        pause_en <= 1'b1;  
                                        VGA_startup_en <= 1'b1;
                                    end
                READ_B1_WRITE_B2  : begin 
                                        read_bank1  <= 1; 
                                        count_en    <= 1;
                                    end
                READ_B2_WRITE_B1  : begin
                                        read_bank2  <= 1; 
                                        count_en    <= 1;
                                    end
            endcase
        end
    end



    //////////////////////////////
    //       FSM Counters       //    
    //////////////////////////////

    // VGA Sync Counter for transition
    counter  #(
        `ifdef SHORT_VGA_STARTUP
            .THRESHOLD(`FRAME_PIXEL_COUNT - 0),
        `else
            .THRESHOLD(`MODE_SWITCH_THRESHOLD * `SYNCH_TIME - 0),
        `endif 
        .ENABLE_ON_TIME('d1)
    ) VGA_SYNC_COUNTER (
        .clk(CLK_40),
        .reset(reset),
        .count_en(VGA_startup_en),
        .clk_en(1'b1),
        .enable_signal(startup_done)
    );

    // Pause Counter
    // This is to ensure that a the pause ends on a frame and not in the middle of one
    // Alternative is to generate a reset signal 
    counter #(
        .THRESHOLD(`FRAME_PIXEL_COUNT - 0),
        .ENABLE_ON_TIME(1'b1)
    ) PAUSE_COUNTER (
        .clk(CLK_40),
        .reset(reset),
        .count_en(pause_en),
        .clk_en(1'b1),
        .enable_signal(pause_done)
    );

    counter #(
        .THRESHOLD(`MODE_SWITCH_THRESHOLD - 0),
        .ENABLE_ON_TIME(1'b1)
    ) SWITCH_MODE_COUNTER (
        .clk(CLK_40),
        .reset(reset),
        .count_en(count_en),
        .clk_en(1'b1),
        .enable_signal(switch_mode)
    );

    // Startup data FSM on initial transition from the pause screen to 
    // starting video display
    always_ff @ (posedge CLK_40) begin
        if (state==VGA_STARTUP & nextstate==READ_B1_WRITE_B2) begin
            start_data_FSM <= 1'b1;
        end
        else start_data_FSM <= 1'b0;
    end

endmodule