// Need to make sure that the length of h_synch is lasting for enough time. i.e. SP time units
// https://github.com/edolinsky/cpen311/blob/master/lab2/Task2_3_4/vga_controller.v
// My implmentation is a chain of clock enable modules. Are h_sync and v_synch even meant to be clocks?


module screenPositionTracker #(
    parameter X_DATA_WIDTH = 10,
    parameter Y_DATA_WIDTH = 10,
    parameter X_LINE_WIDTH = 640,
    parameter Y_LINE_WIDTH = 480
)
(
    input wire                      CLK_50,
    input wire                      reset,
    input wire                      pixel_clk,
    output reg [X_DATA_WIDTH:0]     x_pos,
    output reg [Y_DATA_WIDTH:0]     y_pos
);
    always @(posedge CLK_50) begin 
        if (reset) begin
            x_pos <= 0;      
            y_pos <= 0; 
        end else begin
            if (pixel_clk) begin
                if (x_pos < X_LINE_WIDTH-1) begin
                    x_pos <= x_pos + 1;
                end else begin
                    x_pos <= 0;          // the last assignment wins, we'll go back to incrementing x at the next clock cycle.
                    y_pos <= y_pos + 1;   
                    if (y_pos == Y_LINE_WIDTH-1) begin
                        y_pos <= 0;    // the last assignment wins
                    end
                end
            end
        end
    end
endmodule

module pixel_clk_gen(
    input      CLK_50,  // 50MHz clock from the oscilator - the system clock 
    input      reset,
    output reg pixel_clk // 25MHz clk that will be used to drive the monitor - being used as a clk enable
);

    reg clk_counter; // 1 bit counter used for frequency division of CLK_50

    // Generates the 25MHz clk that we need to update pixels
    // Should go high for 3.8us, or 96 counts of pixel_clk (192 counts of CLK_50)
    always @(posedge CLK_50) begin
        if (reset) begin
            pixel_clk   <= 1'b0;
            clk_counter <= 1'b0;
        end else begin
            clk_counter <= clk_counter + 1;
            pixel_clk   <= (clk_counter == 1); // creating a clock enable
            if (clk_counter == 1) begin
                clk_counter <= 0;
            end
        end
    end
endmodule

module hsyn_clk_enable_gen (
    input      CLK_50,
    input      pixel_clk,          // used as clock enable for hsynch pusle generation
    input      reset,
    output reg hsync_n,            // used to begin a new scan line
    output reg h_BLANK,            // control bit used to create the blanking region
    output reg hsync_clk_enable    // clk enable used control vsynch pulse generation
);
    reg [9:0] clk_counter; // 10 bit counter used for frequency division of CLK_50, counts up to 1024
    
    parameter h_front_porch = 16;
    parameter h_synch_pulse = 96; // This means that the negative portion must last for 96 units of pixel_clk
    parameter h_back_porch  = 48;
    parameter h_area        = 640; // Marks the end fo the active area

    // Timing parameters to generate hsynch and blanking signal pulse
    // During blanking, BLACK pixels are transmitted
    parameter h_synch_start = h_area + h_front_porch;  
    parameter h_synch_end   = h_synch_start + h_synch_pulse;
    parameter h_line_width  = h_synch_end + h_back_porch; 

    // In this design, CLK_50 (system clock) drives the logic and action is controlled via a "clock_enable"
     
    always @(posedge CLK_50) begin
        if (reset) begin
            hsync_n <= 1'b0;
            clk_counter <= 10'b0;
        end else begin
            if (pixel_clk) begin
                clk_counter <= clk_counter + 1;

                hsync_n <= (clk_counter >= h_synch_start) && (clk_counter < h_synch_end-1); // Generate 96 pixel long synch pulse
                h_BLANK <= (clk_counter >= h_area)        && (clk_counter < h_line_width);  // Generating blanking control signal
                hsync_clk_enable <= (clk_counter == h_synch_end);
                if (clk_counter == h_line_width) begin
                    clk_counter <= 0;
                end
            end else begin
                hsync_clk_enable <= 0; // This ensures the clock enable signal only lasts for a single clock cycle -> fixes count by x2 error on the vsynch clock counter
            end
        end
    end


endmodule

// @ 60Hz
// vsynch pulse lasts for ~63.555us
module vsync_clk_enable_gen (
    input      CLK_50,
    input      reset,
    input      hsync_clk_enable,
    output reg vsync_n ,    // used to generate new frames
    output reg v_BLANK      // used to control generation of black pixels for the blanking area
);
    reg [9:0] clk_counter; // 10 bit counter used for frequency division of CLK_50

    parameter v_front_porch = 10;
    parameter v_synch_pulse = 2; // This must mean that the negative portion must last for 2 scan lines (2 iterations of hsync_clk)_enable
    parameter v_back_porch  = 33;
    parameter v_area        = 480;
    parameter v_synch_start = v_area + v_front_porch; 
    parameter v_synch_end   = v_synch_start + v_synch_pulse; // marks the end of the synchronization pulse
    parameter v_line_width  = v_synch_end + v_back_porch;    // 525 

    // Generates vsync_counth pulse
    always @(posedge CLK_50) begin
         if (reset) begin
            vsync_n <= 1'b0;
            clk_counter <= 10'b0;
        end else begin
            if (hsync_clk_enable) begin // Can't use this as a clock enable anymore since it'll be positive for 96 clock cycles at a time
                clk_counter <= clk_counter + 1;
                vsync_n <= (clk_counter >= v_synch_start) && (clk_counter < v_synch_end);
                v_BLANK <= (clk_counter >= v_area)        && (clk_counter < v_line_width);
                if (clk_counter == v_line_width) begin
                    clk_counter <= 0;
                end
            end
        end
    end
endmodule


// output a 1kz clock
module debug_clk_gen (
    input      CLK_50,  // 50MHz clock from the oscilator - the system clock 
    input      reset,
    output reg  clk_debug // 25MHz clk that will be used to drive the monitor - being used as a clk enable
);
    reg  [15:0] clk_counter; // 1 bit counter used for frequency division of CLK_50

    parameter divisor = 200;
    always @(posedge CLK_50) begin
        if (reset) begin
            clk_debug   <= 1'b0;
            clk_counter <= 1'b0;
        end else begin
            clk_counter <= clk_counter + 1;
            if (clk_counter == divisor) begin
                clk_debug <= ! clk_debug;
                clk_counter <= 0;
            end
        end
    end
endmodule