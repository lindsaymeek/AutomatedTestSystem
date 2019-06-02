;;********************************************************************
;;********************************************************************
;;  ADCINC12.asm
;;
;;  Assembler source for the 12 bit Incremential A/D converter.
;;
;;  REV D, 2002 MAR 30
;;
;;  Copyright: Cypress MicroSystems 2000-2002.  All Rights Reserved.
;;
;;*********************************************************************
;;*********************************************************************

export  ADC_Start
export _ADC_Start
export  ADC_SetPower
export _ADC_SetPower
export  ADC_Stop
export _ADC_Stop
export  ADC_GetSamples
export _ADC_GetSamples
export  ADC_StopAD
export _ADC_StopAD
export  ADC_fIsData
export _ADC_fIsData
export  ADC_iGetData
export _ADC_iGetData
export  ADC_ClearFlag
export _ADC_ClearFlag

include "ADC.inc"
include "m8c.inc"

LowByte:   equ 1
HighByte:  equ 0


;;------------------------------------------------------------------
;;  Start:
;;  SetPower:
;;  Applies power setting to the module's analog PSoc block.
;;  INPUTS:  A contains the power setting
;;  OUTPUTS: None.  
;;------------------------------------------------------------------
 ADC_Start:
_ADC_Start:
 ADC_SetPower:
_ADC_SetPower:
   push X            ;save X
   mov  X,SP	   ;X will point at next pushed value
   and  A,03h
   push A		   ;X points at copy of A
   mov  A,reg[ADC_AtoDcr3]
   and  A,~03h       ;clear power bits
   or   A,[ X ]
   mov  reg[ADC_AtoDcr3],A
   pop  A
   pop  X
   ret

;;------------------------------------------------------------------
;;  Stop:
;;  SetPower:
;;  Removes power from the module's analog PSoc block.
;;  INPUTS:  None.
;;  OUTPUTS: None.  
;;------------------------------------------------------------------
 ADC_Stop:
_ADC_Stop:
   and reg[ADC_AtoDcr3], ~03h
   ret

;;------------------------------------------------------------------
;;  Get_Samples:
;;  SetPower:
;;  Starts the A/D convertor and will place data is memory.  A flag
;;  is set whenever a new data value is available.
;;  INPUTS:  A passes the number of samples (0 is continous).
;;  OUTPUTS: None.  
;;------------------------------------------------------------------
 ADC_GetSamples:
_ADC_GetSamples:
   mov [ADC_bIncrC],A	      ;number of samples
   or  reg[INT_MSK1],(ADC_TimerMask | ADC_CounterMask )
                                          ;Enable both interrupts
   mov [ADC_cTimerU],1       ;Force the Timer to do one cycle of rest
IF ADC_NoAZ
   or  reg[ADC_AtoDcr2],20h  ;force the Integrator into reset
ENDIF
   or  reg[ADC_AtoDcr3],10h
   mov [ADC_cCounterU],(-(1<<(ADC_NUMBITS - 7)));Initialize Counter
   mov reg[ADC_TimerDR1],ffh
   mov reg[ADC_CounterDR1],ffh
   mov reg[ADC_TimerCR0],01h ;enable the Timer
   mov [ADC_fIncr],00h       ;A/D Data Ready Flag is reset
   ret

;;------------------------------------------------------------------
;;  StopAD:
;;  Completely shuts down the A/D is an orderly manner.  Both the
;;  Timer and COunter interrupts are disabled.
;;  INPUTS:  None.
;;  OUTPUTS: None.  
;;------------------------------------------------------------------
 ADC_StopAD:
_ADC_StopAD:
   mov reg[ADC_TimerCR0],00h       ;disable the Timer
   mov reg[ADC_CounterCR0],00h     ;disable the Counter
   nop
   nop
   ;Disable both interrupts
   M8C_DisableIntMask INT_MSK1, (ADC_TimerMask | ADC_CounterMask )
IF ADC_NoAZ
   or  reg[ADC_AtoDcr2],20h        ;reset Integrator
ENDIF
   or  reg[ADC_AtoDcr3],10h
   ret
;;------------------------------------------------------------------
;;  fIsData:
;;  Returns the status of the A/D Data
;;  is set whenever a new data value is available.
;;  INPUTS:  None.
;;  OUTPUTS: A returned data status A =: 0 no data available
;;                                   !=: 0 data available.  
;;------------------------------------------------------------------
 ADC_fIsData:
_ADC_fIsData:
   mov A,[ADC_fIncr]
   ret

;;------------------------------------------------------------------
;;  iGetData:
;;  Returns the data from the A/D.  Does not check if data is
;;  available.
;;  is set whenever a new data value is available.
;;  INPUTS:  None.
;;  OUTPUTS: X:A returns the A/D data value.  
;;------------------------------------------------------------------
 ADC_iGetData:
_ADC_iGetData:
   mov X,[(ADC_iIncr + HighByte)]
   mov A,[(ADC_iIncr + LowByte)]
   ret

;;------------------------------------------------------------------
;;  ClearFlag:
;;  clears the data ready flag.
;;  INPUTS:  None.
;;  OUTPUTS: None.
;;------------------------------------------------------------------
 ADC_ClearFlag:
_ADC_ClearFlag:
   mov [ADC_fIncr],00h
   ret

ADC_API_End:
	
