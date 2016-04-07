library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity t_instructions_memory is
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);
end t_instructions_memory;

architecture behavioral of t_instructions_memory is

  component instructions_memory
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);
	port (
		address_to_read: in std_logic_vector (address_width - 1 downto 0);
		instruction_out: out std_logic_vector (data_width - 1 downto 0));
  end component;

	signal	address_to_read: std_logic_vector (address_width - 1 downto 0) := (others => '0');
  signal	instruction_out: std_logic_vector (data_width - 1 downto 0);


begin

  dut: instructions_memory port map(address_to_read, instruction_out);

  address_inc: process
  begin
      address_to_read <= address_to_read + 1;
      wait for 100 ns;
  end process;

end behavioral;

