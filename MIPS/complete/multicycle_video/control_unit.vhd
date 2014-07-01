library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity control_unit is 
	port (
		clock: in std_logic;
		instruction: in std_logic_vector (31 downto 0);
		enable_program_counter,
		enable_alu_output_register: out std_logic := '0';
		register1, register2, register3: out std_logic_vector (4 downto 0);
		write_register, mem_to_register: out std_logic;
		source_alu_a: out std_logic_vector (1 downto 0); 
		source_alu_b: out std_logic_vector (1 downto 0);
		pc_source: out std_logic_vector (1 downto 0);  
		reg_dst: out std_logic_vector(1 downto 0);
		alu_operation: out std_logic_vector (2 downto 0);
		read_memory, write_memory: out std_logic;
		offset,shamt: out std_logic_vector (31 downto 0);
		jump_offset: out std_logic_vector(25 downto 0));
end control_unit;

architecture behavioral of control_unit is
	type state is (fetch, decode, alu, mem, writeback);
	signal next_state: state := fetch;
	signal opcode: std_logic_vector(5 downto 0);
	signal funct: std_logic_vector(5 downto 0);

	constant lw: std_logic_vector (5 downto 0) := "100011";
	constant sw: std_logic_vector (5 downto 0) := "101011";
	constant  r: std_logic_vector (5 downto 0) := "000000";
	constant  j: std_logic_vector (5 downto 0) := "000010";
	constant jr: std_logic_vector(5 downto 0) := "001000";
	constant jal: std_logic_vector(5 downto 0) := "000011";
	constant shiftll: std_logic_vector (5 downto 0) := "000000";
	constant slti: std_logic_vector (5 downto 0) := "001010";
	constant funct_or: std_logic_vector (5 downto 0) := "100101";
	constant ori: std_logic_vector (5 downto 0) := "001101";
	constant lui: std_logic_vector (5 downto 0) := "001111"; 
	constant funct_sub : std_logic_vector (5 downto 0) := "100010";
	constant funct_and : std_logic_vector (5 downto 0) := "100100";



	function extend_to_32(input: std_logic_vector (15 downto 0)) return std_logic_vector is 
	variable s: signed (31 downto 0);
	begin
		s := resize(signed(input), s'length);
		return std_logic_vector(s);  
	end;
	
	function extend_to_32_shamt(input: std_logic_vector (4 downto 0)) return std_logic_vector is 
	variable s: signed (31 downto 0);
	begin
		s := resize(signed(input), s'length);
		return std_logic_vector(s);  
	end;
	

begin

  	shamt <= extend_to_32_shamt(instruction(10 downto 6));
  	offset <= extend_to_32(instruction(15 downto 0));
  	opcode <= instruction(31 downto 26);
  	funct <= instruction(5 downto 0);
	register1 <= instruction(25 downto 21);
	register2 <= instruction(20 downto 16);
	register3 <= instruction(15 downto 11);
  	jump_offset <= instruction(25 downto 0);

	next_state_function: process(clock)
	begin

  	if rising_edge(clock) then

		alu_operation <= "010";
		pc_source <= "00";
		enable_alu_output_register <= '0';
		enable_program_counter <= '0';
		read_memory <= '0';
		reg_dst <= "00";
		source_alu_a <= "00";
		source_alu_b <= "01";
   		mem_to_register <= '0';
		write_memory <= '0';
		write_register <= '0';

		case next_state is

			when fetch =>
				-- instruction fetch
				enable_program_counter <= '1';
			  next_state <= decode;

			when decode =>
				-- instruction decode 
				next_state <= alu;

			when alu =>
				enable_alu_output_register <= '1';

				if opcode = lw then
				  	source_alu_a <= "01";
      		  		source_alu_b <= "11";
					next_state <= mem;
				
				elsif opcode = sw then
				  	source_alu_a <= "01";
      		  		source_alu_b <= "11";
					next_state <= mem;
				
				elsif opcode = j then
				  	enable_program_counter <= '1';
				  	pc_source <= "10";
				  	next_state <= fetch;
				
				elsif opcode = slti then
				  	source_alu_a <= "01";
				  	source_alu_b <= "10";
				  	alu_operation <= "100";
				  	next_state <= writeback;
				
				elsif opcode = jal then
				   	enable_program_counter <= '1';
				   	pc_source <= "10";
				   	source_alu_a <= "00";
				   	source_alu_b <= "01";
				   	next_state <= writeback;   
				
				elsif opcode = r then
				  	if funct = jr then
				    	enable_program_counter <= '1';
				    	pc_source <= "00";
				    	source_alu_a <= "01";
				    	source_alu_b <= "00";
				    	next_state <= fetch;
				  	
				  	elsif funct = shiftll then
				    	source_alu_a <= "10";
				    	source_alu_b <= "00";
				    	alu_operation <= "101";
				    	next_state <= writeback;
				 	
				 	elsif funct = funct_or then					
						alu_operation <= "001";
						source_alu_a <= "01";
						source_alu_b <= "00";
						next_state <= writeback; 			
				 	
				 	elsif funct = funct_sub then
				   		source_alu_a <= "01";
				   		source_alu_b <= "00";
				   		alu_operation <= "011";--subtration
				   		next_state <= writeback;
				 	
				 	elsif funct = funct_and then
				   		source_alu_a <= "01";
				   		source_alu_b <= "00";
				   		alu_operation <= "000"; --and
				   		next_state <= writeback;							
				  	
				  	else
				   		source_alu_a <= "01";
				   		source_alu_b <= "00";
				  		next_state <= writeback;
					end if;

				elsif opcode = ori then
					source_alu_a <= "01";
					source_alu_b <= "10";
					alu_operation <= "001";
					next_state <= writeback;
			  	
			  	elsif opcode = lui then
					source_alu_a <= "11";
					source_alu_b <= "10";
					alu_operation <= "101";
					next_state <= writeback;				   
				end if;

			when mem =>
        	-- memory address calculation
				if opcode = lw then
          			read_memory <= '1';
					next_state <= writeback;
				
				else --if opcode = sw then
      				write_memory <= '1';
					next_state <= fetch; 
				end if;

			when writeback =>
			-- write regiter result
        		if opcode = lw then
   					mem_to_register <= '1';
 				
 				elsif opcode = slti or opcode = lui then
 					reg_dst <= "00";
 				
 				elsif opcode = jal then
 				 	reg_dst <= "10";       
        
        		else
					reg_dst <= "01";
        		end if;
				
				write_register <= '1';
				next_state <= fetch;
		end case;
    
    end if;
	end process;

end behavioral;

