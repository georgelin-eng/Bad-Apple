module dff_sync2 (
    input       clk,
    input       reset,
    input       data_in,
    output reg  data_out
);
    reg data_in1; 

    always_ff @ (posedge clk) begin
        if (reset) begin
            data_in1 <= 0;
        end else begin
            data_in1 <= data_in;
            data_out <= data_in1;
        end
    end
endmodule