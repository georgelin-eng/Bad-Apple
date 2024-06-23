onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /video_tb/reset
add wave -noupdate /video_tb/data_in
add wave -noupdate /video_tb/CLK_40
add wave -noupdate /video_tb/CLK_EN_GEN/read_pixel_clk_en
add wave -noupdate /video_tb/mode
add wave -noupdate /video_tb/SPI_clk_en
add wave -noupdate -divider {Video Banks}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4557025000 ps} 0} {{Cursor 2} {2352032100 ps} 0} {{Cursor 3} {210300 ps} 0}
quietly wave cursor active 3
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
WaveRestoreZoom {0 ps} {4195200 ps}
