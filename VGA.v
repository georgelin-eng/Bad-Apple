// VGA module

// Specs
// - 25.175MHz clock - 640x480 at 60Hz <-- The De1Soc has a 50Mhz regulator. Use a 1 bit counter to generate the clk frequency
// https://www.fpga4fun.com/VGA.html


module VGA_drive (
    clk_50,
    h_sync, 
    v_sync,
    R,
    G,
    B
)
input clk_50;
input reset;
output h_sync;
output v_sync;

// Going to assume 12bit color for now
output [11:0] R, G, B;

reg clk_counter;
reg clk_25; // 25MHz clk that will be used to drive the monitor

// Generates the 25MHz clk that we need
always @(posedge clk_50) begin
    clk_counter <= clk_counter + 1;
    if (reset) begin
        clk_25 = 1'b0;
    end
    if (clk_counter == 1) begin
        clk_25 = ~clk_25;
    end
end













endmodule