set design processor
set testbench t_$design

onerror {abort}

vlib work
vmap work work

vcom -work work *.vhd

vsim work.$testbench
add wave -radix hexadecimal sim:/$testbench/dut/*

run 1 us
wave zoom full


