library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity t_data_memory is
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);
end t_data_memory;

architecture behavioral of t_data_memory is

  component data_memory 
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);
	port (
		address_to_read, address_to_write: in std_logic_vector (address_width - 1 downto 0);
		data_to_write: in std_logic_vector (data_width - 1 downto 0);
		read, write: in std_logic;
		data_out: out std_logic_vector (data_width - 1 downto 0));
  end component;

	signal address_to_read, address_to_write: std_logic_vector (address_width - 1 downto 0);
	signal data_to_write: std_logic_vector (data_width - 1 downto 0);
	signal read, swrite: std_logic;
	signal data_out: std_logic_vector (data_width - 1 downto 0);

	function to_string (signal sl_vector: std_logic_vector) return string is
	use std.textio.all; 
	variable b_vector: bit_vector (sl_vector'range) := to_bitvector(sl_vector);
	variable ln: line;
	begin
		write(ln, b_vector);
		return ln.all;
	end;

	begin

		dut: data_memory  port map (address_to_read, address_to_write, data_to_write, read, swrite, data_out);  

		process
		begin

			report "Starting test bench";

			swrite <= '1';
			read <= '0';
			address_to_write <= "00000000000000000000000000000010";
			data_to_write <= "00000000000000000000000000000110";
			wait for 100 ns;

			report "Writing " & to_string(data_to_write) & 
				" to position " & to_string(address_to_write);

			address_to_write <= "00000000000000000000000000000111";
			data_to_write <= "00000000000000000000000000001000";
			wait for 100 ns;

			report "Writing " & to_string(data_to_write) & 
				" to position " & to_string(address_to_write);


			swrite <= '0';
			read <= '1';
			report "Reading data from position";
			address_to_read <= "00000000000000000000000000000010";
			wait for 100 ns;

			report "Data in position " & to_string(address_to_write) &
				" = " & to_string(data_out);

			assert data_out = "00000000000000000000000000000110";

			report "Reading data from position";
			address_to_read <= "00000000000000000000000000000111";
			wait for 100 ns;

			report "Data in position " & to_string(address_to_write) &
				" = " & to_string(data_out);

			assert data_out = "00000000000000000000000000001000";

			wait;

		end process;
end behavioral;

