LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity t_adder4 is
end;

architecture only of t_adder4 is

constant bits : integer := 8;

  COMPONENT adder4vfg
  GENERIC (
    bits : integer := 8);
  PORT(
    Cin  : IN  STD_LOGIC;
    X, Y : IN  STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    S    : OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    Cout : OUT STD_LOGIC);
  END COMPONENT;  

  signal  Cin  : STD_LOGIC;
  signal  X, Y : STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
  signal  S    : STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
  signal  Cout : STD_LOGIC;

begin
  -- design under test (projeto a ser testado)
  dut: adder4vfg port map (Cin, X, Y, S, Cout);
  -- ...
  stim: process
    type pattern_type is record
      --  Entradas
      Cin  :  STD_LOGIC;
      X, Y :  STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
      --  Saidas esperadas
      S    :  STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
      Cout :  STD_LOGIC;
    end record;
    --  Casos de teste a serem aplicados
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', "00000001", "00000000", "00000001", '0'),
       ('1', "00000000", "00000000", "00000001", '0'),
  -- insira mais casos de testes aqui   
       ('0', "11111111", "11111111", "11111110", '1'),
       ('1', "11111111", "00000001", "00000001", '1'));
  begin
    --  Verifica cada padrao
    for i in patterns'range loop
      --  Insere as entradas
      Cin <= patterns(i).Cin;
      X   <= patterns(i).X;
      Y   <= patterns(i).Y;
      --  Aguarda o resultado
      wait for 10 ns;
      --  Verifica a saida
      assert S = patterns(i).S
        report "Erro na soma!" severity error;
      assert Cout = patterns(i).Cout
        report "Erro no vai um!" severity error;
    end loop;
    assert false report "Fim do teste!" severity note;
    --  Espera para sempre
    wait;
  end process;

end only;

