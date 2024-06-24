// Currently a very manual implementation of ram block installation that forces Quartus to compile
// the design using multiple ram blocks. This is to store multiple frames. 

module videoRam (
    input logic          clk,
    input logic [3:0]    mem_block_sel, // Selection signal for memory block
    input logic [0:0]    data_in,       // Input data
    input logic [32:0]   x, y,          // Write and read addresses
    input we,                           // Write enable

    output logic         data_out_after_sel      // Output data after selection
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
    assign we_sel = 1'b1 << mem_block_sel;

    always_ff @ (posedge clk) begin
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

    // Instantiate 15 single_clk_ram instances with one-hot write enable
    single_clk_ram MEM1 (
        .q(data_out1),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[0]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM2 (
        .q(data_out2),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[1]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM3 (
        .q(data_out3),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[2]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM4 (
        .q(data_out4),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[3]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM5 (
        .q(data_out5),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[4]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM6 (
        .q(data_out6),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[5]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM7 (
        .q(data_out7),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[6]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM8 (
        .q(data_out8),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[7]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM9 (
        .q(data_out9),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[8]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM10 (
        .q(data_out10),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[9]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM11 (
        .q(data_out11),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[10]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM12 (
        .q(data_out12),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[11]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM13 (
        .q(data_out13),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[12]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM14 (
        .q(data_out14),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[13]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

    single_clk_ram MEM15 (
        .q(data_out15),
        .d(data_in),
        .write_address(x),
        .read_address(y),
        .we(we_sel[14]), // Selecting we signal based on bank_counter
        .clk(clk)
    );

endmodule

module single_clk_ram( 
    output reg              q,
    input                   d,
    input      [32:0]       write_address, read_address, // should be clog2 (150) - 1
    input                   we, clk
);                            // data     // 30,000 addresses for 200x150
    (* ramstyle = "M10K" *) reg [0:0] mem [29999:0];

    always @ (posedge clk) begin
        if (we)
            mem[write_address] <= d;
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end

endmodule