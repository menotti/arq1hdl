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
    clock, enable: in std_logic;
		address_to_read: in std_logic_vector (address_width - 1 downto 0);
		instruction_out: out std_logic_vector (data_width - 1 downto 0));
end instructions_memory;

architecture behavioral of instructions_memory is

	type instructions_sequence is array (0 to length) of std_logic_vector (data_width - 1 downto 0);
	
-- Quartus II
-- ------------------------------------------------------------
-- Synthesis-only
-- ------------------------------------------------------------
--
-- Note: Quartus does not allow comments inside the read
-- comments as HDL block.
--
-- synthesis read_comments_as_HDL on

--  signal instructions: instructions_sequence;
--  attribute ram_init_file: string;
--  attribute ram_init_file of instructions: signal is "../instructions_memory.mif";

-- synthesis read_comments_as_HDL off


-- ModelSim
--pragma synthesis_off
    signal instructions: instructions_sequence := (
    0 => X"8C080000", -- lw  $t0, 0($zero)
    1 => X"8C090000", -- lw  $t1, 0($zero)
    2 => X"8C0A0004", -- lw  $t2, 4($zero)
    3 => X"01094020", -- add $t0, $t0, $t1
    4 => X"AD0A0000", -- sw  $t2, 0($t0)
    5 => X"08000003", -- j 3
    others => (others => '0'));
--pragma synthesis_on

begin

	process(clock)
		variable index: integer;
	begin
    if rising_edge(clock) then
      if enable='1' then
      		index := to_integer(unsigned(address_to_read));
			  instruction_out <= instructions(index);
			end if;
    end if;
	end process;

end behavioral;
