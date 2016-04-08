onbreak {resume}
puts {
ModelSim general compile/simulation script version 0.1
Copyright (c) Ricardo Menotti, 2014
}

# configure o nome do test bench aqui:
set top_level talu

proc qs {} {quit -sim}

vlib work
vmap work work
vlog -work work *.v

vsim work.$top_level
add wave -radix unsigned sim:/$top_level/*

configure wave -shortnames 1

run -all

# use o comando resume no prompt para o modelsim continuar apos um $finish 
wave zoom full
