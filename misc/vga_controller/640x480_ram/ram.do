onerror {resume}
vlib work
vmap work work
vcom *.vhd
vsim work.t_ram
quietly WaveActivateNextPane {} 0
add wave -noupdate /t_ram/clk
add wave -noupdate /t_ram/addr_a
add wave -noupdate /t_ram/addr_b
add wave -noupdate -radix hexadecimal /t_ram/data_a
add wave -noupdate -radix hexadecimal /t_ram/data_b
add wave -noupdate /t_ram/we_a
add wave -noupdate /t_ram/we_b
add wave -noupdate -radix hexadecimal /t_ram/q_a
add wave -noupdate -radix hexadecimal /t_ram/q_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85386 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
run 500 ns
update
WaveRestoreZoom {0 ps} {525 ns}
