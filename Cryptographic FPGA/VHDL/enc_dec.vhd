---------------------------------------------------------------------------
-- En/Decode input - Crypto FPGA Side
--                                   
-- File name   : enc_dec.vhd
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

entity encdec is
		--generic (N: integer:=16; K: integer:=8; INS: integer:=2);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Interconnect Bus ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_di0: in std_logic;
			----- Local Interface Bus -----
			ende: out std_logic);
end encdec;

architecture arch of encdec is
	signal temp: std_logic;
	
	begin
		proc0: process (clk)
			begin
				if (clk'event and clk = '1') then
					if (rst = '1') then
						temp <= '0';
					else
						case lbus_a is
							when "0000000000001100" =>
								temp <= lbus_di0;
							when others =>
								temp <= temp;
						end case;
					end if;	
				end if;
		end process;
		ende <= temp;
end arch;