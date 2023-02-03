LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY SPP_TB IS
END SPP_TB ;
 
ARCHITECTURE behavior OF SPP_TB  IS 

	COMPONENT SPP_system
    port
        ( reset     : in std_logic;
          clk       : in std_logic;
		  enable_in : in std_logic;
	  
		  --Uscite dallo stage IF
		  IF_next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";     
          IF_control_signals_out : out std_logic_vector(11 downto 0);
		  IF_instruction_out : out std_logic_vector(15 downto 0);
		  
		  --Uscite dallo stage ID
		  ID_next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";    
		  ID_offset_branch_out : out std_logic_vector(7 downto 0) := "00000000";
		  ID_jump_address_out : out std_logic_vector(7 downto 0) := "00000000";
          ID_control_signals_out : out std_logic_vector(9 downto 0);
		  ID_register_source_1_out: out std_logic_vector(3 downto 0);
		  ID_register_source_2_out: out std_logic_vector(3 downto 0);
		  ID_register_destination_out : out std_logic_vector(3 downto 0);
		  ID_register_data_1_out : out std_logic_vector(15 downto 0);
		  ID_register_data_2_out : out std_logic_vector(15 downto 0);
		  ID_immediate_out : out std_logic_vector(15 downto 0);
		  ID_address_mem_out : out std_logic_vector(7 downto 0);
		  
		  --Uscite dallo stage EX
		  EX_control_signals_out : out std_logic_vector(3 downto 0);
		  EX_ALU_result_out : out std_logic_vector(15 downto 0);
		  EX_register_destination_out : out std_logic_vector(3 downto 0);
		  EX_address_mem_out : out std_logic_vector(7 downto 0);
		  EX_register_source_1_out : out std_logic_vector(3 downto 0);
		  EX_register_source_2_out : out std_logic_vector(3 downto 0);
		  
		  EX_Branch_taken : out std_logic;
		  EX_Jump_taken : out std_logic;
		  EX_Address_out : out std_logic_vector(7 downto 0);
		  
		  --Uscite dallo stage MEM
		  
		  MEM_control_signals_out : out std_logic_vector(1 downto 0);
		  MEM_ALU_result_out : out std_logic_vector(15 downto 0);
		  MEM_memory_result_out : out std_logic_vector(15 downto 0);
		  MEM_register_destination_out : out std_logic_vector(3 downto 0);
		  
		  --Uscite di forwarding dallo stage MEM
		  MEM_forwarded_ALU_data : out std_logic_vector(15 downto 0);
		  MEM_forwarded_memory_data : out std_logic_vector(15 downto 0);
		    
		  --Uscite dal WB 
		  
		  WB_data_out : out std_logic_vector(15 downto 0);
		  WB_write_reg : out std_logic
		  
        );
    END COMPONENT;

   --Inputs
   signal reset : std_logic := '1';
   signal enable_in : std_logic := '1';
   signal clk : std_logic := '1';
   
   --signal forwarded_ALU_data : std_logic_vector(15 downto 0);
  -- signal forwarded_memory_data : std_logic_vector(15 downto 0);
   --signal DHC_abi_A : std_logic_vector(1 downto 0);
   --signal DHC_abi_B : std_logic_vector(1 downto 0);
   
  -- signal register_destination_WB_in : std_logic_vector(3 downto 0);
  -- signal register_result_WB_in: std_logic_vector(15 downto 0);
  -- signal write_reg_WB_in : std_logic;
   
   --signal DHC_abi_C : std_logic := '0';
 --  signal forwarded_final_result : std_logic_vector(15 downto 0) := x"0000";

   --Outputs
   
   --IF STAGE:
   
   signal IF_next_PC_out : std_logic_vector(7 downto 0);     
   signal IF_control_signals_out : std_logic_vector(11 downto 0);
   signal IF_instruction_out : std_logic_vector(15 downto 0);
   
   --ID STAGE:
   
   signal ID_next_PC_out   : std_logic_vector(7 downto 0) := "00000000";    
   signal ID_offset_branch_out : std_logic_vector(7 downto 0) := "00000000";
   signal ID_jump_address_out : std_logic_vector(7 downto 0) := "00000000";
   signal ID_control_signals_out : std_logic_vector(9 downto 0);
   signal ID_register_source_1_out: std_logic_vector(3 downto 0);
   signal ID_register_source_2_out: std_logic_vector(3 downto 0);
   signal ID_register_destination_out : std_logic_vector(3 downto 0);
   signal ID_register_data_1_out : std_logic_vector(15 downto 0);
   signal ID_register_data_2_out : std_logic_vector(15 downto 0);
   signal ID_immediate_out : std_logic_vector(15 downto 0);
   signal ID_address_mem_out : std_logic_vector(7 downto 0);
   
   --EX STAGE:
   
   signal EX_control_signals_out : std_logic_vector(3 downto 0);
   signal EX_ALU_result_out : std_logic_vector(15 downto 0);
   signal EX_register_destination_out : std_logic_vector(3 downto 0);
   signal EX_address_mem_out : std_logic_vector(7 downto 0);
   signal EX_register_source_1_out : std_logic_vector(3 downto 0);
   signal EX_register_source_2_out : std_logic_vector(3 downto 0);
   signal EX_Branch_taken : std_logic;
   signal EX_Jump_taken : std_logic;
   signal EX_Address_out : std_logic_vector(7 downto 0);
   
   --MEM STAGE:
   
   signal MEM_control_signals_out: std_logic_vector(1 downto 0);
   signal MEM_ALU_result_out : std_logic_vector(15 downto 0);
   signal MEM_memory_result_out : std_logic_vector(15 downto 0);
   signal MEM_register_destination_out : std_logic_vector(3 downto 0);
   
   signal MEM_forwarded_memory_data : std_logic_vector(15 downto 0);
   signal MEM_forwarded_ALU_data : std_logic_vector(15 downto 0);
   
   --WB STAGE:
   
   signal WB_data_out : std_logic_vector(15 downto 0);
   signal WB_write_reg : std_logic;
   
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN

	-- Instantiate the Unit Under Test (UUT)
    SPP_uut: SPP_system port map
        ( reset => reset,
          clk => clk,
		  enable_in => enable_in,

		  --Uscite dallo stage IF
		  IF_next_PC_out => IF_next_PC_out,     
          IF_control_signals_out => IF_control_signals_out,
		  IF_instruction_out => IF_instruction_out,
		  
		  --Uscite dellao stage ID
		  ID_next_PC_out => ID_next_PC_out,  
		  ID_offset_branch_out => ID_offset_branch_out,
		  ID_jump_address_out => ID_jump_address_out,
          ID_control_signals_out => ID_control_signals_out,
		  ID_register_source_1_out => ID_register_source_1_out,
		  ID_register_source_2_out => ID_register_source_2_out,
		  ID_register_destination_out => ID_register_destination_out,
		  ID_register_data_1_out => ID_register_data_1_out,
		  ID_register_data_2_out => ID_register_data_2_out,
		  ID_immediate_out => ID_immediate_out,
		  ID_address_mem_out  => ID_address_mem_out,
		  
		  --Uscite dallo stage EX
		  EX_control_signals_out => EX_control_signals_out,
		  EX_ALU_result_out => EX_ALU_result_out,
		  EX_register_destination_out => EX_register_destination_out,
		  EX_address_mem_out => EX_address_mem_out,
		  EX_register_source_1_out => EX_register_source_1_out,
		  EX_register_source_2_out =>EX_register_source_2_out,
		  EX_Branch_taken => EX_Branch_taken,
		  EX_Jump_taken => EX_Jump_taken,
		  EX_Address_out => EX_Address_out,
		  
		  --Uscite dallo stage MEM
		  
		  MEM_control_signals_out => MEM_control_signals_out,
		  MEM_ALU_result_out => MEM_ALU_result_out,
		  MEM_memory_result_out =>  MEM_memory_result_out,
		  MEM_register_destination_out => MEM_register_destination_out,
		  
		  --Uscite di forwarding dallo stage MEM
		  MEM_forwarded_ALU_data => MEM_forwarded_ALU_data,
		  MEM_forwarded_memory_data => MEM_forwarded_memory_data,
		  
		   --Uscite dal WB 
		  
		  WB_data_out => WB_data_out,
		  WB_write_reg => WB_write_reg
		  
		  
        );

   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
      
	  reset <= '0';
	  enable_in <= '1'; 
	  
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';
	  wait for 5 ns; clk <= '0'; 
	  wait for 5 ns; clk <= '1';

      wait;
   end process;

END;
