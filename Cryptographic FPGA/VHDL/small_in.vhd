---------------------------------------------------------------------------
-- small_input - Crypto FPGA Side
--                                   
-- File name   : small_in.vhd
-- Version     : Version  beta 1.0
-- Created     : 10/JAN/2017
-- Last update : 10/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
----------------------------------------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity smallin is
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Interconnect Bus ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_di: in std_logic_vector (7 downto 0);
			---- Local Interface Bus ----
			sm_in: out std_logic_vector(7 downto 0));
end smallin;

architecture arch of smallin is
	signal small: std_logic_vector(7 downto 0);
	
	begin
		proc0: process (clk)
			begin
				if (clk'event and clk = '1') then
					if (rst = '1') then
						small <= (others => '0');
					else
						case lbus_a is	
							when "0000000000000011" =>
								small <= lbus_di;
							when others =>
								small <= small;
						end case;
					end if;
				end if;
		end process;
		sm_in <= small;
end arch;