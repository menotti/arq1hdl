library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity t_processor is
end t_processor;

architecture behavioral of t_processor is

	constant period: time := 10 ns;
	signal clock: std_logic := '1';
	signal turn_off: std_logic := '0';
	signal current_instruction, video_out: std_logic_vector (31 downto 0);
	signal data_in_last_modified_register, instruction_address: std_logic_vector (31 downto 0);
	signal video_address: std_logic_vector(11 downto 0);

	component processor 
	port (clock, turn_off: in std_logic;
		instruction_address, current_instruction, data_in_last_modified_register, video_out: 
		out std_logic_vector (31 downto 0);
    video_address: in std_logic_vector(11 downto 0));
	end component;

begin

		the_processor: processor port map (clock, turn_off, instruction_address, current_instruction,	data_in_last_modified_register, video_out, video_address);

		clock_process: process
		begin
			clock <= not clock;
			wait for period / 2;
		end process;

    asserts: process
    begin
      wait for period;
        assert instruction_address = std_logic_vector(to_unsigned(0, 32))
           report "Invalid instruction address!";
      wait for period;
        assert current_instruction = X"8C080000" -- lw  $t0, 0($zero)
           report "Invalid instruction fetched!";
    end process;

		stimulus: process
		begin
			wait for period * 50;
			turn_off <= '1';
			assert false report "End of simulation!";
		end process;

end behavioral;
