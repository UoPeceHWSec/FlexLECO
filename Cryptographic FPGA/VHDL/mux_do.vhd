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
-- Lbus_do_MUX - Crypto FPGA Side
--                                   
-- File name   : mux_do.vhd
-- Version     : Version  beta 1.0
-- Created     : 
-- Last update : 6/JAN/2016
-- Desgined by : Athanassios Moschos
----------------------------------------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity muxdo is
		-- generic();
		port (clk: in std_logic;
		      rst: in std_logic;
		      ---- Interconnect Bus ----
			lbus_do: out std_logic_vector (15 downto 0);
			----- Local Interface Bus -----
			mux_en: in std_logic_vector(1 downto 0);
			do_hypereg: in std_logic_vector (15 downto 0);
			status_word: in std_logic_vector (5 downto 0));
end muxdo;

architecture arch of muxdo is
    signal temp: std_logic_vector(15 downto 0);
     
	begin
	   proc: process(clk)                              
	       begin
	       if (clk'event and clk='1') then
	           if (rst = '1') then
	               temp <= (others => '0');
	           else
	               case mux_en is
	                   when "01" =>
	                       temp <= do_hypereg;
	                   when "10" =>
	                       temp <="0000000000"&status_word;
	                   when others =>
	                       temp <= temp;
	               end case;
	           end if;
	       end if;
	   end process; 
	   
		with mux_en select lbus_do <=
			do_hypereg when "01",
			"0000000000"&status_word when "10",
			temp when others;
end arch;
