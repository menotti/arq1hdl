set inputFileName "teste.asm"
set inputFile [open $inputFileName] 
set file_data [read $inputFile]


# define opcode of instruction
proc define_opcode { opcode } {
	switch $opcode {
		"add" 	  { return "000000" } #r-type
		"addu" 	  { return "000000" } #r-type
		"div" 	  { return "000000" } #r-type - 2 register
		"divu" 	  { return "000000" } #r-type - 2 register
		"mult" 	  { return "000000" } #r-type - 2 register
		"multu"   { return "000000" } #r-type - 2 register
		"sub" 	  { return "000000" } #r-type
		"subu" 	  { return "000000" } #r-type

		"and" 	  { return "000000" } #r-type
		"or" 	  { return "000000" } #r-type
		"xor" 	  { return "000000" } #r-type
		"slt" 	  { return "000000" } #r-type
		"sltu" 	  { return "000000" } #r-type

		"sll" 	  { return "000000" } #r-type - 2 register - h
		"sllv" 	  { return "000000" } #r-type
		"sra" 	  { return "000000" } #r-type - 2 register - h
		"srl" 	  { return "000000" } #r-type - 2 register - h
		"srlv" 	  { return "000000" } #r-type
		"noop" 	  { return "000000" } #r-type - 00000000

		"mfhi" 	  { return "000000" } #r-type - 1 register - ddddd
		"mflo" 	  { return "000000" } #r-type - 1 register - ddddd

		"jr" 	  { return "000000" } #r-type - 1 register - sssss

		"syscall" { return "000000" } #r-type - $v0, $a0
		

		"addi" 	  { return "001000" } #i-type
		"andi" 	  { return "001100" } #i-type
		"addiu"   { return "001001" } #i-type
		"lui" 	  { return "001111" } #i-type - lui
		"ori" 	  { return "001101" } #i-type
		"slti" 	  { return "001010" } #i-type
		"sltiu"   { return "001011" } #i-type
		"xori" 	  { return "001110" } #i-type

		"beq" 	  { return "000100" } #i-type
		"bgez" 	  { return "000001" } #i-type - zero
		"bgezal"  { return "000001" } #i-type - zero
		"bgtz" 	  { return "000111" } #i-type - zero
		"blez" 	  { return "000110" } #i-type - zero
		"bltz" 	  { return "000001" } #i-type - zero
		"bltzal"  { return "000001" } #i-type - zero
		"bne" 	  { return "000101" } #i-type

		"lb" 	  { return "100000" } #i-type
		"sb" 	  { return "101000" } #i-type
		"lw" 	  { return "100011" } #i-type
		"sw" 	  { return "101011" } #i-type
		
		
		"j" 	  { return "000010" } #j-type
		"jal" 	  { return "000011" } #j-type
		
		default   { puts "ERROR! Incorrect instruction." }
	}
}

# define type of instruction
# r-type
# i-type
# j-type
proc define_type { opcode } {
	#r-type
	if { $opcode=="add" || $opcode=="addu" || $opcode=="sub" || $opcode=="subu" || $opcode=="and"  || $opcode=="or" || $opcode=="xor" || $opcode=="slt" || $opcode=="sltu" || $opcode=="sllv" || $opcode=="srlv" } { 
		return 0 
	} elseif { $opcode=="div" || $opcode=="divu" || $opcode=="mult" || $opcode=="multu" } { 
		return 1 
	} elseif { $opcode=="sll" || $opcode=="sra"  || $opcode=="srl"} { 
		return 2 
	} elseif { $opcode=="mfhi" || $opcode=="mflo" } { 
		return 3 
	} elseif { $opcode=="jr" } { 
		return 4 
	} elseif { $opcode=="noop" } { 
		return 5 
	} elseif { $opcode=="syscall" } { 
		return 6 
	} elseif { $opcode=="addi" || $opcode=="addiu" || $opcode=="andi" || $opcode=="ori" || $opcode=="slti" || $opcode=="sltiu" || $opcode=="lw" || $opcode=="sw" || $opcode=="lb" || $opcode=="sb" } { 
		return 7 
	} elseif { $opcode=="bgez" || $opcode=="bgezal" || $opcode=="bgtz" || $opcode=="blez" || $opcode=="bltz" || $opcode=="bltzal" } { 
		return 8 
	} elseif { $opcode=="lui" } { 
		return 9 
	} else { 
		return 10 
	}
}

