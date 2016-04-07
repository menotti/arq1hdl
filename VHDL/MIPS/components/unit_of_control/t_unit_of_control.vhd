library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity t_unit_of_control is

end t_unit_of_control;

architecture behavioral of t_unit_of_control is

	component unit_of_control 
		port (
			instruction: in std_logic_vector (31 downto 0);
			destination_register, register1, register2: out std_logic_vector (4 downto 0);
			write_register: out std_logic;
			alu_operation: out std_logic_vector (2 downto 0);
			read_memory, write_memory: out std_logic;
			offset: out std_logic_vector (15 downto 0));
	end component;

	signal instruction: std_logic_vector (31 downto 0);
	signal destination_register, register1, register2: std_logic_vector (4 downto 0);
	signal write_register, read_memory, write_memory: std_logic;
	signal alu_operation: std_logic_vector (2 downto 0);
	signal offset: std_logic_vector (15 downto 0);
 
begin

		control: unit_of_control port map (instruction, destination_register, register1, 		register2, write_register, alu_operation, read_memory, write_memory, offset);

		process
		begin
			report "Starting test bench";
			report "Verifing a r instruction";
			instruction <= "00000000011111000000100000000010";
			wait for 100 ns;

			assert destination_register = "00011";
			assert register1 = "11100";
			assert register2 = "00001";
		assert alu_operation = "010";
			assert write_register = '1';

			report "Verifing a lw instruction";
			instruction <= "10001111110100110000000000000100";
			wait for 100 ns;

			assert destination_register = "11110";
			assert register1 = "10011"; 
			assert offset = "0000000000000100";
			assert read_memory = '1';
			assert write_register = '1';

			report "Verifing a sw operation";
			instruction <= "10101110000000010000000000001000";
			wait for 100 ns;

			assert register1 = "10000";
			assert register2 = "00001";
			assert offset = "0000000000001000";
			assert write_memory = '1';
 
			wait;  
		end process;

end behavioral;

