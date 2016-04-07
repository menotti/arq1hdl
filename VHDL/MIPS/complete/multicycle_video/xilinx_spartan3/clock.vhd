library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all ;

entity clock is port (
clk: in std_logic;
clk_out: buffer std_logic);
end clock;

architecture behaviour of clock is

signal reset : std_logic;

begin
process(clk,reset)
begin

if reset = '1' then
clk_out <= '0';
elsif rising_edge(clk) then
clk_out <= not clk_out;
end if;
end process;

end behaviour;