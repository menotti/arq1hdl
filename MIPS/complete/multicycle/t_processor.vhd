library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity t_processor is
end t_processor;

architecture behavioral of t_processor is

	constant period: time := 10 ns;
	signal clock: std_logic := '1';
	signal turn_off: std_logic := '0';
	signal current_instruction: std_logic_vector (31 downto 0);
	signal data_in_last_modified_register, instruction_address: std_logic_vector (31 downto 0);
	signal expected: std_logic_vector (31 downto 0) := 			"00000000000000000000000000101010";

	component processor 
	port (clock, turn_off: in std_logic;
		instruction_address, current_instruction, data_in_last_modified_register: 
		out std_logic_vector (31 downto 0));
	end component;
	
begin

		the_processor: processor port map (
		  clock, 
		  turn_off, 
		  instruction_address, 
		  current_instruction, 
		  data_in_last_modified_register);

		clock_process: process
		begin
			clock <= not clock;
			wait for period / 2;
		end process;

		stimulus: process
		begin
			wait for period * 50;
			turn_off <= '1';
     	wait;
		end process;

end behavioral;
