---------------------------------------------------------------------------
-- Cipher data component - Crypto FPGA Side
--                                   
-- File name   : crypto_return-AES.vhd
-- Version     : Version  beta 1.0
-- Created     : 4/JAN/2016
-- Last update : 12/JAN/2016
-- Desgined by : Athanassios Moschos
--
--Copyright (C) 2016 Athanassios Moschos
---------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity Crypto_Algo_Return is
        generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Crypto Bus ----
			blk_dout1: in std_logic_vector (8*N-1-EXBITS downto 0);	     -- Data Input (Cryptographic module -> Interface)		--generic
--            blk_dout2: in std_logic_vector (8*N-1-EXBITS downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
--            blk_dout3: in std_logic_vector (8*N-1-EXBITS downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
--            blk_dout4: in std_logic_vector (8*N-1-EXBITS downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
--            blk_dout5: in std_logic_vector (8*N-1-EXBITS downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
            blk_kvld: in std_logic;
            blk_dvld: in std_logic;
			----Slow Local Bus ----
			s_kvld: out std_logic;
			s_dvld: out std_logic;
			hyperegout: out std_logic_vector (DAO*8*N-1 downto 0));
end Crypto_Algo_Return;

architecture arch of Crypto_Algo_Return is
	signal hyperout: std_logic_vector (DAO*8*N-1 downto 0):=(others => '0');
	signal kvld: std_logic;
	signal dvld: std_logic;

	begin
		proc0: process(clk)
				begin
					if (clk'event and clk='1') then
						if rst = '1' then
							hyperout <= (others => '0');
						else
							case (blk_dvld OR blk_kvld) is
								when '1' => -- I only use blk_dvld case
								    hyperout(8*N-EXBITS-1 downto 0) <= blk_dout1;
--								    hyperout(8*N-1 downto 8*N-EXBITS) <= (others => '0');
--									hyperout(2*8*N-EXBITS-1 downto 1*8*N) <= blk_dout2;
--									hyperout(2*8*N-1 downto 2*8*N-EXBITS) <= (others => '0');
--									hyperout(3*8*N-EXBITS-1 downto 2*8*N) <= blk_dout3;
--                                    hyperout(3*8*N-1 downto 3*8*N-EXBITS) <= (others => '0');
--                                    hyperout(4*8*N-EXBITS-1 downto 3*8*N) <= blk_dout4;
--                                    hyperout(4*8*N-1 downto 4*8*N-EXBITS) <= (others => '0');
--                                    hyperout(5*8*N-EXBITS-1 downto 4*8*N) <= blk_dout5;
--                                    hyperout(5*8*N-1 downto 5*8*N-EXBITS) <= (others => '0');
								when others =>
									hyperout <= hyperout;
							end case;
						end if;
						
						case blk_kvld is                -- blk_kvld input stays 'HIGH' for 1 SLOW_clock sycle
							when '1' =>
								kvld <= '1';            -- kvld for INTER_OUT component / stays 'HIGH' for 1 SLOW_clock sycle
							when others =>
								kvld <= '0';
						end case;
						
						case blk_dvld is                -- blk_dvld input stays 'HIGH' for 1 SLOW_clock sycle
							when '1' =>
								dvld <= '1';            -- dvld for INTER_OUT component / stays 'HIGH' for 1 SLOW_clock sycle
							when others =>
								dvld <= '0';
						end case;						
					end if;
		end process;
		hyperegout <= hyperout;                       -- Return of the Crypto Component
		s_kvld <= kvld;                               -- stays 'HIGH' for 1 SLOW_clock sycle
		s_dvld <= dvld;                               -- stays 'HIGH' for 1 SLOW_clock sycle
end arch;