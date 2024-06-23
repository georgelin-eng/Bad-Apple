module screenPositionTracker #(
    parameter X_LINE_WIDTH = 640,
    parameter Y_LINE_WIDTH = 480,
    parameter X_DATA_WIDTH = $clog2(X_LINE_WIDTH),
    parameter Y_DATA_WIDTH = $clog2(Y_LINE_WIDTH)
)
(
    input wire                        CLK_40,
    input wire                        reset,
    input wire                        clk_en,
    output reg [X_DATA_WIDTH-1:0]     x_pos,
    output reg [Y_DATA_WIDTH-1:0]     y_pos
);
    always @(posedge CLK_40) begin 
        if (reset) begin
            x_pos <= 0;      
            y_pos <= 0; 
        end else begin
            if (clk_en) begin
                if (x_pos < X_LINE_WIDTH-1) begin
                    x_pos <= x_pos + 1;
                end else begin
                    x_pos <= 0;          // the last assignment wins, we'll go back to incrementing x at the next clock cycle.
                    y_pos <= y_pos + 1;   
                    if (y_pos == Y_LINE_WIDTH-1) begin
                        y_pos <= 0;    // the last assignment wins
                    end
                end
            end
        end
    end
endmodule

