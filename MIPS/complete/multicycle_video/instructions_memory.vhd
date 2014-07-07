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
	signal instructions: instructions_sequence;
  attribute ram_init_file: string;
  attribute ram_init_file of instructions: signal is "instructions_memory.mif";

-- ModelSim
   -- signal instructions: instructions_sequence := (
 --   0 =>  X"8C080000", -- lw  $t0, 0($zero)
 --   1 =>  X"8C090004", -- lw  $t1, 4($zero)
  --  2 =>  X"A009000B", -- sb  $t1, 11($zero)
   -- 3 =>  X"8C0C0000", -- lw  $t4, 0($zero)
	--4 =>  X"05200001", -- bltz $t1, 5
--	5 =>  X"8C090000", -- lw  $t1, 0($zero)
   -- 6 =>  X"00094880", -- sll $t1 , $t1 , 2
 --   7 =>  X"00000000", -- noop
  --  8 =>  X"8C0A0004", -- lw  $t2, 4($zero)
 --   9 =>  X"292C0003", -- slti $t4, $t1, 3
 --   10 => X"01094020", -- add $t0, $t0, $t1
	--  11 => X"0511000D", -- bgezal $t0, 14
  --  12 => X"01095826", -- xor $t3, $t0, $t1
  --  13 => X"01084824", -- and $t0, $t0, $t1		
  --  14 => X"01084822", -- sub $t0, $t0, $t1      
  --  15 => X"3C09F30F", -- lui $t3, 62223
   -- 16 => X"01284825", -- or $t1, $t1, $t0
  --  17 => X"35290006", -- ori $t1, $t1, 6
  --  18 => X"39290006", -- ori $t1, $t1, 6
	--19 => X"31290008", -- andi $t1, $t1, 8
  --  20 => X"AD0A0000", -- sw  $t2, 0($t0)
   -- 21 => X"20080007", -- addi $t0, $zero, 7
  --  22 => X"20090008", -- addi $t1, $zero, 8    
   -- 23 => X"0108402D", -- nand $t0, $t0, $t0
  --  24 => X"0109482D", -- nand $t1, $t0, $t1
  --  25 => X"20080007", -- addi $t0, $zero, 7  
   -- 26 => X"0800000B", -- j 11
   -- 27 => X"0C00000E", -- jal 14
    --28 => X"01200008", -- jr $t1
    
    --others => (others => '0'));

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
