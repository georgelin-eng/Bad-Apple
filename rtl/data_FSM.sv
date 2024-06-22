
// FSM states
// IDLE      -> REQ_V       : default state. Transition if with init. button is pressed or current video frame has finished displaying
// REQ_V     -> PARSE_V     : send a data data request to slave, transition once the request has been sent
// PARSE_V   -> RECEIVE_V   : continuously check MISO line for the video data header. Stay in this state until packet parse condition is met
// RECEIVE_V -> REQ_A       : transition after video frames have been received
// REQ_A     -> PARSE_A     : continuously check MISO line for the audio data header. Stay in this state until packet parse condition is met
// RECEIVE_A -> IDLE        : transition after audio has been received


// Control registers don't need to be set. We instead configure the verilog to act in a certain mode. Change software side to fit this.
// Note: Correct timing on the frame_done signal will ensure that neither video or audio buffer overflows

`define AUDIO_CMD 8'hAA
`define VIDEO_CMD 8'hFA

module DATA_FSM (
    input  wire     CLK_50,
    input  wire     SPI_clock_enable,
    input  wire     reset,

    // video data control signals
    input  wire     start,           // initiated by a button press
    input  wire     frame_done,      // signal that will come from the memory bank being read
    input  wire     video_bank_full, // signal that will come from the memory bank being written
    output reg      write_video,
    output reg      video_bank_sel,

    // SPI signals
    input  wire     MISO,        // MISO
    output wire     SPI_clock,   // SPI clock
    output wire     MOSI,        // MOSI
    output wire     chip_select, // SS


    // Audio data control signals
    input  wire     audio_bank_full,
    output reg      write_audio
);
    typedef enum logic [2:0] {IDLE, REQ_V, PARSE_V, RECEIVE_V, REQ_A, PARSE_A, RECEIVE_A, XX} statetype;
    statetype state, nextstate;


    // Internal signals for managing SPI communications
    // Configuring SPI to use 8 bit words
    reg  [7:0] CMD;                 // This will be set to either video or audio command in the FSM 
    reg  [7:0] DATA_HEADER_BUFF;    // buffer to store the MISO data when in parse modes
    wire [7:0] MISO_BUFF;           // buffer to store the MISO data when in receive modes. Implementing this so it's easier to construct audio data.

    // this will set the chip select?
    SPI_master SPI_CONTROL (
        .SPI_clock_enable(SPI_clock_enable),
        .CMD_to_send(CMD),
        .MISO(MISO),
        .MOSI(MOSI),
        .SS  (chip_select),
        .SCLK(SPI_clock)
    );

    // State output logic
    //      CMD               - data request to be sent        -> SPI master
    //      write_video       - enable write to video buffer   -> video buffer
    //      write_audio       - enable write to audio buffer   -> audio buffer

    logic request_sent_done, parse_done;

    // State register
    always_ff @( posedge CLK_50 ) begin 
        if (SPI_clock_enable) begin
            if (reset) state <= IDLE;
            else       state <= nextstate;
        end
    end

    // next state logic
    always_comb begin
        nextstate = XX; 
        case (state)
            IDLE      : if (start | frame_done)                nextstate = REQ_V;
                        else                                   nextstate = IDLE;
            REQ_V     : if (request_sent_done)                 nextstate = PARSE_V;
                        else                                   nextstate = REQ_V;
            PARSE_V   : if (parse_done)                        nextstate = RECEIVE_V;
                        else                                   nextstate = PARSE_V;             
            RECEIVE_V : if (video_bank_full)                   nextstate = REQ_A;
                        else                                   nextstate = RECEIVE_V;
            REQ_A     : if (request_sent_done)                 nextstate = PARSE_A;
                        else                                   nextstate = REQ_A;
            PARSE_A   : if (parse_done)                        nextstate = RECEIVE_A;
                        else                                   nextstate = PARSE_A;
            RECEIVE_A : if (audio_bank_full)                   nextstate = IDLE;
                        else                                   nextstate = RECEIVE_A;
        endcase
    end

    // registered output logic
    always_ff @ (posedge CLK_50) begin
        if (SPI_clock_enable) begin
            if (reset) begin
                write_video    <= 1'b0;
                write_audio    <= 1'b0;
                CMD            <= 8'b0;
            end else begin
                write_video    <= 1'b0;  // defaults. Set only the signals that change and they are registered. 
                write_audio    <= 1'b0;
                CMD            <= 8'b0;
                case(nextstate)
                    REQ_V      : CMD <= `VIDEO_CMD;
                    RECEIVE_V  : write_video <= 1'b1;
                    REQ_A      : CMD <= `AUDIO_CMD;
                    RECEIVE_A  : write_audio <= 1'b1;
                endcase
            end
        end
    end

    // Assign the value of video_bank_sel based ON TRANSITION only
    // registered output logic
    always_ff @ (posedge CLK_50) begin
        if (reset) 
            video_bank_sel <= 1'b0;
        else begin
            if (SPI_clock_enable) begin
                    if ((state == RECEIVE_V && nextstate == REQ_A)) begin
                            video_bank_sel <= ~video_bank_sel;
                    end
            end
        end
    end

endmodule