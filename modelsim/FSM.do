onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Video Bank Internals}
add wave -noupdate /FSM_tb/CLK_40
add wave -noupdate /FSM_tb/SPI_clk_CDC
add wave -noupdate -group {SPI clk} /FSM_tb/FSM_TOP/SPI_CLK/clk
add wave -noupdate -group {SPI clk} /FSM_tb/FSM_TOP/SPI_CLK/reset
add wave -noupdate -group {SPI clk} /FSM_tb/FSM_TOP/SPI_CLK/data_in
add wave -noupdate -group {SPI clk} /FSM_tb/FSM_TOP/SPI_CLK/data_in1
add wave -noupdate -group {SPI clk} /FSM_tb/FSM_TOP/SPI_CLK/data_out
add wave -noupdate /FSM_tb/FSM_TOP/DATA_FSM/video_data_ready
add wave -noupdate -expand -group {Data FSM} /FSM_tb/FSM_TOP/DATA_FSM/state
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/CLK_40
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/count_en
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/init
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/nextstate
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/OS_done
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/pause_done
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/pause_en
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/pixel_count
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/read_bank1
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/read_bank2
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/reset
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/start_data_FSM
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/startup_done
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/state
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/switch_mode
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/VGA_startup_en
add wave -noupdate -group {Mode FSM} /FSM_tb/FSM_TOP/MODE_FSM/vid_start
add wave -noupdate /FSM_tb/FSM_TOP/MISO_CDC
add wave -noupdate -color Cyan /FSM_tb/FSM_TOP/received_bit
add wave -noupdate -label {Contributors: received_bit} -group {Contributors: sim:/FSM_tb/FSM_TOP/received_bit} /FSM_tb/FSM_TOP/DATA_FSM/CLK_40
add wave -noupdate -label {Contributors: received_bit} -group {Contributors: sim:/FSM_tb/FSM_TOP/received_bit} /FSM_tb/FSM_TOP/DATA_FSM/MISO
add wave -noupdate -label {Contributors: received_bit} -group {Contributors: sim:/FSM_tb/FSM_TOP/received_bit} /FSM_tb/FSM_TOP/DATA_FSM/data_clk_falling_edge
add wave -noupdate /FSM_tb/data_write_clk_CDC
add wave -noupdate -radix hexadecimal -childformat {{{/FSM_tb/DATA_BUFF[23]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[22]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[21]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[20]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[19]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[18]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[17]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[16]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[15]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[14]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[13]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[12]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[11]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[10]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[9]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[8]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[7]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[6]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[5]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[4]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[3]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[2]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[1]} -radix hexadecimal} {{/FSM_tb/DATA_BUFF[0]} -radix hexadecimal}} -subitemconfig {{/FSM_tb/DATA_BUFF[23]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[22]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[21]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[20]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[19]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[18]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[17]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[16]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[15]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[14]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[13]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[12]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[11]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[10]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[9]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[8]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[7]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[6]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[5]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[4]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[3]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[2]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[1]} {-height 15 -radix hexadecimal} {/FSM_tb/DATA_BUFF[0]} {-height 15 -radix hexadecimal}} /FSM_tb/DATA_BUFF
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/reset
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/CLK_40
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/write_clk
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/read_clk
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/read_en
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/write_en
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/din
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/dout
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/empty
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/full
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/write_ptr
add wave -noupdate -expand -group FIFO /FSM_tb/FSM_TOP/DATA_FSM/SYNC_FIFO/read_ptr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0} {{Cursor 2} {14796413800 ps} 0} {{Cursor 3} {2173467900 ps} 0} {{Cursor 4} {0 ps} 0}
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
WaveRestoreZoom {2163227100 ps} {2206929100 ps}
