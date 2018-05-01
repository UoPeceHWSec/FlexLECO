---------------------------------------------------------------------------
-- AES-key/data component - Crypto FPGA Side
--                                   
-- File name   : Crypto_Algo_In.vhd
-- Version     : Version  beta 1.0
-- Created     : 2/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity Crypto_Algo_In is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Crypto Bus ----
			blk_in1: out std_logic_vector (8*N-1 downto 0);		--(Interface -> Cryptographic module)		--generic
            blk_in5: out std_logic_vector (8*N-1 downto 0);     --(Interface -> Cryptographic module)       --generic
--            blk_in4: out std_logic_vector (8*N-1 downto 0);     --(Interface -> Cryptographic module)     --generic
--            blk_in3: out std_logic_vector (8*N-1 downto 0);     --(Interface -> Cryptographic module)     --generic
--            blk_in2: out std_logic_vector (8*N-1 downto 0);     --(Interface -> Cryptographic module)     --generic		
            s_krdy_cr: out std_logic;
			s_drdy_cr: out std_logic;
			---- Slow Local Bus ----
			s_krdy: in std_logic;
			s_drdy: in std_logic;
			s_kvld: out std_logic;
			s_dvld: out std_logic;
			hyperegin: in std_logic_vector (INS*8*N-1 downto 0));
end Crypto_Algo_In;

architecture arch of Crypto_Algo_In is
    signal in1: std_logic_vector (8*N-1 downto 0);
    signal in2: std_logic_vector (8*N-1 downto 0);
    signal in3: std_logic_vector (8*N-1 downto 0);
    signal in4: std_logic_vector (8*N-1 downto 0);
    signal in5: std_logic_vector (8*N-1 downto 0);
	signal kvld: std_logic;
	signal dvld: std_logic;
	
	begin
		AESproc: process (clk)
			begin
				if (clk'event and clk='1') then
					if rst='1' then
							in1 <= (others=>'0');
							in5 <= (others=>'0');
--							in4 <= (others=>'0');
--							in3 <= (others=>'0');
--							in2 <= (others=>'0');
							kvld <= '0';
							dvld <= '0';
					else
						case s_krdy is
							when '1' =>
								in1(8*N-1 downto 0) <= hyperegin(8*N-1 downto 0);
								kvld <= '1';                                        
							when others =>
								in1 <= in1;
								kvld <= '0';
						end case;
						
						case s_drdy is
							when '1' =>
							    in5(8*N-1 downto 0) <= hyperegin (8*N-1 downto 0);
--								in4(8*N-1 downto 0) <= hyperegin((2*8*N-1) downto (8*N));
--								in3(8*N-1 downto 0) <= hyperegin((3*8*N-1) downto (2*8*N));
--								in2(8*N-1 downto 0) <= hyperegin((4*8*N-1) downto (3*8*N));
								dvld <= '1';                                      
							when others =>
								in5 <= in5;
								in4 <= in4;
								in3 <= in3;
								in2 <= in2;
								dvld <= '0';
						end case;
					end if;
				end if;
		end process;
		s_krdy_cr <= kvld;                            
		s_drdy_cr <= dvld;                            
		s_kvld <= kvld;                               
		s_dvld <= dvld;                               
		blk_in1 <= in1;
		blk_in5 <= in5;
--		blk_in4 <= in4;
--		blk_in3 <= in3;
--		blk_in2 <= in2;
end arch;		