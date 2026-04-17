onerror {resume}
radix define Q0_15 -fixed -fraction 15 -signed -base decimal
quietly WaveActivateNextPane {} 0
add wave -noupdate /seq_filter_top/clk
add wave -noupdate /seq_filter_top/rst
add wave -noupdate /seq_filter_top/s_axis_dl_tdata
add wave -noupdate /seq_filter_top/s_axis_dl_tvalid
add wave -noupdate /seq_filter_top/s_axis_dl_tready
add wave -noupdate /seq_filter_top/wren
add wave -noupdate /seq_filter_top/w_coef_data
add wave -noupdate /seq_filter_top/w_coef_addr
add wave -noupdate /seq_filter_top/filter_depth
add wave -noupdate /seq_filter_top/m_axis_mac_tdata
add wave -noupdate /seq_filter_top/m_axis_mac_tvalid
add wave -noupdate /seq_filter_top/m_axis_mac_tready
add wave -noupdate /seq_filter_top/dl_ena
add wave -noupdate /seq_filter_top/dl_r_addr
add wave -noupdate /seq_filter_top/dl_signal
add wave -noupdate /seq_filter_top/r_coef_addr
add wave -noupdate /seq_filter_top/r_coef_data
add wave -noupdate /seq_filter_top/res_valid
add wave -noupdate /seq_filter_top/mac_clr
add wave -noupdate -divider {Ring Buffer}
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/s_axis_tdata
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/s_axis_tvalid
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/s_axis_tready
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/ena
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/push
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/push_reg
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/w_ptr
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/i_data_reg
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/r_addr
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/r_addr_reg
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/o_data_reg
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/out_data
add wave -noupdate /seq_filter_top/genblk1/sync_dl_inst/r_ptr
add wave -noupdate -divider FSM
add wave -noupdate /seq_filter_top/fsm_inst/i_c_depth
add wave -noupdate /seq_filter_top/fsm_inst/i_fifo_valid
add wave -noupdate /seq_filter_top/fsm_inst/o_dl_ena
add wave -noupdate /seq_filter_top/fsm_inst/o_dl_addr
add wave -noupdate /seq_filter_top/fsm_inst/o_cmem_addr
add wave -noupdate /seq_filter_top/fsm_inst/i_res_fifo_ready
add wave -noupdate /seq_filter_top/fsm_inst/o_res_valid
add wave -noupdate /seq_filter_top/fsm_inst/o_mac_clr
add wave -noupdate /seq_filter_top/fsm_inst/state
add wave -noupdate /seq_filter_top/fsm_inst/next_state
add wave -noupdate /seq_filter_top/fsm_inst/cnt
add wave -noupdate /seq_filter_top/fsm_inst/cnt_max
add wave -noupdate /seq_filter_top/fsm_inst/cmp_res
add wave -noupdate -divider {Real MAC}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_signal}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_coef}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/o_res}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_mac_clr}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_signal_reg_0}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_signal_reg_1}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_coef_reg_0}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/i_coef_reg_1}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/mul_res}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/acc_res}
add wave -noupdate -radix decimal {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/round_res}
add wave -noupdate -radix decimal {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/round_res_1}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/pos_overflow}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[0]/mac_inst/neg_overflow}
add wave -noupdate -divider {Imag MAC}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_signal}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_coef}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/o_res}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_mac_clr}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_signal_reg_0}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_signal_reg_1}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_coef_reg_0}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/i_coef_reg_1}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/mul_res}
add wave -noupdate -radix Q0_15 {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/acc_res}
add wave -noupdate -radix decimal {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/round_res}
add wave -noupdate -radix decimal {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/round_res_1}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/pos_overflow}
add wave -noupdate {/seq_filter_top/genblk2/mac_inst/genblk1[1]/mac_inst/neg_overflow}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199413 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 416
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
configure wave -timelineunits ns
update
WaveRestoreZoom {173240 ps} {378850 ps}
