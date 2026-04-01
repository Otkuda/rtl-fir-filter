set part_name "xc7a35tcsg325-1"

read_verilog -sv ../rtl/compute_mac.sv
read_verilog -sv ../rtl/complex_mac.sv
synth_design -top complex_mac -part $part_name
write_checkpoint -force ./netlists/synth_complex_mac.dcp

report_utilization -file util_report.txt

exit