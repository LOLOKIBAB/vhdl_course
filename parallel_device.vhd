library STD;  
library IEEE;                         
use STD.textio.all; 
use IEEE.NUMERIC_STD.ALL; 
use IEEE.std_logic_1164.all;  
use IEEE.std_logic_textio.all;

entity parallel_device is
	generic(n: natural:=4);
	port(
			input_vector: in std_logic_vector((2**n)-1 downto 0);
			output_vector: out std_logic_vector(1 downto 0)
		);
end entity;

architecture behavior of parallel_device is

begin
	main: process(input_vector)  
		variable temp_vector: std_logic_vector(n-1 downto 0);
		variable counter: natural := 0;
		variable flags: std_logic_vector(n-1 downto 1);
		variable result: std_logic_vector(1 downto 0) := "11";
		begin 
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
					flags(counter) := input_vector(i);
				elsif flags(counter) /= input_vector(i) then
					result := "10";
					exit ev;
				end if;
			end loop;
			output_vector <= result;
	end process main;
end architecture;


