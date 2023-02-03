LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY DHC_TB IS
END DHC_TB ;
 
ARCHITECTURE behavior OF DHC_TB  IS 
 
    COMPONENT Data_Hazard_Control
		port(
		  DHC_RS1_1	: in std_logic_vector(3 downto 0);
          DHC_RS1_2 : in std_logic_vector(3 downto 0);
          DHC_RS2 : in std_logic_vector(3 downto 0);
          DHC_RD_1 : in std_logic_vector(3 downto 0);
          DHC_RD_2 : in std_logic_vector(3 downto 0);
		  
		  --segnali di controllo in ingresso
		  
		  DHC_Mem_write : in std_logic;
		  DHC_Mem_read : in std_logic;
		  DHC_Write_reg_1 : in std_logic;
		  DHC_Write_reg_2 : in std_logic;
		  
		  --segnali di uscita
		  
		  DHC_Abi_a : out std_logic_vector(1 downto 0);
		  DHC_Abi_b : out std_logic_vector(1 downto 0);
		  DHC_Abi_c : out std_logic
		);
	END COMPONENT;

   --Inputs
	signal DHC_RS1_1 : std_logic_vector(3 downto 0);
    signal DHC_RS1_2 : std_logic_vector(3 downto 0);
    signal DHC_RS2 : std_logic_vector(3 downto 0);
    signal DHC_RD_1 : std_logic_vector(3 downto 0);
    signal DHC_RD_2 : std_logic_vector(3 downto 0);
		  
	signal DHC_Mem_write : std_logic;
	signal DHC_Mem_read : std_logic;
	signal DHC_Write_reg_1 : std_logic;
	signal DHC_Write_reg_2 : std_logic;
		  
	--outputs	  
	signal DHC_Abi_a : std_logic_vector(1 downto 0);
	signal DHC_Abi_b : std_logic_vector(1 downto 0);
	signal DHC_Abi_c : std_logic;
 
BEGIN
 
	--next_address <= std_logic_vector(testadd);
	
	-- Instantiate the Unit Under Test (UUT)
    dhc_uut: Data_Hazard_Control PORT MAP (
          DHC_RS1_1 => DHC_RS1_1,
          DHC_RS1_2 => DHC_RS1_2,
          DHC_RS2 => DHC_RS2,
          DHC_RD_1 => DHC_RD_1,
          DHC_RD_2 => DHC_RD_2,
		  
		  --segnali di controllo in ingresso
		  
		  DHC_Mem_write => DHC_Mem_write,
		  DHC_Mem_read => DHC_Mem_read,
		  DHC_Write_reg_1 => DHC_Write_reg_1,
		  DHC_Write_reg_2 => DHC_Write_reg_2,
		  
		  --segnali di uscita
		  
		  DHC_Abi_a => DHC_Abi_a,
		  DHC_Abi_b => DHC_Abi_b,
		  DHC_Abi_c => DHC_Abi_c
		  );
		 
	

   -- Stimulus process
   stim_proc: process
   begin
			
	  DHC_RS1_1 <= x"A";
      DHC_RS1_2 <= x"B";
      DHC_RS2 <= x"C";
      DHC_RD_1 <= x"A";
      DHC_RD_2 <= x"B";

	  DHC_Mem_write <= '0';
	  DHC_Mem_read <= '0';
	  DHC_Write_reg_1 <= '1';
	  DHC_Write_reg_2 <= '0';
		  
	  wait for 5 ns;
	  
	  DHC_Mem_write <= '1';
	  DHC_Mem_read <= '0';
	  DHC_Write_reg_1 <= '0';
	  DHC_Write_reg_2 <= '1';
	  
	  wait for 5 ns;
      
      wait;
   end process;

END;
