set fileInput [open "input.asm"]
set fileOutput [open "output.mif" "w"]

proc opConverter { word } {
	switch $word {
		"add" {
			set word "000000"
			return $word
		}
		"addi" {
			set word "001000"
			return $word
		}
		"addiu" {
			set word "001001"
			return $word
		}
		"andi" {
			set word "001100"
			return $word
		}
		"beq" {
			set word "000100"
			return $word
		}
		"bgez" {
			set word "000001"
			return $word
		}
		"bgezal" {
			set word "000001"
			return $word
		}
		"bgtz" {
			set word "000111"
			return $word
		}
		"blez" {
			set word "000110"
			return $word
		}
		"bltz" {
			set word "000001"
			return $word
		}
		"bltzal" {
			set word "000001"
			return $word
		}
		"bne" {
			set word "000101"
			return $word
		}
		"j" {
			set word "000010"
			return $word
		}
		"jal" {
			set word "000011"
			return $word
		}
		"jr" {
			set word "000000"
			return $word
		}
		"lb" {
			set word "100000"
			return $word
		}
		"lui" {
			set word "001111"
			return $word
		}
		"lw" {
			set word "100011"
			return $word
		}
		"mfhi" {
			set word "001000"
			return $word
		}
		"mflo" {
			set word "000000"
			return $word
		}
		"mult" {
			set word "000000"
			return $word
		}
		"multu" {
			set word "000000"
			return $word
		}
		"noop" {
			set word "000000"
			return $word
		}
		"ori" {
			set word "001101"
			return $word
		}
		"sb" {
			set word "101000"
			return $word
		}
		"sll" {
			set word "000000"
			return $word
		}
		"sllv" {
			set word "000000"
			return $word
		}
		"slti" {
			set word "001010"
			return $word
		}
		"sltiu" {
			set word "001011"
			return $word
		}
		"sra" {
			set word "000000"
			return $word
		}
		"srl" {
			set word "000000"
			return $word
		}
		"srlv" {
			set word "000000"
			return $word
		}
		"sw" {
			set word "101011"
			return $word
		}
		"syscall" {
			set word "000000"
			return $word
		}
		"xori" {
			set word "001110"
			return $word
		}
	} 
}

proc functConverter { word } {
	switch $word {
		"add" {
			set word "100000"
			return $word
		}
		"addu" {
			set word "100001"
			return $word
		}
		"and" {
			set word "100100"
			return $word
		}
		"or" {
			set word "100101"
			return $word
		}
		"sub" {
			set word "100010"
			return $word
		}
		"slt" {
			set word "101010"
			return $word
		}
		"subu" {
			set word "100011"
			return $word
		}
		"sltu" {
			set word "101011"
			return $word
		}
		"div" {
			set word "011010"
			return $word
		}
		"divu" {
			set word "011011"
			return $word
		}
		"mfhi" {
			set word "010000"
			return $word
		}
		"mflo" {
			set word "000101"
			return $word
		}
		"mult" {
			set word "011000"
			return $word
		}
		"multu" {
			set word "011001"
			return $word
		}
		"sllv" {
			set word "000100"
			return $word
		}
		"srlv" {
			set word "000110"
			return $word
		}
		"xor" {
			set word "100110"
			return $word
		}
		"sra" {
			set word "000011"
			return $word
		}
		"srl" {
			set word "000010"
			return $word
		}
		default
			puts "ERRO NA INSTRUCAO: $word"
			set word "ERRO NA INSTRUCAO"
			return $word
	} 
}

#converte registradores
proc registerConverter { word } {
	switch $word {
		"$zero" { return "00000" }
		"$v0" {	return "00010" }
		"$v1" { return "00011" }
		"$a0" { return "00100" }
		"$a1" { return "00101" }
		"$a2" { return "00110" }
		"$a3" { return "00111" }
		"$t0" { return "01000" }
		"$t1" { return "01001" }
		"$t2" { return "01010" }
		"$t3" { return "01011" }
		"$t4" { return "01100" }
		"$t5" { return "01101" }
		"$t6" { return "01110" }
		"$t7" { return "01111" }
		"$t8" { return "11000" }
		"$t8" { return "11000" }
		"$t9" { return "11001" }
		"$s0" { return "10000" }
		"$s1" { return "10001" }
		"$s2" { return "10010" }
		"$s3" { return "10011" }
		"$s4" { return "10100" }
		"$s5" { return "10101" }
		"$s6" { return "10110" }
		"$k0" { return "11010" }
		"$k1" { return "11011" }
		"$gp" { return "11100" }
		"$sp" { return "11101" }
		"$fp" { return "11110" }
		"$ra" { return "11111" }
		"$0"  { return "00000" }
        "$2"  { return "00010" }
        "$3"  { return "00011" }
        "$4"  { return "00100" }
        "$5"  {	return "00101" }
        "$6"  { return "00110" }
        "$7"  {	return "00111" }
        "$8"  { return "01000" }              
        "$9"  { return "01001" }
        "$10" { return "01010" }
        "$11" { return "01011" }
        "$12" { return "01100" }
        "$13" { return "01101" }
        "$14" { return "01110" }
        "$15" { return "01111" }
        "$16" { return "10000" }
        "$17" { return "10001" }
        "$18" { return "10010" }
        "$19" { return "10011" }
        "$20" { return "10100" }
        "$21" { return "10101" }
        "$22" { return "10110" }
        "$23" { return "10111" }
        "$24" { return "11000" }
        "$25" { return "11001" }
        "$31" { return "11111" }
		default {
			puts "Erro no código, nenhum registrador encontrado, resgistrador no arquivo de saida"
			return $word
		}
	}
}

