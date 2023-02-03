library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SE_4_8 is
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0) := "0000";
           a_extended : out  STD_LOGIC_VECTOR (7 downto 0));
end SE_4_8;

architecture Behavioral of SE_4_8 is
begin
	with a(3) select
    a_extended <= "0000" & a when '0',
				  "1111" & a when '1',
				  "00000000" when others;

end Behavioral;