onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Video Bank Internals}
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/CLK_40
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/SPI_clk
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/data_write_clk
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/SPI_clk_rising_edge
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/data_clk_rising_edge
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/reset
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/start_req
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/video_data_ready
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/audio_data_ready
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/MISO
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/chip_select
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/received_bit
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/state
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/fill_FIFO
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/sync_FIFO_done
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/parse_done
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/FIFO_empty
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/FIFO_full
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/FIFO_read_en
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/FIFO_write_en
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/DATA_HEADER_XNOR_BUFF
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/num_match
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/cmd_bit_count
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/video_bank_full
add wave -noupdate -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/audio_bank_full
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/CLK_40
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/count_en
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/init
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/nextstate
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/OS_done
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/pause_done
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/pause_en
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/pixel_count
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/read_bank1
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/read_bank2
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/reset
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/start_data_FSM
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/startup_done
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/state
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/switch_mode
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/VGA_startup_en
add wave -noupdate -expand -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/vid_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55932800 ps} 0} {{Cursor 2} {3952092300 ps} 0} {{Cursor 3} {1835694500 ps} 0} {{Cursor 4} {180397300 ps} 0}
quietly wave cursor active 3
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
WaveRestoreZoom {133692400 ps} {2306620400 ps}
