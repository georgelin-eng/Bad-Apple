onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /video_tb/reset
add wave -noupdate /video_tb/data_in
add wave -noupdate /video_tb/CLK_40
add wave -noupdate /video_tb/CLK_EN_GEN/read_pixel_clk_en
add wave -noupdate -color Cyan /video_tb/pixel_color
add wave -noupdate /video_tb/mode
add wave -noupdate /video_tb/video_bank_sel
add wave -noupdate /video_tb/SPI_clk_en
add wave -noupdate /video_tb/bank_read_done1
add wave -noupdate /video_tb/bank_read_done2
add wave -noupdate -divider {Video Banks}
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/FSM/state
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/clk_enable
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/write_enable
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/data_in
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/data_out
add wave -noupdate -expand -group {Bank 1} -radix unsigned /video_tb/VIDEO_BANK1/x_pos
add wave -noupdate -expand -group {Bank 1} -radix unsigned -childformat {{{/video_tb/VIDEO_BANK1/y_pos[2]} -radix unsigned} {{/video_tb/VIDEO_BANK1/y_pos[1]} -radix unsigned} {{/video_tb/VIDEO_BANK1/y_pos[0]} -radix unsigned}} -subitemconfig {{/video_tb/VIDEO_BANK1/y_pos[2]} {-height 15 -radix unsigned} {/video_tb/VIDEO_BANK1/y_pos[1]} {-height 15 -radix unsigned} {/video_tb/VIDEO_BANK1/y_pos[0]} {-height 15 -radix unsigned}} /video_tb/VIDEO_BANK1/y_pos
add wave -noupdate -expand -group {Bank 1} -radix unsigned /video_tb/VIDEO_BANK1/bank_counter
add wave -noupdate -expand -group {Bank 1} /video_tb/VIDEO_BANK1/video_buffer_we
add wave -noupdate -expand -group {Bank 2} /video_tb/VIDEO_BANK2/data_out
add wave -noupdate -expand -group {Bank 2} /video_tb/VIDEO_BANK2/FSM/state
add wave -noupdate -expand -group {Bank 2} /video_tb/VIDEO_BANK2/last_pixel
add wave -noupdate -expand -group {Bank 2} /video_tb/VIDEO_BANK2/clk_enable
add wave -noupdate -expand -group {Bank 2} /video_tb/VIDEO_BANK2/write_enable
add wave -noupdate -expand -group {Bank 2} -radix unsigned /video_tb/VIDEO_BANK2/x_pos
add wave -noupdate -expand -group {Bank 2} -radix unsigned /video_tb/VIDEO_BANK2/y_pos
add wave -noupdate -expand -group {Bank 2} -radix unsigned /video_tb/VIDEO_BANK2/bank_counter
add wave -noupdate -expand -group {Bank 2} -group {xpos ypos source signal} -radix unsigned /video_tb/VIDEO_BANK2/VGA_x_pos
add wave -noupdate -expand -group {Bank 2} -group {xpos ypos source signal} -radix unsigned /video_tb/VIDEO_BANK2/VGA_y_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4557025000 ps} 0} {{Cursor 2} {2352032100 ps} 0} {{Cursor 3} {1245000000 ps} 0}
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
WaveRestoreZoom {704778500 ps} {2571735300 ps}
