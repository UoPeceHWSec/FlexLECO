---------------------------------------------------------------------------
-- Block Key Ready component - Crypto FPGA Side
--                                   
-- File name   : krdy.vhd
-- Version     : Version  beta 1.0
-- Created     : 6/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity k_rdy is
		--generic ();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Local Bus ----
			enl: in std_logic;
			krdy_l: out std_logic);
end k_rdy;

architecture arch of k_rdy is
	signal krdy: std_logic;
	
	begin
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
				    if (rst='1') then
						krdy <= '0';
					else
						krdy <= enl;
					end if;
				end if;
		end process;
		krdy_l <= krdy;
end arch;