onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /compute_mac_tb/DUT/clk
add wave -noupdate /compute_mac_tb/DUT/rst
add wave -noupdate /compute_mac_tb/DUT/i_signal
add wave -noupdate /compute_mac_tb/DUT/i_coef
add wave -noupdate /compute_mac_tb/DUT/o_res
add wave -noupdate /compute_mac_tb/DUT/i_mac_clr
add wave -noupdate /compute_mac_tb/DUT/mac_clr_0
add wave -noupdate /compute_mac_tb/DUT/mac_clr_1
add wave -noupdate /compute_mac_tb/DUT/i_signal_reg
add wave -noupdate /compute_mac_tb/DUT/i_coef_reg
add wave -noupdate /compute_mac_tb/DUT/mul_res
add wave -noupdate /compute_mac_tb/DUT/acc_res
add wave -noupdate /compute_mac_tb/DUT/round_res
add wave -noupdate /compute_mac_tb/DUT/pattern_detect
add wave -noupdate /compute_mac_tb/DUT/pattern
add wave -noupdate /compute_mac_tb/DUT/c
add wave -noupdate /compute_mac_tb/DUT/round_acc
add wave -noupdate /compute_mac_tb/DUT/round_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27124324341 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
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
WaveRestoreZoom {27124299815 ps} {27124442115 ps}
