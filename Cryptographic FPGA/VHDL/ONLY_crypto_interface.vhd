---------------------------------------------------------------------------
-- Crypto Interface
--                                   
-- File name   : ONLY_crypto_interface.vhd
-- Version     : Version alpha 1.0
-- Created     : 
-- Last update : 10/Jan/2017
-- Desgined by : Athanassios Moschos
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity crypto_if is
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
            blk_in1: out std_logic_vector (8*N-1 downto 0);        --(Interface -> Cryptographic module)        --generic
            blk_in5: out std_logic_vector (8*N-1 downto 0);        --(Interface -> Cryptographic module)        --generic
--            blk_in4: out std_logic_vector (8*N-1 downto 0);        --(Interface -> Cryptographic module)        --generic
--            blk_in3: out std_logic_vector (8*N-1 downto 0);        --(Interface -> Cryptographic module)        --generic
--            blk_in2: out std_logic_vector (8*N-1 downto 0);        --(Interface -> Cryptographic module)        --generic
            blk_dout1: in std_logic_vector (8*N-1 downto 0);        --(Cryptographic module -> Interface)        --generic
--            blk_dout2: in std_logic_vector (8*N-1 downto 0);        --(Cryptographic module -> Interface)        --generic
--            blk_dout3: in std_logic_vector (8*N-1 downto 0);        --(Cryptographic module -> Interface)        --generic
--            blk_dout4: in std_logic_vector (8*N-1 downto 0);        --(Cryptographic module -> Interface)        --generic
--            blk_dout5: in std_logic_vector (8*N-1 downto 0);        --(Cryptographic module -> Interface)        --generic
                                                
		------------------------------------------------
			blk_kvld: in std_logic;		-- Round-Key generation is completed
			blk_dvld: in std_logic;		-- Cipher(plain)text ready on data input port (Cryptographic module -> Interface)
			blk_krdy: out std_logic;	-- Secret key is latched for an internal register of the AES component
			blk_drdy: out std_logic;	-- Plaintext is latched & encryption process begins
			
			small_in: out std_logic_vector (7 downto 0);		--for the small input of E.C. implementation
		
			blk_endec: out std_logic;	-- Encryption (EncDec = 0) and Decryption (EncDec = 1)
			blk_en: out std_logic;		-- Enable
			blk_rstn: out std_logic);	-- Reset
end crypto_if;

architecture arch of crypto_if is

	component blktrig is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- FPGA Interconnect ----
			lbus_di0: in std_logic;
			---- Local Bus ----
			ctrl_wr: in std_logic;
			blk_trig: out std_logic_vector (N-1 downto 0));
	end component;
	
	component trigctrl is
		--generic();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- FPGA Interconnect ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_wr: in std_logic;
			---- Local Bus ----
			ctrl_wr: out std_logic);
	end component;
	
	component comreg is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Local Bus ----
			dvld: in std_logic;
			blk_trig0: in std_logic;
			commandreg: out std_logic_vector (INS-1 downto 0));
	end component;
	
	component cryreset is
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
	end component;
	
	component rsthold is
        --generic();
        
        port(-------------- Clock and Reset
            clk: in std_logic;
            rst: in std_logic;
            ---- Crypto Bus ----
            blk_rstn: in std_logic;
            rst_state: in std_logic_vector(1 downto 0);
            ack_rstn: out std_logic_vector(1 downto 0);
            blk_rstn_s: out std_logic);
    end component;
	
	component controlword is
		--generic();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Local Bus ----
			blk_krdy: in std_logic;
			blk_drdy: in std_logic;
			blk_dvld: in std_logic;
			blk_kvld: in std_logic;
			blk_rstn: in std_logic;
			blk_endec: in std_logic;
			status_word: out std_logic_vector (5 downto 0));
	end component;
	
	component enhl is
        -- generic();
        
        port (    ---- Local Bus ----
                commandregh: in std_logic;
                commandreghalf: in std_logic;
                commandregl: in std_logic;
                blk_trig0: in std_logic;
                enh: out std_logic;
                enl: out std_logic);
    end component;
	
	component k_rdy is
		--generic ();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Crypto Component ----
--            kvld: in std_logic;
			---- Local Bus ----
			enl: in std_logic;
			krdy_l: out std_logic);
--			krdy_c: out std_logic);
	end component;
	
	component d_rdy is
		--generic ();
		
		port(-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Crypto Component ----
 --           dvld: in std_logic;
			---- Local Bus ----
			enh: in std_logic;
			drdy_l: out std_logic);
