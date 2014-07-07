library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY clk_div IS
  PORT (
    clock_50Mhz      : IN  STD_LOGIC;
    clock_25MHz      : OUT  STD_LOGIC
    );
END clk_div;

ARCHITECTURE a OF clk_div IS
  SIGNAL  count_25Mhz                            : UNSIGNED(0 DOWNTO 0); 
 
  SIGNAL  clock_25Mhz_int : STD_LOGIC; 
BEGIN

  PROCESS 
  BEGIN
    WAIT UNTIL clock_50Mhz'EVENT and clock_50Mhz = '1';
      IF count_25Mhz < 1 THEN
        count_25Mhz <= count_25Mhz + 1;
      ELSE
        count_25Mhz <= "0";
      END IF;
      IF count_25Mhz < 1 THEN
        clock_25Mhz_int <= '0';
      ELSE
        clock_25Mhz_int <= '1';
      END IF;  

      clock_25Mhz <= clock_25Mhz_int;  
end process;
END a;

