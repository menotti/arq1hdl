library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity unit_of_control is 
	port (
		instruction: in std_logic_vector (31 downto 0);
		destination_register, register1, register2: out std_logic_vector (4 downto 0);
		write_register: out std_logic;
		alu_operation: out std_logic_vector (2 downto 0);
		read_memory, write_memory: out std_logic;
		offset: out std_logic_vector (15 downto 0));
end unit_of_control;

architecture behavioral of unit_of_control is
	-- Bellow the operations supported by the simplified version of the processor.
	constant r: std_logic_vector (5 downto 0) := "000000";
	constant lw: std_logic_vector (5 downto 0) := "100011";
	constant sw: std_logic_vector (5 downto 0) := "101011";

begin

	process(instruction)
	variable opcode: std_logic_vector (5 downto 0);
	begin
		-- Extracts the opcode from the instruction.
		opcode := instruction(31 downto 26);

		if opcode = r then -- aritmetic and logic operation.
			-- Extracts the destination register.
			destination_register <= instruction(25 downto 21);
			-- Extracts the "left hand side" register.
			register1 <= instruction(20 downto 16);
			-- Extracts the "right hand side" register.
			register2 <= instruction(15 downto 11);
			-- Extracts the interesting values from the function field.
			alu_operation <= instruction(2 downto 0);
			write_register <= '1';
			read_memory <= '0';
			write_memory <= '0';
			offset <= "XXXXXXXXXXXXXXXX";
		elsif opcode = lw then -- load word operation.
			-- Extracts the destination register.
			destination_register <= instruction(25 downto 21);
			-- Extracts the base register.
			register1 <= instruction(20 downto 16);
			register2 <= "XXXXX";
			-- Extracts the offset.
			offset <= instruction(15 downto 0);
			read_memory <= '1';
			write_register <= '1';
			write_memory <= '0';
			alu_operation <= "XXX";
		elsif opcode = sw then -- store word operation.
			-- Extracts the value of origin register.
			register1 <= instruction(25 downto 21);
			-- Extracts the base register.
			register2 <= instruction(20 downto 16);
			-- Extracts the offset.
			offset <= instruction(15 downto 0);
			write_memory <= '1';
			destination_register <= "XXXXX";
			read_memory <= '0';
			write_register <= '0';
			alu_operation <= "XXX";
			end if;  
	end process;

end behavioral;
 
