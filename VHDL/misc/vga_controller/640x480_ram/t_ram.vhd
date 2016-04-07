library ieee;
use ieee.std_logic_1164.all;

entity t_ram is
end t_ram;

architecture tb of t_ram is

constant       DATA_WIDTH : natural := 8;
constant       ADDR_WIDTH : natural := 8;

component ram  
   generic (
       DATA_WIDTH : natural := 8;
       ADDR_WIDTH : natural := 8);
   port (
       clk: in std_logic;
       addr_a: in natural range 0 to 2**ADDR_WIDTH - 1; 
       addr_b: in natural range 0 to 2**ADDR_WIDTH - 1; 
       data_a: in std_logic_vector((DATA_WIDTH-1) downto 0); 
       data_b: in std_logic_vector((DATA_WIDTH-1) downto 0); 
       we_a: in std_logic := '1';
       we_b: in std_logic := '1';
       q_a: out std_logic_vector((DATA_WIDTH -1) downto 0); 
       q_b: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;

signal       clk:  std_logic := '1';
signal       addr_a:  natural range 0 to 2**ADDR_WIDTH - 1 := 0; 
signal       addr_b:  natural range 0 to 2**ADDR_WIDTH - 1 := 0; 
signal       data_a:  std_logic_vector((DATA_WIDTH-1) downto 0) := (others => '1'); 
signal       data_b:  std_logic_vector((DATA_WIDTH-1) downto 0) := (others => '1'); 
signal       we_a:  std_logic := '0';
signal       we_b:  std_logic := '0';
signal       q_a:  std_logic_vector((DATA_WIDTH -1) downto 0); 
signal       q_b:  std_logic_vector((DATA_WIDTH -1) downto 0);

begin

uut: ram generic map (DATA_WIDTH, ADDR_WIDTH) port map (clk, addr_a, addr_b, data_a, data_b, we_a, we_b, q_a, q_b);

cg: process
begin
  clk <= not clk;
  wait for 5 ns;
end process;

st: process
begin
  we_a <= '0';
  wait for 40 ns;
  we_a <= '1';
  wait for 40 ns;
  we_a <= '0';
  addr_a <= 1;
  addr_b <= 1;
  wait for 40 ns;
  we_b <= '1';
  wait for 40 ns;
  we_b <= '0';
  addr_a <= 2;
  addr_b <= 2;
  wait for 40 ns;
  we_a <= '1';
  we_b <= '1';
  wait for 40 ns;
  data_a <= "01010101";
  we_b <= '0';
  wait for 40 ns;
  data_b <= "10101010";
  we_a <= '0';
  we_b <= '1';
  wait;
end process;


end tb;