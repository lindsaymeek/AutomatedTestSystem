/******************************************************************************
*  FILENAME:      BAUDCLK.h
*   VERSION:      REV B, 2002 Mar 30
*******************************************************************************
*  DESCRIPTION:
*     BAUDCLK Counter8 User Module header file.
*******************************************************************************
*	Copyright (c) Cypress MicroSystems 2000-2002.  All Rights Reserved.
******************************************************************************/

/* include the global header file */
#include <m8c.h>

/* Create pragmas to support proper argument and return value passing */
#pragma fastcall  BAUDCLK_EnableInt
#pragma fastcall  BAUDCLK_DisableInt
#pragma fastcall  BAUDCLK_Start
#pragma fastcall  BAUDCLK_Stop
#pragma fastcall  BAUDCLK_WritePeriod
#pragma fastcall  BAUDCLK_WriteCompareValue
#pragma fastcall bBAUDCLK_ReadCompareValue
#pragma fastcall bBAUDCLK_ReadCounter

/**************************************************
* Prototypes of Counter8 API. For a definition of
* functions see BAUDCLK.inc. 
**************************************************/
extern void  BAUDCLK_EnableInt(void);
extern void  BAUDCLK_DisableInt(void);
extern void  BAUDCLK_Start(void);
extern void  BAUDCLK_Stop(void);
extern void  BAUDCLK_WritePeriod(BYTE bPeriod);
extern void  BAUDCLK_WriteCompareValue(BYTE bCompareValue);
extern BYTE bBAUDCLK_ReadCompareValue(void);	
extern BYTE bBAUDCLK_ReadCounter(void);	 

/************************************************
*  Hardware Register Definitions
*************************************************/
#pragma ioport  BAUDCLK_CONTROL_REG:    0x02b              //Control register
BYTE            BAUDCLK_CONTROL_REG;
#pragma ioport  BAUDCLK_COUNTER_REG:    0x028              //Counter register
BYTE            BAUDCLK_COUNTER_REG;
#pragma ioport  BAUDCLK_PERIOD_REG: 0x029                  //Period value register
BYTE            BAUDCLK_PERIOD_REG;
#pragma ioport  BAUDCLK_COMPARE_REG:    0x02a              //CompareValue register
BYTE            BAUDCLK_COMPARE_REG;
#pragma ioport  BAUDCLK_FUNC_REG:   0x128                  //Function register
BYTE            BAUDCLK_FUNC_REG;
#pragma ioport  BAUDCLK_INPUT_REG:  0x129                  //Input register
BYTE            BAUDCLK_INPUT_REG;
#pragma ioport  BAUDCLK_OUTPUT_REG: 0x12a                  //Output register
BYTE            BAUDCLK_OUTPUT_REG;

// end of file
