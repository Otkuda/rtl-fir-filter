onerror {resume}
radix define Q0_15 -fixed -fraction 15 -signed -base decimal
radix define Q33_15 -fixed -fraction 15 -signed -base decimal
quietly WaveActivateNextPane {} 0
add wave -noupdate /compute_mac_tb/DUT/clk
add wave -noupdate /compute_mac_tb/DUT/rst
add wave -noupdate /compute_mac_tb/DUT/i_signal
add wave -noupdate -radix Q0_15 /compute_mac_tb/DUT/i_coef
add wave -noupdate -radix decimal /compute_mac_tb/DUT/o_res
add wave -noupdate /compute_mac_tb/DUT/i_mac_clr
add wave -noupdate -radix decimal /compute_mac_tb/DUT/i_signal_reg_0
add wave -noupdate -radix Q0_15 /compute_mac_tb/DUT/i_coef_reg_0
add wave -noupdate -radix decimal /compute_mac_tb/DUT/i_signal_reg_1
add wave -noupdate -radix Q0_15 /compute_mac_tb/DUT/i_coef_reg_1
add wave -noupdate -radix Q0_15 /compute_mac_tb/DUT/mul_res
add wave -noupdate -radix Q0_15 /compute_mac_tb/DUT/acc_res
add wave -noupdate -radix decimal /compute_mac_tb/DUT/round_res
add wave -noupdate -radix decimal /compute_mac_tb/DUT/round_res_1
add wave -noupdate /compute_mac_tb/DUT/pos_overflow
add wave -noupdate /compute_mac_tb/DUT/neg_overflow
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58728 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
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
WaveRestoreZoom {26877 ps} {155807 ps}
