// VGA controller on FPGA
// Feature list
//   - Circle shape drawing <-- circle calculation
//   - Color support <--

module VGA_controller (
    input  wire       clk_50,
    input  wire       pixel_clk,
    input  wire       reset,
    input  wire       hsync_n,
    input  wire       vsync_n,
    output wire       h_sync,
    output wire       v_sync,
    output reg  [9:0] x, 
    output reg  [9:0] y,
    output reg  [7:0] R_dac,
    output reg  [7:0] G_dac,
    output reg  [7:0] B_dac
);

    // FSM states would be something like 
    typedef enum logic [1:0] {  IDLE, 
                                DRAWING,        // later might change this to be drawings of specific shapes
                                CLEAR_SCREEN
                            } state_e;

    // Invert clock signals since hysnc and vsync are meant to have negative polarities
    assign h_sync = ~hsync_n;
    assign v_sync = ~vsync_n;

    // In theory, I should have a purely white output on VGA if I'm doing this
    // Ideally I would check with an osciliscope so that I can actually see the 
    // signals
    assign R_dac = 255;
    assign G_dac = 255;
    assign B_dac = 255;

    // Keeping track of horizontal and vertical screen position
    // 
    always_ff @( posedge clk_50) begin 
        if (reset) begin
            x <= 0;
            y <= 0;
        end 
        else begin 
            if (pixel_clk) begin 
                // check for when the x pixels reach the end of the line. Should be at 799 (since they are reset to zero)
                if (x == 799) begin
                    x <= 0;
                    y <= (y == 524) ? 0 : y + 1; // increment y, reset back to zero once we've reach the end of the line
                end
                else begin
                    x <= x + 1; 
                end
            end 
        end        
    end

endmodule


module frame_buffer_gen (
    input  wire          clk_50,
    input  wire          pixel_clk,
    input  wire  [9:0]   x,
    input  wire  [9:0]   y,
    output logic         write_enable
);
    // circle coordinate calculation. Write to the frame buffer module

endmodule


// module responsible for write to the frame buffer after calculating the coordinate of a circle
// the intention is that this should be controlled via an FSM
// -> Main FSM controls radius and centre of the circle to be drawn
// -> Written into the frame buffer
// -> Display logic drives the calculation
module bresenham_circle_calc (

);


endmodule