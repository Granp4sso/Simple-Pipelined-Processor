LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY registers_TB IS
END registers_TB;
 
ARCHITECTURE behavior OF registers_TB IS 
 
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
	
    

   --Inputs
   signal reset : std_logic := '1';
   signal write_reg : std_logic := '0';
   signal clk : std_logic := '1';
   signal register_source_1 : std_logic_vector(3 downto 0);
   signal register_source_2 : std_logic_vector(3 downto 0);
   signal register_destination : std_logic_vector(3 downto 0);
   signal register_result : std_logic_vector(15 downto 0);

   -- OUT
   signal register_data_1 : std_logic_vector(15 downto 0);
   signal register_data_2 : std_logic_vector(15 downto 0);
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--next_address <= std_logic_vector(testadd);
	
	-- Instantiate the Unit Under Test (UUT)
    uut: registers PORT MAP (
		  reset => reset,
          clk => clk,
		  register_source_1 => register_source_1,
		  register_source_2 => register_source_2,
		  register_destination => register_destination,
		  register_result => register_result,
		  write_reg => write_reg,
		  
		  register_data_1 => register_data_1,
          register_data_2 => register_data_2
		  );


   -- Stimulus process
   stim_proc: process
   begin
			
      wait for 5 ns;
      
	  reset <= '0';
	  register_source_1 <= x"0";
	  register_source_2 <= x"0";
	  register_result <= x"1000";
	  register_destination <= x"0";
	  write_reg <= '1';
	  
	  wait for 5 ns;
	  
	  clk <= '0';  
	  
	  wait for 5 ns;
      
	  write_reg <= '0';
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
