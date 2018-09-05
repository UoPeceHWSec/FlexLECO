# FlexLECO
A Flexible Lekeage Trace Collection Control Loop for Arbitrary Cryptographic IP Cores

## Introduction
Leakage Assessment and Side Channel Attacks (SCA) leakage trace acquisition tools and platforms require a considerable amount of time to  collect  millions  of  traces and rely on custom, hard to change or handle acquisition control mechanisms. To match these problems, in this paper, a flexible and scalable architecture for leakage trace collection is proposed, providing a fast, reconfigurable and flexible control mechanism that can be easily scaled to a wide variety of Devices Under Test (DUT). The proposed system migrates test vector generation, control and transmission, from off-board Personal Computer (PC) to an on-board embedded-system hardware control mechanism. 

## The Flexible solution
The FlexLECO solution provides a toolset that can be used to structure various leakage assessment scenarios, regardless of the DUT’s implemented cryptographic algorithm. The proposed approach enables single, multiple encryption per control loop round and DUT clock frequency adjustment to achieve accurate and fast leakage trace collection even for low-mid range oscilloscopes

## Features

The entire Control Loop Logic is migrated inside an embedded soft-core microprocessor,
1. completely controls the communication between the DUT and the Control Componen
2. executes the experiment defined by the user through the software API.

The system has:

1. Control FPGA: Embedded microprocessor connected with a generic Control Interface.
2. Cryptographic FPGA: Generic Cryptographic Interface connected with the DUT
3. 16-bit Busses supporting a fast custom hardware protocol for the communication between the 2 FPGAs.

## Main features
1. HW and SW Pseudo Random Number Generator available in the Control Interface for the creation of random inputs.
2. The microprocessor, the Control and the Cryptographic interface are clocked at 100 MHz
3. Adjustable MMCM based DUT clock inside the Cryptographic interface

##  FlexLECO ‘s  FLEXIBILITY – SCALABILITY
The Control FPGA remains unchanged regardless of the DUT inside the Cryptographic FPGA.
- Simple configuration by passing specific control words (through the SW API) to hardware control registers/counters.
- The same software API functions used for the definition of different experiments.
- An MMCM component for the DUT clock can be configured through a single parameter change during the implementation phase.

Simple Cryptographic interface adjustments per DUT:
1. change of 5 parameters in the VHDL code and by 
2. commenting/uncommenting the appropriate number of inputs/outputs during the implementation phase.

### Support:
- Trace collection for a Wide Range of Side Channel Analysis Attacks
- Leakage Assessment (eg. Interleaved Random vs Fixed TVLA)

### Prerequirements
- SAKURA X board
- Xilinx Software Development Kit (from Xilinx ISE 14.7 system edition). To be used for the SAKURA X Control FPGA
- Xilinx Vivado 14.2 and above. To be used for the SAKURA X cryptographic FPGA


###
FlexLECO is basdd on the published work in IEEE Hardware Oriented Security and Trust Symposium 2018:

A. Moschos, A. P. Fournaris, O. Koufopavlou, A Flexible Leakage Trace Collection Setup for Arbitrary Cryptographic IP Cores, in proc. of IEEE International Symposium on Hardware Oriented Security and Trust 2018 (IEEE HOST 2018), Washington DC, USA, April 30 - May 4, 2018

### Git structure

The FlexLECO git has two main folders:
- Control FPGA folder that has the bitstream to be downloaded in the SAKURA X board control FPGA, the software API functions to be use for designing an experinment. Also, an embedded microblaze software example for collecting 1000 AES traces
- Cryptographic FPGA folder that contains the FlexLECO cryptographic interface configured for AES 128

### Current Status

We have currently made available a functional yet draft version of the FlexLECO inplementation. As the research work (IEEE HOST paper) is made fully available (in the IEEExplore proceedings) we will add more results, examples and details on the implementation as well as the full documentation of the design.

Release of Version 1: end of September 2018

### Support 
For more information about the FlexLECO feel free to contact:

A. Moschos: ece7567@upnet.gr

A. Fournaris: apofour@ece.upatras.gr

### License
All code and documents of this repository are published under the Apache License, Version 2.0
