//************************************************************************
//************************************************************************
//
// DAC_P05.h (from DAC6.h user module template)
//  Rev C, 2002 Mar 30
// 
// C declarations for the DAC6 user module interface.
//
// Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
//
//************************************************************************
//************************************************************************

#define DAC_P05_OFF         0
#define DAC_P05_LOWPOWER    1
#define DAC_P05_MEDPOWER    2
#define DAC_P05_FULLPOWER   3

#pragma fastcall DAC_P05_Start
#pragma fastcall DAC_P05_SetPower
#pragma fastcall DAC_P05_WriteBlind
#pragma fastcall DAC_P05_WriteStall
#pragma fastcall DAC_P05_Stop


extern void DAC_P05_Start(char cPowerSetting);
extern void DAC_P05_SetPower(char cPowerSetting);
extern void DAC_P05_WriteBlind(char cOutputValue);
extern void DAC_P05_WriteStall(char cOutputValue);
extern void DAC_P05_Stop(void);
