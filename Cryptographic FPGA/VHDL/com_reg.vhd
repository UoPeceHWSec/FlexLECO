---------------------------------------------------------------------------
-- Command Register Component - Crypto FPGA Side
--                                   
-- File name   : com_reg.vhd
-- Version     : Version  beta 1.0
-- Created     : 9/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity comreg is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Local Bus ----
			dvld: in std_logic;
			blk_trig0: in std_logic;
			commandreg: out std_logic_vector (INS-1 downto 0));
end comreg;

architecture arch of comreg is
	signal command: std_logic_vector(INS-1 downto 0):=(others =>'0');
	
	begin
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
					if ( (rst OR dvld) = '1') then 
						command <= (others => '0');
					else 
						case blk_trig0 is
							when '1' =>
								command <= command(INS-2 downto 0)&'1'; 
							when others =>
								command <= command;
						end case;
					end if;
				end if;
		end process;
		commandreg <= command;
end arch;