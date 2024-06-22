// Need to make sure that the length of h_synch is lasting for enough time. i.e. SP time units
// https://github.com/edolinsky/cpen311/blob/master/lab2/Task2_3_4/vga_controller.v
// My implmentation is a chain of clock enable modules. Are h_sync and v_synch even meant to be clocks?


// Changing all my clock generation to now be enables
// Use deticated resources for creating clocking
module clk_en_gen(
    input      CLK_40,  // 40MHz clock from the oscilator - the system clock 
    input      reset,
    output reg read_pixel_clk_en, // pixel clock freq / 4
    output reg SPI_clk_en,
    output reg audio_clk_en
);

    reg [1:0]  read_pixel_counter;
    reg [5:0]  SPI_clk_counter;   // divide by 50   -> 6 bit counter
    reg [12:0] audio_clk_counter; // divide by 6250 -> 13 bit counter

    parameter read_pixel_divisor = 4;
    parameter SPI_divisor        = 40;
    parameter audio_divisor      = 5000;

    // Generates the 25MHz clk that we need to update pixels
    // Should go high for 3.8us, or 96 counts of pixel_clk (192 counts of CLK_40)
    always @(posedge CLK_40) begin
        if (reset) begin
            audio_clk_en      <= 1'b0;
            SPI_clk_en        <= 1'b0;
            read_pixel_clk_en <= 1'b0;
            SPI_clk_counter   <= 1'b0;
            audio_clk_counter <= 1'b0;
            read_pixel_counter<= 1'b0;
        end else begin
            read_pixel_counter <= read_pixel_counter + 1;
            SPI_clk_counter    <= SPI_clk_counter   + 1;
            audio_clk_counter  <= audio_clk_counter + 1;

            read_pixel_clk_en  <= (read_pixel_counter== read_pixel_divisor-1);
            SPI_clk_en         <= (SPI_clk_counter   == SPI_divisor-1);
            audio_clk_en       <= (audio_clk_counter == audio_divisor-1);

            if (read_pixel_counter == SPI_divisor-1) begin
                read_pixel_counter <= 0;
            end
            if (SPI_clk_counter == SPI_divisor-1) begin
                SPI_clk_counter <= 0;
            end

            if (audio_clk_counter == audio_divisor-1) begin
                audio_clk_counter <= 0;
            end
        end
    end
endmodule


// I'm thinking that in here, I should generate a signal that's for "active" maybe?
// i.e. only read from memory if I'm in an active region
module hsync_gen # (
    parameter X_DATA_WIDTH  = 10,
    parameter h_front_porch = 16,
    parameter h_synch_pulse = 96, // This means that the negative portion must last for 96 units of pixel_clk
    parameter h_back_porch  = 48,
    parameter h_area        = 640, // Marks the end of the active area

    // Timing parameters to generate hsynch and blanking signal pulse
    // During blanking, BLACK pixels are transmitted
    parameter h_synch_start = h_area + h_front_porch,  
    parameter h_synch_end   = h_synch_start + h_synch_pulse,
    parameter h_line_width  = h_synch_end + h_back_porch
)(
    input wire                             CLK_40,
    input wire                             pixel_clk,          // used as clock enable for hsynch pusle generation
    input wire                             reset,
    input wire        [X_DATA_WIDTH:0]     x_pos,
    output reg                             hsync_n,            // used to begin a new scan line
    output reg                             h_BLANK             // control bit used to create the blanking region
);

    // In this design, CLK_40 (system clock) drives the logic and action is controlled via a "clock_enable"
    always @(posedge CLK_40) begin
        if (reset) begin
            hsync_n <= 1'b0;
        end else begin
            if (pixel_clk) begin
                hsync_n <= (x_pos >= h_synch_start) && (x_pos < h_synch_end-1); // Generate 96 pixel long synch pulse
                h_BLANK <= (x_pos >= h_area)        && (x_pos < h_line_width);  // Generating blanking control signal
            end
        end
    end
endmodule



module vsync_gen # (
    parameter Y_DATA_WIDTH = 10,
    parameter v_front_porch = 10,
    parameter v_synch_pulse = 2, // This must mean that the negative portion must last for 2 scan lines (2 iterations of hsync_clk)_enable
    parameter v_back_porch  = 33,
    parameter v_area        = 480,
    parameter v_synch_start = v_area + v_front_porch, 
    parameter v_synch_end   = v_synch_start + v_synch_pulse, // marks the end of the synchronization pulse
    parameter v_line_width  = v_synch_end + v_back_porch    // 525
)
(
    input                              CLK_40,
    input                              pixel_clk,
    input                              reset,
    input  wire  [Y_DATA_WIDTH:0]      y_pos, 
    output reg                         vsync_n ,    // used to generate new frames
    output reg                         v_BLANK      // used to control generation of black pixels for the blanking area
);

    // Generates vsync_counth pulse
    always @(posedge CLK_40) begin
         if (reset) begin
            vsync_n <= 1'b0;
        end else begin
            if (pixel_clk) begin // Can't use this as a clock enable anymore since it'll be positive for 96 clock cycles at a time
                vsync_n <= (y_pos >= v_synch_start) && (y_pos < v_synch_end);
                v_BLANK <= (y_pos >= v_area)        && (y_pos < v_line_width);
            end
        end
    end
endmodule


module debug_clk_gen (
    input      CLK_40,  // 50MHz clock from the oscilator - the system clock 
    input      reset,
    output reg  clk_debug // 25MHz clk that will be used to drive the monitor - being used as a clk enable
);
    reg  [15:0] clk_counter; // 1 bit counter used for frequency division of CLK_40

    parameter divisor = 8;
    always @(posedge CLK_40) begin
        if (reset) begin
            clk_debug   <= 1'b0;
            clk_counter <= 1'b0;
        end else begin
            clk_counter <= clk_counter + 1;
            if (clk_counter == divisor) begin
                clk_debug <= ~clk_debug;
                clk_counter <= 0;
            end
        end
    end
endmodule


module clock_mux (clk,clk_select,clk_out);

	parameter num_clocks = 4;

	input [num_clocks-1:0] clk;
	input [num_clocks-1:0] clk_select; // one hot
	output clk_out;

	genvar i;

	reg [num_clocks-1:0] ena_r0;
	reg [num_clocks-1:0] ena_r1;
	reg [num_clocks-1:0] ena_r2;
	wire [num_clocks-1:0] qualified_sel;

	// A look-up-table (LUT) can glitch when multiple inputs 
	// change simultaneously. Use the keep attribute to
	// insert a hard logic cell buffer and prevent 
	// the unrelated clocks from appearing on the same LUT.

	wire [num_clocks-1:0] gated_clks /* synthesis keep */;

	initial begin
		ena_r0 = 0;
		ena_r1 = 0;
		ena_r2 = 0;
	end

	generate
		for (i=0; i<num_clocks; i=i+1) 
		begin : lp0
			wire [num_clocks-1:0] tmp_mask;
			assign tmp_mask = {num_clocks{1'b1}} ^ (1 << i);

			assign qualified_sel[i] = clk_select[i] & (~|(ena_r2 & tmp_mask));

			always @(posedge clk[i]) begin
				ena_r0[i] <= qualified_sel[i];    	
				ena_r1[i] <= ena_r0[i];    	
			end

			always @(negedge clk[i]) begin
				ena_r2[i] <= ena_r1[i];    	
			end

			assign gated_clks[i] = clk[i] & ena_r2[i];
		end
	endgenerate

	// These will not exhibit simultaneous toggle by construction
	assign clk_out = |gated_clks;

endmodule


