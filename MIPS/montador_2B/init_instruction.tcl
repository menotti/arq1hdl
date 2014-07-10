proc define_opcode { opcode } {
	switch $opcode {
		"add" 	  { return "000000" } 
		
		"addu" 	  { return "000000" } 
		
		"div" 	  { return "000000" } 
		
		"divu" 	  { return "000000" } 
		
		"mult" 	  { return "000000" } 
		
		"multu"   { return "000000" } 
		
		"sub" 	  { return "000000" } 
		
		"subu" 	  { return "000000" } 
		
		"and" 	  { return "000000" } 
		
		"nand"	  { return "000000" }
		
		"or" 	  { return "000000" } 
		
		"xor" 	  { return "000000" } 
		
		"slt" 	  { return "000000" }
		
		"sltu" 	  { return "000000" }
		
		"sll" 	  { return "000000" } 
		
		"sllv" 	  { return "000000" } 
		
		"sra" 	  { return "000000" } 
		
		"srl" 	  { return "000000" } 
		
		"srlv" 	  { return "000000" } 
		
		"noop" 	  { return "000000" } 
		
		"mfhi" 	  { return "000000" } 
		
		"mflo" 	  { return "000000" } 
		
		"jr" 	  { return "000000" } 
		
		"syscall" { return "000000" } 
		
		"addi" 	  { return "001000" } 
		
		"andi" 	  { return "001100" } 
		
		"addiu"   { return "001001" } 
		
		"lui" 	  { return "001111" } 
		
		"ori" 	  { return "001101" } 
		
		"slti" 	  { return "001010" } 
		
		"sltiu"   { return "001011" } 
		
		"xori" 	  { return "001110" } 
		
		"beq" 	  { return "000100" } 
		
		"bgez" 	  { return "000001" } 
		
		"bgezal"  { return "000001" } 
		
		"bgtz" 	  { return "000111" } 
		
		"blez" 	  { return "000110" } 
		
		"bltz" 	  { return "000001" } 
		
		"bltzal"  { return "000001" } 
		
		"bne" 	  { return "000101" } 
		
		"lb" 	  { return "100000" } 
		
		"sb" 	  { return "101000" } 
		
		"lw" 	  { return "100011" } 
		
		"sw" 	  { return "101011" } 
		
		"j" 	  { return "000010" } 
		
		"jal" 	  { return "000011" } 
		
		default   { puts "ERROR! Incorrect instruction." }
	}
}

proc define_funct { opcode } {
	switch $opcode {
		"add" 	  { return "100000" }
		
		"addu" 	  { return "100001" }
		
		"div" 	  { return "011010" }
		
		"divu" 	  { return "011011" }
		
		"mult" 	  { return "011000" }
		
		"multu"   { return "011001" }
		
		"sub" 	  { return "100010" }
		
		"subu" 	  { return "100011" }
		
		"and" 	  { return "100100" }
		
		"nand"    { return "101101" }
		
		"or" 	  { return "100101" }
		
		"xor" 	  { return "100110" }
		
		"slt" 	  { return "101010" }
		
		"sltu" 	  { return "101011" }
		
		"sll" 	  { return "000000" }
		
		"sllv" 	  { return "000100" }
		
		"sra" 	  { return "000011" }
		
		"srl" 	  { return "000010" }
		
		"srlv" 	  { return "000110" }
		
		"noop" 	  { return "000000" }
		
		"mfhi" 	  { return "010000" }
		
		"mflo" 	  { return "010010" }
		
		"jr" 	  { return "001000" }
		
		"syscall" { return "001100" }
	}
}

