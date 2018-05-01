----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2018 09:17:38 PM
-- Design Name: 
-- Module Name: Crypto_Fpga - Arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Crypto_Fpga is
    generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1);
        port (
            -------------- Interconnect Bus
            Lbus_Clk: in std_logic;
            Lbus_Rst: in std_logic;
            Lbus_A: in std_logic_vector (15 downto 0); 
            Lbus_Di: in std_logic_vector (15 downto 0); 
            Lbus_Wr: in std_logic;            
            Lbus_Rd: in std_logic;         
            Lbus_Rd_Ack: out std_logic;
            Lbus_Do: out std_logic_vector (15 downto 0);
            Lbus_Drdy: out std_logic; 
            Lbus_Dvld: out std_logic
            );  
end Crypto_Fpga;

architecture Arch of Crypto_Fpga is

component crypto_if is
	generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
	
	port(								-------------- Clock and Reset
			clk_f: in std_logic;
			clk_s: in std_logic;
			rst: in std_logic;			
											---- FPGA Interconnect ----
			lbus_a: in std_logic_vector (15 downto 0); -- Address
			lbus_di: in std_logic_vector (15 downto 0); -- Data Input (Controller -> Cryptographic module (Interface))
			lbus_wr: in std_logic;			-- Assert input data - When '1' data are ready to be written from Controller -> Cryptographic module (Interface).	
			lbus_rd: in std_logic; 			-- Assert output data
			lbus_rd_ACK: out std_logic;     -- Initiate transmission of output data to the Control FPGA
			lbus_do: out std_logic_vector (15 downto 0); -- Output data (Cryptographic module (Interface) -> Controller)
			lbus_dvld: out std_logic;		-- Data Valid signal (Cryptographic module (Interface) -> Controller)
			lbus_drdy: out std_logic;
			
												---- Crypto Bus -----
		-------------- Block Cipher for Cryptography Algorithm
			blk_in1: out std_logic_vector (8*N-1 downto 0);		--(Interface -> Cryptographic module)		--generic
			blk_in5: out std_logic_vector (8*N-1 downto 0);		--(Interface -> Cryptographic module)		--generic
--			blk_in4: out std_logic_vector (8*N-1 downto 0);		--(Interface -> Cryptographic module)		--generic
--			blk_in3: out std_logic_vector (8*N-1 downto 0);		--(Interface -> Cryptographic module)		--generic
--			blk_in2: out std_logic_vector (8*N-1 downto 0);		--(Interface -> Cryptographic module)		--generic
			blk_dout1: in std_logic_vector (8*N-1 downto 0);		--(Cryptographic module -> Interface)		--generic
--			blk_dout2: in std_logic_vector (8*N-1 downto 0);		--(Cryptographic module -> Interface)		--generic
--			blk_dout3: in std_logic_vector (8*N-1 downto 0);		--(Cryptographic module -> Interface)		--generic
--			blk_dout4: in std_logic_vector (8*N-1 downto 0);		--(Cryptographic module -> Interface)		--generic
--			blk_dout5: in std_logic_vector (8*N-1 downto 0);		--(Cryptographic module -> Interface)		--generic
		
		------------------------------------------------
			blk_kvld: in std_logic;		-- Round-Key generation is completed
			blk_dvld: in std_logic;		-- Cipher(plain)text ready on data input port (Cryptographic module -> Interface)
			blk_krdy: out std_logic;	-- Secret key is latched for an internal register of the AES component
			blk_drdy: out std_logic;	-- Plaintext is latched & encryption process begins
			
			small_in: out std_logic_vector (7 downto 0);		--for the small input of E.C. implementation
		
			blk_endec: out std_logic;	-- Encryption (EncDec = 0) and Decryption (EncDec = 1)
			blk_en: out std_logic;		-- Enable
			blk_rstn: out std_logic);	-- Reset
end component;

component AES_Table_enc is
    port(
        Kin: in std_logic_vector (127 downto 0);  -- Key input
        Din: in std_logic_vector (127 downto 0);  -- Data input
        Dout: out std_logic_vector (127 downto 0); -- Data output
        Krdy: in std_logic;         -- Key input ready
        Drdy: in std_logic;         -- Data input ready
        Kvld: out std_logic;         -- Data output valid
        Dvld: out std_logic;        -- Data output valid
        EN: in std_logic;           -- AES circuit enable
        BSY: out std_logic;          -- Busy signal
        CLK: in std_logic;          -- System clock
        RSTn: in std_logic);         -- Reset (Low active)
end component;  

