	component VGA_800x600 is
		port (
			ref_clk_clk        : in  std_logic := 'X'; -- clk
			ref_reset_reset    : in  std_logic := 'X'; -- reset
			vga_clk_clk        : out std_logic;        -- clk
			reset_source_reset : out std_logic         -- reset
		);
	end component VGA_800x600;

	u0 : component VGA_800x600
		port map (
			ref_clk_clk        => CONNECTED_TO_ref_clk_clk,        --      ref_clk.clk
			ref_reset_reset    => CONNECTED_TO_ref_reset_reset,    --    ref_reset.reset
			vga_clk_clk        => CONNECTED_TO_vga_clk_clk,        --      vga_clk.clk
			reset_source_reset => CONNECTED_TO_reset_source_reset  -- reset_source.reset
		);

