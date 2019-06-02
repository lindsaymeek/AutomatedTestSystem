//************************************************************************
//************************************************************************
//
// DAC_P02.h (from DAC6.h user module template)
//  Rev C, 2002 Mar 30
// 
// C declarations for the DAC6 user module interface.
//
// Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
//
//************************************************************************
//************************************************************************

#define DAC_P02_OFF         0
#define DAC_P02_LOWPOWER    1
#define DAC_P02_MEDPOWER    2
#define DAC_P02_FULLPOWER   3

#pragma fastcall DAC_P02_Start
#pragma fastcall DAC_P02_SetPower
#pragma fastcall DAC_P02_WriteBlind
#pragma fastcall DAC_P02_WriteStall
#pragma fastcall DAC_P02_Stop


extern void DAC_P02_Start(char cPowerSetting);
extern void DAC_P02_SetPower(char cPowerSetting);
extern void DAC_P02_WriteBlind(char cOutputValue);
extern void DAC_P02_WriteStall(char cOutputValue);
extern void DAC_P02_Stop(void);
