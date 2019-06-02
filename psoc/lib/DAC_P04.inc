;;************************************************************************
;;************************************************************************
;;
;;  DAC_P04.inc (from DAC6.inc user module template)
;;  Rev C, 2002 Mar 30
;;
;; Assembler declarations for the DAC6 user module interface.
;;
;; Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************

DAC_P04_OFF:              equ 00h
DAC_P04_LOWPOWER:         equ 01h
DAC_P04_MEDPOWER:         equ 02h
DAC_P04_HIGHPOWER:        equ 03h

DAC_P04_CR0:              equ 98h
DAC_P04_CR1:              equ 99h
DAC_P04_CR2:              equ 9ah
DAC_P04_CR3:              equ 9bh

DAC_P04_OffsetBinary:     equ 04h
DAC_P04_TwosComplement:   equ 02h
DAC_P04_SignAndMagnitude: equ 01h
DAC_P04_RawRegister:      equ 00h

DAC_P04_DATAFORMAT:       equ 7h
DAC_P04_OFFSETBINARY:     equ DAC_P04_DATAFORMAT & DAC_P04_OffsetBinary
DAC_P04_TWOSCOMPLEMENT:   equ DAC_P04_DATAFORMAT & DAC_P04_TwosComplement
DAC_P04_SIGNANDMAGNITUDE: equ DAC_P04_DATAFORMAT & DAC_P04_SignAndMagnitude

DAC_P04_PHASE_Normal:     equ 0
DAC_P04_PHASE_Swapped:    equ 1
DAC_P04_PHASE_SWAP:       equ DAC_P04_PHASE_Normal

IF DAC_P04_PHASE_SWAP
    DAC_P04_CR0_HIBITS:   equ C0h
ELSE
    DAC_P04_CR0_HIBITS:   equ 80h
ENDIF
