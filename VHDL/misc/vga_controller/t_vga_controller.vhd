LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY t_vga_controller IS
END t_vga_controller;

ARCHITECTURE tb OF t_vga_controller IS
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

SIGNAL    pixel_clk :    STD_LOGIC := '0';     --pixel clock at frequency of VGA mode being used
SIGNAL    reset_n   :    STD_LOGIC := '0';     --active low asycnchronous reset
SIGNAL    h_sync    :    STD_LOGIC;     --horiztonal sync pulse
SIGNAL    v_sync    :    STD_LOGIC;     --vertical sync pulse
SIGNAL    disp_ena  :    STD_LOGIC;     --display enable ('1' = display time, '0' = blanking time)
SIGNAL    column    :    INTEGER;       --horizontal pixel coordinate
SIGNAL    row       :    INTEGER;       --vertical pixel coordinate
SIGNAL    n_blank   :    STD_LOGIC;     --direct blacking output to DAC
SIGNAL    n_sync    :    STD_LOGIC;    --sync-on-green output to DAC
SIGNAL 		VGA_R 		:	STD_LOGIC_VECTOR(3 downto 0);
SIGNAL 		VGA_G 		:	STD_LOGIC_VECTOR(3 downto 0);
SIGNAL 		VGA_B 		:	STD_LOGIC_VECTOR(3 downto 0);

BEGIN
  
  dut: vga_controller port map (pixel_clk, reset_n, h_sync, v_sync, disp_ena, column, row, n_blank, n_sync);

  img: hw_image_generator generic map (479, 639) port map (disp_ena, row, column, VGA_R, VGA_G, VGA_B);
  
  CLOCK_GEN: process
  begin
      pixel_clk <= not pixel_clk;
      wait for 5 ns;
  end process;

  stim: process
  begin
    wait for 20 ns;
    reset_n <= '1';
    wait;
  end process;


END tb;