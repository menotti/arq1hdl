library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity decoder_x is
   port(enable : in std_logic;
        din : in std_logic_vector (1 downto 0);
        dout : out std_logic_vector (3 downto 0));
end decoder_x;

architecture descript of decoder_x is 

begin
  
  dout <= "1111" when enable = '0' else
          "0001" when enable = '1' and din = "00" else
          "0010" when enable = '1' and din = "01" else
          "0100" when enable = '1' and din = "10" else
          "1000" when enable = '1' and din = "11";

end descript;