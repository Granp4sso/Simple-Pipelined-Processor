library IEEE;
use IEEE.std_logic_1164.all;
entity mux_16bit_3_1 is
port(
  a1      : in  std_logic_vector(15 downto 0);
  a2      : in  std_logic_vector(15 downto 0);
  a3      : in  std_logic_vector(15 downto 0);
  sel     : in  std_logic_vector(1 downto 0);
  b       : out std_logic_vector(15 downto 0));
end mux_16bit_3_1;
architecture rtl of mux_16bit_3_1 is

begin
  with sel select
    b <= a1 when "00",
       a2 when "01",
       a3 when "10",
	   "0000000000000000" when others;
end rtl;