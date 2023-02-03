library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_8bit is
    Port ( a : in  signed(7 downto 0) ;
           b : in  signed(7 downto 0);
           sum : out  signed(7 downto 0));
end adder_8bit;

architecture Behavioral of adder_8bit is
begin

    sum <= a + b;

end Behavioral;