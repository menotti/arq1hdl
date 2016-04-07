## Generated SDC file "multicycle.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Thu Jul 10 00:42:37 2014"

##
## DEVICE  "EP2C20F484C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_24[0]} -period 41.666 -waveform { 0.000 20.833 } [get_ports {CLOCK_24[0]}]
create_clock -name {MOUSE:mouse_sp2|clock_mouse_FILTER} -period 1.000 -waveform { 0.000 0.500 } [get_registers {MOUSE:mouse_sp2|clock_mouse_FILTER}]
create_clock -name {keyboard:teclado|keyboard_clk_filtered} -period 1.000 -waveform { 0.000 0.500 } [get_registers {keyboard:teclado|keyboard_clk_filtered}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll|altpll_component|pll|clk[0]} -source [get_pins {pll|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 21 -divide_by 20 -master_clock {CLOCK_24[0]} [get_pins {pll|altpll_component|pll|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {MOUSE:mouse_sp2|clock_mouse_FILTER}]  2.500 [get_ports {CLOCK_24[0]}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {keyboard:teclado|keyboard_clk_filtered}]  -to  [get_clocks {CLOCK_24[0]}]
set_false_path  -from  [get_clocks {MOUSE:mouse_sp2|clock_mouse_FILTER}]  -to  [get_clocks {CLOCK_24[0]}]
set_false_path  -from  [get_clocks {CLOCK_24[0]}]  -to  [get_clocks {MOUSE:mouse_sp2|clock_mouse_FILTER}]
set_false_path  -from  [get_clocks {MOUSE:mouse_sp2|clock_mouse_FILTER}]  -to  [get_clocks {MOUSE:mouse_sp2|clock_mouse_FILTER}]
set_false_path  -from  [get_clocks {keyboard:teclado|keyboard_clk_filtered}]  -to  [get_clocks {keyboard:teclado|keyboard_clk_filtered}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

