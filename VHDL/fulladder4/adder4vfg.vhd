LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fulladder_package.ALL;

ENTITY adder4vfg IS
  GENERIC (
    bits : integer := 8);
  PORT(
    Cin  : IN  STD_LOGIC;
    X, Y : IN  STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    S    : OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    Cout : OUT STD_LOGIC);
END adder4vfg;

ARCHITECTURE LogicFunc OF adder4vfg IS
  SIGNAL C : STD_LOGIC_VECTOR(bits DOWNTO 0);
BEGIN
  stage: for n in bits-1 downto 0 generate
    stage: fulladder PORT MAP (C(n), X(n), Y(n), S(n), C(n+1));
  end generate;
  C(0) <= Cin;
  Cout <= C(bits);
END LogicFunc;

