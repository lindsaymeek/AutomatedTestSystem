;------------------------------------------------------------------------------
;  FILENAME:   UARTIN.asm
;   VERSION:   Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     UARTIN UART User Module API.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------

;-----------------------------------------------
; include instance specific register definitions
;-----------------------------------------------
include "m8c.inc"
include "UARTIN.inc"

area text (ROM, REL)

;-------------------------------------------------------------------
;  Declare the functions global for both assembler and C compiler.
;
;  Note that there are two names for each API. First name is 
;  assembler reference. Name with underscore is name refence for
;  C compiler.  Calling function in C source code does not require 
;  the underscore.
;-------------------------------------------------------------------
export   UARTIN_EnableInt
export  _UARTIN_EnableInt
export   UARTIN_DisableInt
export  _UARTIN_DisableInt
export   UARTIN_Start
export  _UARTIN_Start
export   UARTIN_Stop
export  _UARTIN_Stop
export   UARTIN_SendData
export  _UARTIN_SendData
export  bUARTIN_ReadTxStatus
export _bUARTIN_ReadTxStatus
export  bUARTIN_ReadRxData
export _bUARTIN_ReadRxData
export  bUARTIN_ReadRxStatus
export _bUARTIN_ReadRxStatus

;-----------
;  EQUATES
;-----------
bfCONTROL_REG_START_BIT:   equ   1     ; Control register start bit 

;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTIN_EnableInt
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
 UARTIN_EnableInt:
_UARTIN_EnableInt:
   M8C_EnableIntMask UARTIN_TX_INT_REG, bUARTIN_TX_INT_MASK
   M8C_EnableIntMask UARTIN_RX_INT_REG, bUARTIN_RX_INT_MASK
   ret	

	
;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTIN_DisableInt
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
 UARTIN_DisableInt:
_UARTIN_DisableInt:
   M8C_DisableIntMask UARTIN_TX_INT_REG, bUARTIN_TX_INT_MASK
   M8C_DisableIntMask UARTIN_RX_INT_REG, bUARTIN_RX_INT_MASK
   ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTIN_Start(BYTE bParity)
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
 UARTIN_Start:
_UARTIN_Start:
   or    A, bfCONTROL_REG_START_BIT
   mov   REG[UARTIN_TX_CONTROL_REG], A
   mov   REG[UARTIN_RX_CONTROL_REG], A
   ret	


;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTIN_Stop
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
 UARTIN_Stop:
_UARTIN_Stop:
   and   REG[UARTIN_TX_CONTROL_REG], ~bfCONTROL_REG_START_BIT
   and   REG[UARTIN_RX_CONTROL_REG], ~bfCONTROL_REG_START_BIT
   ret	


;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTIN_SendData
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
 UARTIN_SendData:
_UARTIN_SendData:
	mov REG[UARTIN_TX_BUFFER_REG], A
	ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bUARTIN_ReadTxStatus
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
 bUARTIN_ReadTxStatus:
_bUARTIN_ReadTxStatus:
 	mov A,  REG[UARTIN_TX_CONTROL_REG]
	ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bUARTIN_ReadRxData
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
 bUARTIN_ReadRxData:
_bUARTIN_ReadRxData:
	mov A, REG[UARTIN_RX_BUFFER_REG]
	ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bUARTIN_ReadRxStatus
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
 bUARTIN_ReadRxStatus:
_bUARTIN_ReadRxStatus:
	mov A,  REG[UARTIN_RX_CONTROL_REG]
	ret

;	end of UART API code
