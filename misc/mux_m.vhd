library  IEEE;
use IEEE.std_logic_1164.all;

entity mux_m is  
  generic (
    w_in   : integer := 32;
    N_ops  : integer := 32;
    N_sels : integer := 31);
  port (
    I0  : in   std_logic_vector((w_in*N_ops)-1 downto 0);
    Sel : in   std_logic_vector(N_sels-1 downto 0);
    O0  : out  std_logic_vector(w_in-1 downto 0));
end mux_m;

architecture behav of mux_m is

begin
  process(I0, Sel)
    variable O_aux : std_logic_vector(w_in-1 downto 0);
  begin
    -- by default de output is the first input
    O_aux := (others => '-');
    for i in N_ops downto 1 LOOP
      if (N_sels = N_ops -1) AND (i = N_ops) THEN
        O_aux := I0(N_ops*w_in-1 downto (N_ops-1)*w_in);
      ELSE
        if (Sel(i-1) = '1') THEN
          O_aux := I0(i*w_in-1 downto (i-1)*w_in);
        end if;
      end if;
    end LOOP;
    O0 <= O_aux;
  end process;
end behav;