onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Data FSM State} -color Cyan /top_tb/DUT/DATA_FSM/state
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/chip_select
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/CLK_40
add wave -noupdate -expand -group {Data FSM} -color Cyan /top_tb/DUT/DATA_FSM/data_clk_rising_edge
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/data_clk_falling_edge
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/parse_done
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/parse_en
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/received_bit
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/video_bank_full
add wave -noupdate -expand -group {Data FSM} /top_tb/DUT/DATA_FSM/video_data_ready
add wave -noupdate -expand -group {Data FSM} -radix unsigned /top_tb/DUT/DATA_FSM/num_match
add wave -noupdate -group xy -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos
add wave -noupdate -group xy -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/mem_y_pos
add wave -noupdate -group xy -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VGA_x_pos
add wave -noupdate -group xy -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VGA_y_pos
add wave -noupdate -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos
add wave -noupdate -expand -label {Contributors: mem_x_pos} -group {Contributors: sim:/top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos} /top_tb/DUT/VIDEO_CONTROLLER/mem_pos_tracker/CLK_40
add wave -noupdate -expand -label {Contributors: mem_x_pos} -group {Contributors: sim:/top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos} /top_tb/DUT/VIDEO_CONTROLLER/mem_pos_tracker/clk_en
add wave -noupdate -expand -label {Contributors: mem_x_pos} -group {Contributors: sim:/top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos} /top_tb/DUT/VIDEO_CONTROLLER/mem_pos_tracker/count_en
add wave -noupdate -expand -label {Contributors: mem_x_pos} -group {Contributors: sim:/top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos} /top_tb/DUT/VIDEO_CONTROLLER/mem_pos_tracker/reset
add wave -noupdate -expand -label {Contributors: mem_x_pos} -group {Contributors: sim:/top_tb/DUT/VIDEO_CONTROLLER/mem_x_pos} -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/mem_pos_tracker/x_pos
add wave -noupdate -expand -group {Bank 1} -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/bank_counter
add wave -noupdate -expand -group {Bank 1} -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/pixel_addr
add wave -noupdate -group B1M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/clk
add wave -noupdate -group B1M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/d
add wave -noupdate -group B1M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/mem
add wave -noupdate -group B1M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/q
add wave -noupdate -group B1M1 -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/read_address
add wave -noupdate -group B1M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/we
add wave -noupdate -group B1M1 -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM1/write_address
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/ADDRW
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/clk
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/d
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/frame
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/mem
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/NUM_ADDR
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/q
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/read_address
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/we
add wave -noupdate -expand -group B1M15 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK1/VIDEO_MEM/VIDEO_RAM/MEM15/write_address
add wave -noupdate -group {Bank 2} /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/FSM/last_pixel
add wave -noupdate -group {Bank 2} /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/FSM/state
add wave -noupdate -group {Bank 2} -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/bank_counter
add wave -noupdate -group {Bank 2} -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/pixel_addr
add wave -noupdate -group B2M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/clk
add wave -noupdate -group B2M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/d
add wave -noupdate -group B2M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/mem
add wave -noupdate -group B2M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/q
add wave -noupdate -group B2M1 -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/read_address
add wave -noupdate -group B2M1 -radix unsigned /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/write_address
add wave -noupdate -group B2M1 /top_tb/DUT/VIDEO_CONTROLLER/VIDEO_BANK2/VIDEO_MEM/VIDEO_RAM/MEM1/we
add wave -noupdate -radix unsigned /top_tb/DUT/DATA_FSM/video_write_sync_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8103511500 ps} 0} {{Cursor 2} {3291200 ps} 0} {{Cursor 3} {320434700 ps} 0} {{Cursor 4} {2448543000 ps} 0} {{Cursor 5} {4710112500 ps} 0}
quietly wave cursor active 5
configure wave -namecolwidth 189
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
WaveRestoreZoom {0 ps} {2496800 ps}
