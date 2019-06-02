//************************************************************************
//************************************************************************
//
// DoubleEnded.h for INSAMP
//
// C declarations for the Continuous Time Instrumentation Amplifier
// 
// Rev A, 2002 Mar 30
// 
// Copyright (c) 2000-2002 Cypress Microsystems, Inc. All rights reserved.
//
//************************************************************************
//************************************************************************
#include <M8C.h>

#define DoubleEnded_OFF         0
#define DoubleEnded_LOWPOWER    1
#define DoubleEnded_MEDPOWER    2
#define DoubleEnded_HIGHPOWER   3

#define DoubleEnded_G16_0  0x00
#define DoubleEnded_G8_00  0x10
#define DoubleEnded_G5_33  0x20
#define DoubleEnded_G4_00  0x30
#define DoubleEnded_G3_20  0x40
#define DoubleEnded_G2_67  0x50
#define DoubleEnded_G2_27  0x60
#define DoubleEnded_G2_00  0x70



#pragma fastcall DoubleEnded_Start
#pragma fastcall DoubleEnded_SetPower
#pragma fastcall DoubleEnded_SetGain
#pragma fastcall DoubleEnded_Stop

extern void DoubleEnded_Start(char power);
extern void DoubleEnded_SetPower(char power);
extern void DoubleEnded_SetGain(char power);
extern void DoubleEnded_Stop(void);



/************************************************
*  Hardware Register Definitions
*************************************************/

#pragma ioport  DoubleEnded_INV_CR0:    0x071
BYTE            DoubleEnded_INV_CR0;
#pragma ioport  DoubleEnded_INV_CR1:    0x072
BYTE            DoubleEnded_INV_CR1;
#pragma ioport  DoubleEnded_INV_CR2:    0x073
BYTE            DoubleEnded_INV_CR2;
#pragma ioport  DoubleEnded_NON_INV_CR0:    0x075
BYTE            DoubleEnded_NON_INV_CR0;
#pragma ioport  DoubleEnded_NON_INV_CR1:    0x076
BYTE            DoubleEnded_NON_INV_CR1;
#pragma ioport  DoubleEnded_NON_INV_CR2:    0x077
BYTE            DoubleEnded_NON_INV_CR2;
