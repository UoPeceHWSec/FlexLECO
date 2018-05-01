---------------------------------------------------------------------------
--	Copyright 2018 Athanasios Moschos, Apostolos Fournaris
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--  	  http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
--	
--	 When you publish any results arising from the use of this code, we will
--   appreciate it if you can cite our webpage.
--	 (https://github.com/UoPeceHWSec/FlexLECO)
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- HyperegOUT component - Crypto FPGA Side
--                                   
-- File name   : hypereg_out.vhd
-- Version     : Version  beta 1.0
-- Created     : 1/JAN/2016
-- Last update : 7/JAN/2016
-- Desgined by : Athanasios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity hypereg_out is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			set_dvld: in std_logic;
			---- FPGA Interconnect ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_rd: in std_logic;
			---- Local Bus ----
			start_adr: in std_logic_vector (15 downto 0);
			hyperegout: in std_logic_vector (DAO*8*N-1 downto 0);
			do_l: out std_logic_vector (15 downto 0);
			rd_ACK_l: out std_logic;
			expadr: out std_logic_vector(15 downto 0));
end hypereg_out;

architecture arch of hypereg_out is
	signal exp_adr: std_logic_vector (15 downto 0):="1111111111111111";
	signal hyper_temp: std_logic_vector (DAO*8*N-1 downto 0):=(others =>'0');
	signal dvld: std_logic;
	signal rd_ACK: std_logic;
	signal do: std_logic_vector (15 downto 0);
	signal len2: integer;
	signal len1: integer;
	
	begin
		proc0: process(clk)                           
			begin
				if (clk'event and clk='1') then
					dvld <= set_dvld;              
				end if;
		end process;
		
		proc1: process(clk)
			begin
				if (clk'event and clk='1') then
					if (dvld = '1') then
						exp_adr <= start_adr;
						do <= do;
						hyper_temp <= hyperegout;
						rd_ACK <= '0';
					else
						if ((lbus_a = exp_adr) AND (NOT lbus_rd = '1')) then
						          exp_adr <= std_logic_vector(unsigned(exp_adr) + "0000000000000010");
                                  do <= hyper_temp(DAO*8*N-1 downto DAO*8*N-16);
                                  hyper_temp <= hyper_temp(DAO*8*N-17 downto 0)&"0000000000000000";
                                  rd_ACK <= '1';
						else 
                            exp_adr <= exp_adr;
							do <= do;
							hyper_temp <= hyper_temp;
							rd_ACK <= '0';
						end if;
					end if;
				end if;
		end process;
		do_l <= do;
		expadr <= exp_adr;
		rd_ACK_l <= rd_ACK;
end arch;
						