---------------------------------------------------------------------------
-- Control Word component - Crypto FPGA Side
--                                   
-- File name   : control_word.vhd
-- Version     : Version  beta 1.0
-- Created     : 4/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity controlword is
		-- generic();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Local Bus ----
			blk_krdy: in std_logic;
			blk_drdy: in std_logic;
			blk_dvld: in std_logic;
			blk_kvld: in std_logic;
			blk_rstn: in std_logic;
			blk_endec: in std_logic;
			status_word: out std_logic_vector (5 downto 0));
end controlword;

architecture arch of controlword is
	signal cntrl: std_logic_vector (5 downto 0); 
	
	begin
		proc0: process (clk)
			begin
				if (clk'event and clk='1') then
					if rst='1' then
						cntrl <= (others => '0');
					else
						case blk_krdy is
							when '1' =>
								cntrl(0) <= '1';
							when others =>
								cntrl(0) <= cntrl(0);
						end case;
				
						case blk_drdy is
							when '1' =>
								cntrl(1) <= '1';
							when others =>
								cntrl(1) <= cntrl(1);
						end case;
					
						case blk_kvld is
							when '1' =>
								cntrl(2) <= '1';
							when others =>
								cntrl(2) <= cntrl(2);
						end case;
					
						case blk_dvld is
							when '1' =>
								cntrl(3) <= '1';
							when others =>
								cntrl(3) <= cntrl(3);
						end case;
					end if;
					cntrl(5) <= NOT(blk_rstn);	
					cntrl(4) <= blk_endec;
				end if;
		end process;
		status_word <= cntrl;
end arch;
		
					
					
					
			