---------------------------------------------------------------------------
-- Block Trigger component - Crypto FPGA Side
--                                   
-- File name   : blk_trig.vhd
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

entity blktrig is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- FPGA Interconnect ----
			lbus_di0: in std_logic;
			---- Local Bus ----
			ctrl_wr: in std_logic;
			blk_trig: out std_logic_vector (N-1 downto 0));
end blktrig;

architecture arch of blktrig is
	signal trigger: std_logic_vector (N-1 downto 0);
	
	begin	
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
					if rst='1' then 
						trigger <= (others => '0');
					else
						case ctrl_wr is
							when '1' =>
								trigger <= (others => '0');
								trigger(N-1) <= lbus_di0;	
							when others =>
								trigger <= '0'&trigger(N-1 downto 1);	
						end case;
					end if;
				end if;	
		end process;
		blk_trig <= trigger;
end arch;