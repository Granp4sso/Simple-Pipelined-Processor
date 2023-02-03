library IEEE;
use IEEE.std_logic_1164.all;
entity mux_8bit_2_1 is
port(
  a1      : in  std_logic_vector(7 downto 0);
  a2      : in  std_logic_vector(7 downto 0);
  sel     : in  std_logic;
  b       : out std_logic_vector(7 downto 0));
end mux_8bit_2_1;
architecture rtl of mux_8bit_2_1 is

begin
  with sel select
    b <= a1 when '0',
       a2 when '1',
	   "00000000" when others;
end rtl;