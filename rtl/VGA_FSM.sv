// VGA controller on FPGA
// Feature list
//   - Circle shape drawing <-- circle calculation
//   - Color support <--

module VGA_controller (
    input  wire       pixel_clk,
    input  wire       reset,
    input  wire       hsync_n,
    input  wire       vsync_n,
    output wire       h_sync,
    output wire       v_sync,
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


    reg [9:0] x, y; // variables for keeping track of current cursor location on the screen. 

    // Keeping track of horizontal and vertical screen position
    // 
    always_ff @( posedge pixel_clk ) begin 
        if (reset) begin
            x <= 0;
            y <= 0;
        end 
        else begin 
            // check for when the x pixels reach the end of the line. Should be at 799 (since they are reset to zero)
            if (x == 700) begin
                x <= 0;
                y <= (y == 524) ? 0 : y + 1; // increment y, reset back to zero once we've reach the end of the line
            end
            else begin
                x <= x + 1; 
            end
        end


        
    end

endmodule