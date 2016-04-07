LIBRARY ieee;
USE ieee.std_logic_1164.ALL;      
USE ieee.std_logic_unsigned.ALL;

ENTITY  mux4 IS
 PORT (s0     : IN  STD_LOGIC;
       s1     : IN  STD_LOGIC;
       in0    : IN  STD_LOGIC;
       in1    : IN  STD_LOGIC;
       in2    : IN  STD_LOGIC;
       in3    : IN  STD_LOGIC;
       output : OUT STD_LOGIC);
END mux4;

--ARCHITECTURE func OF mux4 IS
--	signal sel: std_logic_vector(1 downto 0);
--BEGIN
--  sel <= s1 & s0;
--  output <= in0 WHEN sel="00" ELSE
--            in1 WHEN sel="01" ELSE
--            in2 WHEN sel="10" ELSE
--            in3 WHEN sel="11" ELSE 'X';
--END func; -- ou ARCHITECTURE

--ARCHITECTURE func OF mux4 IS
--  SIGNAL  sel  :  STD_LOGIC_VECTOR(1 DOWNTO 0);
--BEGIN 
--  sel <= s1 & s0;  
--  WITH sel SELECT  
--    output <= in0 WHEN "00",
--              in1 WHEN "01",
--              in2 WHEN "10",
--              in3 WHEN "11",
--              'X' WHEN OTHERS;
--END func; -- ou ARCHITECTURE

--ARCHITECTURE func OF mux4 IS
--BEGIN 
--  mux: PROCESS(s0, s1, in0, in1, in2, in3)
--    VARIABLE  sel  :  STD_LOGIC_VECTOR(1 DOWNTO 0);
--  BEGIN
--    sel := s1 & s0;   
--    CASE sel IS
--      WHEN  "00"  =>  output <= in0;
--      WHEN  "01"  =>  output <= in1;
--      WHEN  "10"  =>  output <= in2;
--      WHEN  "11"  =>  output <= in3;
--      WHEN OTHERS =>  output <= 'X';
--    END CASE;
--  END PROCESS; 
--END func; 

--ARCHITECTURE func OF mux4 IS
--BEGIN 
--  mux: PROCESS(s0, s1, in0, in1, in2, in3)
--  BEGIN
--    IF    (s0='0' AND s1='0') THEN
--      output <= in0;
--    ELSIF (s0='1' AND s1='0') THEN
--      output <= in1;
--    ELSIF (s0='0' AND s1='1') THEN
--      output <= in2;
--    ELSIF (s0='1' AND s1='1') THEN
--      output <= in3;
--    ELSE
--      output <= 'X';
--    END IF;
--  END PROCESS mux;
--END func;
