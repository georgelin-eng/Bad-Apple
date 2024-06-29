`define MODE_SWITCH_THRESHOLD 40*32*60

module mode_FSM(
    input CLK_40,
    input reset,
    input init, 

    // control signals
    output logic read_bank1,
    output logic read_bank2,
    output logic write_bank1,
    output logic write_bank2
);

    typedef enum logic [2:0] {IDLE, READ_B1_WRITE_B2, READ_B2_WRITE_B1, XX} statetype;
    statetype state, nextstate;

    // Internal control signal
    logic        count_en;
    logic        switch_mode;
    logic [31:0] pixel_count;

    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset) state <= IDLE;
        else       state <= nextstate;
    end

    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE             : if (init)             nextstate =READ_B1_WRITE_B2;
                               else                  nextstate = IDLE;
            READ_B1_WRITE_B2 : if (switch_mode)      nextstate = READ_B2_WRITE_B1;
                               else                  nextstate = READ_B1_WRITE_B2;
            READ_B2_WRITE_B1 : if (switch_mode)      nextstate = READ_B1_WRITE_B2;    // if the mode is 'READ', write_enable will be 0
                               else                  nextstate = READ_B2_WRITE_B1;    // if the mode is 'READ', write_enable will be 0
        endcase
    end

    // registered output logic
    always_ff @ (posedge CLK_40) begin
        if (reset) 
            bank_full <= 0;
        else begin
            if (clk_enable) begin
                bank_full <= 0;
                case(nextstate)
                    WRITE_DONE  : bank_full <= 1;
                endcase
            end
        end
    end


    // Counter
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            pixel_count <= 0;
        end else if (count_en) begin
            pixel_count <= pixel_count + 1;

            switch_mode <= (pixel_count == MODE_SWITCH_THRESHOLD -1);
            
            if (pixel_count == MODE_SWITCH_THRESHOLD -1 ) begin
               pixel_count <= 0;
            end
        end
    end


endmodule