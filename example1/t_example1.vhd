entity t_example1 is
end;

architecture only of t_example1 is

  COMPONENT example1
    PORT (
      x1, x2, x3 : IN  BIT;
      f          : OUT BIT);
  END COMPONENT;  

  signal x1, x2, x3, f : bit;

begin
  -- design under test (projeto a ser testado)
  dut: example1 port map (x1, x2, x3, f);
  -- ...
  stim: process
    type pattern_type is record
      --  Entradas
      x1, x2, x3 : bit;
      --  Saidas esperadas
      f : bit;
    end record;
    --  Casos de teste a serem aplicados
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0'),
       ('0', '0', '1', '1'),
       ('0', '1', '0', '0'),
       ('0', '1', '1', '0'),
       ('1', '0', '0', '0'),
       ('1', '0', '1', '1'),
       ('1', '1', '0', '1'),
       ('1', '1', '1', '1'));
  -- ...   
  begin
    --  Verifica cada padrao
    for i in patterns'range loop
      --  Insere as entradas
      x1 <= patterns(i).x1;
      x2 <= patterns(i).x2;
      x3 <= patterns(i).x3;
      --  Aguarda o resultado
      wait for 10 ns;
      --  Verifica a saida
      assert f = patterns(i).f
        report "Erro na funcao!" severity error;
    end loop;
    assert false report "Fim do teste!" severity note;
    --  Espera para sempre
    wait;
  end process;
end only;

