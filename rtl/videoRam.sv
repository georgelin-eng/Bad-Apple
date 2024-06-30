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
            11'b00000: data_out_after_sel <= data_out1 ;
            11'b00001: data_out_after_sel <= data_out2 ;
            11'b00010: data_out_after_sel <= data_out3 ;
            11'b00011: data_out_after_sel <= data_out4 ;
            11'b00100: data_out_after_sel <= data_out5 ;
            11'b00101: data_out_after_sel <= data_out6 ;
            11'b00110: data_out_after_sel <= data_out7 ;
            11'b00111: data_out_after_sel <= data_out8 ;
            11'b01000: data_out_after_sel <= data_out9 ;
            11'b01001: data_out_after_sel <= data_out10;
            11'b01010: data_out_after_sel <= data_out11;
            11'b01011: data_out_after_sel <= data_out12;
            11'b01100: data_out_after_sel <= data_out13;
            11'b01101: data_out_after_sel <= data_out14;
            11'b01110: data_out_after_sel <= data_out15;

            default: data_out_after_sel   <= 1'bx; // Default case
        endcase
    end

    // Instantiate 15 single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(1)) instances with one-hot write enable
    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(1)) MEM1 (
        .q(data_out1),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[0]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(2)) MEM2 (
        .q(data_out2),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[1]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(3)) MEM3 (
        .q(data_out3),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[2]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(4)) MEM4 (
        .q(data_out4),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[3]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(5)) MEM5 (
        .q(data_out5),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[4]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(6)) MEM6 (
        .q(data_out6),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[5]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(7)) MEM7 (
        .q(data_out7),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[6]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(8)) MEM8 (
        .q(data_out8),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[7]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(9)) MEM9 (
        .q(data_out9),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[8]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(10)) MEM10 (
        .q(data_out10),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[9]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(11)) MEM11 (
        .q(data_out11),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[10]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(12)) MEM12 (
        .q(data_out12),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[11]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(13)) MEM13 (
        .q(data_out13),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[12]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(14)) MEM14 (
        .q(data_out14),
        .d(data_in),
        .write_address(pixel_addr),
        .read_address(pixel_addr),
        .we(we_sel[13]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram #(.NUM_ADDR(WIDTH*HEIGHT), .frame(15)) MEM15 (
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
	parameter path1 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_1.mem";
    parameter path2 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_2.mem";
    parameter path3 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_3.mem";
    parameter path4 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_4.mem";
    parameter path5 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_5.mem";
    parameter path6 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_6.mem";
    parameter path7 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_7.mem";
    parameter path8 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_8.mem";
    parameter path9 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_9.mem";
    parameter path10 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_10.mem";
    parameter path11 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_11.mem";
    parameter path12 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_12.mem";
    parameter path13 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_13.mem";
    parameter path14 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_14.mem";
    parameter path15 = "C:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\frame_15.mem";

    initial begin
        case(frame)
            1 : $readmemb(path1, mem);
            2 : $readmemb(path2, mem);
            3 : $readmemb(path3, mem);
            4 : $readmemb(path4, mem);
            5 : $readmemb(path5, mem);
            6 : $readmemb(path6, mem);
            7 : $readmemb(path7, mem);
            8 : $readmemb(path8, mem);
            9 : $readmemb(path9, mem);
            10 : $readmemb(path10, mem);
            11 : $readmemb(path11, mem);
            12 : $readmemb(path12, mem);
            13 : $readmemb(path13, mem);
            14 : $readmemb(path14, mem);
            15 : $readmemb(path15, mem);

            default: $readmemb(path1, mem);
        endcase
    end

    always @ (negedge clk) begin
        if (we)
            mem[write_address] <= d; // write operation
        q <= mem[read_address];      // read operation
    end

endmodule