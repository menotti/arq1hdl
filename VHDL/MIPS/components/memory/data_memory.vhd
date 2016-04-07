library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity data_memory is
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);

	port (
		address_to_read, address_to_write: in std_logic_vector (address_width - 1 downto 0);
		data_to_write: in std_logic_vector (data_width - 1 downto 0);
		read, write: in std_logic;
		data_out: out std_logic_vector (data_width - 1 downto 0));
end data_memory;

architecture behavioral of data_memory is

	type data_sequence is array (0 to length - 1) of std_logic_vector (data_width - 1 downto 0);  
	signal data: data_sequence :=
		(others => (others => '0')); 

begin

	read_data: process (read, address_to_read)
		variable index: integer;
	begin
		if read = '1' then
			index := to_integer(unsigned(address_to_read));
			data_out <= data(index);
		end if;
	end process;

	write_data: process (write, address_to_write, data_to_write)
		variable index: integer;
	begin
		if write = '1' then
			index := to_integer(unsigned(address_to_write));
			data(index) <= data_to_write;
		end if;
	end process;	

end behavioral;

