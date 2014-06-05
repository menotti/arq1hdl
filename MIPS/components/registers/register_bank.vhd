library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_bank is
	generic (width: integer := 32);
	port (
		register_to_read1, register_to_read2, register_to_write: 
		in std_logic_vector (4 downto 0);
	write: in std_logic;
	data_to_write: in std_logic_vector (width - 1 downto 0);
	data_out1, data_out2: out std_logic_vector (width - 1 downto 0));
end register_bank;

architecture behavioral of register_bank is

	type register_set is array (0 to 31) of std_logic_vector (width - 1 downto 0); 
	signal registers: register_set := 
		(0 => (others => '0'),
			others => (others => 'X'));

begin

		read_data: process (register_to_read1, register_to_read2)
			variable index1, index2: integer;
		begin
			index1 := to_integer(unsigned(register_to_read1));
			index2 := to_integer(unsigned(register_to_read2));

			data_out1 <= registers(index1);
			data_out2 <= registers(index2);
	end process;

		write_data: process (write, register_to_write, data_to_write)
			variable index: integer;
		begin
			if write = '1' then
				index := to_integer(unsigned(register_to_write));
				if index /= 0 then
					registers(index) <= data_to_write;
				end if;
			end if;
		end process;

end behavioral;

