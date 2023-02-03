LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY FF_T_TB IS
END FF_T_TB;
 
ARCHITECTURE behavior OF FF_T_TB IS 
 
    COMPONENT FF_T
	port( 
		T: in std_logic;
		abi: in std_logic;
		clk: in std_logic;
		reset: in std_logic;
		Q: out std_logic
	);
	END COMPONENT;
   
   signal T : std_logic := '0';
   signal clk : std_logic := '1';
   signal reset : std_logic := '1';
   signal abi : std_logic := '0';
   
   signal Q : std_logic;
   
 
BEGIN
 

    uut: FF_T PORT MAP (
         T => T,
		 abi => abi,
		 clk => clk,
		 reset => reset,
		 Q => Q);


   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
      
	  reset <= '0';
	  clk <= '0';

	  wait for 5 ns;
      
      clk <= '1';
	  abi <= '1';
	  T <= '1';
	  
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
