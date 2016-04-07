library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity t_alu is
	generic (width: integer := 4);
end t_alu;

architecture behavioral of t_alu is

	component alu_x
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
		operation: in std_logic_vector (2 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
end component;

	signal a, b, result: std_logic_vector (width - 1 downto 0);
	signal operation: std_logic_vector (2 downto 0);
	signal zero: std_logic_vector (width - 1 downto 0) := (others => '0');
	signal one: std_logic_vector (width - 1 downto 0) := (0 => '1', others => '0');

	function to_string (signal sl_vector: std_logic_vector) return string is
	use std.textio.all; 
	variable b_vector: bit_vector (sl_vector'range) := to_bitvector(sl_vector);
	variable ln: line;
	begin
		write(ln, b_vector);
		return ln.all;
	end;

	procedure report_result(description: string) is
	begin
		report "operation = " & to_string(operation) & "(" & description & ")";
	report "result = " & to_string(result);
end;

	begin

		alu: alu_x generic map (width) port map (a, b, operation, result);

		process
		begin

			report "Starting test bench";

			a <= "0101";
			b <= "0011";
			operation <= "000";
			wait for 100 ns;

			report "a = " & to_string(a);
			report "b = " & to_string(b);
			report_result("bitwise and");
			assert result = (a and b);

			operation <= "001";
			wait for 100 ns;

			report_result("bitwise or");
			assert result = (a or b);

			operation <= "010";
			wait for 100 ns;

			report_result("adition");
			assert result = (a + b);

			operation <= "011";
			wait for 100 ns;

			report_result("subtraction");
			assert result = (a - b);

			operation <= "100";
			wait for 100 ns;

			report_result("set on less than");
			assert result = zero;

			a <= "0111";
			b <= "1000";
			wait for 100 ns;

			report "a = " & to_string(a);
			report "b = " & to_string(b);
			report_result("set on less than");
			assert result = one;

			wait;

		end process;

end behavioral;

