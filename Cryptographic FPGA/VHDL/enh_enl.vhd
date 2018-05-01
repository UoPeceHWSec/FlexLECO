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
-- Enable signals for Krdy/Drdy - Crypto FPGA Side
--                                   
-- File name   : enh_enl.vhd
-- Version     : Version  beta 1.0
-- Created     : 6/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanasios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity enhl is
	-- generic();
	
	port (	---- Local Bus ----
			commandregh: in std_logic;
			commandreghalf: in std_logic;
			commandregl: in std_logic;
			blk_trig0: in std_logic;
			enh: out std_logic;
			enl: out std_logic);
end enhl;

architecture arch of enhl is
	
	begin
		enh <= (NOT commandregh) AND commandreghalf AND blk_trig0 AND commandregl;
		enl <= (NOT commandregl) AND blk_trig0;
end arch;