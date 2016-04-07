library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
	generic (address_width: integer := 32);
	port (
		clock: in std_logic;
		load: in std_logic;
		load_address: in std_logic_vector (address_width - 1 downto 0);
		next_address: out std_logic_vector (address_width - 1 downto 0));
end program_counter;

architecture behavioral of program_counter is

	signal current_address: std_logic_vector (address_width - 1 downto 0) := (others => '0');
	signal maximum_address: std_logic_vector (address_width - 1 downto 0) := (others => '1'); 

begin

	next_address <= current_address;

		process (clock)
		begin
			if rising_edge(clock) then
				if load = '1' then
					current_address <= load_address;
				elsif current_address /= maximum_address then
					current_address <= current_address + '1';
				end if;
			end if;
		end process;

end behavioral;

