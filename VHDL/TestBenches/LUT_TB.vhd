library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LUT_TB is
end LUT_TB;

architecture Behavioral of LUT_TB is

	component LUT
    port
        ( opCode  : in std_logic_vector(3 downto 0);
          signals : out std_logic_vector(11 downto 0)
        );
    end component;
	
	--inputs
    signal opCode: std_logic_vector(3 downto 0);

 	--outputs

    signal signals : std_logic_vector(11 downto 0);
    
begin
	
	-- instantiate the unit under test (uut)
    uut: LUT
        port map
            ( opCode => opCode,
           signals => signals 
            );

	process begin
	
		opCode <= "0000";
		
		wait for 1 ns;
		
		opCode <= "0001";
		
		wait for 1 ns;
		
		opCode <= "0010";
		
		wait for 1 ns;
		
		opCode <= "0011";
		
		wait for 1 ns;
		opCode <= "0100";
		
		wait for 1 ns;
		
		opCode <= "0101";
		
		wait for 1 ns;
		
		opCode <= "0110";
		
		wait for 1 ns;
		
		opCode <= "0111";
		
		wait for 1 ns;
		
		opCode <= "1000";
		
		wait for 1 ns;
		
		opCode <= "1001";
		
		wait for 1 ns;
		
		opCode <= "1010";
		
		wait for 1 ns;
		
		opCode <= "1011";
		
		wait for 1 ns;
		
		opCode <= "1100";
		
		wait for 1 ns;
		
		opCode <= "1101";
		
		wait for 1 ns;
		
		opCode <= "1110";
		
		wait for 1 ns;
		
		opCode <= "1111";
		
		wait for 1 ns;
		

		
		assert false report "End of test";
		wait;
	
	end process;

end Behavioral;