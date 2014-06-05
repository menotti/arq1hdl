LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE fulladder_package IS
  COMPONENT fulladder
    PORT(
      Cin, x, y : IN  STD_LOGIC;
      s, Cout   : OUT STD_LOGIC
    );
  END COMPONENT;  
END fulladder_package;