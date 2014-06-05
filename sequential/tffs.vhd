library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tffs is
  port (
		Clock : in  STD_LOGIC;
		Clear : in  STD_LOGIC;
		T     : in  STD_LOGIC;
		Q     : out STD_LOGIC);
end tffs;

architecture Behavioral of tffs is
	signal Qint : std_logic; -- para FPGAs podemos usar ainda := '0';
begin
  eval: process(Clock, Clear)
  begin
    if Clear = '1' then
      Qint <= '0';
    elsif Clock'EVENT and Clock = '1' then
      if T = '1' then
        Qint <= not Qint;
      end if;
    end if;
  end process;
  Q <= Qint;
end Behavioral;
