library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity processor is
	port (clock, turn_off: in std_logic;
		current_instruction, data_in_last_modified_register: 
		out std_logic_vector (31 downto 0));
end processor;

architecture behavioral of processor is

	component program_counter 
		generic (address_width: integer := 32);
		port (
			clock: in std_logic;
			next_address: out std_logic_vector (address_width - 1 downto 0));
	end component;

	component instructions_memory 
		generic (
			length: integer := 256;
			address_width: integer := 32;
			data_width: integer := 32);

		port (
			address_to_read: in std_logic_vector (address_width - 1 downto 0);
			instruction_out: out std_logic_vector (data_width - 1 downto 0));
	end component;

	component unit_of_control 
		port (
			instruction: in std_logic_vector (31 downto 0);
			destination_register, register1, register2: out std_logic_vector (4 downto 0);
			write_register: out std_logic;
			alu_operation: out std_logic_vector (2 downto 0);
			read_memory, write_memory: out std_logic;
			offset: out std_logic_vector (15 downto 0));
	end component;

	component register_bank
		generic (width: integer := 32);

		port (
			register_to_read1, register_to_read2, register_to_write: 
			in std_logic_vector (4 downto 0);
		write: in std_logic;
		data_to_write: in std_logic_vector (width - 1 downto 0);
		data_out1, data_out2: out std_logic_vector (width - 1 downto 0));
	end component;

	component data_memory 
		generic (
			length: integer := 256;
			address_width: integer := 32;
			data_width: integer := 32);

		port (
			address_to_read, address_to_write: 
			in std_logic_vector (address_width - 1 downto 0);
			data_to_write: in std_logic_vector (data_width - 1 downto 0);
			read, write: in std_logic;
			data_out: out std_logic_vector (data_width - 1 downto 0));
	end component;

	component alu_x
		generic (width: integer := 32);

		port (
			a, b: in std_logic_vector (width - 1 downto 0);
		operation: in std_logic_vector (2 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	signal clk: std_logic;
	signal address_of_next_instruction: std_logic_vector (31 downto 0);
	signal instruction: std_logic_vector (31 downto 0);
	signal destination_register, register1, register2: std_logic_vector (4 downto 0);
	signal write_register, read_memory, write_memory: std_logic;
	signal address_to_read, address_to_write: std_logic_vector (31 downto 0);
	signal offset: std_logic_vector (15 downto 0);
	signal data_from_register1, data_from_register2, data_to_write_in_register, data_from_memory, 			data_from_alu: std_logic_vector(31 downto 0);
	signal aritmetic_and_logic_operation: std_logic_vector (2 downto 0);

begin

		address_to_read <= data_from_register1 + offset; 
		address_to_write <= data_from_register2 + offset;
		data_to_write_in_register <= data_from_memory when aritmetic_and_logic_operation = "XXX" 			else data_from_alu;
		current_instruction <= instruction;
		data_in_last_modified_register <= data_to_write_in_register;

		counter: program_counter port map (clk, address_of_next_instruction);

		memory_of_instructions: instructions_memory port map (address_of_next_instruction, 			instruction);

		control: unit_of_control port map (instruction, destination_register, register1, 			register2, write_register, 			aritmetic_and_logic_operation, 			read_memory, write_memory, offset);

		bank_of_registers: register_bank port map (register1, register2, destination_register, 			write_register, data_to_write_in_register, data_from_register1, data_from_register2);  

		memory_of_data : data_memory port map (address_to_read, address_to_write, 			data_from_register1, read_memory, write_memory, data_from_memory);     

		alu: alu_x port map (data_from_register1, data_from_register2, 			aritmetic_and_logic_operation, data_from_alu);

		process (clock, turn_off)
		begin
			if turn_off /= '1' then
				clk <= clock;
			end if; 
		end process;
 
end behavioral;

