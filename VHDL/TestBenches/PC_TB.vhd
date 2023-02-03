LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY PC_TB IS
END PC_TB;
 
ARCHITECTURE behavior OF PC_TB IS 
 
    COMPONENT PC
    port
        ( reset     : in std_logic;
		  pc_en     : in std_logic;
          clk       : in std_logic;
          next_address : in std_logic_vector(7 downto 0) := "00000000";     
          next_instruction : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	
	COMPONENT adder_8bit
    Port ( a : in  signed(7 downto 0) ;
           b : in  signed(7 downto 0);
           sum : out  signed(7 downto 0));
    END COMPONENT;
	
    

   --Inputs
   signal reset : std_logic := '1';
   signal pc_en : std_logic := '1';
   signal clk : std_logic := '1';
   signal next_address : std_logic_vector(7 downto 0) := "00000000";
   signal testadd : signed(7 downto 0) := "00000000";

   -- OUT
   signal next_instruction : std_logic_vector(7 downto 0) := "00000000";

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--next_address <= std_logic_vector(testadd);
	
	-- Instantiate the Unit Under Test (UUT)
    uut: PC PORT MAP (
         reset => reset,
		 pc_en => pc_en,
		 clk => clk,
		 next_address => std_logic_vector(testadd),
		 next_instruction => next_instruction);
		 
	uut2: adder_8bit PORT MAP (
			a => x"01",
			b => signed(next_instruction),
			sum => testadd
         );

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
