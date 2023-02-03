LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Execute_stage is
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
end Execute_stage;

architecture Structural of Execute_stage is
	
 COMPONENT AND_gate 
	port(
	  a : in std_logic;
	  b : in std_logic;
	  c : out std_logic);
 END COMPONENT;
 
 COMPONENT ALU
       port
        ( operand_A  : in      signed (15 downto 0);
          operand_B  : in      signed (15 downto 0) ;
          operator   : in      std_logic_vector(2 downto 0);
          zero_flag  : out     std_logic := '0';
          result     : out     signed (15 downto 0)
        );
 END COMPONENT;
 
 COMPONENT adder_8bit
    Port ( a : in  signed(7 downto 0) ;
           b : in  signed(7 downto 0);
           sum : out  signed(7 downto 0));
 END COMPONENT;
 
 
 COMPONENT mux_16bit_2_1 
	port(
	  a1      : in  std_logic_vector(15 downto 0);
	  a2      : in  std_logic_vector(15 downto 0);
	  sel     : in  std_logic;
	  b       : out std_logic_vector(15 downto 0));
 END COMPONENT;
 
 COMPONENT mux_16bit_3_1 
	port(
	  a1      : in  std_logic_vector(15 downto 0);
	  a2      : in  std_logic_vector(15 downto 0);
	  a3      : in  std_logic_vector(15 downto 0);
	  sel     : in  std_logic_vector(1 downto 0);
	  b       : out std_logic_vector(15 downto 0));
 END COMPONENT;
 
 COMPONENT mux_8bit_2_1
	port(
	  a1      : in  std_logic_vector(7 downto 0);
	  a2      : in  std_logic_vector(7 downto 0);
	  sel     : in  std_logic;
	  b       : out std_logic_vector(7 downto 0));
 END COMPONENT;
 
 COMPONENT pipe_EX_MEM
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
 END COMPONENT;
 
--Dichiarazioni

--Segnali intermedi

signal mux_source_out : std_logic_vector(15 downto 0);
signal operand_A_int : std_logic_vector(15 downto 0);
signal operand_B_int : std_logic_vector(15 downto 0);
signal z_flag_int : std_logic;
signal ALU_result_int : signed(15 downto 0);
signal mux_branch_abi : std_logic;
signal mux_branch_in : signed(7 downto 0);
signal mux_jump_in : std_logic_vector(7 downto 0);
signal control_cut : std_logic_vector(3 downto 0);

signal reg_1or2_a_out : std_logic_vector(15 downto 0);
signal mem_1or2_a_out : std_logic_vector(15 downto 0);
signal reg_1or2_b_out : std_logic_vector(15 downto 0);
signal mem_1or2_b_out : std_logic_vector(15 downto 0);
		  
begin

	--Connessione componenti
	
	mux_source : mux_16bit_2_1 PORT MAP (
			a1 => immediate_in,
			a2 => register_data_2_in,
			sel => control_signals_in(8), --Alu source signal
			b => mux_source_out);
			
	mux_reg_1or2_A : mux_16bit_2_1 PORT MAP (
			a1 => forwarded_ALU_data,
			a2 => forwarded_final_result,
			sel => DHC_1or2_a(1), 
			b => reg_1or2_a_out);
		
	mux_mem_1or2_A : mux_16bit_2_1 PORT MAP (
			a1 => forwarded_memory_data,
			a2 => forwarded_final_result,
			sel => DHC_1or2_a(0),
			b => mem_1or2_a_out);
	
	mux_reg_1or2_B : mux_16bit_2_1 PORT MAP (
			a1 => forwarded_ALU_data,
			a2 => forwarded_final_result,
			sel => DHC_1or2_b(1), 
			b => reg_1or2_b_out);
			
	mux_mem_1or2_B : mux_16bit_2_1 PORT MAP (
			a1 => forwarded_memory_data,
			a2 => forwarded_final_result,
			sel => DHC_1or2_b(0), 
			b => mem_1or2_b_out);
			
	muxA : mux_16bit_3_1 PORT MAP (
			a1 => register_data_1_in,
			a2 => reg_1or2_a_out,
			a3 => mem_1or2_a_out,
			sel => DHC_abi_A,
			b => operand_A_int);
			
	muxB : mux_16bit_3_1 PORT MAP (
			a1 => mux_source_out,
			a2 => reg_1or2_b_out,
			a3 => mem_1or2_b_out,
			sel => DHC_abi_B,
			b => operand_B_int);

			
	alu_c : ALU port map(
		  operand_A => signed(operand_A_int),
          operand_B => signed(operand_B_int),
          operator => control_signals_in(7 downto 5), --Alu control Signal
          zero_flag => z_flag_int ,
          result => ALU_result_int
	);
	
	andg : AND_gate port map(
		  a => control_signals_in(4), --Branch Signal
          b => z_flag_int,
          c => mux_branch_abi
	);
	
	add : adder_8bit port map(
		  a => signed(next_PC_in),
		  b => signed(offset_branch_in),
		  sum => mux_branch_in
	);
	
	mux_branch : mux_8bit_2_1 port map(
		  a1 => next_PC_in,
		  a2 => std_logic_vector(mux_branch_in),
		  sel => mux_branch_abi,
		  b => mux_jump_in
	);
	
	mux_jump : mux_8bit_2_1 port map(
		  a1 => mux_jump_in,
		  a2 => jump_address_in,
		  sel => control_signals_in(3), --Jump signal
		  b => Address_out
	);
	
	pipe : pipe_EX_MEM port map(
		reset => reset, 
		stall => stall,    
		clk => clk,    
			  
		control_signals_in => control_cut,
		ALU_result_in => std_logic_vector(ALU_result_int),
	    register_destination_in => register_destination_in,
		address_mem_in => address_mem_in,
		register_source_1_in => register_source_1_in,
		register_source_2_in => register_source_2_in,
			  
		control_signals_out => control_signals_out,
		ALU_result_out => ALU_result_out,
		register_destination_out => register_destination_out,
		address_mem_out => address_mem_out,
		register_source_1_out => register_source_1_out,
		register_source_2_out => register_source_2_out
	);
	
	control_cut <= control_signals_in(9) & control_signals_in(2 downto 0);
	Jump_taken <= control_signals_in(3);
	Branch_taken <= mux_branch_abi;
		 
	--Process

end Structural;
