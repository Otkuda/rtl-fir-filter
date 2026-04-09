vlib work
vlog ./compute_mac_tb.sv
vlog ../../rtl/opt_compute_mac.sv

vsim -novopt work.compute_mac_tb
do wave.do
run -all