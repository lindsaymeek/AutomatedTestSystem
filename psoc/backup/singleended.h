//************************************************************************
//************************************************************************
//
// SingleEnded.h for PGA_A
//
//  C declarations for the Continuous Time Programmable Gain Amplifier
// Copyright (c) 2000-2002 Cypress Microsystems, Inc. All rights reserved.
// Rev B, 2002 Mar 30
// UserModuleID "PGA_A" 
//
//************************************************************************
//************************************************************************
#include <M8C.h>

#define SingleEnded_OFF         0
#define SingleEnded_LOWPOWER    1
#define SingleEnded_MEDPOWER    2
#define SingleEnded_HIGHPOWER   3

#define SingleEnded_G16_0    0x08
#define SingleEnded_G8_00    0x18
#define SingleEnded_G5_33    0x28
#define SingleEnded_G4_00    0x38
#define SingleEnded_G3_20    0x48
#define SingleEnded_G2_67    0x58
#define SingleEnded_G2_27    0x68
#define SingleEnded_G2_00    0x78
#define SingleEnded_G1_78    0x88
#define SingleEnded_G1_60    0x98
#define SingleEnded_G1_46    0xA8
#define SingleEnded_G1_33    0xB8
#define SingleEnded_G1_23    0xC8
#define SingleEnded_G1_14    0xD8
#define SingleEnded_G1_06    0xE8
#define SingleEnded_G1_00    0xF8
#define SingleEnded_G0_93    0xE0
#define SingleEnded_G0_87    0xD0
#define SingleEnded_G0_81    0xC0
#define SingleEnded_G0_75    0xB0
#define SingleEnded_G0_68    0xA0
#define SingleEnded_G0_62    0x90
#define SingleEnded_G0_56    0x80
#define SingleEnded_G0_50    0x70
#define SingleEnded_G0_43    0x60
#define SingleEnded_G0_37    0x50
#define SingleEnded_G0_31    0x40
#define SingleEnded_G0_25    0x30
#define SingleEnded_G0_18    0x20
#define SingleEnded_G0_12    0x10
#define SingleEnded_G0_06    0x00



#pragma fastcall SingleEnded_Start
#pragma fastcall SingleEnded_SetPower

#pragma fastcall SingleEnded_SetGain

#pragma fastcall SingleEnded_Stop


extern void SingleEnded_Start(char power);
extern void SingleEnded_SetPower(char power);

extern void SingleEnded_SetGain(char chout);

extern void SingleEnded_Stop(void);


/************************************************
*  Hardware Register Definitions
*************************************************/
#pragma ioport  SingleEnded_GAIN_CR0:   0x079
BYTE            SingleEnded_GAIN_CR0;
#pragma ioport  SingleEnded_GAIN_CR1:   0x07a
BYTE            SingleEnded_GAIN_CR1;
#pragma ioport  SingleEnded_GAIN_CR2:   0x07b
BYTE            SingleEnded_GAIN_CR2;
