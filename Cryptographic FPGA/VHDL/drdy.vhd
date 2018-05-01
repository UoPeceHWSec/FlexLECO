---------------------------------------------------------------------------
-- Block Data Ready component - Crypto FPGA Side
--                                   
-- File name   : drdy.vhd
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

entity d_rdy is
		--generic ();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Local Bus ----
			enh: in std_logic;
			drdy_l: out std_logic);
end d_rdy;

architecture arch of d_rdy is
	signal drdy: std_logic;
	
	begin
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
				    if (rst='1') then
						drdy <= '0';
					else
						drdy <= enh;
					end if;
				end if;
		end process;
		drdy_l <= drdy;
end arch;