proc r_type { word } {
	set register [split $word ","]
	set rd [ define_register [lindex $register 0]]
	set rs [ define_register [lindex $register 1]]
	set rt [ define_register [lindex $register 2]]
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc r_type_tworegister { word } {
	set register [split $word ","]
	set rd "00000"
	set rs [ define_register [ lindex $register 0]]
	set rt [ define_register [ lindex $register 0]]
	set shamt "00000"
	return "$rs$rt$rd$shamt"
}

proc construct_instruction { type word } {
	if { $type==0 } { 
		return [r_type $word] 
	} elseif { $type==1 } { 
		return [r_type_tworegister $word] 
	} else { 
		return 0 
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
		
		"or" 	  { return "100101" }
		
		"xor" 	  { return "100110" }
		
		"slt" 	  { return "101010" }
		
		"sltu" 	  { return "101011" }
		
		"sll" 	  { return "000000" }
		
		"sllv" 	  { return "000100" }
		
		"sra" 	  { return "000011" }
		
		"srl" 	  { return "000010" }
		
		"srlv" 	  { return "000110" }
		#"noop" 	  { return "000000" }
		"mfhi" 	  { return "010000" }
		
		"mflo" 	  { return "010010" }
		
		"jr" 	  { return "001000" }
		
		"syscall" { return "001100" }
	}
}


# dividir o arquvio em linhas, e tratar cada linha separadamente, assim criar o codigo das instruções
set data [split $file_data "\n"]

set line [lindex $data 0]
set instruction [split $line " "]
set opcode 	[lindex $instruction 0]
set word 	[lindex $instruction 1]

set code [define_opcode $opcode]

set type [define_type $opcode]

set construc [construct_instruction $type $word]

set funct [define_funct $opcode]

puts "$code$construc$funct"

	#puts [define_opcode $opcode]
	#puts [lindex $register 0]
	#puts [define_register [lindex $register 0]]
	#puts [lindex $register 1]
	#puts [define_register [lindex $register 1]]
	#puts [lindex $register 2]
	#puts [define_register [lindex $register 2]]
	
	#set opcode [split $instruction " "]
	#set resto [split $instruction ","]
	#puts [define_opcode [lindex $opcode 0]]
	#puts [define_reg [lindex $resto 1]]
	#puts [define_reg [lindex $resto 2]]

if 0 {
proc generateBuildInstruction_MIF {} {
	# Open file 
	set inputFileName "teste.txt"
	set outputFileName "instruction.mif"
	
	set inputFile [open $inputFileName] 
	set file_data [read $inputFile]
	set outputFile [open $outputFileName "w"]

	puts $outputFile "-- Copyright (C) 1991-2013 Altera Corporation"
	puts $outputFile "-- Your use of Altera Corporation's design tools, logic functions" 
	puts $outputFile "-- and other software and tools, and its AMPP partner logic" 
	puts $outputFile "-- functions, and any output files from any of the foregoing" 
	puts $outputFile "-- (including device programming or simulation files), and any" 
	puts $outputFile "-- associated documentation or information are expressly subject" 
	puts $outputFile "-- to the terms and conditions of the Altera Program License" 
	puts $outputFile "-- Subscription Agreement, Altera MegaCore Function License" 
	puts $outputFile "-- Agreement, or other applicable license agreement, including," 
	puts $outputFile "-- without limitation, that your use is for the sole purpose of" 
	puts $outputFile "-- programming logic devices manufactured by Altera and sold by" 
	puts $outputFile "-- Altera or its authorized distributors.  Please refer to the" 
	puts $outputFile "-- applicable agreement for further details."
	puts $outputFile ""	
	puts $outputFile "-- Quartus II generated Memory Initialization File (.mif)"
	
	set maxDEPTH 256
	
	puts $outputFile ""	
	puts $outputFile "WIDTH=32;"
	puts $outputFile "DEPTH=$maxDEPTH;"
	puts $outputFile ""
	puts $outputFile "ADDRESS_RADIX=UNS;"
	puts $outputFile "DATA_RADIX=HEX;"
	puts $outputFile ""
	puts $outputFile "CONTENT BEGIN"
}
}