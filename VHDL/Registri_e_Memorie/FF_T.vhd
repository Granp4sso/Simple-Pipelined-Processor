library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity FF_T is
	port( 
		T: in std_logic;
		abi : in std_logic;
		clk: in std_logic;
		reset: in std_logic;
		Q: out std_logic
	);
end FF_T ;
 
architecture Behavioral of FF_T  is
signal tmp: std_logic;
begin
	process (clk)
		begin
		if reset = '1' then
			tmp <= '0';
		elsif falling_edge(clk) and abi = '1' then
			if T='0' then
				tmp <= tmp;
			elsif T='1' then
				tmp <= not (tmp);
			end if;
		end if;
	end process;
	Q <= tmp;
end Behavioral;
