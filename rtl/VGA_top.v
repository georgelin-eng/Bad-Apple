// VGA module

// Specs
// - 25.175MHz clock - 640x480 at 60Hz <-- The De1Soc has a 50Mhz regulator. Use a 1 bit counter to generate the clk frequency
// - (640 + 16 + 96 + 48) x (480 + 10 + 2 + 33) = 800 * 525 @ 60Hz ~ 25.2MHz
// https://www.fpga4fun.com/VGA.html

// Synchronization
// - HSYNC : horizontal synchronization : negative pulse for new scanline
// - VSYNC : vertical synchronization   : negative pulse for new frame

module VGA_top (
    input pixel_clk,
    output h_sync,//directly to VGA 
    output h_sync_n, // inverted, to DAC
    output v_sync,//directory to VGA
    output v_sync_n, // inverted, to DAC
    output R,      // to DAC
    output G,      // to DAC
    output B       // to DAC
)



endmodule