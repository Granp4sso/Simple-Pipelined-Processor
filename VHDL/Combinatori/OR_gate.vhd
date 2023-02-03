library IEEE;
use IEEE.std_logic_1164.all;
entity OR_gate is
port(
  a : in std_logic;
  b : in std_logic;
  c : out std_logic);
end OR_gate ;

architecture rtl of OR_gate is

begin
  
  c <= a OR b;
  
end rtl;