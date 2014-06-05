library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity t_registers is
	generic (width: integer := 4);
end t_registers;

architecture behavioral of t_registers is

	signal register_to_read1, register_to_read2, register_to_write: std_logic_vector (4 downto 0);
	signal data_to_write, readed_data1, readed_data2: std_logic_vector (width - 1 downto 0);
	signal swrite: std_logic;

	function to_string (signal sl_vector: std_logic_vector) return string is
	use std.textio.all; 
	variable b_vector: bit_vector (sl_vector'range) := to_bitvector(sl_vector);
	variable ln: line;
	begin
		write(ln, b_vector);
		return ln.all;
	end;

	component register_bank
		generic (width: integer := 32);
		port (
			register_to_read1, register_to_read2, register_to_write: 
			in std_logic_vector (4 downto 0);
		write: in std_logic;
		data_to_write: in std_logic_vector (width - 1 downto 0);
		data_out1, data_out2: out std_logic_vector (width - 1 downto 0));
	end component;

	begin

		register_bank1: register_bank generic map (width) port map (register_to_read1, 			register_to_read2, register_to_write, swrite, data_to_write, readed_data1, 			readed_data2);  

		process

		begin

			report "Starting test bench";

			swrite <= '1';
			register_to_write <= "00011";
			data_to_write <= "0110";
			wait for 100 ns;

						report "Writing " & to_string(data_to_write) & 
				" to register " & to_string(register_to_write);

			swrite <= '1';
			register_to_write <= "00110";
			data_to_write <= "1000";
			wait for 100 ns;

						report "Writing " & to_string(data_to_write) & 
				" to register " & to_string(register_to_write);

			report "Reading data from registers";
			register_to_read1 <= "00011";
			register_to_read2 <= "00110";
			wait for 100 ns;

			report "Data in register " & to_string(register_to_read1) &
				" = " & to_string(readed_data1);
			report "Data in register " & to_string(register_to_read2) &
				" = " & to_string(readed_data2);
			assert readed_data1 = "0110";
			assert readed_data2 = "1000";

			report "Attempting to write in register $0";
			swrite <= '1';
			register_to_write <= "00000";
			data_to_write <= "1111";
						wait for 100 ns;

			report "Reading data from register $0";
			register_to_read1 <= "00000";
			register_to_read2 <= "XXXXX";
			wait for 100 ns;

			report "Data in register 1 = " & to_string(readed_data1);
			assert readed_data1 = "0000";

			wait;

		end process;
end behavioral;

