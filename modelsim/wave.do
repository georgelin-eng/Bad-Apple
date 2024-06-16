onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk_50
add wave -noupdate /tb/pixel_clk
add wave -noupdate /tb/reset
add wave -noupdate /tb/h_sync
add wave -noupdate /tb/v_sync
add wave -noupdate -group DUT /tb/hsync_n
add wave -noupdate -group DUT /tb/vsync_n
add wave -noupdate -group {pixel clk gen} /tb/PIXEL_CLK_GEN/clk_50
add wave -noupdate -group {pixel clk gen} /tb/PIXEL_CLK_GEN/clk_counter
add wave -noupdate -group {pixel clk gen} /tb/PIXEL_CLK_GEN/pixel_clk
add wave -noupdate -group {pixel clk gen} /tb/PIXEL_CLK_GEN/reset
add wave -noupdate -group {hsync clk gen} /tb/HSYNC_GEN/pixel_clk
add wave -noupdate -group {hsync clk gen} /tb/hsync_n
add wave -noupdate -group {hsync clk gen} -radix unsigned /tb/HSYNC_GEN/clk_counter
add wave -noupdate -group {vsync clk gen} -radix unsigned /tb/VSYNC_GEN/clk_counter
add wave -noupdate -group {vsync clk gen} /tb/VSYNC_GEN/hsync_clk_enable
add wave -noupdate -group {vsync clk gen} /tb/VSYNC_GEN/vsync_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16823480 ns} 0} {{Cursor 2} {30 ns} 0}
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
WaveRestoreZoom {16662010 ns} {17185060 ns}
