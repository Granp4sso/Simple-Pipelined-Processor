library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DM is
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
end DM;

architecture Behavioral of DM is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(15 downto 0);
	type memory_t is array(255 downto 0) of word_t;
	
	-- Declare the RAM signal.
	signal ram : memory_t := (others => (others => '0'));
	
	-- Register to hold the address
	signal addr_reg : std_logic_vector(7 downto 0) :=x"00";
 
begin

	process(clk)
	begin
		if(reset = '1') then
			data_out <= (others => '0');
		end if;
		
		if(rising_edge(clk)) then
			if(mem_write = '1') then
				ram(to_integer(unsigned(data_address))) <= data_in;
			end if;
		elsif(falling_edge(clk)) then
			if(mem_read = '1') then
				data_out <= ram(to_integer(unsigned(data_address)));
			end if;

		end if;
	
	end process;
	
	

end Behavioral;

