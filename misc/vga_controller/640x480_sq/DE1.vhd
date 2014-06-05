LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY de1 IS
  PORT(
    CLOCK_24  :  IN     STD_LOGIC_VECTOR(0 DOWNTO 0);  
    CLOCK_27  :  IN     STD_LOGIC_VECTOR(0 DOWNTO 0);  
    CLOCK_50  :  IN     STD_LOGIC;  
    VGA_R     :  OUT    STD_LOGIC_VECTOR(3 DOWNTO 0);
    VGA_G     :  OUT    STD_LOGIC_VECTOR(3 DOWNTO 0);
    VGA_B     :  OUT    STD_LOGIC_VECTOR(3 DOWNTO 0);
    VGA_HS    :  OUT    STD_LOGIC;
    VGA_VS    :  OUT    STD_LOGIC);  
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
    inclk0 : IN  STD_LOGIC  := '0';
    c0     : OUT STD_LOGIC 
  );
end component;

component hw_image_generator IS
  GENERIC(
    pixels_y :  INTEGER := 320;    --row that first color will persist until
    pixels_x :  INTEGER := 240);   --column that first color will persist until
  PORT(
    disp_ena :  IN   STD_LOGIC;   --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;     --row pixel coordinate
    column   :  IN   INTEGER;     --column pixel coordinate
    red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END component;

SIGNAL pixel_clk: std_logic;
SIGNAL disp_ena: std_logic;
SIGNAL row, column: integer;

BEGIN

  pll: vga_pll port map (CLOCK_24(0), pixel_clk);

  video: vga_controller port map (pixel_clk, '1', VGA_HS, VGA_VS, disp_ena, column, row);

  img: hw_image_generator generic map (479, 639) port map (disp_ena, row, column, VGA_R, VGA_G, VGA_B);

END behavior;
