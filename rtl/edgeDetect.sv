// Requires that CDC already be handled

module edge_detect (
    input  logic sample_clk,
    input  logic reset,
    input  logic target_data,
    output logic rising_edge,
    output logic falling_edge
);
    logic [1:0] data_buff;

    always_ff @ (posedge sample_clk) begin
        data_buff        <= {data_buff [0], target_data}; 
    end

    assign rising_edge  = (data_buff == 2'b01);
    assign falling_edge = (data_buff == 2'b10);

endmodule