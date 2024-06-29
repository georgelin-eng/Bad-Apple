onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Clocking /FSM_tb/CLK_40
add wave -noupdate -expand -group Clocking /FSM_tb/SPI_clk_en
add wave -noupdate -expand -group Clocking /FSM_tb/SPI_clk
add wave -noupdate -radix unsigned -childformat {{{/FSM_tb/VGA_G[7]} -radix unsigned} {{/FSM_tb/VGA_G[6]} -radix unsigned} {{/FSM_tb/VGA_G[5]} -radix unsigned} {{/FSM_tb/VGA_G[4]} -radix unsigned} {{/FSM_tb/VGA_G[3]} -radix unsigned} {{/FSM_tb/VGA_G[2]} -radix unsigned} {{/FSM_tb/VGA_G[1]} -radix unsigned} {{/FSM_tb/VGA_G[0]} -radix unsigned}} -subitemconfig {{/FSM_tb/VGA_G[7]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[6]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[5]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[4]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[3]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[2]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[1]} {-height 15 -radix unsigned} {/FSM_tb/VGA_G[0]} {-height 15 -radix unsigned}} /FSM_tb/VGA_G
add wave -noupdate -group SPI /FSM_tb/MISO
add wave -noupdate -group SPI /FSM_tb/DATA_FSM/chip_select
add wave -noupdate -group SPI /FSM_tb/MOSI
add wave -noupdate -group {Control Signals} /FSM_tb/frame_done
add wave -noupdate -group {Control Signals} /FSM_tb/video_bank_full
add wave -noupdate -group {Control Signals} /FSM_tb/audio_bank_full
add wave -noupdate -group {Control Signals} /FSM_tb/write_video
add wave -noupdate -group {Control Signals} /FSM_tb/VIDEO_CONTROLLER/video_bank_sel
add wave -noupdate -group {Control Signals} /FSM_tb/write_video
add wave -noupdate /FSM_tb/DATA_FSM/state
add wave -noupdate -divider {Video Bank Internals}
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
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/data_out
add wave -noupdate -group {Bank 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/pixel_addr
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/clk_enable
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/read_enable
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/write_enable
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/FSM/state
add wave -noupdate -group {Bank 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/bank_counter
add wave -noupdate -group {Bank 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/y_pos
add wave -noupdate -group {Bank 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/last_pixel
add wave -noupdate -group {Bank 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/x_pos
add wave -noupdate -group {Bank 1} -group {mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/we
add wave -noupdate -group {Bank 1} -group {mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/q
add wave -noupdate -group {Bank 1} -group {mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/d
add wave -noupdate -group {Bank 1} -group {mem 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/write_address
add wave -noupdate -group {Bank 1} -group {mem 1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/read_address
add wave -noupdate -group {Bank 1} -group {mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/clk
add wave -noupdate -group {Bank 1} -group {mem 1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/mem
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/q
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/d
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/write_address
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/read_address
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/we
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/clk
add wave -noupdate -group {Bank 1} -group mem2 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM2/mem
add wave -noupdate -group {Bank 1} -group mem3 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM3/q
add wave -noupdate -group {Bank 1} -group mem3 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM3/d
add wave -noupdate -group {Bank 1} -group mem3 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM3/write_address
add wave -noupdate -group {Bank 1} -group mem3 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM3/read_address
add wave -noupdate -group {Bank 1} -group mem3 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM3/we
add wave -noupdate -group {Bank 1} -group mem3 /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM3/clk
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/mem_clk
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out
add wave -noupdate -expand -group {Bank 2} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/pixel_addr
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/FSM/state
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/write_enable
add wave -noupdate -expand -group {Bank 2} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/bank_counter
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/bank_full
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/bank_read_done
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/last_pixel
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/x_pos
add wave -noupdate -expand -group {Bank 2} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/y_pos
add wave -noupdate /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/clk
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out2
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out3
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out4
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out5
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out6
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out7
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out8
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out9
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out10
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out11
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out12
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out13
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out14
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out15
add wave -noupdate -expand -label {Contributors: data_out} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/data_out} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/mem_block_sel
add wave -noupdate /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1
add wave -noupdate -label {Contributors: data_out1} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/clk
add wave -noupdate -label {Contributors: data_out1} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/d
add wave -noupdate -label {Contributors: data_out1} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/mem
add wave -noupdate -label {Contributors: data_out1} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/read_address
add wave -noupdate -label {Contributors: data_out1} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1} /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/we
add wave -noupdate -label {Contributors: data_out1} -group {Contributors: sim:/FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/data_out1} -radix unsigned /FSM_tb/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/write_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3530904700 ps} 0} {{Cursor 2} {4215812500 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {3312500500 ps} {4888436500 ps}
