LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY Memory_TB IS
END Memory_TB ;
 
ARCHITECTURE behavior OF Memory_TB  IS 
 
    COMPONENT Memory_Stage 
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
	
	--Ingresso alla Decode Stage

	signal reset : std_logic := '1';
	signal clk : std_logic := '0';
	signal stall : std_logic := '0';

	signal control_signals_in :  std_logic_vector(3 downto 0);
	signal ALU_result_in :  std_logic_vector(15 downto 0);
	signal register_destination_in :  std_logic_vector(3 downto 0);
	signal address_mem_in :  std_logic_vector(7 downto 0);
		  
	--Ingressi esterni per il forwarding
	signal DHC_abi_C :  std_logic;
	signal forwarded_final_result :  std_logic_vector(15 downto 0);
		  	  
	--Uscite della pipe_MEM_WB
	signal control_signals_out :  std_logic_vector(1 downto 0);
	signal ALU_result_out :  std_logic_vector(15 downto 0);
	signal memory_result_out :  std_logic_vector(15 downto 0);
	signal register_destination_out :  std_logic_vector(3 downto 0);
		  
		  --Uscite di forwarding
	signal forwarded_ALU_data :  std_logic_vector(15 downto 0);
	signal forwarded_memory_data :  std_logic_vector(15 downto 0);
 
BEGIN
	
	-- Instantiate the Unit Under Test (UUT)
    ms_uut: Memory_Stage PORT MAP (
          reset => reset,
		  stall => stall,
          clk => clk,
		  
		  --Ingressi della pipe_EX_MEM
          control_signals_in => control_signals_in,
		  ALU_result_in => ALU_result_in,
		  register_destination_in => register_destination_in,
		  address_mem_in => address_mem_in,
		  
		  --Ingressi esterni per il forwarding
		  DHC_abi_C => DHC_abi_C,
		  forwarded_final_result => forwarded_final_result,
		  	  
		  --Uscite della pipe_MEM_WB
		  control_signals_out => control_signals_out,
		  ALU_result_out => ALU_result_out,
		  memory_result_out => memory_result_out,
		  register_destination_out => register_destination_out,
		  
		  --Uscite di forwarding
		  forwarded_ALU_data => forwarded_ALU_data,
		  forwarded_memory_data => forwarded_memory_data
		  );
		 
	
   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
	  
	  reset <= '0';

	  control_signals_in <= "0100"; --abilita scrittura
	  ALU_result_in <= x"100D";
	  address_mem_in <= x"04";

	  DHC_abi_C <= '0';
	  forwarded_final_result <= x"0000";
	  
	  wait for 5 ns;
	  
	  clk <= '1';
	  
	  wait for 5 ns;
	  
	  clk <= '0';
  
	  wait for 5 ns;
      
      clk <= '1';
	  control_signals_in <= "0010"; --abilita lettura
	  ALU_result_in <= x"2A00";
	  address_mem_in <= x"03";

	  
	  wait for 5 ns;
	  
      clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  control_signals_in <= "0010"; --abilita lettura
	  ALU_result_in <= x"6A00";
	  address_mem_in <= x"04";
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  control_signals_in <= "0010"; --abilita lettura
	  
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
