// `define DEBUG_ON  // comment this line out in order to run a short simulation on video
// `define SHORT_VGA_STARTUP 
// `define ONLY_40MHz_CLOCK_DOMAIN

//////////////////////////////////////

`ifndef DEBUG_ON
    `define SYNCH_TIME 10 // how many seconds is required VGA signal to be aquired by device
`else 
    `define SYNCH_TIME 1
`endif

`define DATA_CMD 8'hAA
`define DATA_HEADER 8'b11111111
`define FIFO_BUFF_AMOUNT 60


/////////////////////////////////////


`ifdef DEBUG_ON
    `define MODE "DEBUG"
    `define FRAME_PIXEL_COUNT     40*32
    `define MODE_SWITCH_THRESHOLD 40*32*60
    `define VIDEO_MEM_CELL_COUNT  8*6*15
    `define AUDIO_MEM_CELL_COUNT  200
`else
    `define MODE "NORMAL"
    `define FRAME_PIXEL_COUNT     1056*628
    `define MODE_SWITCH_THRESHOLD 1056*628*60
    `define VIDEO_MEM_CELL_COUNT  200*150*15
    // `define VIDEO_MEM_CELL_COUNT  48*15
    `define AUDIO_MEM_CELL_COUNT  1000
`endif 

