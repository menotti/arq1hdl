LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fulladder_package.ALL;

ENTITY adder4v IS
  PORT(
    Cin  : IN  STD_LOGIC;
    X, Y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    S    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    Cout : OUT STD_LOGIC
  );
END adder4v;

ARCHITECTURE LogicFunc OF adder4v IS
  SIGNAL C : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
  stage0: fulladder PORT MAP (Cin, X(0), Y(0), S(0), C(1));
  stage1: fulladder PORT MAP (C(1), X(1), Y(1), S(1), C(2));
  stage2: fulladder PORT MAP (C(2), X(2), Y(2), S(2), C(3));
  stage3: fulladder PORT MAP (C(3), X(3), Y(3), S(3), Cout);
END LogicFunc;

