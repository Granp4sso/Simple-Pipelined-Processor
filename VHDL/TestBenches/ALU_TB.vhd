library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is

	component ALU
    port
        ( operand_A  : in      signed (15 downto 0);
          operand_B  : in      signed (15 downto 0) ;
          operator   : in      std_logic_vector(2 downto 0);
          zero_flag  : out     std_logic := '0';
          result     : out     signed (15 downto 0)
        );
    end component;
	
	--inputs
    signal operand_A: signed(15 downto 0);
	signal operand_B : signed(15 downto 0);
	signal operator : std_logic_vector(2 downto 0);

 	--outputs

    signal result : signed(15 downto 0);
	signal zero_flag : std_logic;
    
begin
	
	-- instantiate the unit under test (uut)
    uut: ALU
        port map
            ( operand_A => operand_A,
           operand_B => operand_B ,
           operator => operator,
		   zero_flag => zero_flag,
		   result => result
            );

	process begin
	
		operand_A <= x"00AA";
		operand_B <= x"00AA";
		
		operator <= "000";
		
		wait for 1 ns;
		
		operator <= "001";
		
		wait for 1 ns;
		
		operator <= "010";
		
		wait for 1 ns;
		
		operator <= "011";
		
		wait for 1 ns;
		
		operator <= "100";
		
		wait for 1 ns;
		
		assert false report "End of test";
		wait;
	
	end process;

end Behavioral;