proc increaseIndex { line i } {
	while { [string index $line $i] != " "} {
		incr i 1
	}
	incr i 1
	return $i
}

proc getWord { line i } {
	set word ""
	while { [string index $line $i] != " "} {
		if { [string index $line $i] == "," } {
			incr i 1
		} else {
			append word [string index $line $i]
			incr i 1
		}
	}
	return $word
}

#define o tipo da instrução
proc instructionType { word } {
	if { $word == "add" || $word == "addu" || $word == "and" || 
		 $word == "or" || $word == "sub" || $word == "xor" || 
		 $word == "slt" || $word == "subu" || $word == "sltu" || 
		 $word == "div" || $word == "divu" || $word == "mfhi" || 
		 $word == "mfhi"|| $word == "mflo" || $word == "mult" || 
		 $word == "multu" || $word == "sllv" || $word == "srlv" } {
		 	return 1
	}
	if { $word == "lw" || $word == "sw" || $word == "lb" || 
		 $word == "lbu" || $word == "sw" || $word == "lui" || $word == "sb" } {
		return 2
	}
	if { $word == "andi" || $word == "addiu" || $word == "sll" ||
	     $word == "addi" || $word == "ori" || $word == "xori" || 
	     $word == "slti" || $word == "sltiu" || $word == "sra" || $word == "srl" } {
	     	return 3
	}
	if { $word == "beq" || $word == "bne" || $word == "bgez" || 
		 $word == "bgezal" || $word == "bltzal" || $word == "bgtz" ||
		 $word == "blez" || $word == "bltz" } {
		 	return 4
	}
	if { $word == "j" || $word == "jal" || $word == "jr" } {
        return 5
	}
	if { $word == "syscall" || $word == "noop" } {
        return 6
	}
	if { $word == "move" } {
		return 7
	}
	return 0;
}

#transforma decimal para binario
proc decimalBinary { word } { 
    binary scan [binary format c $word] B* bin 
    string range $bin end-4 end
}

proc immBinary { word } { 
    binary scan [binary format W $word] b* bin 
    string range $bin end-15 end
}

set word ""
set instruction ""
set opType 0
set i 0

#partes das instruções
set op ""
set rs ""
set rt ""
set rd ""
set shamt ""
set imm ""
set funct ""

#cabeçalho do arquivo de saida
puts $fileOutput "-- Copyright (C) 1991-2013 Altera Corporation"
puts $fileOutput "-- Your use of Altera Corporation's design tools, logic functions" 
puts $fileOutput "-- and other software and tools, and its AMPP partner logic" 
puts $fileOutput "-- functions, and any output files from any of the foregoing" 
puts $fileOutput "-- (including device programming or simulation files), and any" 
puts $fileOutput "-- associated documentation or information are expressly subject" 
puts $fileOutput "-- to the terms and conditions of the Altera Program License" 
puts $fileOutput "-- Subscription Agreement, Altera MegaCore Function License" 
puts $fileOutput "-- Agreement, or other applicable license agreement, including," 
puts $fileOutput "-- without limitation, that your use is for the sole purpose of" 
puts $fileOutput "-- programming logic devices manufactured by Altera and sold by" 
puts $fileOutput "-- Altera or its authorized distributors.  Please refer to the" 
puts $fileOutput "-- applicable agreement for further details."
puts $fileOutput ""     
puts $fileOutput "-- Quartus II generated Memory Initialization File (.mif)"
puts $fileOutput "WIDTH=32;"
puts $fileOutput "DEPTH=256;"
puts $fileOutput ""
puts $fileOutput "ADDRESS_RADIX=DEC;"
puts $fileOutput "DATA_RADIX=BIN;"
puts $fileOutput ""
puts $fileOutput "CONTENT BEGIN"

