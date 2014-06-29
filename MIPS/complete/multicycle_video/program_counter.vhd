library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
	generic (address_width: integer := 32);
	port (
		clock, enable: in std_logic;
		next_address: out std_logic_vector (address_width - 1 downto 0);
		address_to_point: in std_logic_vector (address_width - 1 downto 0));
end program_counter;

architecture behavioral of program_counter is

	signal current_address: std_logic_vector (address_width - 1 downto 0) := (others => '0');
	constant maximum_address: std_logic_vector (address_width - 1 downto 0) := (others => '1'); 

begin

	next_address <= current_address;

		process (clock)
		begin
			if rising_edge(clock) then
				if enable = '1' and current_address /= maximum_address then
					current_address <= address_to_point;
				end if;
			end if;
		end process;

end behavioral;

