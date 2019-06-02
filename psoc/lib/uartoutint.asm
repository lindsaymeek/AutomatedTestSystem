;------------------------------------------------------------------------------
;  FILENAME:   UARTOUTint.asm
;   VERSION:    Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Interrupt handler routine for UART user module instance:
;        UARTOUT.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002.  All Rights Reserved.
;------------------------------------------------------------------------------

include  "UARTOUT.inc"

area text (ROM, REL)

;-----------------------------------------------------
;  Export interrupt handler
;     NOTE that interrupt handler is NOT exported
;     for access by C function.  Interrupt handlers
;     are not callable by C functions.
;-----------------------------------------------------
export   UARTOUTTX_INT
export   UARTOUTRX_INT

;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUTTX_INT
;
;  DESCRIPTION:
;     UART TX interrupt handler for instance UARTOUT.  
;
;     This is a place holder function.  If the user requires use of an interrupt
;     handler for this function, then place code where specified.
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
;     none.
;
;-----------------------------------------------------------------------------
UARTOUTTX_INT:
   ;--------------------------
   ; Place user code here!!!
   ;--------------------------
   reti
	

;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTOUTRX_INT
;
;  DESCRIPTION:
;     UART RX interrupt handler for instance UARTOUT.  
;
;     This is a place holder function.  If the user requires use of an interrupt
;     handler for this function, then place code where specified.
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
;     none.
;
;-----------------------------------------------------------------------------
UARTOUTRX_INT:
   ;--------------------------
   ; Place user code here!!!
   ;--------------------------
   reti
	

; end of file
	
