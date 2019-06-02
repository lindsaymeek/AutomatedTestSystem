;;***********************************************************************
;;***********************************************************************
;;
;;  ADC.inc  for the 12 bit incremental A/D converter
;;
;;  Assembler declarations for the ACDINC12 User Module.
;;
;;  Rev D, 2002 MAR 30
;;
;;  Copyright: Cypress Micro Systems 2000, 2001.  All Rights Reserved
;;
;;************************************************************************
;;************************************************************************

ADC_AtoDcr0:    equ 88h
ADC_AtoDcr1:    equ 89h
ADC_AtoDcr2:    equ 8ah
ADC_AtoDcr3:    equ 8bh
ADC_CounterFN:  equ 24h
ADC_CounterSL:  equ 25h
ADC_CounterOS:  equ 26h
ADC_CounterDR0: equ 24h
ADC_CounterDR1: equ 25h
ADC_CounterDR2: equ 26h
ADC_CounterCR0: equ 27h
ADC_TimerFN:    equ 20h
ADC_TimerSL:    equ 21h
ADC_TimerOS:    equ 22h
ADC_TimerDR0:   equ 20h
ADC_TimerDR1:   equ 21h
ADC_TimerDR2:   equ 22h
ADC_TimerCR0:   equ 23h
ADC_TimerMask:   equ  01h
ADC_CounterMask: equ  02h
ADC_OFF:         equ  0
ADC_LOWPOWER:    equ  1
ADC_MEDPOWER:    equ  2
ADC_HIGHPOWER:   equ  3
ADC_NUMBITS:     equ  12
ADC_NoAZ:        equ  1
HighByte:                     equ  0
LowByte:                      equ  1

macro ADC_ISDATA
   mov A,[ADC_fIncr]
   endm

macro ADC_GETDATA
   mov X,[(ADC_iIncr + HighByte)]
   mov A,[(ADC_iIncr + LowByte)]
   endm

macro ADC_CLEARFLAG
   mov [ADC_fIncr],00h
   endm