--			drdy_c: out std_logic);
	end component;
	
	component addcon is
		--generic ();
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			----- FPGA Interconnect ---
			lbus_a: in std_logic_vector (15 downto 0); -- Address
			lbus_rd: in std_logic;
			----- Local Interface Bus -----
			exp_adr: in std_logic_vector (15 downto 0);
			mux_en: out std_logic_vector(1 downto 0));
	end component;
	
	component hypereg_in is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			master_dvld: in std_logic;
			---- Interconnect Bus ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_di: in std_logic_vector (15 downto 0);
			lbus_wr: in std_logic;
			---- Local Bus ----
			hyperegin: out std_logic_vector (INS*8*N-1 downto 0);
			expadr: out std_logic_vector(15 downto 0));
	end component;
	
	component Crypto_Algo_In is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
            rst: in std_logic;
            ---- Crypto Bus ----
            blk_in1: out std_logic_vector (8*N-1 downto 0);        --(Interface -> Cryptographic module)        --generic
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
	end component;	
	
	component INTERin is
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
	end component;
	
	component Crypto_Algo_Return is
		generic (N: integer:=16; K: integer:=8; INS: integer:=2; DAO: integer:=1; EXBITS: integer:=0);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Crypto Bus ----
			blk_dout1: in std_logic_vector (8*N-1 downto 0);	-- Data Input (Cryptographic module -> Interface)		--generic
