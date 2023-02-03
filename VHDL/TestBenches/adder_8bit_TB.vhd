library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_8bit_TB is
end adder_8bit_TB;

architecture Behavioral of adder_8bit_TB is

	component adder_8bit
    Port ( a : in  signed(7 downto 0) ;
           b : in  signed(7 downto 0);
           sum : out  signed(7 downto 0));
    end component;
	
	--inputs
    signal a_in : signed(7 downto 0);
	signal b_in : signed(7 downto 0);

 	--outputs

    signal result : signed(7 downto 0);
    
begin
	
	-- instantiate the unit under test (uut)
    uut: adder_8bit
        port map
            ( a => a_in,
           b => b_in ,
           sum => result
            );

	process begin
	
		a_in <= "00000000";
		b_in <= "00000000";
		
		wait for 1 ns;
		
		a_in <= "00000100";
		b_in <= "00000100";
		
		wait for 1 ns;
		
		a_in <= "10000000";
		b_in <= "01000000";
		
		wait for 1 ns;
		
		a_in <= "00000010";
		b_in <= "00000001";
		
		wait for 1 ns;
		
		assert false report "End of test";
		wait;
	
	end process;

end Behavioral;