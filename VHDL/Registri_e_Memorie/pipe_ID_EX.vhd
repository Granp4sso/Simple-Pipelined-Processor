library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pipe_ID_EX is

    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  flush		: in std_logic;
          clk       : in std_logic;
		  
          next_PC_in   : in std_logic_vector(7 downto 0) := "00000000";    
		  offset_branch_in : in std_logic_vector(7 downto 0) := "00000000";
		  jump_address_in : in std_logic_vector(7 downto 0) := "00000000";
          control_signals_in : in std_logic_vector(9 downto 0);
		  register_source_1_in: in std_logic_vector(3 downto 0);
		  register_source_2_in: in std_logic_vector(3 downto 0);
		  register_destination_in : in std_logic_vector(3 downto 0);
		  register_data_1_in : in std_logic_vector(15 downto 0);
		  register_data_2_in : in std_logic_vector(15 downto 0);
		  immediate_in : in std_logic_vector(15 downto 0);
		  address_mem_in : in std_logic_vector(7 downto 0);
		  
		  next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";    
		  offset_branch_out : out std_logic_vector(7 downto 0) := "00000000";
		  jump_address_out : out std_logic_vector(7 downto 0) := "00000000";
          control_signals_out : out std_logic_vector(9 downto 0);
		  register_source_1_out: out std_logic_vector(3 downto 0);
		  register_source_2_out: out std_logic_vector(3 downto 0);
		  register_destination_out : out std_logic_vector(3 downto 0);
		  register_data_1_out : out std_logic_vector(15 downto 0);
		  register_data_2_out : out std_logic_vector(15 downto 0);
		  immediate_out : out std_logic_vector(15 downto 0);
		  address_mem_out : out std_logic_vector(7 downto 0)
        );
end pipe_ID_EX;

architecture Behavioral of pipe_ID_EX is
	
begin

    process (reset, clk, stall, flush)
    begin
        if (reset = '1') then
          next_PC_out <= (others => '0');
		  offset_branch_out <= (others => '0');
		  jump_address_out <= (others => '0');
          control_signals_out <= (others => '0');
		  register_source_1_out <= (others => '0');
		  register_source_2_out <= (others => '0');
		  register_destination_out <= (others => '0');
		  register_data_1_out <= (others => '0');
		  register_data_2_out <= (others => '0');
		  immediate_out <= (others => '0');
		  address_mem_out <= (others => '0');
		  
		elsif rising_edge(clk) and stall = '0' then
		
			if(flush = '1') then
				next_PC_out <= (others => '0');
				offset_branch_out <= (others => '0');
				jump_address_out <= (others => '0');
				control_signals_out <= (others => '0');
				register_source_1_out <= (others => '0');
				register_source_2_out <= (others => '0');
				register_destination_out <= (others => '0');
				register_data_1_out <= (others => '0');
				register_data_2_out <= (others => '0');
				immediate_out <= (others => '0');
				address_mem_out <= (others => '0');
			else
				next_PC_out <= next_PC_in;
				offset_branch_out <= offset_branch_in;
				jump_address_out <= jump_address_in;
				control_signals_out <= control_signals_in;
				register_source_1_out <= register_source_1_in ;
				register_source_2_out <= register_source_2_in;
				register_destination_out <= register_destination_in;
				register_data_1_out <= register_data_1_in;
				register_data_2_out <= register_data_2_in;
				immediate_out <= immediate_in;
				address_mem_out <= address_mem_in;
			end if;
			
        end if;
    end process;

end Behavioral;

