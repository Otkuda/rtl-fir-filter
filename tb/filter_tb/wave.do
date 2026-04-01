onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /filter_tb/DUT/clk
add wave -noupdate /filter_tb/DUT/rst
add wave -noupdate /filter_tb/DUT/s_axis_dl_tdata
add wave -noupdate /filter_tb/DUT/s_axis_dl_tvalid
add wave -noupdate /filter_tb/DUT/s_axis_dl_tready
add wave -noupdate /filter_tb/DUT/wren
add wave -noupdate /filter_tb/DUT/w_coef_data
add wave -noupdate /filter_tb/DUT/w_coef_addr
add wave -noupdate /filter_tb/DUT/filter_depth
add wave -noupdate /filter_tb/DUT/m_axis_mac_tdata
add wave -noupdate /filter_tb/DUT/m_axis_mac_tvalid
add wave -noupdate /filter_tb/DUT/m_axis_mac_tready
add wave -noupdate /filter_tb/DUT/dl_ena
add wave -noupdate /filter_tb/DUT/dl_r_addr
add wave -noupdate /filter_tb/DUT/dl_signal
add wave -noupdate /filter_tb/DUT/r_coef_addr
add wave -noupdate /filter_tb/DUT/r_coef_data
add wave -noupdate /filter_tb/DUT/res_valid
add wave -noupdate -divider {Real MAC}
add wave -noupdate -radix decimal {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/i_signal}
add wave -noupdate {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/i_coef}
add wave -noupdate -radix decimal {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/mul_res}
add wave -noupdate -radix decimal {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/round_res}
add wave -noupdate -radix decimal {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/mac_res}
add wave -noupdate {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/i_res_valid}
add wave -noupdate -radix decimal {/filter_tb/DUT/mac_inst/genblk1[0]/mac_inst/o_res}
add wave -noupdate -divider FSM
add wave -noupdate /filter_tb/DUT/fsm_inst/cnt
add wave -noupdate /filter_tb/DUT/fsm_inst/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {175000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 312
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
WaveRestoreZoom {129249 ps} {261019 ps}
