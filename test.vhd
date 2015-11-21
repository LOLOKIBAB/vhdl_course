library IEEE;
use IEEE.std_logic_1164.all;

library STD;
use std.textio.all;

entity test is
	generic (n: natural := 4);
end test;

architecture behavior of test is
    component synchronius_device 
		generic(n: natural:=n);
		port(
				input_vector: in std_logic_vector(15 downto 0);
				output_vector: out std_logic_vector(1 downto 0);
				clk: in std_logic;
				load: in std_logic
			);
    end component;
    signal input_vector: std_logic_vector(15 downto 0);
    signal output_vector: std_logic_vector(1 downto 0);
    signal clk, load: std_logic;
begin

	load <= '1', '0' after 750 ns;

    input_vector <=

	"1111111111111111" after 0 ns, --True
	"1111011111100111" after 100 ns, --True
	"1111001100111111" after 200 ns, --False
	"1111100000011011" after 300 ns, --False
	"1111111111111111" after 400 ns, --True
	"1110000011111111" after 500 ns, --True
	"1111111100001111" after 600 ns, --False
	"1111100011111111" after 700 ns; --False

	clk_pr: process
	begin
		clk <= '1';
		wait for 50 ns;
		clk <= '0';
		wait for 50 ns;
	end process;

    scheme: synchronius_device port map(input_vector=>input_vector, output_vector=>output_vector, clk => clk, load => load);

end architecture;