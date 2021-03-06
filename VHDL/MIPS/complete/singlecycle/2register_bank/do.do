set design register_bank
set testbench t_$design

onerror {abort}

vlib work
vmap work work

vcom -work work ../$design.vhd
vcom -work work $testbench.vhd

vsim work.$testbench
add wave -radix hexadecimal sim:/$testbench/dut/*

run 1 us
wave zoom full