# define register of instruction
# $zero : 0			constant values 0 
# $v0-$v1 : 2-3 	values to results and expression evaluations
# $a0-$a3 : 4-7		Arguments
# $t0-$t7 : 8-15	Temporaries 
# $s0-$s7 : 16-23	Saved
# $t8-$t9 : 24-25	More temporaries
# 28-29-30          Pointers
# $ra     : 31		return address
proc define_register { register } {
	switch $register {
		"$zero" { return "00000" }
		"$0" 	{ return "00000" }
		
		"$v0" 	{ return "00010" }
		"$2" 	{ return "00010" }
		
		"$v1" 	{ return "00011" }
		"$3" 	{ return "00011" }
		
		"$a0" 	{ return "00100" }
		"$4" 	{ return "00100" }
		
		"$a1" 	{ return "00101" }
		"$5" 	{ return "00101" }
		
		"$a2" 	{ return "00110" }
		"$6" 	{ return "00110" }
		
		"$a3"  	{ return "00111" }
		"$7" 	{ return "00111" }
		
		"$t0" 	{ return "01000" }
		"$8" 	{ return "01000" }
		
		"$t1" 	{ return "01001" }		
		"$9" 	{ return "01001" }
		
		"$t2" 	{ return "01010" }
		"$10" 	{ return "01010" }
		
		"$t3" 	{ return "01011" }
		"$11" 	{ return "01011" }
		
		"$t4" 	{ return "01100" }
		"$12" 	{ return "01100" }
		
		"$t5" 	{ return "01101" }
		"$13" 	{ return "01101" }
			
		"$t6" 	{ return "01110" }
		"$14" 	{ return "01110" }
		
		"$t7" 	{ return "01111" }
		"$15" 	{ return "01111" }
			
		"$s0" 	{ return "10000" }
		"$16" 	{ return "10000" }
		
		"$s1" 	{ return "10001" }
		"$17" 	{ return "10001" }

		"$s2" 	{ return "10010" }
		"$18" 	{ return "10010" }
		
		"$s3" 	{ return "10011" }
		"$19" 	{ return "10011" }
		
		"$s4" 	{ return "10100" }
		"$20" 	{ return "10100" }
		
		"$s5" 	{ return "10101" }
		"$21" 	{ return "10101" }
		
		"$s6" 	{ return "10110" }
		"$22" 	{ return "10110" }
		
		"$s7" 	{ return "10111" }
		"$23" 	{ return "10111" }
		
		"$t8" 	{ return "11000" }
		"$24" 	{ return "11000" }
		
		"$t9" 	{ return "11001" }
		"$25" 	{ return "11001" }
		
		"$ra" 	{ return "11111" }
		"$31" 	{ return "11111" }
		
		default { puts "ERROR! Incorrect register." }
	}
}

proc define_branch_funct { opcode } {
	switch $opcode { 
		"bgez"   { return "00001" }
		
		"bgezal" { return "10001" }
		
		"bltzal" { return "10000" }
		
		default  { return "00000" }
	}
}

proc int_to_binary { shamt } {
	binary scan [binary format c $shamt] B* bin 
	return [string range $bin end-4 end]
}

proc imm_to_binary { imm } { 
    binary scan [binary format W $imm] B* bin 
    string range $bin end-15 end
}

proc imm_to_binary_data { imm } { 
    binary scan [binary format W $imm] B* bin 
    string range $bin end-25 end
}


