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
-- Tri_Ctrl_wr component - Crypto FPGA Side
--                                   
-- File name   : trig_ctrl_wr.vhd
-- Version     : Version  beta 1.0
-- Created     : 6/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanasios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity trigctrl is
	--generic();
	
	port(-------------- Clock and Reset
		clk: in std_logic;
		rst: in std_logic;
		---- FPGA Interconnect ----
		lbus_a: in std_logic_vector (15 downto 0);
		lbus_wr: in std_logic;
		---- Local Bus ----
		ctrl_wr: out std_logic);
end trigctrl;

architecture arch of trigctrl is
	signal trig: std_logic;
	signal ctrl: std_logic;
	signal wr: std_logic_vector (1 downto 0);
	begin
		proc0: process (clk)
			begin
				if (clk'event and clk='1') then
					if (rst = '1') then
						trig <= '0';
						wr <= "00";
						ctrl <= '0';
					else
						case wr is
							when "01" =>
								trig <= '1';
							when others =>
								trig <= '0';
						end case;
						wr <= wr(0)&lbus_wr;
					end if;
					case lbus_a is
						when "0000000000000010" =>
							ctrl <= '1';
						when others =>
							ctrl <= '0';
					end case;
				end if;
		end process;
		ctrl_wr <= (trig AND ctrl);
end arch;