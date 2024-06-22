////////////////////////////////////////////
// General information:
//          data width  : 8 bits
//          clock frequency: 
// 
// 
// 
// 
/////////////////////////////////////////


module SPI_master (
    input  wire      SPI_clock_enable,
    input  wire [7:0] CMD_to_send,

    // Standard 4 signals used by SPI
    input  wire      MISO,   
    output reg       MOSI,   // going to PC through GPIO
    output reg       SS,
    output reg       SCLK
);


    // shift register
    reg [7:0] shift_reg;




endmodule