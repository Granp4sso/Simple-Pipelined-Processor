library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SE_to_adder_TB is
end SE_to_adder_TB;

architecture Behavioral of SE_to_adder_TB is

	component adder_8bit
    Port ( a : in  signed(7 downto 0) ;
           b : in  signed(7 downto 0);
           sum : out  signed(7 downto 0));
    end component;
	
	component SE_4_8
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0) := "0000";
           a_extended : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
	
	--inputs
    signal a_in : STD_LOGIC_VECTOR(3 downto 0);
	signal b_in : signed(7 downto 0);

 	--outputs

    signal result : signed(7 downto 0);
	
	--input/outputs
    signal a_extended_in : STD_LOGIC_VECTOR(7 downto 0);
	
begin
	
	-- instantiate the unit under test (uut)
	
	uut1: SE_4_8
        port map
            ( a => a_in,
			a_extended => a_extended_in        
			);
			
    uut2: adder_8bit
        port map
            ( a => signed(a_extended_in),
           b => b_in ,
           sum => result
            );

	process begin
	
		a_in <= "0110";
		b_in <= "00010000";
		
		wait for 1 ns;
		
		a_in <= "1110";
		b_in <= "00011000";
		
		wait for 1 ns;
		

		assert false report "End of test";
		wait;
	
	end process;

end Behavioral;