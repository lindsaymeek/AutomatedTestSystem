;------------------------------------------------------------------------------
;  FILENAME:   SampleCLK.asm
;   VERSION:   Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     SampleCLK Counter8 User Module API.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------

;-----------------------------------------------
; include instance specific register definitions
;-----------------------------------------------
include "m8c.inc"
include "SampleCLK.inc"

area text (ROM, REL)

;-------------------------------------------------------------------
;  Declare the functions global for both assembler and C compiler.
;
;  Note that there are two names for each API. First name is 
;  assembler reference. Name with underscore is name refence for
;  C compiler.  Calling function in C source code does not require 
;  the underscore.
;-------------------------------------------------------------------
export   SampleCLK_EnableInt
export  _SampleCLK_EnableInt
export   SampleCLK_DisableInt
export  _SampleCLK_DisableInt
export   SampleCLK_Start
export  _SampleCLK_Start
export   SampleCLK_Stop
export  _SampleCLK_Stop
export   SampleCLK_WritePeriod
export  _SampleCLK_WritePeriod
export   SampleCLK_WriteCompareValue
export  _SampleCLK_WriteCompareValue
export   bSampleCLK_ReadCompareValue
export  _bSampleCLK_ReadCompareValue
export   bSampleCLK_ReadCounter
export  _bSampleCLK_ReadCounter

;-----------
;  EQUATES
;-----------
bfCONTROL_REG_START_BIT:   equ   1     ; Control register start bit 
bfINPUT_REG_CLOCK_MASK:    equ   0Fh   ; input register clock mask

;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLK_EnableInt
;
;  DESCRIPTION:
;     Enables this counter's interrupt by setting the interrupt enable mask bit
;     associated with this User Module. Remember to call the global interrupt
;     enable function by using the macro: M8C_EnableGInt.
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
;     Sets the specific user module interrupt enable mask bit.
;
;-----------------------------------------------------------------------------
 SampleCLK_EnableInt:
_SampleCLK_EnableInt:
   M8C_EnableIntMask SampleCLK_INT_REG, bSampleCLK_INT_MASK
   ret	

	
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLK_DisableInt
;
;  DESCRIPTION:
;     Disables this counter's interrupt by clearing the interrupt enable mask bit
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
;     Clears the specific user module interrupt enable mask bit.
;
;-----------------------------------------------------------------------------
 SampleCLK_DisableInt:
_SampleCLK_DisableInt:
   
   M8C_DisableIntMask SampleCLK_INT_REG, bSampleCLK_INT_MASK
   ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLK_Start
;
;  DESCRIPTION:
;     Sets the start bit in the Control register of this user module.  The
;     counter will begin counting on the next input clock as soon as the 
;     enable input is asserted high.
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
;     Set the start bit in the Control register.
;
;-----------------------------------------------------------------------------
 SampleCLK_Start:
_SampleCLK_Start:
   or    REG[SampleCLK_CONTROL_REG], bfCONTROL_REG_START_BIT
   ret	


;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLK_Stop
;
;  DESCRIPTION:
;     Disables counter operation.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     After this function completes, the Count register will latch any data
;     written to the Period register.  Writing to the Period register is 
;     performed using the SampleCLK_WritePeriod function.
;
;  THEORY of OPERATION:  
;     Clear the start bit in the Control register.
;
;-----------------------------------------------------------------------------
 SampleCLK_Stop:
_SampleCLK_Stop:
   and   REG[SampleCLK_CONTROL_REG], ~bfCONTROL_REG_START_BIT
   ret	


;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLK_WritePeriod
;
;  DESCRIPTION:
;     Write the period value into the Period register.
;
;  ARGUMENTS:
;     BYTE  bPeriodValue - period count - passed in the Accumulator.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     If the counter user module is stopped, then this value will also be
;     latched into the Count register.
;
;  THEORY of OPERATION:  
;     Write data into the Period register.
;
;-----------------------------------------------------------------------------
 SampleCLK_WritePeriod:
_SampleCLK_WritePeriod:
   tst   REG[SampleCLK_CONTROL_REG], bfCONTROL_REG_START_BIT
   jnz   .CounterRunning

