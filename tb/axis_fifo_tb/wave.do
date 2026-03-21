onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axis_fifo_tb/DUT/clk
add wave -noupdate /axis_fifo_tb/DUT/rst
add wave -noupdate -radix unsigned /axis_fifo_tb/DUT/axis_tdata_s
add wave -noupdate /axis_fifo_tb/DUT/axis_tvalid_s
add wave -noupdate /axis_fifo_tb/DUT/axis_tready_s
add wave -noupdate -radix unsigned /axis_fifo_tb/DUT/axis_tdata_m
add wave -noupdate /axis_fifo_tb/DUT/axis_tvalid_m
add wave -noupdate /axis_fifo_tb/DUT/axis_tready_m
add wave -noupdate /axis_fifo_tb/DUT/wr_ptr_d
add wave -noupdate /axis_fifo_tb/DUT/wr_ptr_q
add wave -noupdate /axis_fifo_tb/DUT/rd_ptr_d
add wave -noupdate /axis_fifo_tb/DUT/rd_ptr_q
add wave -noupdate /axis_fifo_tb/DUT/empty_d
add wave -noupdate /axis_fifo_tb/DUT/empty_q
add wave -noupdate /axis_fifo_tb/DUT/full_d
add wave -noupdate /axis_fifo_tb/DUT/full_q
add wave -noupdate /axis_fifo_tb/DUT/push
add wave -noupdate /axis_fifo_tb/DUT/pop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47700 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 221
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {215089 ps}
