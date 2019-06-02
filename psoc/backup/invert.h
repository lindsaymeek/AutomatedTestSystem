//************************************************************************
//************************************************************************
//
// Invert.h (from AMPINV_A.h user module template)
//  REV C, 2002 Mar 30
// 
// C declarations for the AMPINV_A user module interface.
//
// Copyright (c) Cypress MicroSystems 2001. All Rights Reserved.
//
//************************************************************************
//************************************************************************
#include <M8C.h>

/* Power Settings */
#define Invert_OFF         0
#define Invert_LOWPOWER    1
#define Invert_MEDPOWER    2
#define Invert_HIGHPOWER   3

/* Gain Settings */
#define Invert_G15_0    0x00
#define Invert_G7_00    0x10
#define Invert_G4_33    0x20
#define Invert_G3_00    0x30
#define Invert_G2_20    0x40
#define Invert_G1_67    0x50
#define Invert_G1_27    0x60
#define Invert_G1_00    0x70
#define Invert_G0_78    0x80
#define Invert_G0_60    0x90
#define Invert_G0_46    0xA0
#define Invert_G0_33    0xB0
#define Invert_G0_23    0xC0
#define Invert_G0_14    0xD0
#define Invert_G0_06    0xE0


/* Define function Prototypes */
#pragma fastcall Invert_Start
#pragma fastcall Invert_SetPower
#pragma fastcall Invert_SetGain
#pragma fastcall Invert_Stop

extern void Invert_Start(char power);
extern void Invert_SetPower(char power);
extern void Invert_SetGain(BYTE bGainSetting);
extern void Invert_Stop(void);

/************************************************
*  Hardware Register Definitions
*************************************************/
#pragma ioport  Invert_INVAMP_CR0:  0x07d
BYTE            Invert_INVAMP_CR0;
#pragma ioport  Invert_INVAMP_CR1:  0x07e
BYTE            Invert_INVAMP_CR1;
#pragma ioport  Invert_INVAMP_CR2:  0x07f
BYTE            Invert_INVAMP_CR2;
