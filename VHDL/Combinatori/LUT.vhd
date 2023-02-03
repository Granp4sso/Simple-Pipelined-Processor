library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LUT is

    port
        ( opCode  : in std_logic_vector(3 downto 0);
          signals : out std_logic_vector(11 downto 0)
        );

end LUT;

architecture Behavioral of LUT is
begin
  --CONTROL WORD FORMAT:
  --Write registers - Alu Source - Alu Operation[3] - Branch - Jump - Write Memory - Read Memory - Memory or Result - Immediate Source[2]
  with opCode select
    signals <= 
		"000000000000" when "0000", --NOP
		"110100000000" when "0001", --ADD
		"110110000000" when "0010", --SUB
		"100100000000" when "0011", --ADDi
		"111010000000" when "0100", --OR
		"101010000000" when "0101", --ORi
		"111000000000" when "0110", --AND
		"101000000000" when "0111", --ANDi
		"100000000000" when "1000", --MOVE
		"100010000010" when "1001", --SETR
		"000000010001" when "1010", --SW
		"100000001110" when "1011", --LW
		"000000100000" when "1100", --JAM
		"010111000000" when "1101", --BEQ
		"101100000000" when "1110", --SHR
		"101110000000" when "1111", --SHL
		"000000000000" when others; --NOP

end Behavioral;

