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
		(0 => (0 => '1', 1 => '1', others => '0'), others => (others => '0')); 
	
begin

	process(address_to_read)
		variable index: integer;
	begin
		index := to_integer(unsigned(address_to_read));
			instruction_out <= instructions(index);
	end process;

end behavioral;
