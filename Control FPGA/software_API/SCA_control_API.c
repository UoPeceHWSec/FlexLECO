/*---------------------------------------------------------------------------
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
--------------------------------------------------------------------------*/


#include "SCA_control_API.h"


void load_key(Xuint32 matra[LENGTH]){
	int j;
	//WRITE to FIFO IN ---> KEY
	//KEY
	for (j = 0; j < LENGTH; j++){
				CONTROL_INTERFACE_mWriteSlaveReg0(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, (Xuint32) matra[j]);
	}
}
void load_plain(Xuint32 matrb[INPUTS][LENGTH], int a){
	int j;
	//WRITE to FIFO IN ---> DATA
	//DATA
	for (j = 0; j < LENGTH; j++){
		CONTROL_INTERFACE_mWriteSlaveReg0(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, (Xuint32) matrb[a][j]);
	}
}

void init(Xuint32 count_in_out_control_word, Xuint32 encr_decr ){
int i;
	//SET Counter Inputs/Outputs/Length + small_input
	CONTROL_INTERFACE_mWriteSlaveReg2(XPAR_CONTROL_INTERFACE_0_BASEADDR,0x0, count_in_out_control_word);

	//Enable Reset @ Crypto Component
	//address = 0x2Hex & data = 0x8Hex -- Crypto is Reset
//	CONTROL_INTERFACE_mWriteSlaveReg2(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, 0x10020008);
//	for (i=0; i<10000;i++){}

	//address = 0x2Hex & data = 0x0Hex -- Crypto is NOT Reset
//	CONTROL_INTERFACE_mWriteSlaveReg2(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, 0x10020000);

	//Sent ENC/DEC for Encrytpion or Decription - ENC=0 / DEC=1
	CONTROL_INTERFACE_mWriteSlaveReg2(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, encr_decr);
}


void reset(){
	CONTROL_INTERFACE_mReset(XPAR_CONTROL_INTERFACE_0_BASEADDR);
}
void encrypt(int type){
	if (type==SW_DEFINED_INP){
	CONTROL_INTERFACE_mWriteSlaveReg2(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, 0x80000000);
	}
	else if (type==RANDOM_HW_INP){
	CONTROL_INTERFACE_mWriteSlaveReg2(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, 0xa0000000);
	}
}

Xuint32 status(int req){
	switch (req) {
		case FIFO_STATUS:
			return CONTROL_INTERFACE_mReadSlaveReg4(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0);

		case STATUS_REGISTER:
			return CONTROL_INTERFACE_mReadSlaveReg3(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0);

		case FIFO_OUT_STATUS:
			return CONTROL_INTERFACE_mReadSlaveReg1(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0);
	}
return 100;
}

void collect(Xuint32 matrb[INPUTS][LENGTH], int ciph_num){
	int i;
	int c = CONTROL_INTERFACE_mReadSlaveReg1(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0); 	//REG 1 -- output of FIFO OUT
	for (i=0; i<LENGTH; i++){
		matrb[ciph_num][i] = CONTROL_INTERFACE_mReadSlaveReg1(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0); 	//REG 1 -- output of FIFO OUT
	}
}


//void prnginput(Xuint32 seed, Xuint32 byte_length){
void prnginput(pcg32_random_t *rng, Xuint32 byte_length){
int d;
	 //Xuint32 ii;
	//WRITE to FIFO IN ---> DATA
	//DATA
	//pcg32_srandom_r(&rng, seed,1024);
	/*pcg32_random_t rng;
    pcg32_srandom_r(&rng, 77878,1);*/
	for (d = 0; d < byte_length; d++){
		//ii=rand();
		/* Intializes random number generator */
		CONTROL_INTERFACE_mWriteSlaveReg0(XPAR_CONTROL_INTERFACE_0_BASEADDR, 0x0, (Xuint32) pcg32_random_r(rng));
	}
}
