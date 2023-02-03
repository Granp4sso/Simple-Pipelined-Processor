library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pipe_IF_ID is

    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  flush		: in std_logic;
          clk       : in std_logic;
          next_PC_in   : in std_logic_vector(7 downto 0) := "00000000";     
          control_signals_in : in std_logic_vector(11 downto 0);
		  instruction_in : in std_logic_vector(15 downto 0);
		  
		  next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";     
          control_signals_out : out std_logic_vector(11 downto 0);
		  instruction_out : out std_logic_vector(15 downto 0)
        );
end pipe_IF_ID;

architecture Behavioral of pipe_IF_ID is
	
begin

    process (reset, clk, stall, flush)
    begin
        if (reset = '1') then
            next_PC_out <= (others => '0');
			control_signals_out <= (others => '0');
			instruction_out <= (others => '0');
		elsif rising_edge(clk) and stall = '0' then
		
			if(flush = '1') then
				next_PC_out <= (others => '0');
				control_signals_out <= (others => '0');
				instruction_out <= (others => '0');
			else
				next_PC_out <= next_PC_in;
				control_signals_out <= control_signals_in;
				instruction_out <= instruction_in;
			end if;
			
        end if;
    end process;

end Behavioral;

