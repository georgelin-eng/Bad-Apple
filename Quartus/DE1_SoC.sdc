#**************************************************************
# Altera DE1-SoC SDC settings
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]
derive_pll_clocks
create_clock -name {SPI_clk_CDC} -period 1000.0 [get_ports {GPIO_0[0]}]

# Define input delays for SPI_clk_CDC
# set_input_delay -clock [get_clocks SPI_clk] -max 1.5 [get_ports {SPI_clk_CDC}]
# set_input_delay -clock [get_clocks SPI_clk] -min 0.7 [get_ports {SPI_clk_CDC}]

#**************************************************************
# Hold Time Constraints
#**************************************************************

