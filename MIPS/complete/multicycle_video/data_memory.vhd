library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity data_memory is
	generic (
		address_width: integer := 12;
		data_width: integer := 32);
	port (
    clock: std_logic;
		address_to_read, address_to_write, video_address: in std_logic_vector (address_width - 1 downto 0);
		data_to_write: in std_logic_vector (data_width - 1 downto 0);
		read, write: in std_logic;
		be: in std_logic_vector (3 downto 0);
		data_out, video_out: out std_logic_vector (data_width - 1 downto 0));
end data_memory;

architecture behavioral of data_memory is

  type word_t is array (0 to 3) of std_logic_vector (7 downto 0);
  type data_sequence is array (0 to 2**address_width - 1) of word_t; 
	--type data_sequence is array (0 to 2**address_width - 1) of std_logic_vector (data_width - 1 downto 0); 

--  Quartus II 
--	 signal data: data_sequence;
--  attribute ram_init_file : string;
--  attribute ram_init_file of data : signal is "data_memory.mif";
  
-- ModelSim

    --video signal 
    signal video_local: std_logic_vector (data_width - 1 downto 0);
    
		signal word: word_t;
		signal data: data_sequence := (
		  0 => ((0) => X"01",
		        others => X"00"),
      1 => ((0) => X"AA",
            (1) => X"AA",
            (2) => X"F0",
            (3) => X"F0"),
      others => (others => (others => '0')));
		
begin
    unpack: for i in 0 to 3 generate 
        data_out(8*(i+1) - 1 downto 8*i) <= word(i);
    end generate unpack;
    
    unpack_v: for j in 0 to 3 generate 
        video_local(8*(j+1) - 1 downto 8*j) <= word(j);
    end generate unpack_v;  
    
   process(clock)
		variable index: integer;
   begin
   if(rising_edge(clock)) then -- Port A
     index := to_integer(unsigned(address_to_write)); 
     if(write = '1') then
       if(be = "1111") then       
         if(be(0) = '1') then
           data(index)(0) <= data_to_write(7 downto 0);
         end if;
         if(be(1) = '1') then
           data(index)(1) <= data_to_write(15 downto 8);
         end if;
         if(be(2) = '1') then
           data(index)(2) <= data_to_write(23 downto 16);
         end if;
         if(be(3) = '1') then     
           data(index)(3) <= data_to_write(31 downto 24);
         end if;
       else
         if(be(0) = '1') then
           data(index)(0) <= data_to_write(7 downto 0);
         end if;
         if(be(1) = '1') then
           data(index)(1) <= data_to_write(7 downto 0);
         end if;
         if(be(2) = '1') then
           data(index)(2) <= data_to_write(7 downto 0);
         end if;
         if(be(3) = '1') then     
           data(index)(3) <= data_to_write(7 downto 0);
         end if;
       end if; 
     elsif(read = '1') then
       if(be(0) = '1') then
         word(0) <= data(index)(0);
       end if;
       if(be(1) = '1') then
         word(1) <= data(index)(1);
       end if;
       if(be(2) = '1') then
         word(2) <= data(index)(2);
       end if;
       if(be(3) = '1') then
         word(3) <= data(index)(3);
       end if;
     end if;   
  end if;
end process;
  
 	read_video: process (clock)
	variable index: integer;
	begin
   if(rising_edge(clock)) then -- Port B
			index := to_integer(unsigned(video_address));
			video_out <= video_local;
   end if;
  end process;

end behavioral;