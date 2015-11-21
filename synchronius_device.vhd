library STD;  
library IEEE;                         
use STD.textio.all; 
use IEEE.NUMERIC_STD.ALL; 
use IEEE.std_logic_1164.all;  
use IEEE.std_logic_textio.all;

entity synchronius_device is
	generic(n: natural:=5);
	port(
			input_vector: in std_logic_vector(15 downto 0);
			output_vector: out std_logic_vector(1 downto 0);
			clk: in std_logic;
			load: in std_logic
		);
end entity;

architecture behavior of synchronius_device is

begin
	main: process(clk)  
		variable start_vector: std_logic_vector(n-1 downto 0);
		variable temp_vector: std_logic_vector(n-1 downto 0);
		variable counter: natural := 0;
		variable index: natural;
		variable end_vector: std_logic_vector(n-1 downto 0);
		variable flags: std_logic_vector(n-1 downto 1);
		variable result: std_logic_vector(1 downto 0) := "11";
		variable data: std_logic_vector((2**N)-1 downto 0);
		begin 
			if(clk'event and clk = '1') then
				if(load = '0') then
					set_values: for i in flags'range loop
						flags(i) := 'U';
					end loop;
					ev: for i in 1 to 2**n-2 loop
						temp_vector := std_logic_vector(to_unsigned(i, n));
						counter := 0;
						for j in temp_vector'range loop
							if temp_vector(j) = '1' then
								counter := counter + 1;
							end if;
						end loop;
						if flags(counter) = 'U' then
							flags(counter) := data(i);
						elsif flags(counter) /= data(i) then
							result := "10";
							exit ev;
						end if;
					end loop;
					output_vector <= result;
				else
					data := to_stdlogicvector(to_bitvector(data) sll 16);
					data(15 downto 0) := input_vector;
				end if;
			end if;
	end process main;
end architecture;


