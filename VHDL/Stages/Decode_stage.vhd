LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decode_stage is
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
end Decode_stage;

architecture Structural of Decode_stage is
	
 COMPONENT registers
    port
        ( reset     : in std_logic;
          clk       : in std_logic;
		  register_source_1 : in std_logic_vector(3 downto 0);
		  register_source_2 : in std_logic_vector(3 downto 0);
		  register_destination : in std_logic_vector(3 downto 0);
		  register_result :  in std_logic_vector(15 downto 0);
		  write_reg : in std_logic;
		  
		  register_data_1  : out  STD_LOGIC_VECTOR (15 downto 0);
          register_data_2  : out  STD_LOGIC_VECTOR (15 downto 0)
        );
 END COMPONENT;
 
 COMPONENT SE_8_16
    port
        ( a : in  STD_LOGIC_VECTOR (7 downto 0) := "00000000";
          a_extended : out  STD_LOGIC_VECTOR (15 downto 0));
 END COMPONENT;
 
 COMPONENT SE_4_8
    port
        ( a : in  STD_LOGIC_VECTOR (3 downto 0) := "0000";
          a_extended : out  STD_LOGIC_VECTOR (7 downto 0));
 END COMPONENT;
 
 COMPONENT pipe_ID_EX
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
 END COMPONENT;
 
 COMPONENT mux_8bit_3_1
    port
        ( a1      : in  std_logic_vector(7 downto 0);
		  a2      : in  std_logic_vector(7 downto 0);
		  a3      : in  std_logic_vector(7 downto 0);
		  sel     : in  std_logic_vector(1 downto 0);
		  b       : out std_logic_vector(7 downto 0));
 END COMPONENT;
 
  COMPONENT mux_16bit_2_1 
	port(
	  a1      : in  std_logic_vector(15 downto 0);
	  a2      : in  std_logic_vector(15 downto 0);
	  sel     : in  std_logic;
	  b       : out std_logic_vector(15 downto 0));
 END COMPONENT;
 
--Dichiarazioni

--Segnali intermedi

signal register_data_1_int: std_logic_vector(15 downto 0);
signal register_data_2_int: std_logic_vector(15 downto 0);
signal offset_extended_int: std_logic_vector(7 downto 0);
signal immediate_int: std_logic_vector(7 downto 0);
signal immediate_muxed_int : std_logic_vector(7 downto 0);
signal immediate_muxed_extended_int : std_logic_vector(15 downto 0);
signal operand_A_int : std_logic_vector(15 downto 0);
signal operand_B_int : std_logic_vector(15 downto 0);

SIGNAL regsource1_int : std_logic_vector(3 downto 0) := "0000";
SIGNAL regsource2_int : std_logic_vector(3 downto 0) := "0000";
		  
begin

	--Connessione componenti
	
	regsource1_int <= instruction_in(11 downto 8);
	regsource2_int <= instruction_in(7 downto 4);
	register_S1_0 <= regsource1_int;
	register_S2_0 <= regsource2_int;
	
	reg : registers PORT MAP (
         reset => reset,
		 clk => clk,
		 register_source_1 => regsource1_int,
		 register_source_2 => regsource2_int,
		 register_destination => register_destination_WB_in,
		 register_result => register_result_WB_in,
		 write_reg => write_reg_WB_in,
		 
		 register_data_1  =>register_data_1_int,
         register_data_2  => register_data_2_int);
	
	SE_1 : SE_4_8 PORT MAP (
         a => instruction_in(3 downto 0),
         a_extended => offset_extended_int);
	
	SE_2 : SE_4_8 PORT MAP (
         a => instruction_in(7 downto 4),
         a_extended => immediate_int);
		 
	mux : mux_8bit_3_1 PORT MAP (
         a1 => immediate_int,
		 a2 => instruction_in(7 downto 0),
		 a3 => instruction_in(11 downto 4),
		 sel => control_signals_in(1 downto 0),
		 b => immediate_muxed_int);
		 
	mux_s1 : mux_16bit_2_1 port map(
		a1 => register_data_1_int,
		a2 => register_result_WB_in,
		sel => DHC_Abi_S1_in,
		b => operand_A_int);
	
	mux_s2 : mux_16bit_2_1 port map(
		a1 => register_data_2_int,
		a2 => register_result_WB_in,
		sel => DHC_Abi_S2_in,
		b => operand_B_int);
		 
	SE_3 : SE_8_16 PORT MAP (
         a => immediate_muxed_int,
         a_extended => immediate_muxed_extended_int);
		 
	pipe : pipe_ID_EX PORT MAP (
         reset => reset,
		 stall => stall,
		 flush => flush,
         clk => clk,
         next_PC_in => next_PC_in,     
		 offset_branch_in => offset_extended_int,
		 jump_address_in => instruction_in(11 downto 4),
         control_signals_in => control_signals_in(11 downto 2),
		 register_source_1_in => instruction_in(11 downto 8),
		 register_source_2_in => instruction_in(7 downto 4),
		 register_destination_in => instruction_in(3 downto 0),
		 register_data_1_in => operand_A_int,
		 register_data_2_in => operand_B_int,
		 immediate_in => immediate_muxed_extended_int,
		 address_mem_in => immediate_muxed_int,
		  
		 next_PC_out => next_PC_out,    
		 offset_branch_out => offset_branch_out,
		 jump_address_out => jump_address_out,
         control_signals_out => control_signals_out,
		 register_source_1_out => register_source_1_out,
		 register_source_2_out => register_source_2_out,
		 register_destination_out => register_destination_out,
		 register_data_1_out => register_data_1_out,
		 register_data_2_out => register_data_2_out,
		 immediate_out => immediate_out,
		 address_mem_out => address_mem_out);
		 
	--Process

end Structural;
