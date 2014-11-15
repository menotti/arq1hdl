onerror abort

vlib work
vmap work work
vcom -work work *.vhd
vsim work.t_processor
add wave -radix hexadecimal /t_processor/the_processor/clock
add wave /t_processor/the_processor/state_machine/next_state

add wave -group fetch -radix hexadecimal /t_processor/the_processor/enable_program_counter
add wave -group fetch -radix hexadecimal /t_processor/the_processor/instruction_address
add wave -group fetch -radix hexadecimal /t_processor/the_processor/current_instruction
add wave -group fetch                    /t_processor/the_processor/state_machine/opcode
add wave -group fetch -radix hexadecimal /t_processor/the_processor/register1
add wave -group fetch -radix hexadecimal /t_processor/the_processor/register2
add wave -group fetch -radix hexadecimal /t_processor/the_processor/register3
add wave -group fetch -radix hexadecimal /t_processor/the_processor/offset
add wave -group fetch -radix hexadecimal /t_processor/the_processor/jump_offset

add wave -group decode -radix hexadecimal /t_processor/the_processor/alu_operation
add wave -group decode -radix hexadecimal /t_processor/the_processor/register_a
add wave -group decode -radix hexadecimal /t_processor/the_processor/register_b
add wave -group decode -radix hexadecimal /t_processor/the_processor/offset
add wave -group decode -radix hexadecimal /t_processor/the_processor/alu_operand1
add wave -group decode -radix hexadecimal /t_processor/the_processor/alu_operand2
add wave -group decode -radix hexadecimal /t_processor/the_processor/alu_result

add wave -group alu -radix hexadecimal /t_processor/the_processor/enable_alu_output_register
add wave -group alu -radix hexadecimal /t_processor/the_processor/source_alu
add wave -group alu -radix hexadecimal /t_processor/the_processor/data_from_alu_output_register

add wave -group mem -radix hexadecimal /t_processor/the_processor/read_memory
add wave -group mem -radix hexadecimal /t_processor/the_processor/write_memory
add wave -group mem -radix hexadecimal /t_processor/the_processor/write_register
add wave -group mem -radix hexadecimal /t_processor/the_processor/address_to_read
add wave -group mem -radix hexadecimal /t_processor/the_processor/address_to_write
add wave -group mem -radix hexadecimal /t_processor/the_processor/data_from_memory
add wave -group mem -radix hexadecimal /t_processor/the_processor/jump_control

add wave -group writeback -radix hexadecimal /t_processor/the_processor/write_register
add wave -group writeback -radix hexadecimal /t_processor/the_processor/mem_to_register
add wave -group writeback -radix hexadecimal /t_processor/the_processor/reg_dst
add wave -group writeback -radix hexadecimal /t_processor/the_processor/destination_register
add wave -group writeback -radix hexadecimal /t_processor/the_processor/data_to_write_in_register

configure wave -shortnames 1

run 500 ns

wave zoom full
