library IEEE;
use IEEE.std_logic_1164.all;
entity AND_gate is
port(
  a : in std_logic;
  b : in std_logic;
  c : out std_logic);
end AND_gate ;

architecture rtl of AND_gate is

begin
  
  c <= a AND b;
  
end rtl;