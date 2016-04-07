library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
  port (
    Clock : in  STD_LOGIC;
    Clear : in  STD_LOGIC;
    Cont  : out STD_LOGIC_VECTOR(3 downto 0));
end contador;

architecture Behavioral of contador is
  COMPONENT tffs
  PORT(
		Clock : in  STD_LOGIC;
		Clear : in  STD_LOGIC;
		T     : in  STD_LOGIC;
		Q     : out STD_LOGIC);
	END COMPONENT;
	SIGNAL ContInt: STD_LOGIC_VECTOR(3 downto 0);
begin 
	t0: tffs PORT MAP(Clock,          Clear, '1', ContInt(0));
	t1: tffs PORT MAP(not ContInt(0), Clear, '1', ContInt(1));
	t2: tffs PORT MAP(not ContInt(1), Clear, '1', ContInt(2));
	t3: tffs PORT MAP(not ContInt(2), Clear, '1', ContInt(3));
	Cont <= ContInt;
end Behavioral;

