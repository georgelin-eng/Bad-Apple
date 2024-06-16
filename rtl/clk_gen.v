// Need to make sure that the length of h_synch is lasting for enough time. i.e. SP time units
// https://github.com/edolinsky/cpen311/blob/master/lab2/Task2_3_4/vga_controller.v
// My implmentation is a chain of clock enable modules. Are h_sync and v_synch even meant to be clocks?


module pixel_clk_gen(
    input      clk_50,  // 50MHz clock from the oscilator - the system clock 
    input      reset,
    output reg pixel_clk // 25MHz clk that will be used to drive the monitor - being used as a clk enable
);

    reg clk_counter; // 1 bit counter used for frequency division of clk_50

    // Generates the 25MHz clk that we need to update pixels
    // Should go high for 3.8us, or 96 counts of pixel_clk (192 counts of clk_50)
    always @(posedge clk_50) begin
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
    input      clk_50,
    input      pixel_clk,          // not treating as a clock, but as a clock enable
    input      reset,
    output reg hsync_n,            // used to begin a new scan line
    output reg hsync_clk_enable   // clk enable used control vsynch pulse generation
);
    reg [9:0] clk_counter; // 10 bit counter used for frequency division of clk_50, counts up to 1024
    
    parameter h_front_porch = 16;
    parameter h_synch_pulse = 96; // This means that the negative portion must last for 96 units of pixel_clk
    parameter h_back_porch  = 48;
    parameter h_area        = 640;
    parameter h_synch_start = h_area + (h_front_porch + h_back_porch);
    parameter h_synch_end   = h_area + (h_front_porch + h_synch_pulse + h_back_porch); // 800 - h_synch_end

    // In this design, clk_50 (system clock) drives the logic and action is controlled via a "clock_enable"
    // 
    always @(posedge clk_50) begin
        if (reset) begin
            hsync_n <= 1'b0;
            clk_counter <= 10'b0;
        end else begin
            if (pixel_clk) begin
                clk_counter <= clk_counter + 1;
                hsync_n <= (clk_counter >= h_synch_start) && (clk_counter < h_synch_end-1); // Generate 96 pixel long synch pulse
                hsync_clk_enable <= (clk_counter == h_synch_end);
                if (clk_counter == h_synch_end) begin
                    clk_counter <= 0;
                end
            end else begin
                hsync_clk_enable <= 0;
            end
        end
    end
endmodule

// @ 60Hz
// [TODO], the way that the horizontal synch is generated will work. 
// Won't work for vsynch_n since the enable is being controlled by hsynch_n
// vsynch pulse lasts for ~63.555us
// Need a separate enable that's triggered only then xcount reaches 800
module vsync_clk_enable_gen (
    input      clk_50,
    input      reset,
    input      hsync_clk_enable,
    output reg vsync_n     // used to generate new frames
);
    reg [9:0] clk_counter; // 10 bit counter used for frequency division of clk_50

    parameter v_front_porch = 10;
    parameter v_synch_pulse = 2; // This must mean that the negative portion must last for 2 units of pixel_clk
    parameter v_back_porch  = 33;
    parameter v_area        = 480;
    parameter v_synch_start = v_area + (v_front_porch + v_back_porch); // 523
    parameter v_synch_end   = v_area + (v_front_porch + v_synch_pulse + v_back_porch); // 525

    // Generates vsync_counth pulse
    always @(posedge clk_50) begin
         if (reset) begin
            vsync_n <= 1'b0;
            clk_counter <= 10'b0;
        end else begin
            if (hsync_clk_enable) begin // Can't use this as a clock enable anymore since it'll be positive for 96 clock cycles at a time
                clk_counter <= clk_counter + 1;
                vsync_n <= (clk_counter >= v_synch_start) && (clk_counter < v_synch_end);
                if (clk_counter == v_synch_end) begin
                    clk_counter <= 0;
                end
            end
        end
    end
endmodule