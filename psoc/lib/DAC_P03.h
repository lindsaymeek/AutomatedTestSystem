//************************************************************************
//************************************************************************
//
// DAC_P03.h (from DAC6.h user module template)
//  Rev C, 2002 Mar 30
// 
// C declarations for the DAC6 user module interface.
//
// Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
//
//************************************************************************
//************************************************************************

#define DAC_P03_OFF         0
#define DAC_P03_LOWPOWER    1
#define DAC_P03_MEDPOWER    2
#define DAC_P03_FULLPOWER   3

#pragma fastcall DAC_P03_Start
#pragma fastcall DAC_P03_SetPower
#pragma fastcall DAC_P03_WriteBlind
#pragma fastcall DAC_P03_WriteStall
#pragma fastcall DAC_P03_Stop


extern void DAC_P03_Start(char cPowerSetting);
extern void DAC_P03_SetPower(char cPowerSetting);
extern void DAC_P03_WriteBlind(char cOutputValue);
extern void DAC_P03_WriteStall(char cOutputValue);
extern void DAC_P03_Stop(void);
