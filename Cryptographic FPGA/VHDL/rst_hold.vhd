---------------------------------------------------------------------------
-- Crypto Reset component - Crypto FPGA Side
--                                   
-- File name   : rst_hold.vhd
-- Version     : Version  beta 1.0
-- Created     : 27/JAN/2018
-- Last update : 27/JAN/2018
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity rsthold is
	--generic();
	
	port(-------------- Clock and Reset
		clk: in std_logic;
		rst: in std_logic;
		---- Crypto Bus ----
		blk_rstn: in std_logic;
		rst_state: in std_logic_vector(1 downto 0);
		ack_rstn: out std_logic_vector(1 downto 0);
		blk_rstn_s: out std_logic);
end rsthold;

architecture arch of rsthold is
    signal rstn: std_logic;
    signal ack: std_logic_vector (1 downto 0); 
    begin
		proc0: process(clk)
			begin
			     if (clk'event and clk ='1') then
			         if (rst = '1') then
			             rstn <= '1';
			             ack <= "00";
			         else
			             case rst_state is
			                 when "10" =>
			                     rstn <= blk_rstn;
			                     ack <= "10";
			                 when "01" =>
			                     rstn <= blk_rstn;
			                     ack <= "01";
			                 when "11" =>
			                     case blk_rstn is
			                         when '1' =>
			                             rstn <= '1';
			                             ack <= "10";
			                         when others =>
			                             rstn <= '0';
			                             ack <= "01";
			                     end case;
			                 when others =>
			                     rstn <= rstn;
			                     ack <= "00";
			             end case;
			         end if;
			     end if;
		end process;
		ack_rstn <= ack;
		blk_rstn_s <= rstn;    
end arch;			     