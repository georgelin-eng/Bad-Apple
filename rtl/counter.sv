module counter #(
    parameter THRESHOLD = 10,
    parameter COUNT_WIDTH = $clog2(THRESHOLD),
    parameter ENABLE_ON_TIME = 'd0 // turn ON to transition on time 
)
(
    input  logic clk,
    input  logic reset,
    input  logic count_en,
    input  logic clk_en,
    
    output logic enable_signal
);

    logic [COUNT_WIDTH-1:0] count;

    // Switch Mode Counter
    always_ff @ (posedge clk) begin
        if (reset) 
            count <= 0;
        else if (count_en & clk_en) begin
            count <= count + 1;

            enable_signal <= (count == (THRESHOLD -1 - ENABLE_ON_TIME));
            
            if (count == THRESHOLD -1 ) begin
               count <= 0;
            end
        end
    end

endmodule