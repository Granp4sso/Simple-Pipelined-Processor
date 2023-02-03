library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is

    port
        ( operand_A  : in      signed (15 downto 0);
          operand_B  : in      signed (15 downto 0) ;
          operator   : in      std_logic_vector(2 downto 0);
          zero_flag  : out     std_logic := '0';
          result     : out     signed (15 downto 0)
        );

end ALU;

architecture Behavioral of ALU is
begin

    process (operator, operand_A , operand_B)
    begin
        case operator is
            when "000" =>  --LET OPERAND A
				result <= operand_A ;
				zero_flag <= '0';
			when "001" =>  --LET OPERAND B
				result <= operand_B ;
				zero_flag <= '0';
			when "010" =>  --SUM OPERAND A AND B
				result <= operand_A + operand_B;
				zero_flag <= '0';
			when "011" =>  --SUB OPERAND A AND B
				result <= operand_A - operand_B;
					if(operand_B = operand_A) 
						then zero_flag <= '1';
						else zero_flag <= '0';
					end if;
			when "100" =>  --AND OPERAND A AND B
				result <= operand_A and operand_B;
				zero_flag <= '0';
			when "101" =>  --OR OPERAND A AND B
				result <= operand_A or operand_B ;
				zero_flag <= '0';
			when "110" =>  --RIGHT SHIFT OPERAND A BY 1 (NOT IMPLEMENTED)
				result <= operand_A ;
				zero_flag <= '0';
			when "111" =>  --LEFT SHIFT OPERAND A BY 1 (NOT IMPLEMENTED)
				result <= operand_A ;
				zero_flag <= '0';
			when others =>
				result <= operand_A;
				zero_flag <= '0';
        end case;
    end process;

end Behavioral;