component Scalar_Multiplication is

  generic(
  m:           integer:=232);
  port (
        clk:         in std_logic;
        --Reset signal --
        reset:       in std_logic;
        -- Start signal, active high --
        start:       in std_logic;
        -- Scalar number --
        K:           in std_logic_vector(m downto 0);
        -- Input Point X Coordinate --
        Xin:         in std_logic_vector(m downto 0);
        -- Input Point Y Coordinate --
        Yin:         in std_logic_vector(m downto 0);
        -- Input Point Z Coordinate --
        Zin:         in std_logic_vector(m downto 0);
        -- Output Point X Coordinate --
        X:           out std_logic_vector(m downto 0);
        -- Output Point Y Coordinate --
        Y:           out std_logic_vector(m downto 0);
        -- Output Point Z Coordinate --
        Z:           out std_logic_vector(m downto 0);
        -- Multiplication completed signal --
        data_ready:  out std_logic);
end component;

component clk_wiz_0 is
port
 (-- Clock in ports
  Clk           : in     std_logic;
  -- Clock out ports
  clk_if          : out    std_logic;
  clk_cry          : out    std_logic
 );
end component;

-- internal signals between the Crypto_IF and the Crypto_component
signal blk_in1_int: std_logic_vector (8*N-1 downto 0);
signal blk_in2_int: std_logic_vector (8*N-1 downto 0);
signal blk_in3_int: std_logic_vector (8*N-1 downto 0);
signal blk_in4_int: std_logic_vector (8*N-1 downto 0);
signal blk_in5_int: std_logic_vector (8*N-1 downto 0);
signal blk_dout1_int: std_logic_vector (8*N-1 downto 0);
signal blk_dout2_int: std_logic_vector (8*N-1 downto 0);
signal blk_dout3_int: std_logic_vector (8*N-1 downto 0);
signal blk_dout4_int: std_logic_vector (8*N-1 downto 0);
signal blk_dout5_int: std_logic_vector (8*N-1 downto 0);
signal krdy_int: std_logic;
signal drdy_int: std_logic;
signal encdec_int: std_logic;
signal en_int: std_logic;
signal rstn_int: std_logic;
signal kvld_int: std_logic;
signal dvld_int: std_logic;
signal small_in_int: std_logic_vector (7 downto 0);
signal bsy_int: std_logic;

-----registered inputs/outputs ------
signal lbus_a_reg: std_logic_vector (15 downto 0);
signal lbus_di_reg: std_logic_vector (15 downto 0); 
signal lbus_rd_reg: std_logic;
signal lbus_wr_reg: std_logic;


signal lbus_do_reg: std_logic_vector (15 downto 0);
signal temp_do: std_logic_vector (15 downto 0);
signal lbus_rd_ACK_reg: std_logic;
signal temp_rd_ACK: std_logic;
signal lbus_dvld_reg: std_logic;
signal temp_dvld: std_logic;
signal clk_if: std_logic;
signal clk_cry: std_logic;

begin

    proc_reg: process(clk_if)
        begin
            if (clk_if'event and clk_if='1') then
                if (lbus_rst = '1') then
                    lbus_a_reg <= Lbus_A;
                    lbus_di_reg <= Lbus_Di;
                    lbus_wr_reg <= Lbus_Wr;
                    lbus_rd_reg <= Lbus_Rd;
                    temp_rd_ACK <= Lbus_Rd_ACK_reg;
                    temp_do <= (others =>'0');
                    temp_dvld <= lbus_dvld_reg;
                else 
                    lbus_a_reg <= Lbus_A;
                    lbus_di_reg <= Lbus_Di;
                    lbus_wr_reg <= Lbus_Wr;
                    lbus_rd_reg <= Lbus_Rd;
                    temp_rd_ACK <= lbus_rd_ACK_reg;
                    temp_do <= lbus_do_reg;
                    temp_dvld <= lbus_dvld_reg;
                end if;
            end if;
    end process;

    mmcme: clk_wiz_0 port map(Lbus_Clk, clk_if, clk_cry);
	G1: crypto_if port map (clk_if, clk_cry, lbus_rst, lbus_a_reg, lbus_di_reg, lbus_wr_reg, lbus_rd_reg, lbus_rd_ACK_reg, lbus_do_reg, lbus_dvld_reg, Lbus_Drdy, blk_in1_int, blk_in5_int, blk_dout1_int, kvld_int, dvld_int, krdy_int, drdy_int, small_in_int, encdec_int, en_int, rstn_int);
	G2: AES_Table_enc port map (blk_in1_int, blk_in5_int, blk_dout1_int, krdy_int, drdy_int, kvld_int, dvld_int, en_int, bsy_int, clk_cry, rstn_int);
    --G2: Scalar_Multiplication port map (clk_cry, rstn_int, drdy_int, blk_in1_int, blk_in2_int, blk_in3_int, blk_in4_int, blk_out1_int, blk_out2_int, blk_out3_int, dvld_int);
    
    Lbus_Rd_Ack <= temp_rd_ACK;
    Lbus_Do <= temp_do;
    Lbus_Dvld <= temp_dvld;
    
--    osc_en <= '1';
end Arch;
