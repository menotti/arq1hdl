LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY de1 IS
	PORT(
		CLOCK_24	:	IN		STD_LOGIC_VECTOR(0 DOWNTO 0);	
		CLOCK_27	:	IN		STD_LOGIC_VECTOR(0 DOWNTO 0);	
		CLOCK_50	:	IN		STD_LOGIC;	
    KEY       : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
    SW        : IN    STD_LOGIC_VECTOR(9 DOWNTO 0);	
		VGA_R 		:	OUT		STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_G 		:	OUT		STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_B 		:	OUT		STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_HS 		:	OUT		STD_LOGIC;
		VGA_VS 		:	OUT		STD_LOGIC);
END de1;

ARCHITECTURE behavior OF de1 IS

COMPONENT vga_controller
  GENERIC(
    h_pulse   :  INTEGER   := 96;    --horiztonal sync pulse width in pixels
    h_bp      :  INTEGER   := 48;    --horiztonal back porch width in pixels
    h_pixels  :  INTEGER   := 640;   --horiztonal display width in pixels
    h_fp      :  INTEGER   := 16;    --horiztonal front porch width in pixels
    h_pol     :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
    v_pulse   :  INTEGER   := 2;     --vertical sync pulse width in rows
    v_bp      :  INTEGER   := 33;    --vertical back porch width in rows
    v_pixels  :  INTEGER   := 480;   --vertical display width in rows
    v_fp      :  INTEGER   := 10;    --vertical front porch width in rows
    v_pol     :  STD_LOGIC := '0');  --vertical sync pulse polarity (1 = positive, 0 = negative)
  PORT(
    pixel_clk :  IN   STD_LOGIC;     --pixel clock at frequency of VGA mode being used
    reset_n   :  IN   STD_LOGIC;     --active low asycnchronous reset
    h_sync    :  OUT  STD_LOGIC;     --horiztonal sync pulse
    v_sync    :  OUT  STD_LOGIC;     --vertical sync pulse
    disp_ena  :  OUT  STD_LOGIC;     --display enable ('1' = display time, '0' = blanking time)
    column    :  OUT  INTEGER;       --horizontal pixel coordinate
    row       :  OUT  INTEGER;       --vertical pixel coordinate
    n_blank   :  OUT  STD_LOGIC;     --direct blacking output to DAC
    n_sync    :  OUT  STD_LOGIC);    --sync-on-green output to DAC
END COMPONENT;

component vga_pll
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
end component;

component ram IS
   generic (
       DATA_WIDTH : natural := 32;
       ADDR_WIDTH : natural := 12);
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
END component;

SIGNAL pixel_clk: std_logic;
SIGNAL disp_ena: std_logic;
SIGNAL row, column: integer;
SIGNAL column_std: std_logic_vector(9 downto 0);

SIGNAL addr_a, addr_b: std_LOGIC_VECTOR(11 downto 0);
SIGNAL addr_a_n, addr_b_n: natural;
signal data_a, data_b, q_a, q_b: std_logic_vector(31 downto 0);
signal we_a, pixel: std_logic;

signal row_div2 : unsigned(11 downto 0);

BEGIN

  column_std <= std_logic_vector(to_unsigned(column, 10));

  addr_a_n <= to_integer(unsigned(addr_a));
  addr_b_n <= to_integer(unsigned(addr_b));
  
  row_div2 <= shift_right(to_unsigned(row, 12), 1);

  we_a <= not KEY(3);
  addr_a <= "00" & SW; 
  data_a <= (others => '1');
  
  addr_b <= std_logic_vector(
              (shift_left(row_div2, 3)) 
            + (shift_left(row_div2, 1)) 
            + (shift_right(to_unsigned(column, 12), 6)));
  
  pll: vga_pll port map (CLOCK_24(0), pixel_clk);
  
  video: vga_controller port map (pixel_clk, '1', VGA_HS, VGA_VS, disp_ena, column, row);
  
  video_ram: ram port map (pixel_clk, addr_a_n, addr_b_n, data_a, data_b, we_a, '0', q_a, q_b); 
  
  pixel <= q_b(31-to_integer(unsigned(column_std(5 downto 1))));
  
  VGA_R <= (others => pixel) when disp_ena='1' else (others => '0');
  VGA_G <= (others => pixel) when disp_ena='1' else (others => '0');
  VGA_B <= (others => not pixel) when disp_ena='1' else (others => '0');
  
END behavior;
