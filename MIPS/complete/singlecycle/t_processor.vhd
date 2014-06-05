library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity t_processor is
end t_processor;

architecture behavioral of t_processor is

	constant period: time := 100 ns;
	signal clock: std_logic := '0';
	signal turn_off: std_logic := '0';
	signal current_instruction: std_logic_vector (31 downto 0);
	signal data_in_last_modified_register: std_logic_vector (31 downto 0);
			signal expected: std_logic_vector (31 downto 0) := 			"00000000000000000000000000101010";

	component processor 
		port (clock, turn_off: in std_logic;
			current_instruction, data_in_last_modified_register: 
			out std_logic_vector (31 downto 0));
	end component;

	function to_string (signal sl_vector: std_logic_vector) return string is
	use std.textio.all; 
	variable b_vector: bit_vector (sl_vector'range) := to_bitvector(sl_vector);
	variable ln: line;
	begin
		write(ln, b_vector);
		return ln.all;
	end;

	procedure report_instruction (assemble: string) is
	begin
		report "Instruction to be executed: ";
		report to_string (current_instruction);
		report assemble;
	end;

begin

		the_processor: processor port map (clock, turn_off, current_instruction, 			data_in_last_modified_register);

		clock_process: process
		begin
			clock <= '0';
			wait for period /2;
			clock <= '1';
			wait for period / 2;
		end process;

		stimulus: process
		begin

			report "Starting test bench";

			wait for period / 2;

			report_instruction("lw $t0, 0 ($0)");

			wait for period;

			report_instruction("lw $t1, 4 ($0)");

			wait for period;

			report_instruction("add $t2, $t0, $t1");

			wait for period;

			report_instruction("sw $t2, 8 ($0)");

			wait for period;

			report_instruction("lw $t4, 8 ($0)");

			wait for period;

			turn_off <= '1';

			report "After execution data in register $t4 is " & 
				to_string(data_in_last_modified_register);
			assert data_in_last_modified_register = expected;

	wait;

		end process;

end behavioral;
