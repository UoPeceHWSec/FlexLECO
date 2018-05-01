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
-- Block Data Ready component - Crypto FPGA Side
--                                   
-- File name   : drdy.vhd
-- Version     : Version  beta 1.0
-- Created     : 6/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanasios Moschos
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