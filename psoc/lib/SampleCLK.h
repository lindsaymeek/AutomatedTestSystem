/******************************************************************************
*  FILENAME:      SampleCLK.h
*   VERSION:      REV B, 2002 Mar 30
*******************************************************************************
*  DESCRIPTION:
*     SampleCLK Counter8 User Module header file.
*******************************************************************************
*	Copyright (c) Cypress MicroSystems 2000-2002.  All Rights Reserved.
******************************************************************************/

/* include the global header file */
#include <m8c.h>

/* Create pragmas to support proper argument and return value passing */
#pragma fastcall  SampleCLK_EnableInt
#pragma fastcall  SampleCLK_DisableInt
#pragma fastcall  SampleCLK_Start
#pragma fastcall  SampleCLK_Stop
#pragma fastcall  SampleCLK_WritePeriod
#pragma fastcall  SampleCLK_WriteCompareValue
#pragma fastcall bSampleCLK_ReadCompareValue
#pragma fastcall bSampleCLK_ReadCounter

/**************************************************
* Prototypes of Counter8 API. For a definition of
* functions see SampleCLK.inc. 
**************************************************/
extern void  SampleCLK_EnableInt(void);
extern void  SampleCLK_DisableInt(void);
extern void  SampleCLK_Start(void);
extern void  SampleCLK_Stop(void);
extern void  SampleCLK_WritePeriod(BYTE bPeriod);
extern void  SampleCLK_WriteCompareValue(BYTE bCompareValue);
extern BYTE bSampleCLK_ReadCompareValue(void);	
extern BYTE bSampleCLK_ReadCounter(void);	 

/************************************************
*  Hardware Register Definitions
*************************************************/
#pragma ioport  SampleCLK_CONTROL_REG:  0x02f              //Control register
BYTE            SampleCLK_CONTROL_REG;
#pragma ioport  SampleCLK_COUNTER_REG:  0x02c              //Counter register
BYTE            SampleCLK_COUNTER_REG;
#pragma ioport  SampleCLK_PERIOD_REG:   0x02d              //Period value register
BYTE            SampleCLK_PERIOD_REG;
#pragma ioport  SampleCLK_COMPARE_REG:  0x02e              //CompareValue register
BYTE            SampleCLK_COMPARE_REG;
#pragma ioport  SampleCLK_FUNC_REG: 0x12c                  //Function register
BYTE            SampleCLK_FUNC_REG;
#pragma ioport  SampleCLK_INPUT_REG:    0x12d              //Input register
BYTE            SampleCLK_INPUT_REG;
#pragma ioport  SampleCLK_OUTPUT_REG:   0x12e              //Output register
BYTE            SampleCLK_OUTPUT_REG;

// end of file
