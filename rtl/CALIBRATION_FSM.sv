`include "params.sv"
// This module requires that CDC on data_write_clk and SPI_clk has been dealt with

module CALIBRATION_FSM(
    input        CLK_40,
    input        data_write_clk,      // internal
    input        SPI_clk,             // external 
    input        reset,


    input        phase_cal_en,
    output logic SPI_rising_edge,
    output logic SPI_falling_edge,
    // output logic phase_adjust
    output logic [4:0] phase_adjust
);
    logic [4:0] counter;
    logic [1:0] SPI_clk_buff, data_write_clk_buff;
    logic data_clk_rising_edge, data_clk_falling_edge;
    logic special_edge_event;

    assign special_edge_event = SPI_falling_edge & data_clk_rising_edge;
    typedef enum logic [3:0] {  IDLE, 
                                EDGE_DETECT,
                                SPI_EARLY, 
                                DATA_CLK_EARLY, 
                                PHASE_CALC, 
                                ADJUST,
                                XX
                            } statetype;
    statetype state, nextstate;

    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset) state <= IDLE;
        else       state <= nextstate;
    end

    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE             : if (phase_cal_en)              nextstate = EDGE_DETECT;
                               else                           nextstate = IDLE;
            EDGE_DETECT      : if (special_edge_event)        nextstate = PHASE_CALC;
                               else if (SPI_falling_edge)     nextstate = SPI_EARLY;
                               else if (data_clk_rising_edge) nextstate = DATA_CLK_EARLY;
                               else                           nextstate = EDGE_DETECT;
            SPI_EARLY        : if (data_clk_rising_edge)      nextstate = PHASE_CALC;
                               else                           nextstate = SPI_EARLY;
            DATA_CLK_EARLY   : if (SPI_falling_edge)          nextstate = PHASE_CALC;
                               else                           nextstate = DATA_CLK_EARLY;
            PHASE_CALC       :                                nextstate = ADJUST;
            ADJUST           :                                nextstate = ADJUST;
        endcase
    end

    ////////////////////////////////
    //   Edge Event Detection     //
    ////////////////////////////////

    always_ff @ (posedge CLK_40) begin
        // shift registers
        SPI_clk_buff        <= {SPI_clk_buff [0], SPI_clk}; 
        data_write_clk_buff <= {data_write_clk_buff [0], data_write_clk}; 
    end
    logic [1:0] comb_SPI_clk_buff, comb_data_write_clk_buff;
    // detect rising and falling edge events for each one
    assign comb_SPI_clk_buff = {SPI_clk_buff[0], SPI_clk};
    assign comb_data_write_clk_buff = {data_write_clk_buff [0], data_write_clk};  

    assign SPI_rising_edge        = (comb_SPI_clk_buff == 2'b01);
    assign SPI_falling_edge       = (comb_SPI_clk_buff == 2'b10);
    assign data_clk_rising_edge   = (comb_data_write_clk_buff == 2'b01);
    assign data_clk_falling_edge  = (comb_data_write_clk_buff == 2'b10);

    always_ff @ (posedge CLK_40) begin
        if (state == PHASE_CALC) begin 
            if (counter <= 20) phase_adjust <= counter;
            else phase_adjust  <= 40 - counter;
        end
        // phase_adjust <= 'd20; // no adjustment
    end


    ////////////////////////////////
    //      Phase Calculation     // 
    ////////////////////////////////

    // If the Falling edge and rising edge are sufficiently close
    // There is a risk of metastability when sampling due to jitter
    // At 180 degree phase diff, it is as though data is shifted 
    // on falling edge of SPI_clk and then sampled on the falling edge as well

    // There will be a register that stores the incoming data
    // Normally, store just on falling edge events. 
    // If 180 degrees, store on rising edge instead


    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            counter <= 'b0;
        end
        else begin
            counter <= 'b0;
            // phase_adjust <= 1'b0;
            // The smaller the counter, the phase is closer to 180
            case(nextstate)
                SPI_EARLY       : counter <= counter + 1; 
                DATA_CLK_EARLY  : counter <= counter + 1; 
                PHASE_CALC      : counter <= counter;
                ADJUST          : counter <= counter;
                // PHASE_ADJUST   : phase_adjust <= 1'b1;
            endcase
        end
    end 

endmodule


// This should be an FSM
// Enters into a counter state on an edge event
// Sampling should happen based on the result of calibration

module data_select (
    input logic          CLK_40,
    input logic          reset,
    input logic          phase_cal_en,
    input logic [4:0]    phase_adjust, // value that is calculated based on the counter in the calibration FSM
    input wire           data_in,
    input logic          SPI_rising_edge,
    input logic          SPI_falling_edge,
    output reg           data_in_buff
);

    reg [6:0] counter;
    logic special_event;
   
    typedef enum logic [3:0] {  IDLE, 
                                EDGE_DETECT,
                                CALIBRATING,
                                CAPTURE_DATA,
                                XX
                            } statetype;
    statetype state, nextstate;

    // State register
    always_ff @( posedge CLK_40 ) begin 
        if (reset) state <= IDLE;
        else       state <= nextstate;
    end 


    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE             : if (phase_cal_en)              nextstate = EDGE_DETECT;
                               else                           nextstate = IDLE;
            EDGE_DETECT      : if (SPI_rising_edge)           nextstate = CALIBRATING;
                               else                           nextstate = EDGE_DETECT;
            CALIBRATING      : if (counter == phase_adjust)   nextstate = EDGE_DETECT;
                               else                           nextstate = CALIBRATING;
            // CAPTURE_DATA     :                                nextstate = EDGE_DETECT;
           
        endcase
    end

    // Idea should be to capture data 20 ticks after falling edge SPI_clk
    // lock onto it then put onto data_buff based on phase adjust
    reg [4:0] data_lock_counter;
    logic     data_buff, data_lock_count_en;
       
    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            data_lock_counter <= 'd0;
            data_lock_count_en <= 1'b0;
        end
        else begin
            if (SPI_falling_edge) begin 
                data_lock_count_en <= 2'b1;
                data_lock_counter <= 'd0;
            end else begin
                if (data_lock_count_en) data_lock_counter <= data_lock_counter + 1;
                if (data_lock_counter == 'd10) begin
                    data_buff <= data_in;
                    data_lock_counter <= 'd0;
                end
            end
        end
    end  

    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            counter <= 'd0;
        end
        else begin
            counter <= 'd0;
            // The smaller the counter, the phase is closer to 180
            case(state)
                CALIBRATING : begin
                                counter <= counter + 1;

                                if (counter >= phase_adjust) data_in_buff <= data_buff;
                            end
                // CAPTURE_DATA: data_in_buff <= data_in;
            endcase
        end
    end 
endmodule


module sync_FIFO #(
    parameter DEPTH = 32, 
    parameter DWIDTH = 1
)
(

    input                   reset,
    input                   CLK_40,
    input                   write_clk, // on posedge SPI_clk
    input                   read_clk,  // on posedge data_write_clk
    input                   read_en,   
    input                   write_en,
    input      [DWIDTH-1:0] din,
    output reg [DWIDTH-1:0] dout,
    output                  empty,
    output                  full
);

    reg [$clog2(DEPTH)-1:0] write_ptr;
    reg [$clog2(DEPTH)-1:0] read_ptr;

    reg [DWIDTH-1:0] FIFO [DEPTH];

    always_ff @ (posedge CLK_40) begin
        if (reset) begin
            write_ptr <= 0;
            read_ptr  <= 0;
        end
    end
    

    always_ff @ (posedge write_clk) begin
        if (write_en & !full) begin
            FIFO[write_ptr] <= din;
            write_ptr <= write_ptr + 1;
        end
    end

    always_ff @ (posedge read_clk) begin
        if (read_en & ! empty) begin
            dout <= FIFO [read_ptr];
            read_ptr <= read_ptr + 1;
        end
    end

    assign full = (write_ptr + 1) == read_ptr;
    assign empty = write_ptr == read_ptr;
    
endmodule