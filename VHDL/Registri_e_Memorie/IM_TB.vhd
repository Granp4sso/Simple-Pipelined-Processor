LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY IM_TB IS
END IM_TB;
 
ARCHITECTURE behavior OF IM_TB IS 
 
    COMPONENT IM
    port
        ( reset     : in std_logic;
		  en     : in std_logic;
          clk       : in std_logic;
          instr_address : in std_logic_vector(7 downto 0) := "00000000";     
          instr_data : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	
   --Inputs
   signal reset : std_logic := '1';
   signal en : std_logic := '1';
   signal clk : std_logic := '1';
   signal instr_address : std_logic_vector(7 downto 0) := "00000000";

   -- OUT
   signal instr_data : std_logic_vector(15 downto 0) := x"0000";

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--next_address <= std_logic_vector(testadd);
	
	-- Instantiate the Unit Under Test (UUT)
    uut: IM PORT MAP (
         reset => reset,
		 en => en,
		 clk => clk,
		 instr_address => instr_address,
		 instr_data => instr_data);

   -- Clock process definitions
   --clk_process :process
  -- begin
	--	clk <= '0';
	--	wait for clk_period/2;
	--	clk <= '1';
	--	wait for clk_period/2;
  -- end process;
 

   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
      
	  reset <= '0';
	  instr_address <= x"01";
	  clk <= '0';
  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
	  instr_address <= x"02";
      clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
	  
	  instr_address <= x"03";
      clk <= '0';
	  
	  wait for 5 ns;
      
      clk <= '1';
	  
	  wait for 5 ns;
      
      wait;
   end process;

END;
