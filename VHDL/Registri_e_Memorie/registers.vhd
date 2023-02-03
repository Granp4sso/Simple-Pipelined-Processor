library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity registers is

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
end registers;

architecture Behavioral of registers is

    type regfile_t is array (15 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
	signal regfile : regfile_t;
	constant regfile_reset : regfile_t := (others => (others => '0'));
	
begin

    process (reset, clk, write_reg, register_source_1, register_source_2, register_destination)
    begin
        if (reset = '1') then
            register_data_1 <= x"0000";
			register_data_2 <= x"0000";
			regfile <= regfile_reset;
		elsif falling_edge(clk) then
			if(write_reg = '1') then
			regfile(to_integer(unsigned(register_destination))) <= register_result ;
			end if;
			register_data_1 <= regfile(to_integer(unsigned(register_source_1)));
			register_data_2 <= regfile(to_integer(unsigned(register_source_2)));


        end if;
    end process;

end Behavioral;

