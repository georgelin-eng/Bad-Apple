onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /video_tb/write_video
add wave -noupdate /video_tb/VIDEO_CONTROLLER/video_bank_we
add wave -noupdate /video_tb/VIDEO_CONTROLLER/video_bank1_we
add wave -noupdate /video_tb/VIDEO_CONTROLLER/video_bank2_we
add wave -noupdate /video_tb/CLK_40
add wave -noupdate /video_tb/SPI_clk_en
add wave -noupdate /video_tb/MISO
add wave -noupdate -radix unsigned /video_tb/VGA_B
add wave -noupdate -radix unsigned /video_tb/VGA_G
add wave -noupdate -radix unsigned /video_tb/VGA_R
add wave -noupdate /video_tb/VIDEO_CONTROLLER/pixel_data_out
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VGA_controller/h_BLANK
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VGA_controller/v_BLANK
add wave -noupdate -expand -group {VGA Controller} /video_tb/SPI_clk
add wave -noupdate -expand -group {VGA Controller} /video_tb/VIDEO_CONTROLLER/VGA_controller/ACTIVE
add wave -noupdate -expand -group {VGA Controller} -radix unsigned /video_tb/VIDEO_CONTROLLER/VGA_controller/x_pos
add wave -noupdate -expand -group {VGA Controller} -radix unsigned /video_tb/VIDEO_CONTROLLER/VGA_controller/y_pos
add wave -noupdate -divider {Video Banks}
add wave -noupdate -group {Bank 1} /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/NUM_ADDR
add wave -noupdate -group {Bank 1} /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/active
add wave -noupdate -group {Bank 1} -radix unsigned /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/bank_counter
add wave -noupdate -group {Bank 1} -radix unsigned /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/x_pos
add wave -noupdate -group {Bank 1} -radix unsigned /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/y_pos
add wave -noupdate -group {Bank 1} -radix unsigned /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/pixel_addr
add wave -noupdate -group {Bank 1} /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/FSM/state
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/frame
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/we
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/clk
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/d
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/q
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/read_address
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/write_address
add wave -noupdate /video_tb/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {133200 ps} 0} {{Cursor 2} {6791200 ps} 0} {{Cursor 3} {0 ps} 0} {{Cursor 4} {61000000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 148
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
WaveRestoreZoom {0 ps} {320345600 ps}
