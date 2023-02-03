library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Hazard_Control is

    port
        ( 
		  DHC_RS1_0 : in std_logic_vector(3 downto 0);
		  DHC_RS2_0 : in std_logic_vector(3 downto 0);
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
		  DHC_Abi_c : out std_logic;
		  DHC_1or2_a : out std_logic_vector(1 downto 0);
		  DHC_1or2_b : out std_logic_vector(1 downto 0);
		  DHC_Abi_S1 : out std_logic;
		  DHC_Abi_S2 : out std_logic
        );

end Data_Hazard_Control;

architecture Behavioral of Data_Hazard_Control is
begin

	process(DHC_RS1_1,DHC_RS1_2,DHC_RS2,DHC_RD_1,DHC_RD_2,DHC_Mem_read,DHC_Mem_write,DHC_Write_reg_1,DHC_Write_reg_2,DHC_RS1_0, DHC_RS2_0)
		begin
			if(DHC_Mem_read = '0' and DHC_Write_reg_1 = '1' and DHC_RS1_1 = DHC_RD_1) then
				DHC_Abi_a <= "01";
				DHC_1or2_a <= "00";
			elsif(DHC_Mem_read = '0' and DHC_Write_reg_2 = '1' and DHC_RS1_1 = DHC_RD_2) then
				DHC_Abi_a <= "01";
				DHC_1or2_a <= "10";
			elsif(DHC_Mem_read = '1' and DHC_Write_reg_1 = '1' and DHC_RS1_1 = DHC_RD_1) then
				DHC_Abi_a <= "10";
				DHC_1or2_a <= "00";
			elsif(DHC_Mem_read = '1' and DHC_Write_reg_2 = '1' and DHC_RS1_1 = DHC_RD_2) then
				DHC_Abi_a <= "10";
				DHC_1or2_a <= "01";
			else
				DHC_Abi_a <= "00";
				DHC_1or2_a <= "00";
			end if;
			
			if(DHC_Mem_read = '0' and DHC_Write_reg_1 = '1' and DHC_RS2 = DHC_RD_1) then
				DHC_Abi_b <= "01";
				DHC_1or2_b <= "00";
			elsif(DHC_Mem_read = '0' and DHC_Write_reg_2 = '1' and DHC_RS2 = DHC_RD_2) then
				DHC_Abi_b <= "01";
				DHC_1or2_b <= "10";
			elsif(DHC_Mem_read = '1' and DHC_Write_reg_1 = '1' and DHC_RS2 = DHC_RD_1) then
				DHC_Abi_b <= "10";
				DHC_1or2_b <= "00";
			elsif(DHC_Mem_read = '1' and DHC_Write_reg_2 = '1' and DHC_RS2 = DHC_RD_2) then
				DHC_Abi_b <= "10";
				DHC_1or2_b <= "01";
			else
				DHC_Abi_b <= "00";
				DHC_1or2_b <= "00";
			end if;
			
			if(DHC_Mem_write = '1' and DHC_Write_reg_2 = '1' and DHC_RS1_2 = DHC_RD_2) then
				DHC_Abi_c <= '1';
			else
				DHC_Abi_c <= '0';
			end if;
			
			if(DHC_Write_reg_2 = '1' and DHC_RS1_0 = DHC_RD_2) then
				DHC_Abi_S1 <= '1';
				DHC_Abi_S2 <= '0';
			elsif(DHC_Write_reg_2 = '1' and DHC_RS2_0 = DHC_RD_2) then
				DHC_Abi_S1 <= '0';
				DHC_Abi_S2 <= '1';
			else
				DHC_Abi_S1 <= '0';
				DHC_Abi_S2 <= '0';
			end if;
		
		end process;

end Behavioral;