proc r_type { word } {
	set register [split $word ","]
	set rd [define_register [lindex $register 0]]
	set rs [define_register [lindex $register 1]]
	set rt [define_register [lindex $register 2]]
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc r_type_tworegister { word } {
	set register [split $word ","]
	set rd "00000"
	set rs [define_register [lindex $register 0]]
	set rt [define_register [lindex $register 1]]
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc r_type_shamt { word } {
	set register [split $word ","]
	set rd [define_register [lindex $register 0]]
	set rs "00000"
	set rt [define_register [lindex $register 1]]
	set shamt [int_to_binary [lindex $register 2]]
	return "$rs$rt$rd$shamt"
}

proc type_move { word } {
	set rd [define_register $word]
	set rs "00000"
	set rt "00000"
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc type_jr { word } {
	set rd "00000"
	set rs [define_register $word]
	set rt "00000"
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc type_noop {} {
	set rd "00000"
	set rs "00000"
	set rt "00000"
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc type_syscall {} {
	set rd "00000"
	set rs "00010"
	set rt "00100"
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc i_type { word } {
	set register [split $word ","]
	set rs [define_register [lindex $register 0]]
	set rt [define_register [lindex $register 1]]
	set imm [imm_to_binary [lindex $register 2]]
	return "$rs$rt$imm"
}

proc i_type_branch_zero { opcode word } {
	set register [split $word ","]
	set rs [define_register [lindex $register 0]]
	set rt [define_branch_funct $opcode]
	set imm [imm_to_binary [lindex $register 1]]
	return "$rs$rt$imm"
}

proc i_type_lui { word } {
	set register [split $word ","]
	set rs "00000"
	set rt [define_register [lindex $register 0]]
	set imm [imm_to_binary [lindex $register 1]]
	return "$rs$rt$imm"
}

proc j_type { word } { 
	return [imm_to_binary_data $word]
}

proc construct_instruction { opcode word } {
	if { $opcode=="add" || $opcode=="addu" || $opcode=="sub" || $opcode=="subu" || $opcode=="and"  || $opcode=="or" || $opcode=="xor" || $opcode=="slt" || $opcode=="sltu" || $opcode=="sllv" || $opcode=="srlv" || $opcode=="nand"} { 
		set construct [r_type $word]
		set funct [define_funct $opcode]
		return "$construct$funct"
	} elseif { $opcode=="div" || $opcode=="divu" || $opcode=="mult" || $opcode=="multu" } { 
		set construct [r_type_tworegister $word]
		set funct [define_funct $opcode]
		return "$construct$funct"
	} elseif { $opcode=="sll" || $opcode=="sra"  || $opcode=="srl"} { 
		set construct [r_type_shamt $word]
		set funct [define_funct $opcode]
		return "$construct$funct"
	} elseif { $opcode=="mfhi" || $opcode=="mflo" } { 
		set construct [type_move $word]
		set funct [define_funct $opcode]
		return "$construct$funct"
	} elseif { $opcode=="jr" } { 
		set construct [type_jr $word]
		set funct [define_funct $opcode]
		return "$construct$funct"
	} elseif { $opcode=="noop" } { 
		set construct [type_noop $word]
		set funct [define_funct $opcode]
		return "$construct$funct"
	} elseif { $opcode=="syscall" } { 
		set construct [type_syscall $word]
		set funct [define_funct $opcode]
		return "$construct$funct" 
	} elseif { $opcode=="addi" || $opcode=="addiu" || $opcode=="andi" || $opcode=="ori" || $opcode=="slti" || $opcode=="sltiu" || $opcode=="lw" || $opcode=="sw" || $opcode=="lb" || $opcode=="sb" } { 
		return [i_type $word]
	} elseif { $opcode=="bgez" || $opcode=="bgezal" || $opcode=="bgtz" || $opcode=="blez" || $opcode=="bltz" || $opcode=="bltzal" } { 
		return [i_type_branch_zero $opcode $word]
	} elseif { $opcode=="lui" } { 
		return [i_type_lui $word]
	} elseif { $opcode=="j" || $opcode=="jal" } {
		return [j_type $word]
	}
}

proc instruction_complete { line } {
	set instruction [split $line " "]
	set opcode 	[lindex $instruction 0]
	set word 	[lindex $instruction 1]

	set code [define_opcode $opcode]
	set construct [construct_instruction $opcode $word]
	
	return "$code$construct"
}

proc generateBuildInstruction_MIF {} {
	set inputFileName "file.asm"
	set input_file [open $inputFileName] 
	
	set outputFileName "instruction_memory.mif"
	set output_file [open $outputFileName "w"]
	
	puts $output_file "-- Copyright (C) 1991-2013 Altera Corporation"
	puts $output_file "-- Your use of Altera Corporation's design tools, logic functions" 
	puts $output_file "-- and other software and tools, and its AMPP partner logic" 
	puts $output_file "-- functions, and any output files from any of the foregoing" 
	puts $output_file "-- (including device programming or simulation files), and any" 
	puts $output_file "-- associated documentation or information are expressly subject" 
	puts $output_file "-- to the terms and conditions of the Altera Program License" 
	puts $output_file "-- Subscription Agreement, Altera MegaCore Function License" 
	puts $output_file "-- Agreement, or other applicable license agreement, including," 
	puts $output_file "-- without limitation, that your use is for the sole purpose of" 
	puts $output_file "-- programming logic devices manufactured by Altera and sold by" 
	puts $output_file "-- Altera or its authorized distributors.  Please refer to the" 
	puts $output_file "-- applicable agreement for further details."
	puts $output_file ""	
	puts $output_file "-- Quartus II generated Memory Initialization File (.mif)"
	
	set maxDEPTH 256
	set DEPTH 255
	
	puts $output_file ""	
	puts $output_file "WIDTH=32;"
	puts $output_file "DEPTH=$maxDEPTH;"
	puts $output_file ""
	puts $output_file "ADDRESS_RADIX=UNS;"
	puts $output_file "DATA_RADIX=BIN;"
	puts $output_file ""
	puts $output_file "CONTENT BEGIN"
	
	set i 0
	while { [gets $input_file line] >= 0 } {
		if { [string index $line 0]=="#" } {
		} else {
			set instruction [instruction_complete $line]
			puts $output_file "	 $i    :  $instruction;"
			incr i 1
		}
	}

	if { $i-1 != $maxDEPTH } { puts $output_file "  \[$i..$DEPTH\]    :  00000000000000000000000000000000;" }


	puts $output_file "END;"

	close $output_file
}

generateBuildInstruction_MIF