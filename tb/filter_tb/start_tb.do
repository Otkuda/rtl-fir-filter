vlib work

vlog ./*.sv
vlog ../../rtl/*.sv

vsim work.filter_tb -novopt

do ./wave.do
run -all