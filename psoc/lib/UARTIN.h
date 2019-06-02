/******************************************************************************
*  FILENAME:      UARTIN.h
*   VERSION:      Rev B, 2002 Mar 30
*******************************************************************************
*  DESCRIPTION:
*     UARTIN UART User Module header file.
*******************************************************************************
*	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
******************************************************************************/

/* include the global header file */
#include <m8c.h>

/* Create pragmas to support proper argument and return value passing */
#pragma fastcall  UARTIN_EnableInt
#pragma fastcall  UARTIN_DisableInt
#pragma fastcall  UARTIN_Start
#pragma fastcall  UARTIN_Stop
#pragma fastcall  UARTIN_SendData
#pragma fastcall bUARTIN_ReadTxStatus
#pragma fastcall bUARTIN_ReadRxData
#pragma fastcall bUARTIN_ReadRxStatus

/**************************************************
* Prototypes of UART API. For a definition of
* functions see UARTIN.inc. 
**************************************************/
extern void  UARTIN_EnableInt(void);
extern void  UARTIN_DisableInt(void);
extern void  UARTIN_Start(BYTE bParity);
extern void  UARTIN_Stop(void);
extern void  UARTIN_SendData(BYTE bTxData);
extern BYTE bUARTIN_ReadTxStatus(void);	 
extern BYTE bUARTIN_ReadRxData(void);
extern BYTE bUARTIN_ReadRxStatus(void);	 

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
#pragma ioport  UARTIN_TX_CONTROL_REG:  0x03f              //Control register
BYTE            UARTIN_TX_CONTROL_REG; 
#pragma ioport  UARTIN_TX_SHIFT_REG:    0x03c              //TX Shift Register register
BYTE            UARTIN_TX_SHIFT_REG;  
#pragma ioport  UARTIN_TX_BUFFER_REG:   0x03d              //TX Buffer Register
BYTE            UARTIN_TX_BUFFER_REG;  
#pragma ioport  UARTIN_TX_FUNC_REG: 0x13c                  //Function register
BYTE            UARTIN_TX_FUNC_REG;  
#pragma ioport  UARTIN_TX_INPUT_REG:    0x13d              //Input register
BYTE            UARTIN_TX_INPUT_REG; 
#pragma ioport  UARTIN_TX_OUTPUT_REG:   0x13e              //Output register
BYTE            UARTIN_TX_OUTPUT_REG;
#pragma ioport  UARTIN_RX_CONTROL_REG:  0x03b              //Control register
BYTE            UARTIN_RX_CONTROL_REG; 
#pragma ioport  UARTIN_RX_SHIFT_REG:    0x038              //RX Shift Register register
BYTE            UARTIN_RX_SHIFT_REG;  
#pragma ioport  UARTIN_RX_BUFFER_REG:   0x03a              //RX Buffer Register
BYTE            UARTIN_RX_BUFFER_REG;  
#pragma ioport  UARTIN_RX_FUNC_REG: 0x138                  //Function register
BYTE            UARTIN_RX_FUNC_REG;
#pragma ioport  UARTIN_RX_INPUT_REG:    0x139              //Input register
BYTE            UARTIN_RX_INPUT_REG; 
#pragma ioport  UARTIN_RX_OUTPUT_REG:   0x13a              //Output register
BYTE            UARTIN_RX_OUTPUT_REG; 

// end of file
