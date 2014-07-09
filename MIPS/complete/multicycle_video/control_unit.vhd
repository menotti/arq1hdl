library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is 
  port (
    clock: in std_logic;
    instruction: in std_logic_vector (31 downto 0);
	  msb_a: in std_logic;
    enable_program_counter,
    enable_alu_output_register: out std_logic := '0';
    enable_decoder: out std_logic;
    register1, register2, register3: out std_logic_vector (4 downto 0);
    write_register, mem_to_register: out std_logic;
    source_alu_a: out std_logic_vector (1 downto 0); 
    source_alu_b: out std_logic_vector (2 downto 0);
    pc_source: out std_logic_vector (1 downto 0);  
    reg_dst: out std_logic_vector(1 downto 0);
    alu_operation: out std_logic_vector (2 downto 0);
    read_memory, write_memory: out std_logic;
    byte_offset: out std_logic_vector (1 downto 0);
    jump_offset: out std_logic_vector (25 downto 0);
    branch_cp_z_control: out std_logic; -- branch comparing to zero control
    bne_control: out std_logic;
    syscall_control:out std_logic;
    v0_syscall : in std_logic_vector (31 downto 0));
end control_unit;

architecture behavioral of control_unit is
  type state is (fetch, decode, alu, mem, writeback);
  signal next_state: state := fetch;
  signal opcode: std_logic_vector(5 downto 0);
  signal funct: std_logic_vector(5 downto 0);
  signal branch_funct: std_logic_vector(4 downto 0);
  
  
  constant r             : std_logic_vector(5 downto 0) := "000000";
  constant j             : std_logic_vector(5 downto 0) := "000010";
  constant jal           : std_logic_vector(5 downto 0) := "000011";
  constant addi          : std_logic_vector(5 downto 0) := "001000";
  constant slti          : std_logic_vector(5 downto 0) := "001010";
  constant ori           : std_logic_vector(5 downto 0) := "001101";
  constant andi          : std_logic_vector(5 downto 0) := "001100";
  constant xori          : std_logic_vector(5 downto 0) := "001110";
  constant lui           : std_logic_vector(5 downto 0) := "001111"; 
  constant lw            : std_logic_vector(5 downto 0) := "100011";
  constant sw            : std_logic_vector(5 downto 0) := "101011";
  constant branch_cp_z   : std_logic_vector(5 downto 0) := "000001"; -- bltz; bgez; bltzal; bgezal
  constant bne           : std_logic_vector(5 downto 0) := "000101";
  constant sb            : std_logic_vector(5 downto 0) := "101000";
  constant lbu           : std_logic_vector(5 downto 0) := "100000";
  
  constant funct_sll     : std_logic_vector(5 downto 0) := "000000";
  constant funct_sllv    : std_logic_vector(5 downto 0) := "000100";  
  constant funct_jr      : std_logic_vector(5 downto 0) := "001000";
  constant funct_jalr    : std_logic_vector(5 downto 0) := "001001";
  constant funct_sub     : std_logic_vector(5 downto 0) := "100010";
  constant funct_and     : std_logic_vector(5 downto 0) := "100100";
  constant funct_or      : std_logic_vector(5 downto 0) := "100101";
  constant funct_xor     : std_logic_vector(5 downto 0) := "100110";
  constant funct_nand    : std_logic_vector(5 downto 0) := "101101"; --45
  
  constant funct_bgezal  : std_logic_vector(4 downto 0) := "10001";
  constant funct_bltz    : std_logic_vector(4 downto 0) := "00000";
  constant funct_bgez    : std_logic_vector(4 downto 0) := "00001";
  constant funct_syscall : std_logic_vector(5 downto 0) := "001100";

