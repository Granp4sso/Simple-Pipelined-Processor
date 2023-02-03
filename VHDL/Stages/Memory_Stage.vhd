LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory_Stage is
    port
        ( reset     : in std_logic;
		  stall     : inout std_logic;
          clk       : in std_logic;
		  
		  --Ingressi della pipe_EX_MEM
          control_signals_in : in std_logic_vector(3 downto 0);
		  ALU_result_in : in std_logic_vector(15 downto 0);
		  register_destination_in : in std_logic_vector(3 downto 0);
		  address_mem_in : in std_logic_vector(7 downto 0);
		  --register_source_1_in : in std_logic_vector(3 downto 0);
		  --register_source_2_in : in std_logic_vector(3 downto 0);
		  
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
end Memory_Stage;

architecture Structural of Memory_Stage is
	
 COMPONENT OR_gate 
	port(
	  a : in std_logic;
	  b : in std_logic;
	  c : out std_logic);
 END COMPONENT;
 
 COMPONENT FF_T 
	port( 
		T: in std_logic;
		abi : in std_logic;
		clk: in std_logic;
		reset: in std_logic;
		Q: out std_logic
	);
 END COMPONENT;
 
 COMPONENT mux_16bit_2_1
	port(
		a1      : in  std_logic_vector(15 downto 0);
		a2      : in  std_logic_vector(15 downto 0);
		sel     : in  std_logic;
		b       : out std_logic_vector(15 downto 0)
	);
 END COMPONENT;
 
 COMPONENT DM
	port(
		reset     : in std_logic;
		en     : in std_logic;
        clk       : in std_logic;
		mem_write : in std_logic;
		mem_read : in std_logic;
		  
        data_address : in std_logic_vector(7 downto 0) := "00000000";     
        data_in : in std_logic_vector(15 downto 0);
		data_out : out std_logic_vector(15 downto 0)
        );
 END COMPONENT;
 
 COMPONENT pipe_MEM_WB is
    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
          clk       : in std_logic;
		  
          control_signals_in : in std_logic_vector(1 downto 0);
		  ALU_result_in : in std_logic_vector(15 downto 0);
		  memory_result_in : in std_logic_vector(15 downto 0);
		  register_destination_in : in std_logic_vector(3 downto 0);
		  
		  control_signals_out : out std_logic_vector(1 downto 0);
		  ALU_result_out : out std_logic_vector(15 downto 0);
		  memory_result_out : out std_logic_vector(15 downto 0);
		  register_destination_out : out std_logic_vector(3 downto 0)
        );
 END COMPONENT;
 
 signal Toggle : std_logic := '0';
 signal data_mem_in : std_logic_vector(15 downto 0) := x"0000";
 signal mem_output : std_logic_vector(15 downto 0) := x"0000";
 signal control_sign : std_logic_vector(1 downto 0) := "00";
 signal alu_data : std_logic_vector(15 downto 0);
		  
begin

	--Connessione componenti
	
	org : OR_gate port map(
		a => control_signals_in(2), --mem write, 
        b => control_signals_in(1), --mem read,
        c => Toggle
	);
	
	mux : mux_16bit_2_1 PORT MAP (
		a1 => ALU_result_in,
		a2 => forwarded_final_result,
		sel => DHC_abi_C, 
		b => data_mem_in);
			
	ff : FF_T port map(
		T => Toggle,
		abi => '1',
		clk => clk,
		reset => reset,
		Q => stall
	);
	
	mem : DM port map(
		reset => reset,
		en => '1',
        clk => clk,
		mem_write => control_signals_in(2),
		mem_read => control_signals_in(1),
		  
        data_address => address_mem_in,     
        data_in => data_mem_in,
		data_out => mem_output
	);
	pipe : pipe_MEM_WB port map(
		reset => reset,
		stall => stall,
        clk => clk,
		  
        control_signals_in => control_sign,
		ALU_result_in => ALU_result_in,
		memory_result_in => mem_output,
		register_destination_in => register_destination_in,
		  
		control_signals_out => control_signals_out,
		ALU_result_out => ALU_result_out,
		memory_result_out => memory_result_out,
		register_destination_out => register_destination_out
	);
		 
	--Process
	control_sign <= control_signals_in(3)& control_signals_in(0);
	forwarded_memory_data <= mem_output;
	
end Structural;
