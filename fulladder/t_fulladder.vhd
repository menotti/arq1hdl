LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity t_fulladder is
end;

architecture only of t_fulladder is

  COMPONENT fulladder
  PORT(
    Cin, x, y : IN  STD_LOGIC;
    s, Cout   : OUT STD_LOGIC);
  END COMPONENT;  

  signal Cin, x, y, s, Cout: STD_LOGIC;

begin
  -- design under test (projeto a ser testado)
  dut: fulladder port map (Cin, x, y, s, Cout);
  -- ...
  stim: process
    type pattern_type is record
      --  Entradas
      Cin, x, y :  STD_LOGIC;
      --  Saidas esperadas
      s, Cout   :  STD_LOGIC;
    end record;
    --  Casos de teste a serem aplicados
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0', '0'),
       ('0', '0', '1', '1', '0'),
       ('0', '1', '0', '1', '0'),
       ('0', '1', '1', '0', '1'),
       ('1', '0', '0', '1', '0'),
       ('1', '0', '1', '0', '1'),
       ('1', '1', '0', '0', '1'),
       ('1', '1', '1', '1', '1'));
  -- ...   
  begin
    --  Verifica cada padrao
    for i in patterns'range loop
      --  Insere as entradas
      Cin <= patterns(i).Cin;
      x   <= patterns(i).x;
      y   <= patterns(i).y;
      --  Aguarda o resultado
      wait for 10 ns;
      --  Verifica a saida
      assert s = patterns(i).s
        report "Erro na soma!" severity error;
      assert Cout = patterns(i).Cout
        report "Erro no vai um!" severity error;
    end loop;
    assert false report "Fim do teste!" severity note;
    --  Espera para sempre
    wait;
  end process;
end only;

