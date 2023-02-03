library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PC is

    port
        ( reset     : in std_logic;
		  pc_en     : in std_logic;
          clk       : in std_logic;
          next_address : in std_logic_vector(7 downto 0) := "00000000";     
          next_instruction : out std_logic_vector(7 downto 0)
        );
end PC;

architecture Behavioral of PC is

    signal next_PC : std_logic_vector(7 downto 0) := "00000000";
	
begin

    process (reset, clk, pc_en)
    begin
        if (reset = '1') then
            next_instruction <= (others => '0');
			next_PC <= (others => '0');
		elsif falling_edge(clk) and pc_en = '1' then
			--next_PC <= next_address;
			next_instruction <= next_address;
        --elsif rising_edge(clk) and pc_en = '1' then
        --    next_instruction <= next_PC;
        end if;
    end process;

end Behavioral;

