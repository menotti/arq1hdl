puts {
ModelSim general compile/simulation script version 0.1
Copyright (c) Ricardo Menotti, 2014
}

# configure o nome do test bench aqui:
set top_level t_example3

proc qs {} {quit -sim}

vlib work
vmap work work
vcom -work work *.vhd

vsim work.$top_level
add wave sim:/$top_level/*

configure wave -shortnames 1

run -all

wave zoom full
