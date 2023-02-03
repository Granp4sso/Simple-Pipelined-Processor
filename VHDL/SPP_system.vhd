LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY SPP_system IS
	port
        ( reset     : in std_logic;
		  --stall     : inout std_logic; DEPRECATED
		  --flush		: inout std_logic; DEPRECATED
          clk       : in std_logic;
		  
		  --Ingressi del Branch Control
          --branch_taken_in   : in std_logic;   DEPRECATED   
          --jump_in : in std_logic; DEPRECATED
		  --jump_address_in : in std_logic_vector(7 downto 0); DEPRECATED
		  
		  --Enable
		  enable_in : in std_logic; --Per adesso sarà mappato al pc_en, da cambiare poi.
		  
		  --Ingressi dal Data Hazard Control
		  
		  --forwarded_ALU_data : in std_logic_vector(15 downto 0);
		  --forwarded_memory_data : in std_logic_vector(15 downto 0);
		  
		  
		  
		  --forwarded_final_result : in std_logic_vector(15 downto 0); DEPRECATED
		  
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
END SPP_system ;
 
ARCHITECTURE Structural OF SPP_system IS 
 
    COMPONENT Fetch_Stage
    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  flush		: inout std_logic;
          clk       : in std_logic;
		  
		  --Ingressi del Branch Control
          branch_taken_in   : in std_logic;     
          jump_in : in std_logic;
		  jump_address_in : in std_logic_vector(7 downto 0);
		  
		  --Enable
		  enable_in : in std_logic; --Per adesso sarà mappato al pc_en, da cambiare poi.
		  
		  --Uscite della pipe_IF_ID
		  next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";     
          control_signals_out : out std_logic_vector(11 downto 0);
		  instruction_out : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	
	COMPONENT Decode_stage
    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  flush		: in std_logic;
          clk       : in std_logic;
		  
		  --Ingressi della pipe_IF_ID
          next_PC_in   : in std_logic_vector(7 downto 0) := "00000000";     
          control_signals_in : in std_logic_vector(11 downto 0);
		  instruction_in : in std_logic_vector(15 downto 0);
		  
		  --Ingressi esterni per la struttura registers
		  register_destination_WB_in : in std_logic_vector(3 downto 0);
		  register_result_WB_in: in std_logic_vector(15 downto 0);
		  write_reg_WB_in : in std_logic;
		  
		  --Uscite della pipe_ID_EX
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
		  address_mem_out : out std_logic_vector(7 downto 0);
		  
		  --Uscite per il forwarding
		  register_S1_0 : out std_logic_vector(3 downto 0);
		  register_S2_0 : out std_logic_vector(3 downto 0);
		  
		  --Ingressi forwarding
		  DHC_Abi_S1_in : in std_logic;
		  DHC_Abi_S2_in : in std_logic
        );
    END COMPONENT;
	
	COMPONENT  Execute_stage is
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
		  forwarded_final_result : in std_logic_vector(15 downto 0);
		  DHC_abi_A : in std_logic_vector(1 downto 0);
		  DHC_abi_B : in std_logic_vector(1 downto 0);
		  DHC_1or2_a : in std_logic_vector(1 downto 0);
		  DHC_1or2_b : in std_logic_vector(1 downto 0);
		  	  
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
	
	COMPONENT  Memory_stage is
    port
        ( reset     : in std_logic;
		  stall     : inout std_logic;
          clk       : in std_logic;
		  
		  --Ingressi della pipe_EX_MEM
          control_signals_in : in std_logic_vector(3 downto 0);
		  ALU_result_in : in std_logic_vector(15 downto 0);
		  register_destination_in : in std_logic_vector(3 downto 0);
		  address_mem_in : in std_logic_vector(7 downto 0);
		  
		  --Ingressi esterni per il forwarding
		  DHC_abi_C : in std_logic;
		  forwarded_final_result : in std_logic_vector(15 downto 0);
		  	  
		  --Uscite della pipe_MEM_WB
		  control_signals_out : out std_logic_vector(1 downto 0);
		  ALU_result_out : out std_logic_vector(15 downto 0);
		  memory_result_out : out std_logic_vector(15 downto 0);
		  register_destination_out : out std_logic_vector(3 downto 0);
		  
		  --Uscite di forwarding
		  forwarded_ALU_data : out std_logic_vector(15 downto 0);
		  forwarded_memory_data : out std_logic_vector(15 downto 0)

		  
        );
	END COMPONENT;
	
	COMPONENT mux_16bit_2_1 is
		port(
		  a1      : in  std_logic_vector(15 downto 0);
		  a2      : in  std_logic_vector(15 downto 0);
		  sel     : in  std_logic;
		  b       : out std_logic_vector(15 downto 0));
	END COMPONENT;
	
	COMPONENT Data_Hazard_Control is
    port
        ( DHC_RS1_0 : in std_logic_vector(3 downto 0);
		  DHC_RS2_0 : in std_logic_vector(3 downto 0);
		  DHC_RS1_1	: in std_logic_vector(3 downto 0);
          DHC_RS1_2 : in std_logic_vector(3 downto 0);
          DHC_RS2 : in std_logic_vector(3 downto 0);
          DHC_RD_1 : in std_logic_vector(3 downto 0);
          DHC_RD_2 : in std_logic_vector(3 downto 0);
		  
		  --segnali di controllo in ingresso
		  
		  DHC_Mem_write : in std_logic;
		  DHC_Mem_read : in std_logic;
		  DHC_Write_reg_1 : in std_logic;
		  DHC_Write_reg_2 : in std_logic;
		  
		  --segnali di uscita
		  
		  DHC_Abi_a : out std_logic_vector(1 downto 0);
		  DHC_Abi_b : out std_logic_vector(1 downto 0);
		  DHC_Abi_c : out std_logic;
		  DHC_1or2_a : out std_logic_vector(1 downto 0);
		  DHC_1or2_b : out std_logic_vector(1 downto 0);
		  DHC_Abi_S1 : out std_logic;
		  DHC_Abi_S2 : out std_logic
        );
	END COMPONENT;
	
	signal stall : std_logic;
	signal flush : std_logic;
	
	--Int signals for IF_ID
	signal IF_next_PC_int : std_logic_vector(7 downto 0) := x"00";
	signal IF_control_signals_int : std_logic_vector(11 downto 0);
	signal IF_instruction_int : std_logic_vector(15 downto 0);
	
	--Int signals for ID_EX
	signal ID_next_PC_int : std_logic_vector(7 downto 0) := "00000000";    
	signal ID_offset_branch_int : std_logic_vector(7 downto 0) := "00000000";
	signal ID_jump_address_int : std_logic_vector(7 downto 0) := "00000000";
    signal ID_control_signals_int : std_logic_vector(9 downto 0);
	signal ID_register_source_1_int: std_logic_vector(3 downto 0);
	signal ID_register_source_2_int: std_logic_vector(3 downto 0);
	signal ID_register_destination_int : std_logic_vector(3 downto 0);
	signal ID_register_data_1_int : std_logic_vector(15 downto 0);
	signal ID_register_data_2_int :  std_logic_vector(15 downto 0);
	signal ID_immediate_int : std_logic_vector(15 downto 0);
	signal ID_address_mem_int :  std_logic_vector(7 downto 0);
	signal ID_register_S1_int : std_logic_vector(3 downto 0);
	signal ID_register_S2_int : std_logic_vector(3 downto 0);
	
	--Int signals for EX_MEM
	
	signal EX_control_signals_int : std_logic_vector(3 downto 0);
	signal EX_ALU_result_int : std_logic_vector(15 downto 0);
	signal EX_register_destination_int : std_logic_vector(3 downto 0);
	signal EX_address_mem_int : std_logic_vector(7 downto 0);
	signal EX_register_source_1_int : std_logic_vector(3 downto 0);
	signal EX_register_source_2_int : std_logic_vector(3 downto 0);
	
	signal EX_Branch_taken_int : std_logic;
	signal EX_Jump_taken_int : std_logic;
	signal EX_Address_int : std_logic_vector(7 downto 0);
	
	signal MEM_forwarded_ALU_data_int : std_logic_vector(15 downto 0);
	signal MEM_forwarded_memory_data_int : std_logic_vector(15 downto 0);
	
	signal MEM_control_signals_int : std_logic_vector(1 downto 0);
	signal MEM_ALU_result_int : std_logic_vector(15 downto 0);
	signal MEM_memory_result_int : std_logic_vector(15 downto 0);
	signal MEM_register_destination_int : std_logic_vector(3 downto 0);
	
	--Int Signals for MEM_WB
	
	signal register_result_WB_int: std_logic_vector(15 downto 0);
	signal write_reg_WB_int : std_logic;
	
	--Int Signals for DHC
	
	signal DHC_abi_A_int : std_logic_vector(1 downto 0);
	signal DHC_abi_B_int : std_logic_vector(1 downto 0);
	signal DHC_abi_C_int : std_logic;
	signal DHC_1or2_a_int : std_logic_vector(1 downto 0);
	signal DHC_1or2_b_int : std_logic_vector(1 downto 0);
	signal DHC_abi_S1_int : std_logic;
	signal DHC_abi_S2_int : std_logic;
 
