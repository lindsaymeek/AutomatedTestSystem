//***********************************************************************
//***********************************************************************
//
//  ADC.h  for the 12 bit incremental A/D converter
//
//  C declarations for the ACDINC12 User Module.
//
//  Rev D, 2002 MAR 30
//
//  Copyright: Cypress Micro Systems 2000, 2001.  All Rights Reserved
//
//************************************************************************
//************************************************************************
#include <M8C.h>

#define ADC_OFF         0
#define ADC_LOWPOWER    1
#define ADC_MEDPOWER    2
#define ADC_HIGHPOWER   3

#pragma fastcall ADC_Start
#pragma fastcall ADC_SetPower
#pragma fastcall ADC_GetSamples
#pragma fastcall ADC_StopAD
#pragma fastcall ADC_Stop

#pragma fastcall ADC_fIsData
#pragma fastcall ADC_iGetData
#pragma fastcall ADC_ClearFlag


extern void ADC_Start(char power);
extern void ADC_SetPower(char power);
extern void ADC_GetSamples(char chout);
extern void ADC_StopAD(void);
extern void ADC_Stop(void);

extern char ADC_fIsData(void);
extern int  ADC_iGetData(void);
extern void ADC_ClearFlag(void);


/************************************************
*  Hardware Register Definitions
*************************************************/
#pragma ioport  ADC_AtoDcr0:    0x088
BYTE            ADC_AtoDcr0;
#pragma ioport  ADC_AtoDcr1:    0x089
BYTE            ADC_AtoDcr1;
#pragma ioport  ADC_AtoDcr2:    0x08a
BYTE            ADC_AtoDcr2;
#pragma ioport  ADC_AtoDcr3:    0x08b
BYTE            ADC_AtoDcr3;
#pragma ioport  ADC_CounterFN:  0x124
BYTE            ADC_CounterFN;
#pragma ioport  ADC_CounterSL:  0x125
BYTE            ADC_CounterSL;
#pragma ioport  ADC_CounterOS:  0x126
BYTE            ADC_CounterOS;
#pragma ioport  ADC_CounterDR0: 0x024
BYTE            ADC_CounterDR0;
#pragma ioport  ADC_CounterDR1: 0x025
BYTE            ADC_CounterDR1;
#pragma ioport  ADC_CounterDR2: 0x026
BYTE            ADC_CounterDR2;
#pragma ioport  ADC_CounterCR0: 0x027
BYTE            ADC_CounterCR0;
#pragma ioport  ADC_TimerFN:    0x120
BYTE            ADC_TimerFN;
#pragma ioport  ADC_TimerSL:    0x121
BYTE            ADC_TimerSL;
#pragma ioport  ADC_TimerOS:    0x122
BYTE            ADC_TimerOS;
#pragma ioport  ADC_TimerDR0:   0x020
BYTE            ADC_TimerDR0;
#pragma ioport  ADC_TimerDR1:   0x021
BYTE            ADC_TimerDR1;
#pragma ioport  ADC_TimerDR2:   0x022
BYTE            ADC_TimerDR2;
#pragma ioport  ADC_TimerCR0:   0x023
BYTE            ADC_TimerCR0;
