;;************************************************************************
;;************************************************************************
;;
;;  DAC_P05.inc (from DAC6.inc user module template)
;;  Rev C, 2002 Mar 30
;;
;; Assembler declarations for the DAC6 user module interface.
;;
;; Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************

DAC_P05_OFF:              equ 00h
DAC_P05_LOWPOWER:         equ 01h
DAC_P05_MEDPOWER:         equ 02h
DAC_P05_HIGHPOWER:        equ 03h

DAC_P05_CR0:              equ 94h
DAC_P05_CR1:              equ 95h
DAC_P05_CR2:              equ 96h
DAC_P05_CR3:              equ 97h

DAC_P05_OffsetBinary:     equ 04h
DAC_P05_TwosComplement:   equ 02h
DAC_P05_SignAndMagnitude: equ 01h
DAC_P05_RawRegister:      equ 00h

DAC_P05_DATAFORMAT:       equ 7h
DAC_P05_OFFSETBINARY:     equ DAC_P05_DATAFORMAT & DAC_P05_OffsetBinary
DAC_P05_TWOSCOMPLEMENT:   equ DAC_P05_DATAFORMAT & DAC_P05_TwosComplement
DAC_P05_SIGNANDMAGNITUDE: equ DAC_P05_DATAFORMAT & DAC_P05_SignAndMagnitude

DAC_P05_PHASE_Normal:     equ 0
DAC_P05_PHASE_Swapped:    equ 1
DAC_P05_PHASE_SWAP:       equ DAC_P05_PHASE_Normal

IF DAC_P05_PHASE_SWAP
    DAC_P05_CR0_HIBITS:   equ C0h
ELSE
    DAC_P05_CR0_HIBITS:   equ 80h
ENDIF
