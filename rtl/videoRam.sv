// Currently a very manual implementation of ram block installation that forces Quartus to compile
// the design using multiple ram blocks. This is to store multiple frames. 

module videoRam #(
    parameter WIDTH  = 10, 
    parameter HEIGHT = 10,

    ADDRW = $clog2(WIDTH*HEIGHT) 
)(
    input logic               clk,
    input logic [3:0]         mem_block_sel,         // Selection signal for memory block
    input logic [0:0]         data_in,               // Input data
    input logic [ADDRW-1:0]   pixel_addr,            // Write and read addresses
    input logic               we,                    // Write enable

    output logic              data_out_after_sel     // Output data after selection
);

    reg [0:0] data_out1;
    reg [0:0] data_out2;
    reg [0:0] data_out3;
    reg [0:0] data_out4;
    reg [0:0] data_out5;
    reg [0:0] data_out6;
    reg [0:0] data_out7;
    reg [0:0] data_out8;
    reg [0:0] data_out9;
    reg [0:0] data_out10;
    reg [0:0] data_out11;
    reg [0:0] data_out12;
    reg [0:0] data_out13;
    reg [0:0] data_out14;
    reg [0:0] data_out15;

    logic [14:0] we_sel;
    assign we_sel = (1'b1 << mem_block_sel) & {15{we}};

    always_ff @ (negedge clk) begin
        case (mem_block_sel)
            4'b0000: data_out_after_sel <= data_out1 [0];
            4'b0001: data_out_after_sel <= data_out2 [0];
            4'b0010: data_out_after_sel <= data_out3 [0];
            4'b0011: data_out_after_sel <= data_out4 [0];
            4'b0100: data_out_after_sel <= data_out5 [0];
            4'b0101: data_out_after_sel <= data_out6 [0];
            4'b0110: data_out_after_sel <= data_out7 [0];
            4'b0111: data_out_after_sel <= data_out8 [0];
            4'b1000: data_out_after_sel <= data_out9 [0];
            4'b1001: data_out_after_sel <= data_out10[0];
            4'b1010: data_out_after_sel <= data_out11[0];
            4'b1011: data_out_after_sel <= data_out12[0];
            4'b1100: data_out_after_sel <= data_out13[0];
            4'b1101: data_out_after_sel <= data_out14[0];
            4'b1110: data_out_after_sel <= data_out15[0];

            default: data_out_after_sel   <= 1'bx; // Default case
        endcase
    end

    // Instantiate 15 single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd1)) instances with one-hot write enable
    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd1)) MEM1 (
        .q(data_out1),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[0]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd2)) MEM2 (
        .q(data_out2),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[1]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd3)) MEM3 (
        .q(data_out3),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[2]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd4)) MEM4 (
        .q(data_out4),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[3]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd5)) MEM5 (
        .q(data_out5),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[4]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd6)) MEM6 (
        .q(data_out6),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[5]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd7)) MEM7 (
        .q(data_out7),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[6]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd8)) MEM8 (

        .q(data_out8),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[7]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd9)) MEM9 (
        .q(data_out9),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[8]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd10)) MEM10 (
        .q(data_out10),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[9]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd11)) MEM11 (
        .q(data_out11),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[10]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd12)) MEM12 (
        .q(data_out12),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[11]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd13)) MEM13 (
        .q(data_out13),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[12]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd14)) MEM14 (
        .q(data_out14),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[13]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4'd15)) MEM15 (
        .q(data_out15),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[14]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

endmodule

module single_clk_ram # (
    parameter NUM_ADDR = 30000,
    parameter ADDRW = $clog2(NUM_ADDR),
    parameter frame = 1               
) ( 
    output reg                 q,
    input                      d,
    input      [ADDRW-1:0]     write_address, read_address, // should be clog2 (150) - 1
    input                      we, clk
);                            // data     // 30,000 addresses for 200x150
    (* ramstyle = "M10K" *) reg [0:0] mem [NUM_ADDR-1:0];
	parameter path1  = "frame_1.mem";
    parameter path2  = "frame_2.mem";
    parameter path3  = "frame_3.mem";
    parameter path4  = "frame_4.mem";
    parameter path5  = "frame_5.mem";
    parameter path6  = "frame_6.mem";
    parameter path7  = "frame_7.mem";
    parameter path8  = "frame_8.mem";
    parameter path9  = "frame_9.mem";
    parameter path10 = "frame_10.mem";
    parameter path11 = "frame_11.mem";
    parameter path12 = "frame_12.mem";
    parameter path13 = "frame_13.mem";
    parameter path14 = "frame_14.mem";
    parameter path15 = "frame_15.mem";

    initial begin
        case(frame)
            4'd1 : $readmemb(path1, mem);
            4'd2 : $readmemb(path2, mem);
            4'd3 : $readmemb(path3, mem);
            4'd4 : $readmemb(path4, mem);
            4'd5 : $readmemb(path5, mem);
            4'd6 : $readmemb(path6, mem);
            4'd7 : $readmemb(path7, mem);
            4'd8 : $readmemb(path8, mem);
            4'd9 : $readmemb(path9, mem);
            4'd10 : $readmemb(path10, mem);
            4'd11 : $readmemb(path11, mem);
            4'd12 : $readmemb(path12, mem);
            4'd13 : $readmemb(path13, mem);
            4'd14 : $readmemb(path14, mem);
            4'd15 : $readmemb(path15, mem);

            default: $readmemb(path5, mem);
        endcase
    end

    always @ (posedge clk) begin
        if (we)
            mem[write_address] <= d; // write operation
        q <= mem[read_address];      // read operation
    end

endmodule