begin
  
  opcode <= instruction(31 downto 26);
  funct <= instruction(5 downto 0);
  register1 <= instruction(25 downto 21);
  register2 <= instruction(20 downto 16);
  register3 <= instruction(15 downto 11);
  byte_offset <= instruction(1 downto 0);
  jump_offset <= instruction(25 downto 0);
  branch_funct <= instruction(20 downto 16);

  next_state_function: process(clock)
  begin
    if rising_edge(clock) then
      alu_operation <= "010";
      pc_source <= "00";
      enable_alu_output_register <= '0';
      enable_program_counter <= '0';
      enable_decoder <= '0';
      read_memory <= '0';
      reg_dst <= "00";
      source_alu_a <= "00";
      source_alu_b <= "001";
      mem_to_register <= '0';
      write_memory <= '0';
      write_register <= '0';
	  syscall_control <= '0';

      case next_state is
      when fetch =>
        enable_program_counter <= '1';
        next_state <= decode;
      when decode =>
	      enable_alu_output_register <= '1';
          source_alu_a <= "00";
          source_alu_b <= "010";
          alu_operation <= "010";
         next_state <= alu;
      when alu =>
        enable_alu_output_register <= '1';
        if opcode = lw then
          source_alu_a <= "01";
          source_alu_b <= "011";
          next_state <= mem;
        elsif opcode = sw then
          source_alu_a <= "01";
          source_alu_b <= "011";
          next_state <= mem;
        elsif opcode = sb then
          source_alu_a <= "01";
          source_alu_b <= "011";
          next_state <= mem;
        elsif opcode = lbu then
	        source_alu_a <= "01";
	       	source_alu_b <= "011";
	        next_state <= mem; 
        elsif opcode = j then
          enable_program_counter <= '1';
          pc_source <= "10";
          next_state <= fetch;
        elsif opcode = slti then
          source_alu_a <= "01";
          source_alu_b <= "010";
          alu_operation <= "100";
          next_state <= writeback;
        elsif opcode = jal then
          enable_program_counter <= '1';
          pc_source <= "10";
          source_alu_a <= "00";
          source_alu_b <= "001";
          next_state <= writeback;
        elsif opcode = ori then
          source_alu_a <= "01";
          source_alu_b <= "010";
          alu_operation <= "001";
          next_state <= writeback;
		    elsif opcode = andi then
		      source_alu_a <= "01";
		      source_alu_b <= "010";
		      alu_operation <= "000";
		      next_state <= writeback;		  
        elsif opcode = xori then
          source_alu_a <= "01";
          source_alu_b <= "010";
          alu_operation <= "001";
          next_state <= writeback;
        elsif opcode = addi then
          source_alu_a <= "01";
          source_alu_b <= "010";
          next_state <= writeback;
        elsif opcode = lui then
          source_alu_a <= "11";
          source_alu_b <= "010";
          alu_operation <= "101";
          next_state <= writeback;
		    elsif opcode = branch_cp_z then
		      if branch_funct = funct_bltz then
            enable_program_counter <= '1';
            pc_source <= "11";
            source_alu_a <= "01"; 
            source_alu_b <= "000";
            branch_cp_z_control <= '1';
            next_state <= fetch;
		      elsif branch_funct = (funct_bgezal or funct_bgez) then
		        enable_alu_output_register <= '1';
            source_alu_a <= "00";
            source_alu_b <= "100";
            alu_operation <= "010";
			      next_state <= writeback;
		      end if;
        elsif opcode = bne then
          enable_program_counter <= '1';
          pc_source <= "11";
          source_alu_a <= "01";
          source_alu_b <= "000";
          alu_operation <= "011";
          bne_control <= '1';
          next_state <= fetch;
        elsif opcode = r then
          if funct = funct_jr then
            enable_program_counter <= '1';
            pc_source <= "00";
            source_alu_a <= "01";
            source_alu_b <= "000";
            next_state <= fetch;
          elsif funct = funct_jalr then
            source_alu_a <= "00";
            source_alu_b <= "001";
            next_state <= mem;
          elsif funct = funct_sllv then
            source_alu_a <= "01";
            source_alu_b <= "000";
            alu_operation <= "101";
            next_state <= writeback;
          elsif funct = funct_sll then
            source_alu_a <= "10";
            source_alu_b <= "000";
            alu_operation <= "101";
            next_state <= writeback;
          elsif funct = funct_or then          
            alu_operation <= "001";
            source_alu_a <= "01";
            source_alu_b <= "000";
            next_state <= writeback;
          elsif funct = funct_sub then
            source_alu_a <= "01";
            source_alu_b <= "000";
            alu_operation <= "011";
            next_state <= writeback;
          elsif funct = funct_and then
            source_alu_a <= "01";
            source_alu_b <= "000";
            alu_operation <= "000"; --and
            next_state <= writeback;
          elsif funct = funct_xor then
            source_alu_a <= "01";
            source_alu_b <= "000";
            alu_operation <= "110";
            next_state <= writeback;
          elsif funct = funct_nand then
            source_alu_a <= "01";
            source_alu_b <= "000";
            alu_operation <= "111"; --nand
            next_state <= writeback;
	    --implementacao da syscall
          elsif funct = funct_syscall then
            --register1 <= "00100"; -- a0
            --register2 <= "00010"; -- v0
            syscall_control <= '1';
            next_state <= fetch; 
          else
            source_alu_a <= "01";
            source_alu_b <= "000";
            next_state <= writeback;
          end if;  
        end if;
      when mem =>
        if opcode = lw then
          read_memory <= '1';
          next_state <= writeback;
        elsif funct = funct_jalr then
          reg_dst <= "10";
          write_register <= '1';
          next_state <= writeback;
        elsif opcode = sw then
          write_memory <= '1';
          next_state <= fetch;
        elsif opcode = sb then
          write_memory <= '1';
          enable_decoder <= '1';
          next_state <= fetch; 
        elsif opcode = lbu then
		      read_memory <= '1';
		      enable_decoder <= '1';
		      next_state <= writeback;
        end if;
      when writeback =>
        if opcode = lw or opcode = lbu then
          mem_to_register <= '1';
          write_register <= '1';
        elsif opcode = slti or opcode = lui then
          reg_dst <= "00";
          write_register <= '1';
        elsif opcode = jal then
          reg_dst <= "10"; 
          write_register <= '1';
        elsif funct = funct_jalr then
          enable_program_counter <= '1';
          pc_source <= "00";
          source_alu_a <= "01";
          source_alu_b <= "000";
        elsif opcode = addi then
          mem_to_register <= '0';
          write_register <= '1';
          
        elsif opcode = branch_cp_z then
           if branch_funct = funct_bgezal then
             source_alu_a <= "00";
             source_alu_b <= "011";
             alu_operation <= "010";
			     if msb_a = '0' then
			       pc_source <= "00";
			       reg_dst <= "10";
      	      mem_to_register <= '0';
    			      write_register <= '1';
    			      enable_program_counter <= '1';
  			     end if; -- msb_a = '0'
 			     elsif branch_funct = funct_bgez then
 			       source_alu_a <= "00";
             source_alu_b <= "011";
             alu_operation <= "010";
			       if msb_a = '0' then
			         pc_source <= "00";
       			     enable_program_counter <= '1';
       			   end if; -- msb_a = '0'
  			     end if; -- branch_funct
                                  
                  elsif funct = funct_syscall then
          if v0_syscall = "00000000000000000000000000000110" then
            
          end if;               
                    
        else
          reg_dst <= "01";
          write_register <= '1';
        end if;        
        next_state <= fetch;
      end case;    
    end if;
  end process;
end behavioral;

