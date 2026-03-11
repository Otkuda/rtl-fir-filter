onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /compute_mac_tb/DUT/clk
add wave -noupdate /compute_mac_tb/DUT/rst
add wave -noupdate /compute_mac_tb/DUT/i_signal_complex
add wave -noupdate /compute_mac_tb/DUT/i_coef_real
add wave -noupdate /compute_mac_tb/DUT/i_adder_complex
add wave -noupdate /compute_mac_tb/DUT/o_res_complex
add wave -noupdate /compute_mac_tb/DUT/signal_real
add wave -noupdate /compute_mac_tb/DUT/signal_imag
add wave -noupdate /compute_mac_tb/DUT/mul_res_real
add wave -noupdate /compute_mac_tb/DUT/mul_res_imag
add wave -noupdate /compute_mac_tb/DUT/adder_real_0
add wave -noupdate /compute_mac_tb/DUT/adder_real_1
add wave -noupdate /compute_mac_tb/DUT/adder_imag_0
add wave -noupdate /compute_mac_tb/DUT/adder_imag_1
add wave -noupdate /compute_mac_tb/DUT/mac_res_real
add wave -noupdate /compute_mac_tb/DUT/mac_res_imag
add wave -noupdate /compute_mac_tb/DUT/round_res_real
add wave -noupdate /compute_mac_tb/DUT/round_res_imag
add wave -noupdate /compute_mac_tb/DUT/pre_round_real
add wave -noupdate /compute_mac_tb/DUT/pre_round_imag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16672 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
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
WaveRestoreZoom {0 ps} {72649 ps}
