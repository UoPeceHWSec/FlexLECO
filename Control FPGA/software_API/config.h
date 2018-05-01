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
 * config.h
 *
 *  Created on: 16 Óåð 2017
 *      Author: Apostolos Fournaris
 */

#ifndef CONFIG_H_
#define CONFIG_H_


#define INPUTS 3
#define LENGTH 15
//#define AES_SETUP 0x4FFE5008
//#define ECC_SETUP 0x4000600F
#define ECC_SETUP 0x4000E00F //swsto
//#define ECC_SETUP 0x4FF0E00F //swsto
//#define ECC_SETUP 0x4FF0E01E
#define ENCRYPT 0x100C0000


#endif /* CONFIG_H_ */