BEGIN
	
	--Instantiate
	
		
	IF_next_PC_out <= IF_next_PC_int;
	IF_control_signals_out <= IF_control_signals_int;
	IF_instruction_out <= IF_instruction_int;
	
	ID_next_PC_out <= ID_next_PC_int; 
	ID_offset_branch_out <= ID_offset_branch_int;
	ID_jump_address_out <= ID_jump_address_int;
    ID_control_signals_out <= ID_control_signals_int;
	ID_register_source_1_out <= ID_register_source_1_int;
	ID_register_source_2_out <= ID_register_source_2_int;
	ID_register_destination_out <= ID_register_destination_int;
	ID_register_data_1_out <= ID_register_data_1_int;
	ID_register_data_2_out <= ID_register_data_2_int;
	ID_immediate_out <= ID_immediate_int;
	ID_address_mem_out <= ID_address_mem_int;
	
	EX_control_signals_out <= EX_control_signals_int;
	EX_ALU_result_out <= EX_ALU_result_int;
	EX_register_destination_out <= EX_register_destination_int;
	EX_address_mem_out <= EX_address_mem_int;
	EX_register_source_1_out <= EX_register_source_1_int;
	EX_register_source_2_out <= EX_register_source_2_int;
	EX_Branch_taken <= EX_Branch_taken_int;
	EX_Jump_taken <= EX_Jump_taken_int;
	EX_Address_out <= EX_Address_int;
	
	
	MEM_forwarded_ALU_data <= EX_ALU_result_int;
	MEM_forwarded_memory_data <= MEM_forwarded_memory_data_int;
	
	MEM_control_signals_out <= MEM_control_signals_int;
	MEM_ALU_result_out <= MEM_ALU_result_int;
	MEM_memory_result_out <= MEM_memory_result_int;
	MEM_register_destination_out <= MEM_register_destination_int;
	
	WB_data_out <= register_result_WB_int;
	WB_write_reg <= MEM_control_signals_int(1);
	
	
	fetch: Fetch_Stage PORT MAP (
          reset => reset,
		  stall => stall,
		  flush => flush,
          clk => clk,
		  enable_in => enable_in,
		  
		  --Ingressi del Branch Control
          branch_taken_in => EX_Branch_taken_int,  
          jump_in => EX_Jump_taken_int,
		  jump_address_in =>  EX_Address_int,
		  
		  --Uscite della pipe_IF_ID
		  next_PC_out => IF_next_PC_int,     
          control_signals_out => IF_control_signals_int,
		  instruction_out => IF_instruction_int);
		  
	decode: Decode_stage PORT MAP (
          reset => reset,
		  stall => stall,
		  flush => flush,
          clk  => clk,

          next_PC_in => IF_next_PC_int,     
          control_signals_in => IF_control_signals_int,
		  instruction_in => IF_instruction_int,
		  
		  register_destination_WB_in => MEM_register_destination_int,
		  register_result_WB_in => register_result_WB_int,
		  write_reg_WB_in => MEM_control_signals_int(1),
		  
		  next_PC_out => ID_next_PC_int,  
		  offset_branch_out => ID_offset_branch_int,
		  jump_address_out => ID_jump_address_int,
          control_signals_out => ID_control_signals_int,
		  register_source_1_out => ID_register_source_1_int,
		  register_source_2_out => ID_register_source_2_int,
		  register_destination_out => ID_register_destination_int,
		  register_data_1_out => ID_register_data_1_int,
		  register_data_2_out => ID_register_data_2_int,
		  immediate_out => ID_immediate_int,
		  address_mem_out  => ID_address_mem_int,
		  
		  --Uscite per il forwarding
		  register_S1_0 =>ID_register_S1_int,
		  register_S2_0 =>ID_register_S2_int,
		  
		  --Ingressi forwarding
		  DHC_Abi_S1_in => DHC_abi_S1_int,
		  DHC_Abi_S2_in => DHC_abi_S2_int
		  );
		  
	execute: Execute_stage PORT MAP(
		  reset => reset,
		  stall => stall,
          clk => clk,
		  
		  --Ingressi della pipe_ID_EX
          next_PC_in => ID_next_PC_int,  
		  offset_branch_in => ID_offset_branch_int,
		  jump_address_in => ID_jump_address_int,
          control_signals_in => ID_control_signals_int,
		  register_source_1_in => ID_register_source_1_int,
		  register_source_2_in => ID_register_source_2_int,
		  register_destination_in => ID_register_destination_int,
		  register_data_1_in => ID_register_data_1_int,
		  register_data_2_in => ID_register_data_2_int,
		  immediate_in => ID_immediate_int,
		  address_mem_in  => ID_address_mem_int,
		  
		  --Ingressi esterni dal Data Hazard Control
		  forwarded_ALU_data => EX_ALU_result_int,
		  forwarded_memory_data => MEM_forwarded_memory_data_int,
		  forwarded_final_result => register_result_WB_int,
		  DHC_abi_A => DHC_abi_A_int,
		  DHC_abi_B => DHC_abi_B_int,
		  DHC_1or2_a => DHC_1or2_a_int,
		  DHC_1or2_b => DHC_1or2_b_int,
		  	  
		  --Uscite della pipe_EX_MEM
		  control_signals_out => EX_control_signals_int,
		  ALU_result_out => EX_ALU_result_int,
		  register_destination_out => EX_register_destination_int,
		  address_mem_out => EX_address_mem_int,
		  register_source_1_out => EX_register_source_1_int,
		  register_source_2_out => EX_register_source_2_int,
		  
		  --Uscite ausiliarie
		  Branch_taken => EX_Branch_taken_int,
		  Jump_taken => EX_Jump_taken_int,
		  Address_out => EX_Address_int
	);
	
	memory : Memory_stage port map(
		  reset => reset,
		  stall => stall,
          clk => clk,
		  
		  --Ingressi della pipe_EX_MEM
          control_signals_in => EX_control_signals_int,
		  ALU_result_in => EX_ALU_result_int,
		  register_destination_in => EX_register_destination_int,
		  address_mem_in => EX_address_mem_int,
		  
		  --Ingressi esterni per il forwarding
		  DHC_abi_C => DHC_abi_C_int,
		  forwarded_final_result => register_result_WB_int,
		  	  
		  --Uscite della pipe_MEM_WB
		  control_signals_out => MEM_control_signals_int,
		  ALU_result_out => MEM_ALU_result_int,
		  memory_result_out => MEM_memory_result_int,
		  register_destination_out => MEM_register_destination_int,
		  
		  --Uscite di forwarding
		  forwarded_ALU_data => EX_ALU_result_int,
		  forwarded_memory_data => MEM_forwarded_memory_data_int
	
	);
	
	WB_mux : mux_16bit_2_1 port map(
		  a1 => MEM_ALU_result_int,
		  a2 => MEM_memory_result_int,
		  sel => MEM_control_signals_int(0),
		  b => register_result_WB_int
	);
	
	DHC : Data_Hazard_Control port map(
		  DHC_RS1_0 => ID_register_S1_int,
		  DHC_RS2_0 => ID_register_S2_int,
		  DHC_RS1_1	=> ID_register_source_1_int,
          DHC_RS1_2 => EX_register_source_1_int,
          DHC_RS2 => ID_register_source_2_int,
          DHC_RD_1 => EX_register_destination_int,
          DHC_RD_2 => MEM_register_destination_int,
		  
		  --segnali di controllo in ingresso
		  
		  DHC_Mem_write => EX_control_signals_int(2),
		  DHC_Mem_read =>EX_control_signals_int(1),
		  DHC_Write_reg_1 => EX_control_signals_int(3),
		  DHC_Write_reg_2 => MEM_control_signals_int(1),
		  
		  --segnali di uscita
		  
		  DHC_Abi_a => DHC_abi_A_int,
		  DHC_Abi_b => DHC_abi_B_int,
		  DHC_Abi_c => DHC_abi_C_int,
		  DHC_1or2_a => DHC_1or2_a_int,
		  DHC_1or2_b => DHC_1or2_b_int,
		  DHC_Abi_S1 => DHC_abi_S1_int,
		  DHC_Abi_S2 => DHC_abi_S2_int
	);
    

END;
