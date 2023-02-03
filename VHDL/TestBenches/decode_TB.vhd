LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY decode_TB IS
END decode_TB ;
 
ARCHITECTURE behavior OF decode_TB  IS 
 
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
		  address_mem_out : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	
	--Ingresso alla Decode Stage

	signal reset : std_logic := '1';
	signal clk : std_logic := '1';
	signal flush : std_logic := '0';
	signal stall : std_logic := '0';

	signal  next_PC_in   : std_logic_vector(7 downto 0) := "00000000";     
	signal  control_signals_in : std_logic_vector(11 downto 0);
	signal  instruction_in : std_logic_vector(15 downto 0);

	signal register_destination_WB_in : std_logic_vector(3 downto 0);
	signal register_result_WB_in: std_logic_vector(15 downto 0);
	signal write_reg_WB_in : std_logic;
	 
	--Uscita dalla Decode Stage

	signal next_PC_out   : std_logic_vector(7 downto 0) := "00000000";    
	signal offset_branch_out : std_logic_vector(7 downto 0) := "00000000";
	signal jump_address_out : std_logic_vector(7 downto 0) := "00000000";
	signal control_signals_out : std_logic_vector(9 downto 0);
	signal register_source_1_out: std_logic_vector(3 downto 0);
	signal register_source_2_out: std_logic_vector(3 downto 0);
	signal register_destination_out : std_logic_vector(3 downto 0);
	signal register_data_1_out : std_logic_vector(15 downto 0);
	signal register_data_2_out : std_logic_vector(15 downto 0);
	signal immediate_out : std_logic_vector(15 downto 0);
	signal address_mem_out : std_logic_vector(7 downto 0);

	-- Clock period definitions
	constant clk_period : time := 10 ns;
 
BEGIN
	
	-- Instantiate the Unit Under Test (UUT)
    ds_uut: Decode_stage PORT MAP (
          reset => reset,
		  stall => stall,
		  flush => flush,
          clk  => clk,

          next_PC_in => next_PC_in,     
          control_signals_in => control_signals_in,
		  instruction_in => instruction_in,
		  
		  register_destination_WB_in => register_destination_WB_in,
		  register_result_WB_in => register_result_WB_in,
		  write_reg_WB_in => write_reg_WB_in,
		  
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
		  address_mem_out  => address_mem_out);
		 
	
   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
	  
	  reset <= '0';
	  next_PC_in <= x"22";
	  control_signals_in <= "100000001110";
	  
	  write_reg_WB_in <= '1';
	  register_destination_WB_in <= x"6";
	  register_result_WB_in <= x"6666";
	  instruction_in <= x"123A";
	  
	  wait for 5 ns;
	  
	  clk <= '0';
  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  next_PC_in <= x"23";
	  control_signals_in <= "100000001110";
	  
	  write_reg_WB_in <= '1';
	  register_destination_WB_in <= x"7";
	  register_result_WB_in <= x"0011";
	  instruction_in <= x"123A";
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
      clk <= '0';
	 --stall <= '1';
	  next_PC_in <= x"24";
	  control_signals_in <= "111111001110";
	  
	  write_reg_WB_in <= '0';
	  register_destination_WB_in <= x"8";
	  register_result_WB_in <= x"0311";
	  instruction_in <= x"656A";
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
	  clk <= '0';
	  flush <= '1';
	  stall <= '0';
  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
      
      wait;
   end process;

END;
