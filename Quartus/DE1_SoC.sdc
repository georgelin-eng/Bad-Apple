#**************************************************************
# Altera DE1-SoC SDC settings
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]
derive_pll_clocks
create_clock -name {SPI_clk_CDC}    -period 1000.0 [get_ports {GPIO_0[0]}]
create_clock -name {data_write_clk} -period 1000.0 [get_ports {data_write_clk}]

#**************************************************************
# Hold Time Constraints
#**************************************************************

