---------------------------------------------------------------------------
-- HyperegOUT component - Crypto FPGA Side
--                                   
-- File name   : hypereg_out.vhd
-- Version     : Version  beta 1.0
-- Created     : 1/JAN/2016
-- Last update : 7/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
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
		proc0: process(clk)                           -- MAYBE unecessary 1 FAST_clock cycle delay / unecessaru because set_dvld comes from INTER_OUT component as well as the hyperegout
			begin
				if (clk'event and clk='1') then
					dvld <= set_dvld;              -- DELAY OF 1 CLOCK CYCLE, IN ORDER FOR THE HYPEREGOUT TO GET SET WITH THE RIGHT VALUE OF CIPHERTEXT
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
						