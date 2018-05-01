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
-- Interconnect-IN  - Crypto FPGA Side
--                                   
-- File name   : inter_in.vhd
-- Version     : Version  alpha 1.0
-- Created     : 27/FEB/2016
-- Last update : 27/FEB/2016
-- Desgined by : Athanasios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity INTERin is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Fast Local Bus ----
			f_krdy: in std_logic;
			f_drdy: in std_logic;
			f_hyperegin: in std_logic_vector (INS*8*N-1 downto 0);
			---- Slow Local Bus ----
			s_krdy: out std_logic;
			s_drdy: out std_logic;
			s_hyperegin: out std_logic_vector (INS*8*N-1 downto 0);
			s_kvld: in std_logic;
			s_dvld: in std_logic);
end INTERin;

architecture arch of INTERin is
	signal krdy: std_logic;
	signal drdy: std_logic;
	signal hypereg: std_logic_vector (INS*8*N-1 downto 0);
	
	begin
		proc0: process(clk)
			begin	
				if (clk'event and clk='1') then
				
					if ((rst = '1') OR (s_kvld = '1'))then         
						krdy <= '0';
					elsif (f_krdy = '1') then                      
						krdy <= '1';
					else
						krdy <= krdy;                             
					end if;
					
					
					if ((rst = '1') OR (s_dvld = '1'))then         
						drdy <= '0';
					elsif (f_drdy = '1') then                      
						drdy <= '1';
					else
						drdy <= drdy;                              
					end if;
					

					case (f_krdy OR f_drdy) is
						when '1' =>
							hypereg <= f_hyperegin; 
						when others =>
							hypereg <= hypereg;
					end case;
				end if;
		end process;
		
		s_krdy <= krdy;
		s_drdy <= drdy;
		s_hyperegin <= hypereg;
end arch;
					
					
					
						
						
			