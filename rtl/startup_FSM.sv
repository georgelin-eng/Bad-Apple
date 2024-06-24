// This is the controller used to initialize first load up of data into buffers before the data_FSM takes over for the rest of the operations



module startup_FSM (

);




    typedef enum logic [1:0] {IDLE, INIT_DATA, PLAYING_VIDEO} statetype;
    statetype state, nextstate;










endmodule