--            blk_dout2: in std_logic_vector (232 downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
--            blk_dout3: in std_logic_vector (232 downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
--            blk_dout4: in std_logic_vector (8*N-1 downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
--            blk_dout5: in std_logic_vector (8*N-1 downto 0);    -- Data Input (Cryptographic module -> Interface)        --generic
            blk_kvld: in std_logic;
            blk_dvld: in std_logic;
			----Slow Local Bus ----
			s_kvld: out std_logic;
			s_dvld: out std_logic;
			hyperegout: out std_logic_vector (DAO*8*N-1 downto 0));
	end component;
	
	component INTERout is
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
	end component;
	
	component hypereg_out is
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
	end component;

	component muxdo is
		-- generic ();
		
		port (clk: in std_logic;
		      rst: in std_logic;
		    ---- Interconnect Bus ----
			lbus_do: out std_logic_vector (15 downto 0);
			----- Local Interface Bus -----
			mux_en: in std_logic_vector(1 downto 0);
			do_hypereg: in std_logic_vector (15 downto 0);
			status_word: in std_logic_vector (5 downto 0));
	end component;
	
	component smallin is
		--generic (N: integer:=16; K: integer:=8; INS: integer:=2);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Interconnect Bus ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_di: in std_logic_vector (7 downto 0);
			---- Local Interface Bus ----
			sm_in: out std_logic_vector(7 downto 0));
	end component;
	
	component encdec is
	
		--generic (N: integer:=16; K: integer:=8; INS: integer:=2);
		
		port (	-------------- Clock and Reset
			clk: in std_logic;
			rst: in std_logic;
			---- Interconnect Bus ----
			lbus_a: in std_logic_vector (15 downto 0);
			lbus_di0: in std_logic;
			----- Local Interface Bus -----
			ende: out std_logic);
	end component;
	
	component D_FF is
        PORT( D,CLOCK: in std_logic;
              Q: out std_logic);
    end component;
     
	
	signal ctrl_wr_i: std_logic;
	signal blk_trig_i: std_logic_vector (N-1 downto 0);
	signal commandreg_i: std_logic_vector (INS-1 downto 0);
	signal ack_rst_i: std_logic_vector (1 downto 0);
	signal blk_rstn_i: std_logic;
	signal blk_rstn_s_i: std_logic;
	signal rst_state_i: std_logic_vector(1 downto 0);
	signal blk_endec_i: std_logic;
	signal small_in_i: std_logic_vector (7 downto 0);
	
	signal status_word_i: std_logic_vector (5 downto 0);
	signal exp_adr1_i: std_logic_vector (15 downto 0);
	signal exp_adr2_i: std_logic_vector (15 downto 0);
	signal enh_i: std_logic;
	signal enl_i: std_logic;
	signal mux_en_i: std_logic_vector (1 downto 0);
	---- FAST ----
	signal f_hypereg_in_i: std_logic_vector (INS*8*N-1 downto 0);
	signal f_hypereg_out_i: std_logic_vector (DAO*8*N-1 downto 0);
	signal f_krdy_l_i: std_logic;
	signal f_drdy_l_i: std_logic;
	signal f_kvld_out: std_logic;
	signal f_dvld_out: std_logic;
	
	---- SLOW ----
	signal s_hypereg_in_i: std_logic_vector (INS*8*N-1 downto 0);
	signal s_hypereg_out_i: std_logic_vector (DAO*8*N-1 downto 0);
	signal s_krdy_c_i: std_logic;
	signal s_krdy_c_comp: std_logic;
	signal s_drdy_c_i: std_logic;
	signal s_drdy_c_comp: std_logic;
	signal s_kvld_in: std_logic;
	signal s_dvld_in: std_logic;
	signal s_kvld_out: std_logic;
	signal s_dvld_out: std_logic;
	
	signal lbus_do_i: std_logic_vector (15 downto 0);
	signal hyper_rd_ACK_i: std_logic;
	signal expadr_en_i: std_logic_vector (1 downto 0);
	signal lbus_dvld_ff: std_logic;
	signal hyper_rd_ACK_i_ff: std_logic;
	
	begin
        
        proc0: process(clk_f)
            begin
                if (clk_f'event and clk_f='1') then
                   lbus_dvld_ff <=  blk_dvld;
                end if;
        end process; 
        	
		G0: blktrig port map (clk_f, rst, lbus_di(0), ctrl_wr_i, blk_trig_i);						-- OUT: blk_trig_i
		G1: trigctrl port map (clk_f, rst, lbus_a, lbus_wr, ctrl_wr_i);							    -- OUT: ctrl_wr_i
		G2: comreg port map (clk_f, rst, f_dvld_out, blk_trig_i(0), commandreg_i);				    -- OUT: commandreg_i
		G3: cryreset port map (clk_f, rst, lbus_a, lbus_di(3), ack_rst_i, rst_state_i, blk_rstn_i);              -- OUT: blk_rstn
		G4: rsthold port map (clk_s, rst, blk_rstn_i, rst_state_i, ack_rst_i, blk_rstn_s_i);				    
		G5: controlword port map (clk_f, rst, f_krdy_l_i, f_drdy_l_i, f_dvld_out, f_kvld_out, blk_rstn_s_i, blk_endec_i, status_word_i);		-- OUT: status_word_i
		G6: enhl port map (commandreg_i(INS-1), commandreg_i(INS-2), commandreg_i(0), blk_trig_i(0), enh_i, enl_i); 	    -- OUT: enh_i, enl_i
		G7: k_rdy port map (clk_f, rst, enl_i, f_krdy_l_i);					    				    -- OUT: blk_krdy_i
		G8: d_rdy port map (clk_f, rst, enh_i, f_drdy_l_i);										    -- OUT: blk_drdy_i
		G9: addcon port map (clk_f, rst, lbus_a, lbus_rd, exp_adr2_i, mux_en_i);					-- OUT: mux_en_i
		
		G10: hypereg_in port map (clk_f, rst, f_dvld_out, lbus_a, lbus_di, lbus_wr, f_hypereg_in_i, exp_adr1_i);											-- OUT: hypereg_in_i / exp_adr1_i
		G11: INTERin port map (clk_f, rst, f_krdy_l_i, f_drdy_l_i, f_hypereg_in_i, s_krdy_c_i, s_drdy_c_i, s_hypereg_in_i, s_kvld_in, s_dvld_in);	    -- OUT: s_krdy_c_i / s_drdy_c_i / s_hypereg_in_i
--		G12: ECin port map (clk_s, rst, blk_in1, blk_in2, blk_in3, blk_in4, blk_in5, blk_krdy_i, blk_drdy_i, hypereg_in_i);				                -- OUT: blk_in1 / blk_in2 / blk_in3 / blk_in4 / blk_in5
		G12: Crypto_Algo_In port map (clk_s, rst, blk_in1, blk_in5, s_krdy_c_comp, s_drdy_c_comp, s_krdy_c_i, s_drdy_c_i, s_kvld_in, s_dvld_in, s_hypereg_in_i);					-- OUT: blk_kin / blk_din

--		G13: cryreEC port map (clk_s, rst, blk_dout1, blk_dout2, blk_dout3, blk_kvld, blk_dvld, hypereg_out_i);   						-- OUT: hypereg_out_i		
		G13: Crypto_Algo_Return port map (clk_s, rst, blk_dout1, blk_kvld, blk_dvld, s_kvld_out, s_dvld_out, s_hypereg_out_i);						-- OUT: s_kvld_out / s_dvld_out / s_hypereg_out_i
		G14: INTERout port map (clk_f, rst, f_kvld_out, f_dvld_out, f_hypereg_out_i, s_hypereg_out_i, s_kvld_out, s_dvld_out);				   -- OUT: f_kvld_out / f_dvld_out / f_hypereg_out_i  
		G15: hypereg_out port map (clk_f, f_dvld_out, lbus_a, lbus_rd, exp_adr1_i, f_hypereg_out_i, lbus_do_i, hyper_rd_ACK_i, exp_adr2_i);    -- OUT: lbus_do_i / exp_adr2_i
		
		G16: muxdo port map (clk_f, rst, lbus_do, mux_en_i, lbus_do_i, status_word_i);															-- OUT: lbus_do
		G17: smallin port map (clk_f, rst, lbus_a, lbus_di(7 downto 0), small_in_i);														-- OUT: small_in_i
		G18: encdec port map (clk_f,  rst, lbus_a, lbus_di(0), blk_endec_i);
		G19: D_FF port map (hyper_rd_ACK_i, clk_f, hyper_rd_ACK_i_ff);															-- OUT: blk_endec_i
		
		blk_endec <= blk_endec_i;
		blk_en <= '1';

		blk_krdy <= s_krdy_c_comp;
		lbus_drdy <= s_drdy_c_comp;
		blk_drdy <= s_drdy_c_comp;
		lbus_dvld <= f_dvld_out;

		blk_rstn <= blk_rstn_s_i;
		small_in <= small_in_i;
--		lbus_rd_ACK <= ((NOT lbus_rd) OR hyper_rd_ACK_i);                         -- In order to gain one more round of RD_ACK in the begining, for the 1st byte of the Cipher
        lbus_rd_ACK <= (hyper_rd_ACK_i OR hyper_rd_ACK_i_ff);
end arch;