;------------------------------------------------------------------------------
;  FILENAME:   SampleCLKint.asm
;   VERSION:   REV B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Interrupt handler routine for Counter8 user module instance:
;        SampleCLK.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002.  All Rights Reserved.
;------------------------------------------------------------------------------

include  "SampleCLK.inc"

;-----------------------------------------------------
;  Export interrupt handler
;     NOTE that interrupt handler is NOT exported
;     for access by C function.  Interrupt handlers
;     are not callable by C functions.
;-----------------------------------------------------
export   SampleCLKINT

;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLKInt
;
;  DESCRIPTION:
;     Counter8 interrupt handler for instance SampleCLK.  
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
SampleCLKINT:
   ;--------------------------
   ; Place user code here!!!
   ;--------------------------
   reti
	

; end of file
