proc generateBuildData_MIF {} {
	# Open file 
	set inputFileName "memory.txt"
	set outputFileName "data_memory.mif"
	
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
	
	set maxDEPTH 4096
	set DEPTH 4095

	puts $outputFile ""	
	puts $outputFile "WIDTH=32;"
	puts $outputFile "DEPTH=$maxDEPTH;"
	puts $outputFile ""
	puts $outputFile "ADDRESS_RADIX=UNS;"
	puts $outputFile "DATA_RADIX=HEX;"
	puts $outputFile ""
	puts $outputFile "CONTENT BEGIN"

	# Initialize currentAddress to 0
	set currentAddress 0
	
	set data [split $file_data "\n"]
     foreach line $data {
		  set currentWord $line
          puts $outputFile "   $currentAddress    :  $currentWord;"
		  incr currentAddress
     }
	
	if { $currentAddress-1 != $maxDEPTH } { puts $outputFile "   \[$currentAddress..$DEPTH\]    :  00000000;" }

	# Output the MIF footer
	puts $outputFile "END;"
	# Close file to complete write
	close $outputFile
}
# generate Memory Initialization File (.mif)
generateBuildData_MIF