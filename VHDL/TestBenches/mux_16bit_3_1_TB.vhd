library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_16bit_3_1_TB is
end mux_16bit_3_1_TB;

architecture Behavioral of mux_16bit_3_1_TB is

	component mux_16bit_3_1
    port(
	  a1      : in  std_logic_vector(15 downto 0);
	  a2      : in  std_logic_vector(15 downto 0);
	  a3      : in  std_logic_vector(15 downto 0);
	  sel     : in  std_logic_vector(1 downto 0);
	  b       : out std_logic_vector(15 downto 0));
    end component;
	
	--inputs
    signal a1_in : std_logic_vector(15 downto 0);
	signal a2_in : std_logic_vector(15 downto 0);
	signal a3_in : std_logic_vector(15 downto 0);
	signal sel_in : std_logic_vector(1 downto 0);

 	--outputs

    signal result : std_logic_vector(15 downto 0);
    
begin
	
	-- instantiate the unit under test (uut)
    uut: mux_16bit_3_1
        port map
            ( a1 => a1_in,
           a2 => a2_in,
		   a3 => a3_in,
		   sel => sel_in,
           b => result
            );

	process begin
	
		a1_in <= "0000000000000000";
		a2_in <= "1111111111111111";
		a3_in <= "1010101010101010";
		sel_in <= "00";
		
		wait for 1 ns;
		
		a1_in <= "0000000000000000";
		a2_in <= "1111111111111111";
		a3_in <= "1010101010101010";
		sel_in <= "01";
		
		wait for 1 ns;
		
		a1_in <= "0000000000000000";
		a2_in <= "1111111111111111";
		a3_in <= "1010101010101010";
		sel_in <= "10";
		
		wait for 1 ns;

		
		assert false report "End of test";
		wait;
	
	end process;

end Behavioral;