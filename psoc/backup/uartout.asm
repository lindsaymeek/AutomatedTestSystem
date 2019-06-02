;------------------------------------------------------------------------------
;  FILENAME:   UARTOUT.asm
;   VERSION:   Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     UARTOUT UART User Module API.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------

;-----------------------------------------------
; include instance specific register definitions
;-----------------------------------------------
include "m8c.inc"
include "UARTOUT.inc"

area text (ROM, REL)

;-------------------------------------------------------------------
;  Declare the functions global for both assembler and C compiler.
;
;  Note that there are two names for each API. First name is 
;  assembler reference. Name with underscore is name refence for
;  C compiler.  Calling function in C source code does not require 
;  the underscore.
;-------------------------------------------------------------------
export   UARTOUT_EnableInt
export  _UARTOUT_EnableInt
export   UARTOUT_DisableInt
export  _UARTOUT_DisableInt
export   UARTOUT_Start
export  _UARTOUT_Start
export   UARTOUT_Stop
export  _UARTOUT_Stop
export   UARTOUT_SendData
export  _UARTOUT_SendData
export  bUARTOUT_ReadTxStatus
export _bUARTOUT_ReadTxStatus
export  bUARTOUT_ReadRxData
export _bUARTOUT_ReadRxData
export  bUARTOUT_ReadRxStatus
export _bUARTOUT_ReadRxStatus

;-----------
;  EQUATES
;-----------
bfCONTROL_REG_START_BIT:   equ   1     ; Control register start bit 

;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUT_EnableInt
;
;  DESCRIPTION:
;     Enables this UART's interrupt by setting the interrupt enable mask 
;     bit associated with this User Module. Remember to call the global 
;     interrupt enable function by using the macro: M8C_EnableGInt.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Sets the specific user module interrupt enable mask bit in both the
;     TX and RX blocks.
;
;-----------------------------------------------------------------------------
 UARTOUT_EnableInt:
_UARTOUT_EnableInt:
   M8C_EnableIntMask UARTOUT_TX_INT_REG, bUARTOUT_TX_INT_MASK
   M8C_EnableIntMask UARTOUT_RX_INT_REG, bUARTOUT_RX_INT_MASK
   ret	

	
;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUT_DisableInt
;
;  DESCRIPTION:
;     Disables this UART's interrupt by clearing the interrupt enable mask bit
;     associated with this User Module. 
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Clears the specific user module interrupt enable mask bit in the TX
;     and RX blocks.
;
;-----------------------------------------------------------------------------
 UARTOUT_DisableInt:
_UARTOUT_DisableInt:
   M8C_DisableIntMask UARTOUT_TX_INT_REG, bUARTOUT_TX_INT_MASK
   M8C_DisableIntMask UARTOUT_RX_INT_REG, bUARTOUT_RX_INT_MASK
   ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUT_Start(BYTE bParity)
;
;  DESCRIPTION:
;     Sets the start bit and parity in the Control register of this user module. 
;
;  ARGUMENTS:
;     BYTE bParity - parity setting for the Transmitter and receiver. Use defined masks.
;        Passed in the A register.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Set the specified parity and start bits in the Control register of the 
;     TX and RX blocks.
;
;-----------------------------------------------------------------------------
 UARTOUT_Start:
_UARTOUT_Start:
   or    A, bfCONTROL_REG_START_BIT
   mov   REG[UARTOUT_TX_CONTROL_REG], A
   mov   REG[UARTOUT_RX_CONTROL_REG], A
   ret	


;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUT_Stop
;
;  DESCRIPTION:
;     Disables UART operation.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Clear the start bit in the Control registers.
;
;-----------------------------------------------------------------------------
 UARTOUT_Stop:
_UARTOUT_Stop:
   and   REG[UARTOUT_TX_CONTROL_REG], ~bfCONTROL_REG_START_BIT
   and   REG[UARTOUT_RX_CONTROL_REG], ~bfCONTROL_REG_START_BIT
   ret	


;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUT_SendData
;
;  DESCRIPTION:
;     Initiates a transmission of data.
;
;  ARGUMENTS:
;     BYTE  TxData - data to transmit. PASSED in A register.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Writes data to the TX buffer register. 
;
;-----------------------------------------------------------------------------
 UARTOUT_SendData:
_UARTOUT_SendData:
	mov REG[UARTOUT_TX_BUFFER_REG], A
	ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bUARTOUT_ReadTxStatus
;
;  DESCRIPTION:
;     Reads the Tx Status bits in the Control/Status register.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     BYTE  bTxStatus - transmit status data.  Use defined masks for detecting
;              stutus bits.
;        returned in A.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Read TX status and control register.
;
;-----------------------------------------------------------------------------
 bUARTOUT_ReadTxStatus:
_bUARTOUT_ReadTxStatus:
 	mov A,  REG[UARTOUT_TX_CONTROL_REG]
	ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bUARTOUT_ReadRxData
;
;  DESCRIPTION:
;     Reads the RX buffer register.  Should check the status regiser to make
;     sure data is valid.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     bRxData - returned in A.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     none.
;
;-----------------------------------------------------------------------------
 bUARTOUT_ReadRxData:
_bUARTOUT_ReadRxData:
	mov A, REG[UARTOUT_RX_BUFFER_REG]
	ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bUARTOUT_ReadRxStatus
;
;  DESCRIPTION:
;     Reads the RX Status bits in the Control/Status register.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     BYTE  bRXStatus - transmit status data.  Use the following defined bits 
;                       masks: RX_COMPLETE and RX_BUFFER_EMPTY
;     returned in A.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Read the status and control register.
;
;-----------------------------------------------------------------------------
 bUARTOUT_ReadRxStatus:
_bUARTOUT_ReadRxStatus:
	mov A,  REG[UARTOUT_RX_CONTROL_REG]
	ret

;	end of UART API code
