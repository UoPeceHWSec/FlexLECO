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

/*
 * SCA_control_API.h
 *
 *  Created on: 16 Óåð 2017
 *      Author: Apostolos Fournaris
 */

#ifndef SCA_CONTROL_API_H_
#define SCA_CONTROL_API_H_

#include "platform.h"
#include "xparameters.h"
#include "control_interface.h"
#include "config.h"
#include <stdio.h>
#include <stdlib.h>
#include "pcg_basic.h"


#define FIFO_STATUS 0
#define STATUS_REGISTER 1
#define FIFO_OUT_STATUS 2

#define RANDOM_HW_INP 1
#define SW_DEFINED_INP 0

void load_key(Xuint32 matra[LENGTH]);
void load_plain(Xuint32 matrb[INPUTS][LENGTH], int a);
void init(Xuint32 count_in_out_control_word, Xuint32 encr_decr );
void reset();
void encrypt(int type);
//void collect(Xuint32 matrb[INPUTS][LENGTH], int ciph_num);
Xuint32 status(int req);
//void prnginput(Xuint32 seed, Xuint32 byte_length);
void prnginput(pcg32_random_t *rng, Xuint32 byte_length);
#endif /* SCA_CONTROL_API_H_ */
