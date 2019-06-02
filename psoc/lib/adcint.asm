;;********************************************************************
;;********************************************************************
;;  ADCINC12int.asm
;;
;;  Assembler source for interrupt routines the 12 bit Incremential
;;  A/D converter.
;;
;;  Rev D, 2002 Mar 30
;;
;;  Copyright: Cypress MicroSystems 2000-2002.  All Rights Reserved.
;;
;;*********************************************************************
;;*********************************************************************
include "ADC.inc"
include "m8c.inc"

export  ADC_CNT_INT
export  ADC_TMR_INT
export  ADC_cTimerU
export  ADC_cCounterU
export _ADC_iIncr
export  ADC_iIncr
export _ADC_fIncr
export  ADC_fIncr
export  ADC_bIncrC

area bss(RAM) 
    ADC_cTimerU:   BLK  1   ;The Upper byte of the Timer
    ADC_cCounterU: BLK  1   ;The Upper byte of the Counter
   _ADC_iIncr:
    ADC_iIncr:     BLK  2   ;A/D value
   _ADC_fIncr:
    ADC_fIncr:     BLK  1   ;Data Valid Flag
    ADC_bIncrC:    BLK  1   ;# of times to run A/D

area text(ROM,REL)

LowByte:   equ 1
HighByte:  equ 0
 
;;------------------------------------------------------------------
;;  CNT_INT:
;;  Increment  the upper (software) half on the counter whenever the
;;  lower (hardware) half of the counter underflows.
;;  INPUTS:  None.
;;  OUTPUTS: None.  
;;------------------------------------------------------------------
ADC_CNT_INT:
   inc [ADC_cCounterU]
   reti

;;------------------------------------------------------------------
;;  TMR_INT:
;;  This routine allows the counter to collect data for 64 timer cycles
;;  This routine then holds the integrater in reset for one cycle while
;;  the A/D value is calculated.
;;  INPUTS:  None.
;;  OUTPUTS: None.  
;;------------------------------------------------------------------
ADC_TMR_INT:
   dec [ADC_cTimerU]
;  if(upper count >0 )
   jz  else1
      reti
   else1:;(upper count decremented to 0)
      tst reg[ADC_AtoDcr3],10h
      jz   else2
;     if(A/D has been in reset mode)
         mov reg[ADC_CounterCR0],01h   ; Enable Counter
         and reg[ADC_AtoDcr3],~10h     ; Enable Analog Integrator
IF ADC_NoAZ
         and reg[ADC_AtoDcr2],~20h
ENDIF
         mov [ADC_cTimerU],(1<<(ADC_NUMBITS - 6))
                                                    ; This will be the real counter value
         reti
      else2:;(A/D has been in integrate mode)
         mov reg[ADC_CounterCR0],00h   ;disable counter
         or  F,01h                                  ;Enable the interrupts
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ; Good place to add code to switch inputs for multiplexed input to ADC
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF ADC_NoAZ
         or  reg[ADC_AtoDcr2],20h      ;Reset Integrator
ENDIF
         or  reg[ADC_AtoDcr3],10h
         push A
         mov A, reg[ADC_CounterDR0]    ;read Counter
         mov A, reg[ADC_CounterDR2]    ;now you really read the data
         cpl A
         cmp [ADC_cCounterU],(1<<(ADC_NUMBITS - 7))
         jnz endif10
;        if(max positive value)
            dec [ADC_cCounterU]
            mov A,ffh
         endif10:
         asr [ADC_cCounterU]                              ; divide by 4
         rrc A
         asr [ADC_cCounterU]
         rrc A
;
         mov [(ADC_iIncr + HighByte)],[ADC_cCounterU]
         mov [(ADC_iIncr + LowByte)],A
         mov [ADC_fIncr],01h          ;Set AD data flag
         pop A
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ; User code here for interrupt system.
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         cmp [ADC_bIncrC],00h
         jz  endif3
;        if(ADC_bIncrC is not zero)
            dec [ADC_bIncrC]
            jnz endif4
;           if(ADC_bIncrC has decremented down to zero to 0)
               mov reg[ADC_TimerCR0],00h          ;disable the Timer
               mov reg[ADC_CounterCR0],00h        ;disable the Counter
               nop
               nop
               and reg[INT_MSK1],~(ADC_TimerMask | ADC_CounterMask)
                                                               ;Disable both interrupts
IF ADC_NoAZ
               or  reg[ADC_AtoDcr2],20h           ;Reset Integrator
ENDIF
               or  reg[ADC_AtoDcr3],10h
               reti
            endif4:;
         endif3:;
      endif2:;
      mov [ADC_cTimerU],1                         ;Set Timer for one cycle of reset
      mov [ADC_cCounterU],(-(1<<(ADC_NUMBITS - 7))) ;Set Counter hardware for easy enable
      mov reg[ADC_CounterDR1],ffh 
      reti
   endif1:;

ADC_APIINT_END:
