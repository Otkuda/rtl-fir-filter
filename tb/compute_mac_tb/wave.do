onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /compute_mac_tb/DUT/clk
add wave -noupdate /compute_mac_tb/DUT/rst
add wave -noupdate -radix decimal /compute_mac_tb/DUT/i_signal
add wave -noupdate -radix decimal /compute_mac_tb/DUT/i_coef
add wave -noupdate /compute_mac_tb/DUT/o_res
add wave -noupdate /compute_mac_tb/DUT/i_res_valid
add wave -noupdate -radix hexadecimal /compute_mac_tb/DUT/mul_res
add wave -noupdate -radix decimal /compute_mac_tb/DUT/round_res
add wave -noupdate -radix decimal /compute_mac_tb/DUT/mac_res
add wave -noupdate /compute_mac_tb/DUT/pre_round
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {74085 ps} 0}
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
WaveRestoreZoom {21300 ps} {208839 ps}
