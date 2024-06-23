// Currently a very manual implementation of ram block installation that forces Quartus to compile
// the design using multiple ram blocks. This is to store multiple frames. 

module videoRam (
    input logic        CLOCK_50,
    input logic [10:0] mem_block_sel, // Selection signal for memory block
    input logic [10:0] data_out_sel,  // Selection signal for data within selected memory block
    input logic [199:0] data_in,      // Input data
    input logic [10:0] x, y,          // Write and read addresses
    input we,                         // Write enable

    output reg data_out_after_sel // Output data after selection
);

    reg [199:0] data_out1;
    reg [199:0] data_out2;
    reg [199:0] data_out3;
    reg [199:0] data_out4;
    reg [199:0] data_out5;
    reg [199:0] data_out6;
    reg [199:0] data_out7;
    reg [199:0] data_out8;
    reg [199:0] data_out9;
    reg [199:0] data_out10;
    reg [199:0] data_out11;
    reg [199:0] data_out12;
    reg [199:0] data_out13;
    reg [199:0] data_out14;
    reg [199:0] data_out15;

    always_ff @ (posedge CLOCK_50) begin
        case (mem_block_sel)
            11'b00000: data_out_after_sel = data_out1[data_out_sel];
            11'b00001: data_out_after_sel = data_out2[data_out_sel];
            11'b00010: data_out_after_sel = data_out3[data_out_sel];
            11'b00011: data_out_after_sel = data_out4[data_out_sel];
            11'b00100: data_out_after_sel = data_out5[data_out_sel];
            11'b00101: data_out_after_sel = data_out6[data_out_sel];
            11'b00110: data_out_after_sel = data_out7[data_out_sel];
            11'b00111: data_out_after_sel = data_out8[data_out_sel];
            11'b01000: data_out_after_sel = data_out9[data_out_sel];
            11'b01001: data_out_after_sel = data_out10[data_out_sel];
            11'b01010: data_out_after_sel = data_out11[data_out_sel];
            11'b01011: data_out_after_sel = data_out12[data_out_sel];
            11'b01100: data_out_after_sel = data_out13[data_out_sel];
            11'b01101: data_out_after_sel = data_out14[data_out_sel];
            11'b01110: data_out_after_sel = data_out15[data_out_sel];

            default: data_out_after_sel = 200'b0; // Default case
        endcase
    end

    // Instantiate 15 single_clk_ram instances
    single_clk_ram MEM1 (
        .q(data_out1),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM2 (
        .q(data_out2),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM3 (
        .q(data_out3),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM4 (
        .q(data_out4),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM5 (
        .q(data_out5),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM6 (
        .q(data_out6),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM7 (
        .q(data_out7),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM8 (
        .q(data_out8),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM9 (
        .q(data_out9),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM10 (
        .q(data_out10),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM11 (
        .q(data_out11),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM12 (
        .q(data_out12),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM13 (
        .q(data_out13),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM14 (
        .q(data_out14),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

    single_clk_ram MEM15 (
        .q(data_out15),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we),
        .clk(CLOCK_50)
    );

endmodule

module single_clk_ram( 
    output reg [199:0] q,
    input [199:0] d,
    input [10:0] write_address, read_address, // should be clog2 (150) - 1
    input we, clk
);                            // data       // 0 to 150, addresses
    (* ramstyle = "M10K" *) reg [199:0] mem [149:0];

    always @ (posedge clk) begin
        if (we)
            mem[write_address] <= d;
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end

endmodule