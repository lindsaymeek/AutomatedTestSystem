/******************************************************************************
*  FILENAME:      UARTOUT.h
*   VERSION:      Rev B, 2002 Mar 30
*******************************************************************************
*  DESCRIPTION:
*     UARTOUT UART User Module header file.
*******************************************************************************
*	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
******************************************************************************/

/* include the global header file */
#include <m8c.h>

/* Create pragmas to support proper argument and return value passing */
#pragma fastcall  UARTOUT_EnableInt
#pragma fastcall  UARTOUT_DisableInt
#pragma fastcall  UARTOUT_Start
#pragma fastcall  UARTOUT_Stop
#pragma fastcall  UARTOUT_SendData
#pragma fastcall bUARTOUT_ReadTxStatus
#pragma fastcall bUARTOUT_ReadRxData
#pragma fastcall bUARTOUT_ReadRxStatus

/**************************************************
* Prototypes of UART API. For a definition of
* functions see UARTOUT.inc. 
**************************************************/
extern void  UARTOUT_EnableInt(void);
extern void  UARTOUT_DisableInt(void);
extern void  UARTOUT_Start(BYTE bParity);
extern void  UARTOUT_Stop(void);
extern void  UARTOUT_SendData(BYTE bTxData);
extern BYTE bUARTOUT_ReadTxStatus(void);	 
extern BYTE bUARTOUT_ReadRxData(void);
extern BYTE bUARTOUT_ReadRxStatus(void);	 

/**************************************************
* Defines for UART API's. 
**************************************************/
//------------------------------------
//  Parity masks
//------------------------------------
#define  UART_PARITY_NONE        0x00
#define  UART_PARITY_EVEN        0x02
#define  UART_PARITY_ODD         0x06

//------------------------------------
//  Transmitter Status Register masks
//------------------------------------
#define  UART_TX_COMPLETE        0x20
#define  UART_TX_BUFFER_EMPTY    0x10

//------------------------------------
//  Receiver Status Register masks
//------------------------------------
#define  UART_RX_ACTIVE          0x10
#define  UART_RX_COMPLETE        0x08
#define  UART_RX_PARITY_ERROR    0x80
#define  UART_RX_OVERRUN_ERROR   0x40
#define  UART_RX_FRAMING_ERROR   0x20
#define  UART_RX_NO_ERROR        0xE0


/************************************************
*  Hardware Register Definitions
*************************************************/
#pragma ioport  UARTOUT_TX_CONTROL_REG: 0x033              //Control register
BYTE            UARTOUT_TX_CONTROL_REG; 
#pragma ioport  UARTOUT_TX_SHIFT_REG:   0x030              //TX Shift Register register
BYTE            UARTOUT_TX_SHIFT_REG;  
#pragma ioport  UARTOUT_TX_BUFFER_REG:  0x031              //TX Buffer Register
BYTE            UARTOUT_TX_BUFFER_REG;  
#pragma ioport  UARTOUT_TX_FUNC_REG:    0x130              //Function register
BYTE            UARTOUT_TX_FUNC_REG;  
#pragma ioport  UARTOUT_TX_INPUT_REG:   0x131              //Input register
BYTE            UARTOUT_TX_INPUT_REG; 
#pragma ioport  UARTOUT_TX_OUTPUT_REG:  0x132              //Output register
BYTE            UARTOUT_TX_OUTPUT_REG;
#pragma ioport  UARTOUT_RX_CONTROL_REG: 0x037              //Control register
BYTE            UARTOUT_RX_CONTROL_REG; 
#pragma ioport  UARTOUT_RX_SHIFT_REG:   0x034              //RX Shift Register register
BYTE            UARTOUT_RX_SHIFT_REG;  
#pragma ioport  UARTOUT_RX_BUFFER_REG:  0x036              //RX Buffer Register
BYTE            UARTOUT_RX_BUFFER_REG;  
#pragma ioport  UARTOUT_RX_FUNC_REG:    0x134              //Function register
BYTE            UARTOUT_RX_FUNC_REG;
#pragma ioport  UARTOUT_RX_INPUT_REG:   0x135              //Input register
BYTE            UARTOUT_RX_INPUT_REG; 
#pragma ioport  UARTOUT_RX_OUTPUT_REG:  0x136              //Output register
BYTE            UARTOUT_RX_OUTPUT_REG; 

// end of file
