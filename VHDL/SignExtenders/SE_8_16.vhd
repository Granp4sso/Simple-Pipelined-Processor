library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SE_8_16 is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0) := "00000000";
           a_extended : out  STD_LOGIC_VECTOR (15 downto 0));
end SE_8_16;

architecture Behavioral of SE_8_16 is
begin
	with a(3) select
    a_extended <= "00000000" & a when '0',
				  "11111111" & a when '1',
				  "0000000000000000" when others;

end Behavioral;