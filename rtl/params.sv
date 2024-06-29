`define DEBUG_ON  // comment this line out in order to run a short simulation on video

`ifdef DEBUG_ON
    `define MODE "DEBUG"
    `define MODE_SWITCH_THRESHOLD 40*32*60
`else
    `define MODE "NORMAL"
    `define MODE_SWITCH_THRESHOLD 1056*628*60
`endif 