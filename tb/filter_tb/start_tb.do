vlib work

vlog ./filter_tb.sv
vlog ../../rtl/coef_mem.sv
vlog ../../rtl/sync_coef_mem.sv
vlog ../../rtl/control_fsm.sv
vlog ../../rtl/compute_mac.sv
vlog ../../rtl/complex_mac.sv
vlog ../../rtl/opt_compute_mac.sv
vlog ../../rtl/opt_complex_mac.sv
vlog ../../rtl/delay_line.sv
vlog ../../rtl/mem_ring_buffer.sv
vlog ../../rtl/seq_filter_top.sv

vsim work.filter_tb -novopt

do ./wave.do
run -all