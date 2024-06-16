// Keeps track of what xy position should be uploaded and outputs the corresponding RGB values

module xy_pixelGen (
    input  wire       pixel_clk,
    input  wire       reset,
    input  wire       h_sync,
    input  wire       v_sync,
    output reg [9:0] xPixel, 
    output reg [9:0] yPixel
);

    always @(posedge pixel_clk) begin
        if (reset) begin
            xPixel <= 10'b0;
            yPixel <= 10'b0;
        end
        else if (v_sync) begin
            xPixel <= 10'b0;
            yPixel <= 10'b0;
        end
        else begin
            xPixel <= xPixel + 1;
            if (xPixel == 800) begin
                xPixel <= 10'b0;
            end        
        end
    end

    always @(posedge h_sync) begin
        yPixel <= yPixel + 1;
        if (yPixel == 525) begin
            yPixel <= 10'b0;
        end        
    end

endmodule

// Interface that will read from RAM memory and output corresponding RGB values for the pixels
// Assumes that the image is already downscaled to 800x525 
// When reading from memory, we additionally need to make to so that we ignore values outside the 600 x 480 range. 
module RGB_gen (
    input wire [9:0] xPixel,
    input wire [9:0] yPixel,
    output reg [7:0] R,
    output reg [7:0] G,
    output reg [7:0] B
);

endmodule