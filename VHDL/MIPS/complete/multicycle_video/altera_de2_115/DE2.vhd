LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY De2 IS
	PORT(		
	 CLOCK_50	:	IN		STD_LOGIC;	
    KEY       : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
    SW        : IN    STD_LOGIC_VECTOR(17 DOWNTO 0);	
    LEDR      : OUT   STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
    LEDG      : OUT   STD_LOGIC_VECTOR(8 DOWNTO 0) := (others => '0');
	 VGA_R 		:	OUT		STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	 VGA_G 		:	OUT		STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	 VGA_B 		:	OUT		STD_LOGIC_VECTOR(7 DOWNTO 0) ;
	 VGA_HS 		:	OUT		STD_LOGIC;
	 VGA_VS 		:	OUT		STD_LOGIC;
	 HEX7      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
	 HEX6      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
	 HEX5      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
	 HEX4      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    HEX3      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    HEX2      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    HEX1      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    HEX0      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    VGA_CLK : OUT STD_LOGIC;
    VGA_SYNC_N  : OUT STD_LOGIC;
	 VGA_BLANK_N  : OUT STD_LOGIC;
	 PS2_CLK : INOUT STD_LOGIC; 
	 PS2_DAT : INOUT STD_LOGIC);
END De2;

ARCHITECTURE behavior OF De2 IS

component processor
	port (clock, turn_off: in std_logic;
		instruction_address, current_instruction, data_in_last_modified_register, 
	video_out: out std_logic_vector (31 downto 0);
	--IOBUS : INOUT;
    video_address: in std_logic_vector(11 downto 0));
end component;



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
		c0		: OUT STD_LOGIC;
		c1		: OUT STD_LOGIC 	
	);
end component;

component address_video 
	GENERIC (
		width  :  INTEGER  := 4
		);
	PORT(
    column       : IN  INTEGER;
    row          : IN  INTEGER;
    disp_ena     : IN  STD_LOGIC;
    video_out    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    video_address: OUT STD_LOGIC_VECTOR(11 downto 0);
		VGA_R 		   : OUT STD_LOGIC_VECTOR(width - 1  DOWNTO 0);
		VGA_G 	     : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		VGA_B 		   : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0));

END component;

component MOUSE
	port(
		  clock, reset 				: IN std_logic;
          data_mouse					: INOUT std_logic;
          clock_mouse 					: INOUT std_logic;
          left_button, right_button: OUT std_logic;
		  mouse_cursor_row 		   : OUT std_logic_vector(9 DOWNTO 0); 
		  mouse_cursor_column		: OUT std_logic_vector(9 DOWNTO 0));    
end component;



component dec7seg
  PORT(
    hex_digit  : IN  STD_LOGIC_VECTOR(3 downto 0);
    segment   : out STD_LOGIC_VECTOR(6 downto 0));
END component;


component keyboard
  PORT(
    keyboard_clk, keyboard_data, clock_25Mhz, 
    reset, rd       : IN  STD_LOGIC;
    scan_code       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    scan_ready      : OUT STD_LOGIC);
   
end component;

SIGNAL disp_ena, pixel_clk, mouse_clk: std_logic;
SIGNAL row, column: integer;
SIGNAL video_address: std_LOGIC_VECTOR(11 downto 0);
signal instruction_address, current_instruction, data_in_last_modified_register, video_out: std_logic_vector(31 downto 0);
SIGNAL mouse_cursor_column		: std_logic_vector(9 DOWNTO 0);
SIGNAL reset_key: STD_LOGIC := '0';
SIGNAL read_key, scan_ready_key: STD_LOGIC;
SIGNAL scan_code_key: STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL ledr1 : STD_LOGIC_VECTOR (9 downto 0);



BEGIN

  
  --LEDG <= "0" & current_instruction(31 downto 24);
	LEDR <= "00000000" & ledr1;
		
 -- d3: dec7seg port map (
   -- instruction_address(15 downto 12),
   -- HEX3);  

	 
		--HEX4 <= HEX3;
		--HEX5 <= HEX2;
		--HEX6 <= HEX1;
		--HEX7 <= HEX0;
		
  --d2: dec7seg port map (
  --  instruction_address(11 downto 8),
  --  HEX2);  

  --d1: dec7seg port map (
  --  instruction_address(7 downto 4),
  --  HEX1);  

 --- d0: dec7seg port map (
  --  instruction_address(3 downto 0),
   -- HEX0);


  d1: dec7seg port map (
    scan_code_key(7 downto 4),
    HEX1);  

  d0: dec7seg port map (
    scan_code_key(3 downto 0),
    HEX0);  
	
	 

  pll: vga_pll port map (
    CLOCK_50, 
    pixel_clk,
	 mouse_clk);
  
  cpu: processor port map (
    pixel_clk, 
    SW(0), 
    instruction_address,	
    current_instruction, 
    data_in_last_modified_register, 
    video_out, video_address);

  docoder: address_video generic map (8) port map (
    column,
    row,
    disp_ena,
    video_out,
    video_address,
		VGA_R,
		VGA_G,
		VGA_B); 

  video: vga_controller port map (
    pixel_clk, 
    '1', 
    VGA_HS, 
    VGA_VS, 
    disp_ena, 
    column, 
    row,
	VGA_BLANK_N,
	VGA_SYNC_N);
	
	mouse_sp2: MOUSE port map (
		mouse_clk,
		sw(0),
		PS2_DAT,
		PS2_CLK,		
		ledg(1),
		ledg(0),
		ledr1,
		mouse_cursor_column
	);
    
  teclado: keyboard port map (
    PS2_CLK,
    PS2_DAT,
    mouse_clk,
    reset_key,
    read_key,
    scan_code_key,
    scan_ready_key);


	VGA_CLK <= pixel_clk; 
  
END behavior;
