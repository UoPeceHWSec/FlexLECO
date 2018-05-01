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
-- Interconnect-OUT - Crypto FPGA Side
--                                   
-- File name   : inter_out.vhd
-- Version     : Version  alpha 1.0
-- Created     : 27/FEB/2016
-- Last update : 27/FEB/2016
-- Desgined by : Athanasios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity INTERout is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Fast Local Bus ----
			f_kvld: out std_logic;
			f_dvld: out std_logic;
			f_hyperegout: out std_logic_vector (DAO*8*N-1 downto 0);
			---- Slow Local Bus ----
			s_hyperegout: in std_logic_vector (DAO*8*N-1 downto 0);
			s_kvld: in std_logic;
			s_dvld: in std_logic);
end INTERout;

architecture arch of INTERout is

    component D_FF is
        PORT( D,CLOCK: in std_logic;
              Q: out std_logic);
    end component;
    
    signal inp_d_ff: std_logic;
    signal outp_d_ff: std_logic;
    signal inp_k_ff: std_logic;
    signal outp_k_ff: std_logic;
	signal kvld: std_logic;
	signal dvld: std_logic;
	signal hypereg: std_logic_vector (DAO*8*N-1 downto 0);
	
	begin
		proc0: process(clk)                               
				begin
					if (clk'event and clk='1') then
					   inp_k_ff <= s_kvld;
                       inp_d_ff <= s_dvld;
					end if;
		end process;
		
		d_ff_kvld: D_FF port map (inp_k_ff, clk, outp_k_ff);
		d_ff_dvld: D_FF port map (inp_d_ff, clk, outp_d_ff);

		proc1: process(clk)
		      begin
		          	if (clk'event and clk='1') then			
					   if (rst = '1') then
							hypereg <= (others =>'0');
					   elsif ((inp_k_ff AND (NOT outp_k_ff)) = '1') then
							hypereg <= s_hyperegout;
					   elsif ((inp_d_ff AND (NOT outp_d_ff)) = '1') then
							hypereg <= s_hyperegout;
					   else
							hypereg <= hypereg;
					   end if;
						
					   if ((inp_k_ff AND (NOT outp_k_ff)) = '1') then	
							kvld <= '1';                                 
					   else
							kvld <= '0';
					   end if;
						
					   if ((inp_d_ff AND (NOT outp_d_ff)) = '1') then
							dvld <= '1';                                 
					   else
							dvld <= '0';
					   end if;
				    end if;
		end process;
		f_kvld <= kvld;                                                 
		f_dvld <= dvld;                                                 
		f_hyperegout <= hypereg;                                        
end arch;