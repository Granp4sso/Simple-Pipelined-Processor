LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY Fetch_Stage IS
	port
        ( reset     : in std_logic;
		  stall     : in std_logic;
		  flush		: inout std_logic;
          clk       : in std_logic;
		  
		  --Ingressi del Branch Control
          branch_taken_in   : in std_logic;     
          jump_in : in std_logic;
		  jump_address_in : in std_logic_vector(7 downto 0);
		  
		  --Enable
		  enable_in : in std_logic; --Per adesso sarà mappato al pc_en, da cambiare poi.
		  
		  --Uscite della pipe_IF_ID
		  next_PC_out   : out std_logic_vector(7 downto 0) := "00000000";     
          control_signals_out : out std_logic_vector(11 downto 0);
		  instruction_out : out std_logic_vector(15 downto 0)
        );
END Fetch_Stage ;
 
ARCHITECTURE Structural OF Fetch_Stage IS 
 
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
	
	COMPONENT Control_Hazard_Unit
	port
        ( CHU_stall	: in std_logic;
          CHU_Branch_Taken : in std_logic;
          CHU_Jump : in std_logic;
          --CHU_Branch : in std_logic; --solo in caso di prediction
		  --CHU_Offset : in std_logic_vector(3 downto 0); --solo in caso di prediction
		  CHU_Incr_add : in std_logic_vector(7 downto 0);
		  CHU_Jump_add : in std_logic_vector(7 downto 0);
		  
		  --segnali di uscita
		  
		  CHU_Next_add: out std_logic_vector(7 downto 0);
		  CHU_Flush_pipe : out std_logic;
		  CHU_DO_NOP : out std_logic;
		  CHU_en_IM : out std_logic
        );
	END COMPONENT;

	signal adder_signal_int : signed(7 downto 0) := x"00";
	signal next_instruction_int : std_logic_vector(7 downto 0) := x"00";
	signal fetched_int : std_logic_vector(15 downto 0) := x"0000";
	signal control_word : std_logic_vector(11 downto 0) := x"000"; 
	signal opcode_muxed : std_logic_vector(3 downto 0) := x"0";
	signal controlled_address : std_logic_vector(7 downto 0) := x"00";
	signal flush_pipe_int : std_logic := '0';
	signal DO_NOP_int : std_logic := '0';
	signal en_IM_int : std_logic := '1';
 
BEGIN
	
	flush <= flush_pipe_int;
	
	-- Instantiate the Unit Under Test (UUT)
    pc_r: PC PORT MAP (
         reset => reset,
		 pc_en => enable_in,
		 clk => clk,
		 next_address => controlled_address,
		 next_instruction => next_instruction_int);
		 
	add: adder_8bit PORT MAP (
			a => x"01",
			b => signed(next_instruction_int),
			sum => adder_signal_int
         );
		 
	im_c: IM PORT MAP (
         reset => reset,
		 en => en_IM_int,
		 clk => clk,
		 instr_address => next_instruction_int,
		 instr_data => fetched_int);

	lut_c : LUT PORT MAP(
		opCode => opcode_muxed,
		signals => control_word
	);
	
	mux : mux_4bit_2_1 PORT MAP(
		a1 => fetched_int(15 downto 12),
		a2 => x"0",
		sel => DO_NOP_int,
		b => opcode_muxed
	);
	
	pipe: pipe_IF_ID port map(
		reset => reset,
		stall => stall,
		flush => flush_pipe_int,
        clk => clk,
        next_PC_in => next_instruction_int,
        control_signals_in => control_word,
		instruction_in => fetched_int,
		  
		next_PC_out => next_PC_out,
        control_signals_out => control_signals_out,
		instruction_out => instruction_out
	);
	
	chu : Control_Hazard_Unit port map(
		CHU_stall => stall,
        CHU_Branch_Taken => branch_taken_in,
        CHU_Jump => jump_in,
		CHU_Incr_add => std_logic_vector(adder_signal_int),
		CHU_Jump_add => jump_address_in,
		  
		  --segnali di uscita
		  
		CHU_Next_add => controlled_address,
		CHU_Flush_pipe => flush_pipe_int,
		CHU_DO_NOP => DO_NOP_int,
		CHU_en_IM => en_IM_int 
	);

END;
