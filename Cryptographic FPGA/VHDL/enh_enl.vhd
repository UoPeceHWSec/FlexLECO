---------------------------------------------------------------------------
-- Enable signals for Krdy/Drdy - Crypto FPGA Side
--                                   
-- File name   : enh_enl.vhd
-- Version     : Version  beta 1.0
-- Created     : 6/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
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