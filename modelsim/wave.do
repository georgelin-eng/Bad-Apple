onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk_50
add wave -noupdate /tb/reset
add wave -noupdate /tb/pixel_clk
add wave -noupdate -expand -group DUT -radix unsigned /tb/DUT/VGA_R
add wave -noupdate -expand -group DUT -radix unsigned /tb/DUT/VGA_G
add wave -noupdate -expand -group DUT -radix unsigned /tb/DUT/VGA_B
add wave -noupdate -expand -group DUT /tb/DUT/VGA_BLANK_N
add wave -noupdate -expand -group DUT /tb/DUT/VGA_SYNC_N
add wave -noupdate -expand -group DUT /tb/DUT/VGA_HS
add wave -noupdate -expand -group DUT /tb/DUT/VGA_VS
add wave -noupdate -expand -group {hsync clk gen} -radix unsigned /tb/DUT/HSYNC_GEN/clk_counter
add wave -noupdate -expand -group {hsync clk gen} /tb/DUT/h_BLANK
add wave -noupdate -expand -group {hsync clk gen} /tb/DUT/HSYNC_GEN/hsync_n
add wave -noupdate -expand -group {hsync clk gen} /tb/DUT/HSYNC_GEN/hsync_clk_enable
add wave -noupdate -group {vsync clk gen} -radix unsigned /tb/DUT/VSYNC_GEN/clk_counter
add wave -noupdate -group params -radix ascii /tb/DUT/RESOLUTION
add wave -noupdate -group params /tb/DUT/X_LINE_WIDTH
add wave -noupdate -group params /tb/DUT/Y_LINE_WIDTH
add wave -noupdate -group params /tb/DUT/X_DATA_WIDTH
add wave -noupdate -group params /tb/DUT/Y_DATA_WIDTH
add wave -noupdate -radix unsigned /tb/DUT/x_pos
add wave -noupdate -radix unsigned /tb/DUT/y_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15392020 ns} 0} {{Cursor 2} {30080 ns} 0}
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
WaveRestoreZoom {1421150 ns} {41881240 ns}
