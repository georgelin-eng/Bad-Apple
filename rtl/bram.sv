module bram #(
    parameter WIDTH=640, 
    parameter HEIGHT=480, 
    parameter INIT_F="c:\\Users\\flipa\\OneDrive - UBC\\Projects\\Bad-Apple\\rtl\\output_bitmaps\\frame_0200.txt",
    parameter ADDRW=$clog2(WIDTH)
    ) 
    (
    // Ideally I would check with an osciliscope so that I can actually see the 
    // signals
    input wire logic             clk_write,     // write clock (port a)
    input wire logic             clk_read,      // read clock (port b)
    input wire logic             we,            // write enable (port a)
    input wire logic [ADDRW-1:0] addr_write_x,  // write address (port a)
    input wire logic [ADDRW-1:0] addr_write_y,  // write address (port a)
    input wire logic [ADDRW-1:0] addr_read_x,   // read address (port b)
    input wire logic [ADDRW-1:0] addr_read_y,   // read address (port b)
    input wire logic             data_in,       // data in (port a)
    output     logic             data_out       // data out (port b)
);

    logic [WIDTH-1:0] memory [HEIGHT];
    initial begin
        if (INIT_F != 0) begin
            $display("Load init file '%s' into bram.", INIT_F);
            $readmemb(INIT_F, memory);
        end
    end

    // // Port A: Sync Write
    // always_ff @(posedge clk_write) begin
    //     if (we) memory[addr_write_x][addr_write_y] <= data_in;
    // end

    // // Port B: Sync Read
    // always_ff @(posedge clk_read) begin
    //     data_out <= memory[addr_read_x][addr_read_y];
    // end

endmodule