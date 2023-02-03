LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY fetch_TB IS
END fetch_TB ;
 
ARCHITECTURE behavior OF fetch_TB  IS 
 
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
	
    COMPONENT IM
    port
        ( reset     : in std_logic;
		  en        : in std_logic;
          clk       : in std_logic;
          instr_address : in std_logic_vector(7 downto 0) := "00000000";     
          instr_data : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	
	COMPONENT LUT
	    port
        ( opCode  : in std_logic_vector(3 downto 0);
          signals : out std_logic_vector(11 downto 0)
        );
	END COMPONENT;
	
	COMPONENT mux_4bit_2_1
		port(
		  a1      : in  std_logic_vector(3 downto 0);
		  a2      : in  std_logic_vector(3 downto 0);
		  sel     : in  std_logic;
		  b       : out std_logic_vector(3 downto 0));
	END COMPONENT;
	
	COMPONENT pipe_IF_ID
    port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  flush		: in std_logic;
          clk       : in std_logic;
          next_PC_in   : in std_logic_vector(7 downto 0) := "00000000";     
          control_signals_in : in std_logic_vector(11 downto 0);
		  instruction_in : in std_logic_vector(15 downto 0);
		  
		  next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";     
          control_signals_out : out std_logic_vector(11 downto 0);
		  instruction_out : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal reset : std_logic := '1';
   signal pc_en : std_logic := '1';
   signal en : std_logic := '1';
   signal clk : std_logic := '1';
   signal next_address : std_logic_vector(7 downto 0) := "00000000";
   signal testadd : signed(7 downto 0) := "00000000";
   --signal instr_address : std_logic_vector(7 downto 0) := "00000000";

   --Outputs
   signal next_instruction : std_logic_vector(7 downto 0) := "00000000";
   signal instr_data : std_logic_vector(15 downto 0) := x"0000";
   signal abi : std_logic_vector(11 downto 0);
   signal opcode_muxed : std_logic_vector(3 downto 0);
   
   signal next_PC_out   : std_logic_vector(7 downto 0) := "00000000";     
   signal control_signals_out : std_logic_vector(11 downto 0);
   signal instruction_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--next_address <= std_logic_vector(testadd);
	
	-- Instantiate the Unit Under Test (UUT)
    pc_uut: PC PORT MAP (
         reset => reset,
		 pc_en => pc_en,
		 clk => clk,
		 next_address => std_logic_vector(testadd),
		 next_instruction => next_instruction);
		 
	add_uut: adder_8bit PORT MAP (
			a => x"01",
			b => signed(next_instruction),
			sum => testadd
         );
		 
	im_uut: IM PORT MAP (
         reset => reset,
		 en => en,
		 clk => clk,
		 instr_address => next_instruction,
		 instr_data => instr_data);

	lut_uut : LUT PORT MAP(
		opCode => opcode_muxed,
		signals => abi
	);
	
	mux_uut : mux_4bit_2_1 PORT MAP(
		a1 => instr_data(15 downto 12),
		a2 => x"0",
		sel => '0',
		b => opcode_muxed
	);
	
	pipe_uut : pipe_IF_ID port map(
		reset => reset,
		stall => '0',
		flush => '0',
        clk => clk,
        next_PC_in => std_logic_vector(testadd),
        control_signals_in => abi,
		instruction_in => instr_data,
		  
		next_PC_out => next_PC_out,
        control_signals_out => control_signals_out,
		instruction_out => instruction_out
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
