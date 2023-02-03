library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SE_4_8_TB is
end SE_4_8_TB;

architecture Behavioral of SE_4_8_TB is

	component SE_4_8
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);
           a_extended : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
	
	--inputs
    signal a_in : STD_LOGIC_VECTOR(3 downto 0);

 	--outputs

    signal result : STD_LOGIC_VECTOR (7 downto 0);
    
begin
	
	-- instantiate the unit under test (uut)
    uut: SE_4_8
        port map
            ( a   => a_in,
              a_extended  => result
            );

	process begin
	
		a_in <= "XXXX";
		
		wait for 1 ns;
		
		a_in <= "0101";
		
		wait for 1 ns;
		
		a_in <= "1100";
		
		wait for 1 ns;
		
		a_in <= "0000";
		
		wait for 1 ns;
		
		assert false report "End of test";
		wait;
	
	end process;

end Behavioral;