library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pipe_EX_MEM is
    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  --flush		: in std_logic;
          clk       : in std_logic;
		  
          control_signals_in : in std_logic_vector(3 downto 0);
		  ALU_result_in : in std_logic_vector(15 downto 0);
		  register_destination_in : in std_logic_vector(3 downto 0);
		  address_mem_in : in std_logic_vector(7 downto 0);
		  register_source_1_in : in std_logic_vector(3 downto 0);
		  register_source_2_in : in std_logic_vector(3 downto 0);
		  
		  control_signals_out : out std_logic_vector(3 downto 0);
		  ALU_result_out : out std_logic_vector(15 downto 0);
		  register_destination_out : out std_logic_vector(3 downto 0);
		  address_mem_out : out std_logic_vector(7 downto 0);
		  register_source_1_out : out std_logic_vector(3 downto 0);
		  register_source_2_out : out std_logic_vector(3 downto 0)
        );
end pipe_EX_MEM;

architecture Behavioral of pipe_EX_MEM is
	
begin

    process (reset, clk, stall)
    begin
        if (reset = '1') then
          control_signals_out <= (others => '0');
		  ALU_result_out <= (others => '0');
		  register_destination_out <= (others => '0');
		  address_mem_out <= (others => '0');
		  register_source_1_out <= (others => '0');
		  register_source_2_out <= (others => '0');
		  
		elsif rising_edge(clk) and stall = '0' then
		  control_signals_out <= control_signals_in;
		  ALU_result_out <= ALU_result_in;
		  register_destination_out <= register_destination_in;
		  address_mem_out <= address_mem_in;
		  register_source_1_out <= register_source_1_in;
		  register_source_2_out <= register_source_2_in;
        end if;
    end process;

end Behavioral;