#loop olha palavra por palavra onde o limite é o tamanho da string
while { [gets $fileInput line] >= 0 } { 
	set i 0
	#ignora comentários
	if { [string index $line 0] == "#"} {
	} else {
		#pega palavra
		set word [getWord $line $i]
		set i [increaseIndex $line $i]
		set opType [instructionType $word]
		set funct $word

		#se for r-type
		if { $opType == 1 } {
			set op [opConverter $word]
			if { $word == "mfhi" || $word == "mflo" } {
				set rs 00000
				set rt 00000
			} else {
				set word [getWord $line $i]
				set i [increaseIndex $line $i]
				set rs [registerConverter $word]
				set word [getWord $line $i]
				set i [increaseIndex $line $i]
				set rt [registerConverter $word]
			}
			set shamt 00000
			set funct [opConverter $funct]
			#a partir daqui une todas as partes em uma unica string para colocar no arquivo de saida
			if { $funct == "011010" || $funct == "011011" || $funct == "011000" || $funct == "011001" } {
				append instruction $op
				append instruction $rt
				append instruction $rs
				append instruction "00000"
				append instruction $shamt
				append instruction $funct
			} elseif { $funct == "000100" || $funct == "000110"} {
				append instruction $op
				append instruction $rt
				append instruction $rs
				append instruction $rd
				append instruction $shamt
				append instruction $funct
			} else {
				append instruction $op
				append instruction $rs
				append instruction $rt
				append instruction $rd
				append instruction $shamt
				append instruction $funct
			}
			puts $fileOutput $instruction
			set instruction ""
		} elseif { $opType == 2 } {
			set op [opConverter $word]
			set word [getWord $line $i]
			set i [increaseIndex $i]
			set rt [registerConverter $word]
			set word [getWord $line $i]
			set i [increaseIndex $i]
			set rs [registerConverter $word]
			set word [getWord $line $i]
			set imm [decimalBinary $word]

			append instruction $op
			append instruction $rs
			append instruction $rt
			append instruction $imm

			puts $fileOutput $instruction
			set instruction ""

		} elseif { $opType == 3} {
			set op [opConverter $word]
			set funct $word
			set word [getWord $line $i]
			set i [increaseIndex $i]
			set rt [registerConverter $word]
			set word [getWord $line $i]
			set i [increaseIndex $i]
			set rs [registerConverter $word]

			if { $funct == "sll" || $funct == "sra" || $funct == "srl" } {
				set word [getWord $line $i]
				set i [increaseIndex $i]
				set shamt [decimalBinary $word]
				set funct [functConverter $funct]
				append instruction $op
				append instruction "00000"
				append instruction $rs
				append instruction $rt
				append instruction $shamt
				append instruction $funct
			} else {
				set word [getWord $line $i]
				set i [increaseIndex $i]
				set imm [immBinary $word]
				append instruction $op
				append instruction $rs
				append instruction $rt
				append instruction $imm
			}

			puts $fileOutput $instruction
			set instruction ""

		#incompleto devido a falta de label
		} elseif { $opType == 4 } {
			set op [opConverter $word]
			set funct $word
			set word [getWord $line $i]
			set i [increaseIndex $i]
			set rs [registerConverter $word]
			set word [getWord $line $i]
			set i [increaseIndex $i]

			if { funct == "bgez"} {
				set rt "00001"
			} elseif { funct == "bgezal" } {
				set rt "10001"
			} elseif { funct == "bltzal" } {
				set rt "10000"
			} elseif { funct == "bgtz" || funct == "blez"  || funct == "bltz" } {
				set rt "00000"
			} else {
				set rt { registerConverter $word }
			}

			set word [getWord $line $i]
			set i [increaseIndex $i]
			set imm [immBinary $word]

			append instruction $op
			append instruction $rs
			append instruction $rt
			append instruction $imm

			puts $fileOutput $instruction
			set instruction ""

		#incompleto devido a falta de label
		} elseif { $opType == 5 } {
			set op [opConverter $word]
			set funct $word
			set word [getWord $word $i]
			set i [increaseIndex $i]

			if { funct = "jr" } {
				set rs [registerConverter $word]
				append instruction $op
				append instruction $rs
				append instruction "000000000000000001000"
			} else {
				set immed $word
			}
		
		} elseif { $opType == 6 } {
			if { $word == "noop" } {
				set instruction "00000000000000000000000000000000"
			} elseif { $word == "syscall" } {
				set rt "$v0"
				set rt [registerConverter $rt]
				set rs "$a9"
				set rs [registerConverter $rs]

				append instruction "000000"
				append instruction $rt
				append instruction $rs
				append instruction "0000000000001100"
			}

			puts $fileOutput $instruction
			set instruction ""	
		
		} elseif { $opType == 7 } {
			set op [opConverter $word]
			set funct $word
			set word [getWord $word $i]
			set i [increaseIndex $i]
			set rd [registerConverter $word]
			set word [getWord $word $i]
			set i [increaseIndex $i]
			set imm [immBinary $word]
			set rs "00000"
			
			append instruction "001000"
			append instruction $rs
			append instruction $rd
			append instruction $imm

			puts $fileOutput $instruction
			set instruction ""			
		}
	}	
}