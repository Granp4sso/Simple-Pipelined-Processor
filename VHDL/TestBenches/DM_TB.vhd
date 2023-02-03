LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY DM_TB IS
END DM_TB;
 
ARCHITECTURE behavior OF DM_TB IS 
 
    COMPONENT DM
    port
        ( reset     : in std_logic;
		  en     : in std_logic;
          clk       : in std_logic;
		  mem_write : in std_logic;
		  mem_read : in std_logic;
		  
          data_address : in std_logic_vector(7 downto 0) := "00000000";     
          data_in : in std_logic_vector(15 downto 0);
		  data_out : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	
   --Inputs
   signal reset : std_logic := '1';
   signal en : std_logic := '1';
   signal clk : std_logic := '1';
   signal mem_write : std_logic := '0';
   signal mem_read : std_logic := '0';
   
   signal data_address : std_logic_vector(7 downto 0) := "00000000";
   signal data_in : std_logic_vector(15 downto 0) := x"0000";

   -- OUT
   signal data_out : std_logic_vector(15 downto 0) := x"0000";

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	
	-- Instantiate the Unit Under Test (UUT)
    uut: DM PORT MAP (
         reset => reset,
		 en => en,
		 clk => clk,
		 mem_write => mem_write,
		 mem_read => mem_read,
		 data_address => data_address,
		 data_in => data_in,
		 data_out => data_out);

 

   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
      
	  reset <= '0';
	  clk <= '0';
	  mem_write <= '1';
	  data_address <= x"03";
	  data_in <= x"D000";
  
	  wait for 5 ns;
      
      clk <= '1';

	  wait for 5 ns;
	  
      clk <= '0';
	  mem_write <= '0';
	  mem_read <= '1';
	  data_address <= x"03";
	  
	  wait for 5 ns;
      
      clk <= '1';
	  mem_read <= '0';
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  mem_write <= '1';
	  data_address <= x"04";
	  data_in <= x"AAAA";
	  
	  wait for 5 ns;
      
      clk <= '1';	 
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  data_address <= x"03";
	  mem_read <= '1';
	  mem_write <= '0';
	  
	  wait for 5 ns;
	  
	  clk <= '1';
	  
	  wait for 5 ns;
	  
      clk <= '0';
	  data_address <= x"05";
	  data_in <= x"BBBB";
	  
	  wait for 5 ns;
	  
	  clk <= '1';
	  mem_write <= '0';
	  data_address <= x"04";
	  mem_read <= '1';
	  
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
	  
      clk <= '0';
	  
	  wait for 5 ns;
      
      wait;
   end process;

END;