; Counter is stopped.  Due to chip errata, we have to set the clock low for
; the write to the period register to cause the data to be immediately transferred
; into the Counter.
.CounterStopped:
   push  X
   mov   X, A                                   ; save the period argument
   M8C_SetBank1
   mov   A, REG[SampleCLK_INPUT_REG]             ; save the context of the clock - input register
   push  A
   and   REG[SampleCLK_INPUT_REG], F0h           ; set the clock signal low
   M8C_SetBank0
   mov   A, X                                      
   mov   REG[SampleCLK_PERIOD_REG], A                ; set the period register with the new period
   pop   A
   M8C_SetBank1
   mov   REG[SampleCLK_INPUT_REG], A             ; restore the clock
   M8C_SetBank0
   pop   X
   ret

; Counter is running - write the period into the period register.
; Upon Terminal Count this value will get loaded into the counter.
.CounterRunning:
   mov   REG[SampleCLK_PERIOD_REG], A
   ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: SampleCLK_WriteCompareValue
;
;  DESCRIPTION:
;     Writes compare value into the CompareValue register.
;
;  ARGUMENTS:
;     BYTE  bCompareValue - compare value count - passed in Accumulator.
;
;  RETURNS:
;     none.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Write data into the CompareValue register.
;
;-----------------------------------------------------------------------------
 SampleCLK_WriteCompareValue:
_SampleCLK_WriteCompareValue:
   mov   REG[SampleCLK_COMPARE_REG], A
   ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bSampleCLK_ReadCompareValue
;
;  DESCRIPTION:
;     Reads the CompareValue register.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     BYTE  bCompareValue - value read from CompareValue register - returned
;                           in the Accumulator.
;
;  SIDE EFFECTS:
;     none.
;
;  THEORY of OPERATION:  
;     Read the CompareValue register and return value in A.
;
;-----------------------------------------------------------------------------
 bSampleCLK_ReadCompareValue:
_bSampleCLK_ReadCompareValue:
   mov   A, REG[SampleCLK_COMPARE_REG]
   ret


;-----------------------------------------------------------------------------
;  FUNCTION NAME: bSampleCLK_ReadCounter
;
;  DESCRIPTION:
;     Reads the count in the Count register.
;
;  ARGUMENTS:
;     none.
;
;  RETURNS:
;     BYTE  bCount - current count value in Count register.
;
;  SIDE EFFECTS:
;     Reading the Count register may cause the Count register to miss
;     one or more counts due to the fact that the clock is stopped while
;     the Count register is read.  The preferred method is to use the 
;     interrupt feature to determine when the Count has arrived at a 
;     specified value.
;
;  THEORY of OPERATION:  
;     Reading the Count register causes its value to be latched into the 
;     CompareValue register.  Care must be taken to stop the clock and save 
;     the CompareValue register's contents before reading the Count.
;
;-----------------------------------------------------------------------------
 bSampleCLK_ReadCounter:
_bSampleCLK_ReadCounter:

   ; save the input register clock setting
   M8C_SetBank1
   mov   A, REG[SampleCLK_INPUT_REG]
   push  A
   ; disable the clock
   and   REG[SampleCLK_INPUT_REG], ~bfINPUT_REG_CLOCK_MASK
   M8C_SetBank0

   ; save the CompareValue register value
   mov   A, REG[SampleCLK_COMPARE_REG]    
   push  A
   ; Read the counter. This latches the counter data into
   ; the CompareValue register.  This may cause an interrupt.
   mov   A, REG[SampleCLK_COUNTER_REG]    
   ; Read the CompareValue register, which contains the counter value
   mov   A, REG[SampleCLK_COMPARE_REG]    
   ; Save the Count value in X
   mov   X, A
   ; Restore the CompareValue register
   pop   A
   mov   REG[SampleCLK_COMPARE_REG], A

   ; restore the input register clock setting
   M8C_SetBank1
   pop   A
   mov   REG[SampleCLK_INPUT_REG], A
   M8C_SetBank0

   ; Get the saved read counter value
   mov   A, X

   ret

; end of file
