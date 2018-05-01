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
-- HyperegIN component - Crypto FPGA Side
--                                   
-- File name   : hypereg_in.vhd
-- Version     : Version  beta 1.0
-- Created     : 1/JAN/2016
-- Last update : 7/JAN/2016
-- Desgined by : Athanasios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity hypereg_in is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			master_dvld: in std_logic;			
			---- Interconnect Bus ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_di: in std_logic_vector (15 downto 0);
			lbus_wr: in std_logic;
			---- Local Bus ----
			hyperegin: out std_logic_vector (INS*8*N-1 downto 0);
			expadr: out std_logic_vector(15 downto 0));
end hypereg_in;

architecture arch of hypereg_in is

	signal hy_in: std_logic_vector (INS*8*N-1 downto 0):=(others => '0');
	signal exp_adr: std_logic_vector (15 downto 0):="0000000100010000";
	signal dvld_in: std_logic;
	
	begin
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
					dvld_in <= master_dvld;
				end if;
		end process;
		

		proc1: process(clk, rst, hy_in, exp_adr)
			begin
				if (clk'event and clk='1') then
					if ((rst = '1') OR (dvld_in = '1')) then
						exp_adr <= "0000000100010000";
						hy_in <= hy_in;                       
					else
						if ((lbus_a = exp_adr) AND (lbus_wr = '1')) then 
						      exp_adr <= std_logic_vector(unsigned(exp_adr) + "0000000000000010");
                              hy_in <=hy_in((INS*8*N-17) downto 0)&lbus_di;
						else
							exp_adr <=  exp_adr;
							hy_in <= hy_in;
						end if;
					end if;
				end if;
		end process;
		hyperegin <= hy_in;
		expadr <= exp_adr;
end arch;
					
					