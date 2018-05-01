---------------------------------------------------------------------------
-- Crypto Reset component - Crypto FPGA Side
--                                   
-- File name   : cry_reset.vhd
-- Version     : Version  beta 1.0
-- Created     : 6/JAN/2016
-- Last update : 27/JAN/2018
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity cryreset is
	--generic();
	
	port(-------------- Clock and Reset
		clk: in std_logic;
		rst: in std_logic;
		---- FPGA Interconnect ----
		lbus_a: in std_logic_vector (15 downto 0);
		lbus_di3: in std_logic;
		---- Crypto Bus ----
		ack: in std_logic_vector(1 downto 0);
		rst_state: out std_logic_vector(1 downto 0);
		blk_rstn: out std_logic);
end cryreset;

architecture arch of cryreset is
	signal rstn: std_logic;
	signal state: std_logic_vector(1 downto 0);
	signal last: std_logic_vector(1 downto 0);
	begin
		proc0: process(clk)
			begin
				if (clk'event and clk='1') then
					if rst = '1' then
						state <= "00";
						last <="00";
					else
						case lbus_a is
							when "0000000000000010" =>
								case lbus_di3 is
									when '1' =>
									    last <= "01";
									    state(0) <= '1';
								        state(1) <= state(1);
									when others =>
									    last <= "10";
										state(0) <= state(0);
										state(1) <= '1';
								end case;
							when others =>
								case ack is
									when "01" =>
										state(0) <= '0';
										state(1) <= state(1);
									when "10" =>
										state(0) <= state(0);
										state(1) <= '0';
									when others =>
										state(0) <= state(0);
										state(1) <= state(1);
								end case;
								last <= last;
						end case;
					end if;		
				end if;
		end process;
		
		proc1: process(clk)
			begin
				if (clk'event and clk='1') then
					if rst = '1' then
						rstn <= '1';
					else
						case state is
						  when "01" =>
						      rstn <= '0';
						  when "10" =>
						      rstn <= '1';
						  when "11" =>
						      case last is
						          when "01" =>
						               rstn <= '1';   
						          when others =>
						              rstn <= '0';
						      end case;
						  when others =>
						      rstn <= rstn;
						end case;
					end if;
			     end if;
	   end process;
	   rst_state <= state;
	   blk_rstn <= rstn;
end arch;