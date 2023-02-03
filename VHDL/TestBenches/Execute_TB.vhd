LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY Execute_TB IS
END Execute_TB ;
 
ARCHITECTURE behavior OF Execute_TB  IS 
 
    COMPONENT Execute_stage 
    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  --flush		: in std_logic;
          clk       : in std_logic;
		  
		  --Ingressi della pipe_ID_EX
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
		  
		  --Ingressi esterni dal Data Hazard Control
		  forwarded_ALU_data : in std_logic_vector(15 downto 0);
		  forwarded_memory_data : in std_logic_vector(15 downto 0);
		  DHC_abi_A : in std_logic_vector(1 downto 0);
		  DHC_abi_B : in std_logic_vector(1 downto 0);
		  	  
		  --Uscite della pipe_EX_MEM
		  control_signals_out : out std_logic_vector(3 downto 0);
		  ALU_result_out : out std_logic_vector(15 downto 0);
		  register_destination_out : out std_logic_vector(3 downto 0);
		  address_mem_out : out std_logic_vector(7 downto 0);
		  register_source_1_out : out std_logic_vector(3 downto 0);
		  register_source_2_out : out std_logic_vector(3 downto 0);
		  
		  --Uscite ausiliarie
		  Branch_taken : out std_logic;
		  Jump_taken : out std_logic;
		  Address_out : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal reset : std_logic := '1';
   signal clk : std_logic := '1';
   signal stall : std_logic := '0';
   
   signal next_PC_in   : std_logic_vector(7 downto 0) := "00000000";    
   signal offset_branch_in : std_logic_vector(7 downto 0) := "00000000";
   signal jump_address_in : std_logic_vector(7 downto 0) := "00000000";
   signal control_signals_in : std_logic_vector(9 downto 0);
   signal register_source_1_in: std_logic_vector(3 downto 0);
   signal register_source_2_in: std_logic_vector(3 downto 0);
   signal register_destination_in : std_logic_vector(3 downto 0);
   signal register_data_1_in : std_logic_vector(15 downto 0);
   signal register_data_2_in : std_logic_vector(15 downto 0);
   signal immediate_in : std_logic_vector(15 downto 0);
   signal address_mem_in : std_logic_vector(7 downto 0);

   signal forwarded_ALU_data : std_logic_vector(15 downto 0);
   signal forwarded_memory_data : std_logic_vector(15 downto 0);
   signal DHC_abi_A : std_logic_vector(1 downto 0);
   signal DHC_abi_B : std_logic_vector(1 downto 0);

   --Outputs

   signal control_signals_out : std_logic_vector(3 downto 0);
   signal ALU_result_out : std_logic_vector(15 downto 0);
   signal register_destination_out : std_logic_vector(3 downto 0);
   signal address_mem_out : std_logic_vector(7 downto 0); 
   signal register_source_1_out : std_logic_vector(3 downto 0);
   signal register_source_2_out : std_logic_vector(3 downto 0);
   
   signal Branch_taken : std_logic;
   signal Jump_taken : std_logic;
   signal Address_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	
	-- Instantiate the Unit Under Test (UUT)
    exe_uut: Execute_stage PORT MAP (
          reset => reset,
		  stall => stall,
          clk => clk,
		  
		  --Ingressi della pipe_ID_EX
          next_PC_in => next_PC_in,  
		  offset_branch_in => offset_branch_in,
		  jump_address_in => jump_address_in,
          control_signals_in => control_signals_in,
		  register_source_1_in => register_source_1_in,
		  register_source_2_in => register_source_2_in,
		  register_destination_in => register_destination_in,
		  register_data_1_in => register_data_1_in,
		  register_data_2_in => register_data_2_in,
		  immediate_in => immediate_in,
		  address_mem_in  => address_mem_in,
		  
		  --Ingressi esterni dal Data Hazard Control
		  forwarded_ALU_data => forwarded_ALU_data,
		  forwarded_memory_data => forwarded_memory_data,
		  DHC_abi_A => DHC_abi_A,
		  DHC_abi_B => DHC_abi_B,
		  	  
		  --Uscite della pipe_EX_MEM
		  control_signals_out => control_signals_out,
		  ALU_result_out => ALU_result_out,
		  register_destination_out => register_destination_out,
		  address_mem_out => address_mem_out,
		  register_source_1_out => register_source_1_out,
		  register_source_2_out => register_source_2_out,
		  
		  --Uscite ausiliarie
		  Branch_taken => Branch_taken,
		  Jump_taken => Jump_taken,
		  Address_out => Address_out);


   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
      
	  reset <= '0';
	  next_PC_in <= x"03";
	  offset_branch_in <= x"03";
	  jump_address_in <= x"12";
	  control_signals_in <= "0001000000";
	  register_source_1_in <= x"0";
	  register_source_2_in <= x"0";
	  register_destination_in <= x"0";
	  register_data_1_in <= x"0010";
	  register_data_2_in <= x"000B";
	  immediate_in <= x"0003";
	  address_mem_in <= x"00";
	  
	  forwarded_ALU_data <= x"0000";
	  forwarded_memory_data <= x"0000";
	  DHC_abi_A <= "00";
	  DHC_abi_B <= "00";
	  
	  wait for 5 ns;
	  
	  clk <= '0';
  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  next_PC_in <= x"03";
	  offset_branch_in <= x"03";
	  jump_address_in <= x"12";
	  control_signals_in <= "0001110000";
	  register_source_1_in <= x"0";
	  register_source_2_in <= x"0";
	  register_destination_in <= x"0";
	  register_data_1_in <= x"0010";
	  register_data_2_in <= x"0010";
	  immediate_in <= x"0003";
	  address_mem_in <= x"00";
	  
	  forwarded_ALU_data <= x"0000";
	  forwarded_memory_data <= x"0000";
	  DHC_abi_A <= "00";
	  DHC_abi_B <= "00";
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  control_signals_in <= "0001101000";
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
	  clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
	  clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
	  clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
      
      wait;
   end process;

END;
