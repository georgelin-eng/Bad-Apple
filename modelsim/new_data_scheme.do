onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_FSM_tb/CLK_40
add wave -noupdate /top_FSM_tb/SPI_clk
add wave -noupdate /top_FSM_tb/MISO
add wave -noupdate -expand -group {Mode FSM} /top_FSM_tb/DUT/MODE_FSM/state
add wave -noupdate -radix unsigned /top_FSM_tb/DUT/MODE_FSM/pixel_count
add wave -noupdate -expand -group {Data FSM} /top_FSM_tb/DUT/DATA_FSM/audio_data_ready
add wave -noupdate -expand -group {Data FSM} /top_FSM_tb/DUT/DATA_FSM/video_data_ready
add wave -noupdate -expand -group {Data FSM} /top_FSM_tb/DUT/DATA_FSM/state
add wave -noupdate -radix unsigned /top_FSM_tb/DUT/DATA_FSM/audio_mem_count
add wave -noupdate -radix unsigned /top_FSM_tb/DUT/DATA_FSM/video_mem_count
add wave -noupdate -expand -group {Bank 1 FSM} /top_FSM_tb/DUT/BANK1/clk_enable
add wave -noupdate -expand -group {Bank 1 FSM} /top_FSM_tb/DUT/BANK1/state
add wave -noupdate -expand -group {Bank 2 FSM} /top_FSM_tb/DUT/BANK2/clk_enable
add wave -noupdate -expand -group {Bank 2 FSM} /top_FSM_tb/DUT/BANK2/video_data_ready
add wave -noupdate -expand -group {Bank 2 FSM} /top_FSM_tb/DUT/BANK2/write_enable
add wave -noupdate -expand -group {Bank 2 FSM} /top_FSM_tb/DUT/BANK2/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6168037500 ps} 0}
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
WaveRestoreZoom {0 ps} {9632256 ns}
