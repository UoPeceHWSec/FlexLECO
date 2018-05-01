---------------------------------------------------------------------------
-- Address_Controller - Crypto FPGA Side
--                                   
-- File name   : add_con.vhd
-- Version     : Version  beta 1.0
-- Created     : 
-- Last update : 6/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
----------------------------------------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity addcon is
		--generic ();
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			----- FPGA Interconnect ---
			lbus_a: in std_logic_vector (15 downto 0); -- Address
			lbus_rd: in std_logic;
			----- Local Interface Bus -----
			exp_adr: in std_logic_vector (15 downto 0);
			mux_en: out std_logic_vector(1 downto 0));
end addcon;

architecture arch of addcon is
	signal mux: std_logic_vector (1 downto 0);
	
	begin
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
					if rst = '1' then
						mux <= "00";
					else
						if (lbus_a = exp_adr) then
							mux <= '0'&(NOT(lbus_rd));
						elsif (lbus_a = "0000000000000010") then
							mux <= (NOT(lbus_rd))&'0';
						else
							mux <= "00";
						end if;
					end if;
				end if;
		end process;
		mux_en <= mux;
end arch;
		