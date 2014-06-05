library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity instructions_memory is
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);

	port (
		address_to_read: in std_logic_vector (address_width - 1 downto 0);
		instruction_out: out std_logic_vector (data_width - 1 downto 0));
end instructions_memory;

architecture behavioral of instructions_memory is

	type instructions_sequence is array (0 to length) of std_logic_vector (data_width - 1 downto 0);
	signal instructions: instructions_sequence :=
		-- Bellow some instructions loaded into the memory.

		-- lw $t0, 0 ($0)
		(0 => "10001101000000000000000000000000",

		-- lw $t1, 4 ($0);
		1 => "10001101001000000000000000000100",

		-- add $t2, $t0, $t1
		2 => "00000001010010000100100000000010",

		-- sw $t2, 8 ($0)
		3 => "10101101010000000000000000001000",

		--lw $t4, 8 ($0)
		4 => "10001101100000000000000000001000",

		-- End of instructions.
		others => (others => 'U'));

begin

	process(address_to_read)
		variable index: integer;
	begin
		index := to_integer(unsigned(address_to_read));
			instruction_out <= instructions(index);
	end process;

end behavioral;
