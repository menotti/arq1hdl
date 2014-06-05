LIBRARY ieee; 
USE ieee.std_logic_1164.ALL;      
USE ieee.std_logic_unsigned.ALL;

ENTITY example3 IS
  PORT (
    s : IN  std_logic_vector(3 downto 0);
    x : OUT std_logic);
END example3;  

ARCHITECTURE LogicFunc OF example3 IS
BEGIN
with s select x <=
    '1' when "0-10" | "-01-" | "-110",
    '0' when others;
END LogicFunc;
