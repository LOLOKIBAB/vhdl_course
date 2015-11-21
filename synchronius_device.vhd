library STD;  
library IEEE;                         
use STD.textio.all; 
use IEEE.NUMERIC_STD.ALL; 
use IEEE.std_logic_1164.all;  
use IEEE.std_logic_textio.all;

entity synchronius_device is
	generic(n: natural:=7);
	port(
			input_vector: in std_logic_vector(15 downto 0);
			output_vector: out std_logic_vector(1 downto 0);
			clk: in std_logic;
			load: in std_logic
		);
end entity;

architecture behavior of synchronius_device is

	function reverse_bits(bits: std_logic_vector) return std_logic_vector is
		variable result: std_logic_vector(bits'range);
		variable n: natural := bits'length;
		begin
			for i in bits'range loop
				result(i) := bits(n-1-i);
			end loop;
			return result;
	end function;

	function find_last_one(bits: std_logic_vector) return natural is
		variable result: natural := bits'left;
		begin
			find_min: for i in bits'range loop
				if bits(i) = '1' then 
					result := i;
				end if;
			end loop;
			return result;
	end function;

	function generate_next_set(bits: std_logic_vector) return std_logic_vector is
		variable min_pos: natural;
		variable result: std_logic_vector(bits'range);
		variable temp: std_logic;
		begin 
			result := bits;
			find: for j in 1 to n-1 loop
				if result(j) = '0' and result(j-1) = '1' then
					min_pos := find_last_one(result(j-1 downto 0));
					temp := result(j);
					result(j) := result(min_pos);
					result(min_pos) := temp;
					result(j-1 downto 0) := reverse_bits(result(j-1 downto 0));
					exit find;
				end if;
			end loop;
			return result;
	end function;

begin
	main: process(clk)  
		variable start_vector: std_logic_vector(n-1 downto 0);
		variable temp_vector: std_logic_vector(n-1 downto 0);
		variable end_vector: std_logic_vector(n-1 downto 0);
		variable flag: std_logic;
		variable result: std_logic_vector(1 downto 0);
		variable data: std_logic_vector((2**n)-1 downto 0);
		begin 
			if(clk'event and clk = '1') then
				if(load = '0') then
					set_values: for i in start_vector'range loop
						start_vector(i) := '0';
					end loop;
					result := "11";
					start_set: for i in 1 to n-1 loop
						start_vector := to_stdlogicvector(to_bitvector(start_vector) sll 1);
						start_vector(0) := '1';
						temp_vector := start_vector;
						end_vector := reverse_bits(start_vector);
						flag := data(to_integer(unsigned(temp_vector)));
						gen_set: while temp_vector /= end_vector loop
							temp_vector := generate_next_set(temp_vector);
							if flag /= data(to_integer(unsigned(temp_vector))) then 
								result := "10";
								exit start_set;
							end if;
						end loop;
					end loop;
					output_vector <= result;
				else
					data := to_stdlogicvector(to_bitvector(data) sll 16);
					data(15 downto 0) := input_vector;
				end if;
			end if;
	end process main;
end architecture;


