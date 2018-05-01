---------------------------------------------------------------------------
-- Interconnect-IN  - Crypto FPGA Side
--                                   
-- File name   : inter_in.vhd
-- Version     : Version  alpha 1.0
-- Created     : 27/FEB/2016
-- Last update : 27/FEB/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
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
				
					--Set/Reset of SLOW Krdy
					if ((rst = '1') OR (s_kvld = '1'))then         -- s_kvld comes from the AES_in component as an ACK signal for receiving the KRDY signal.
						krdy <= '0';
					elsif (f_krdy = '1') then                      -- f_krdy stays at '1' for 1 FAST_clock cycle (component krdy)
						krdy <= '1';
					else
						krdy <= krdy;                             -- preserves the previous value, so the AES_IN component with the SLOW_clock, to be able and 'catch' krdy = 'HIGH'
					end if;
					
					--Set/Reset of SLOW Drdy
					if ((rst = '1') OR (s_dvld = '1'))then         -- s_dvld comes from the AES_in component as an ACK signal for receiving the DRDY signal.
						drdy <= '0';
					elsif (f_drdy = '1') then                      -- f_drdy stays at '1' for 1 FAST_clock cycle (component drdy)
						drdy <= '1';
					else
						drdy <= drdy;                              -- preserves the previous value, so the AES_IN component with the SLOW_clock, to be able and 'catch' drdy = 'HIGH'
					end if;
					
					--Set/Reset of SLOW Hyperegin
					case (f_krdy OR f_drdy) is
						when '1' =>
							hypereg <= f_hyperegin;               -- hypereg takes the new value when f_krdy = '1 or f_dry = '1' 
						when others =>
							hypereg <= hypereg;
					end case;
				end if;
		end process;
		
		s_krdy <= krdy;
		s_drdy <= drdy;
		s_hyperegin <= hypereg;
end arch;
					
					
					
						
						
			