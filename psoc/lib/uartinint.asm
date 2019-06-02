;------------------------------------------------------------------------------
;  FILENAME:   UARTINint.asm
;   VERSION:    Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Interrupt handler routine for UART user module instance:
;        UARTIN.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002.  All Rights Reserved.
;------------------------------------------------------------------------------

include  "UARTIN.inc"

area text (ROM, REL)

;-----------------------------------------------------
;  Export interrupt handler
;     NOTE that interrupt handler is NOT exported
;     for access by C function.  Interrupt handlers
;     are not callable by C functions.
;-----------------------------------------------------
export   UARTINTX_INT
export   UARTINRX_INT

;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTINTX_INT
;
;  DESCRIPTION:
;     UART TX interrupt handler for instance UARTIN.  
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
UARTINTX_INT:
   ;--------------------------
   ; Place user code here!!!
   ;--------------------------
   reti
	

;-----------------------------------------------------------------------------
;  FUNCTION NAME: UARTINRX_INT
;
;  DESCRIPTION:
;     UART RX interrupt handler for instance UARTIN.  
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
UARTINRX_INT:
   ;--------------------------
   ; Place user code here!!!
   ;--------------------------
   reti
	

; end of file
	
