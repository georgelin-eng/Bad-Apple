// `define DEBUG_ON  // comment this line out in order to run a short simulation on video

`ifdef DEBUG_ON
    `define MODE "DEBUG"
    `define MODE_SWITCH_THRESHOLD 40*32*60
    `define VIDEO_MEM_CELL_COUNT 8*6*15
    `define AUDIO_MEM_CELL_COUNT 200
`else
    `define MODE "NORMAL"
    `define MODE_SWITCH_THRESHOLD 1056*628*60
    `define VIDEO_MEM_CELL_COUNT 200*150*15
    `define AUDIO_MEM_CELL_COUNT 16*2*8000
`endif 

`define DATA_CMD 8'hAA
`define DATA_HEADER 8'b11111111
