onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Clocking /FSM_tb/CLK_40
add wave -noupdate -group Clocking /FSM_tb/SPI_clk_en
add wave -noupdate -group Clocking /FSM_tb/SPI_clk
add wave -noupdate -radix unsigned -childformat {{{/FSM_tb/VGA_G[7]} -radix unsigned} {{/FSM_tb/VGA_G[6]} -radix unsigned} {{/FSM_tb/VGA_G[5]} -radix unsigned} {{/FSM_tb/VGA_G[4]} -radix unsigned} {{/FSM_tb/VGA_G[3]} -radix unsigned} {{/FSM_tb/VGA_G[2]} -radix unsigned} {{/FSM_tb/VGA_G[1]} -radix unsigned} {{/FSM_tb/VGA_G[0]} -radix unsigned}} -subitemconfig {{/FSM_tb/VGA_G[7]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[6]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[5]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[4]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[3]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[2]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[1]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[0]} {-height 15 -radix unsigned}} /FSM_tb/VGA_G
add wave -noupdate -expand -label {Contributors: VGA_G} -group {Contributors: sim:/FSM_tb/VGA_G} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/pixel_color
add wave -noupdate /FSM_tb/VIDEO_CONTROLLER/VGA_controller/pixel_color
add wave -noupdate -expand -label {Contributors: pixel_color} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VGA_controller/pixel_color} /FSM_tb/VIDEO_CONTROLLER/bank1_out
add wave -noupdate -expand -label {Contributors: pixel_color} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VGA_controller/pixel_color} /FSM_tb/VIDEO_CONTROLLER/bank2_out
add wave -noupdate -expand -label {Contributors: pixel_color} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VGA_controller/pixel_color} /FSM_tb/VIDEO_CONTROLLER/video_bank_sel
add wave -noupdate -group SPI /FSM_tb/MISO
add wave -noupdate -group SPI /FSM_tb/DATA_FSM/chip_select
add wave -noupdate -group SPI /FSM_tb/MOSI
add wave -noupdate -group {Mode FSM} /FSM_tb/MODE_FSM/init
add wave -noupdate -group {Mode FSM} /FSM_tb/MODE_FSM/state
add wave -noupdate -group {Mode FSM} /FSM_tb/MODE_FSM/read_bank1
add wave -noupdate -group {Mode FSM} /FSM_tb/MODE_FSM/read_bank2
add wave -noupdate -group {Mode FSM} /FSM_tb/MODE_FSM/write_bank1
add wave -noupdate -group {Mode FSM} /FSM_tb/MODE_FSM/write_bank2
add wave -noupdate -group {Mode FSM} -radix unsigned /FSM_tb/MODE_FSM/pixel_count
add wave -noupdate -group {Data FSM} /FSM_tb/DATA_FSM/chip_select
add wave -noupdate -group {Data FSM} /FSM_tb/DATA_FSM/state
add wave -noupdate -divider {Video Bank Internals}
add wave -noupdate /FSM_tb/VIDEO_CONTROLLER/VGA_controller/VGA_HS
add wave -noupdate /FSM_tb/VIDEO_CONTROLLER/VGA_controller/VGA_VS
add wave -noupdate /FSM_tb/VIDEO_CONTROLLER/ACTIVE
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/h_area
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/h_back_porch
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/v_area
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/v_front_porch
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/v_synch_pulse
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/h_front_porch
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/h_synch_pulse
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/ACTIVE
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/h_BLANK
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/hsync_n
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/v_BLANK
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_controller/VGA_BLANK_N
add wave -noupdate -group {VGA Controller} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VGA_controller/x_pos
add wave -noupdate -group {VGA Controller} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VGA_controller/y_pos
add wave -noupdate -group {VGA Controller} /FSM_tb/VIDEO_CONTROLLER/VGA_BLANK_N
add wave -noupdate -group {Video controller top} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/mem_x_pos
add wave -noupdate -group {Video controller top} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/mem_y_pos
add wave -noupdate -group {Video controller top} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VGA_x_pos
add wave -noupdate -group {Video controller top} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VGA_y_pos
add wave -noupdate -group {Video controller top} /FSM_tb/VIDEO_CONTROLLER/read_bank1
add wave -noupdate -group {Video controller top} /FSM_tb/VIDEO_CONTROLLER/read_bank2
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/CLK_40
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/read_pixel_clk_en
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/SPI_clk
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/SPI_clk_en
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/reset
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/read_enable
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VGA_x_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VGA_y_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/mem_x_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/mem_y_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/data_in
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/active
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/data_out
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/x_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/y_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VGA_x_pos_scaled
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VGA_y_pos_scaled
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/clk_enable
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/mem_clk
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/last_pixel
add wave -noupdate -group {Bank 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/bank_counter
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/video_buffer_we
add wave -noupdate -expand -group {Bank 2} -expand -group {Pos in read} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VGA_x_pos_scaled
add wave -noupdate -expand -group {Bank 2} -expand -group {Pos in read} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VGA_y_pos_scaled
add wave -noupdate -expand -group {Bank 2} -expand -group {Pos in read} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VGA_x_pos
add wave -noupdate -expand -group {Bank 2} -expand -group {Pos in read} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VGA_y_pos
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/chip_select
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_in
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/read_enable
add wave -noupdate -expand -group {Bank 2} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/x_pos
add wave -noupdate -expand -group {Bank 2} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/y_pos
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/active
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/clk_enable
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/mem_clk
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/last_pixel
add wave -noupdate -expand -group {Bank 2} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/bank_counter
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/video_buffer_we
add wave -noupdate -expand -group {Bank 2} -group FSM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/FSM/state
add wave -noupdate -expand -group {Bank 2} -group FSM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/FSM/video_data_ready
add wave -noupdate -expand -group {Bank 2} -group FSM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/FSM/write_en
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out_after_sel
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/clk
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/pixel_addr
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -group {Mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/q
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -group {Mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/d
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -group {Mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/we
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -group {Mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/clk
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -group {Mem 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/write_address
add wave -noupdate -expand -group {Bank 2} -expand -group RAM -group {Mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/read_address
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/mem_block_sel
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_in
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/we
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out2
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out3
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out4
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out5
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out6
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out7
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out8
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out9
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out10
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out11
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out12
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out13
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out14
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out15
add wave -noupdate -expand -group {Bank 2} -expand -group RAM /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/we_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55932800 ps} 0} {{Cursor 2} {3952092300 ps} 0} {{Cursor 3} {436876200 ps} 0} {{Cursor 4} {180397300 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 10
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {3863936800 ps} {4412800800 ps}
