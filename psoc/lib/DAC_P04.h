//************************************************************************
//************************************************************************
//
// DAC_P04.h (from DAC6.h user module template)
//  Rev C, 2002 Mar 30
// 
// C declarations for the DAC6 user module interface.
//
// Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
//
//************************************************************************
//************************************************************************

#define DAC_P04_OFF         0
#define DAC_P04_LOWPOWER    1
#define DAC_P04_MEDPOWER    2
#define DAC_P04_FULLPOWER   3

#pragma fastcall DAC_P04_Start
#pragma fastcall DAC_P04_SetPower
#pragma fastcall DAC_P04_WriteBlind
#pragma fastcall DAC_P04_WriteStall
#pragma fastcall DAC_P04_Stop


extern void DAC_P04_Start(char cPowerSetting);
extern void DAC_P04_SetPower(char cPowerSetting);
extern void DAC_P04_WriteBlind(char cOutputValue);
extern void DAC_P04_WriteStall(char cOutputValue);
extern void DAC_P04_Stop(void);
