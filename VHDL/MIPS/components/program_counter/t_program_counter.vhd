library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity t_program_counter is
	generic (address_width: integer := 4);
end t_program_counter;

architecture behavioral of t_program_counter is

	component program_counter 
		generic (address_width: integer := 32);
		port (
			clock: in std_logic;
			load: in std_logic;
			load_address: in std_logic_vector (address_width - 1 downto 0);
			next_address: out std_logic_vector (address_width - 1 downto 0));
	end component;

	function to_string (signal sl_vector: std_logic_vector) return string is
	use std.textio.all; 
	variable b_vector: bit_vector (sl_vector'range) := to_bitvector(sl_vector);
	variable ln: line;
	begin
		write(ln, b_vector);
		return ln.all;
	end;

	signal clock: std_logic := '0';
	signal load: std_logic := '0';
	signal address: std_logic_vector (address_width - 1 downto 0);
	signal load_address: std_logic_vector (address_width - 1 downto 0);
	constant period: time := 10 ns;

begin

		counter: program_counter generic map (address_width)
			port map (clock, load, load_address, address);

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

			load_address <= "1010";

			for i in 0 to 16 loop
				report to_string(address);
				wait for period;
				if i = 12 then
					load <= '1';
					report "Load!";
				else
					load <= '0';
				end if;
			end loop;

			wait;
		end process;

end behavioral;
