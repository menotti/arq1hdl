library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity xor_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
	result: out std_logic_vector (width - 1 downto 0));
end xor_x;

architecture structural of xor_x is
begin
	g: for i in width - 1 downto 0 generate
		result(i) <= a(i) xor b(i);
	end generate;
end structural;

