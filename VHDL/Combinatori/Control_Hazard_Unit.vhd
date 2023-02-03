library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Hazard_Unit is

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

end Control_Hazard_Unit;

architecture Behavioral of Control_Hazard_Unit is
begin

	process(CHU_stall, CHU_Branch_Taken, CHU_Jump, CHU_Incr_add, CHU_Jump_add)
		begin
		
			if(CHU_stall = '1') then
				CHU_Next_add <= std_logic_vector(signed(CHU_Incr_add)-1);
				CHU_Flush_pipe <= '0';
				CHU_DO_NOP <= '0';
				CHU_en_IM <= '0';
			elsif(CHU_Branch_Taken = '1' or CHU_Jump = '1') then
				CHU_Next_add <= CHU_Jump_add;
				CHU_Flush_pipe <= '1';
				CHU_DO_NOP <= '0';
				CHU_en_IM <= '1';
			else	
				CHU_Next_add <= CHU_Incr_add;
				CHU_Flush_pipe <= '0';
				CHU_DO_NOP <= '0';
				CHU_en_IM <= '1';
			end if;
		
		end process;

end Behavioral;

