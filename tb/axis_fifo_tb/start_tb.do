vlib work
vlog ./axis_fifo_tb.sv
vlog ../../rtl/axis_fifo.sv
vsim -novopt work.axis_fifo_tb

do ./wave.do
run -all
