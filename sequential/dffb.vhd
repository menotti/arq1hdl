library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dffb is
  Port ( 
    Clock : in     STD_LOGIC;
    D     : in     STD_LOGIC;
    Q     : buffer STD_LOGIC;
    notQ  : out    STD_LOGIC);
end dffb;

architecture behav of dffb is
begin
  eval: process(Clock)
  begin
    if Clock'EVENT and Clock='1' then
      Q <= D;
    end if;
  end process;
  notQ <= not D;
end behav;