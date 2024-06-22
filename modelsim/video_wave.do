onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /video_tb/reset
add wave -noupdate /video_tb/data_in
add wave -noupdate /video_tb/CLK_40
add wave -noupdate /video_tb/mode
add wave -noupdate /video_tb/pixel_color
add wave -noupdate /video_tb/CLK_EN_GEN/read_pixel_clk_en
add wave -noupdate /video_tb/video_bank_sel
add wave -noupdate /video_tb/SPI_clk_en
add wave -noupdate /video_tb/bank_read_done1
add wave -noupdate /video_tb/bank_read_done2
add wave -noupdate -group {Sim Params} /video_tb/X_WIDTH
add wave -noupdate -group {Sim Params} /video_tb/line_time_for_write
add wave -noupdate -divider {Video Banks}
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/clk_enable
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/write_enable
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/data_in
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/data_out
add wave -noupdate -expand -group {Bank 1} -radix unsigned /video_tb/VIDEO_BANK1/x_pos
add wave -noupdate -expand -group {Bank 1} -radix unsigned -childformat {{{/video_tb/VIDEO_BANK1/y_pos[2]} -radix unsigned} {{/video_tb/VIDEO_BANK1/y_pos[1]} -radix unsigned} {{/video_tb/VIDEO_BANK1/y_pos[0]} -radix unsigned}} -subitemconfig {{/video_tb/VIDEO_BANK1/y_pos[2]} {-height 15 -radix unsigned} {/video_tb/VIDEO_BANK1/y_pos[1]} {-height 15 -radix unsigned} {/video_tb/VIDEO_BANK1/y_pos[0]} {-height 15 -radix unsigned}} /video_tb/VIDEO_BANK1/y_pos
add wave -noupdate -expand -group {Bank 1} -radix unsigned /video_tb/VIDEO_BANK1/bank_counter
add wave -noupdate -expand -group {Bank 1} {/video_tb/VIDEO_BANK1/video_buffers[0]/VIDEO_BUFFER/memory}
add wave -noupdate -group {Bank 2} /video_tb/VIDEO_BANK2/clk_enable
add wave -noupdate -group {Bank 2} /video_tb/VIDEO_BANK2/write_enable
add wave -noupdate -group {Bank 2} -radix unsigned /video_tb/VIDEO_BANK2/x_pos
add wave -noupdate -group {Bank 2} -radix unsigned /video_tb/VIDEO_BANK2/y_pos
add wave -noupdate -group {Bank 2} -radix unsigned /video_tb/VIDEO_BANK2/bank_counter
add wave -noupdate -group {Bank 2} /video_tb/VIDEO_BANK2/bank_read_done
add wave -noupdate -group {Bank 2} -group {xpos ypos source signal} -radix unsigned /video_tb/VIDEO_BANK2/VGA_x_pos
add wave -noupdate -group {Bank 2} -group {xpos ypos source signal} -radix unsigned /video_tb/VIDEO_BANK2/VGA_y_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1056005200 ps} 0} {{Cursor 2} {7629204400 ps} 0} {{Cursor 3} {58859300 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {3521171300 ps}
