;;************************************************************************
;;************************************************************************
;;
;;  DAC_P03.inc (from DAC6.inc user module template)
;;  Rev C, 2002 Mar 30
;;
;; Assembler declarations for the DAC6 user module interface.
;;
;; Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************

DAC_P03_OFF:              equ 00h
DAC_P03_LOWPOWER:         equ 01h
DAC_P03_MEDPOWER:         equ 02h
DAC_P03_HIGHPOWER:        equ 03h

DAC_P03_CR0:              equ 90h
DAC_P03_CR1:              equ 91h
DAC_P03_CR2:              equ 92h
DAC_P03_CR3:              equ 93h

DAC_P03_OffsetBinary:     equ 04h
DAC_P03_TwosComplement:   equ 02h
DAC_P03_SignAndMagnitude: equ 01h
DAC_P03_RawRegister:      equ 00h

DAC_P03_DATAFORMAT:       equ 7h
DAC_P03_OFFSETBINARY:     equ DAC_P03_DATAFORMAT & DAC_P03_OffsetBinary
DAC_P03_TWOSCOMPLEMENT:   equ DAC_P03_DATAFORMAT & DAC_P03_TwosComplement
DAC_P03_SIGNANDMAGNITUDE: equ DAC_P03_DATAFORMAT & DAC_P03_SignAndMagnitude

DAC_P03_PHASE_Normal:     equ 0
DAC_P03_PHASE_Swapped:    equ 1
DAC_P03_PHASE_SWAP:       equ DAC_P03_PHASE_Normal

IF DAC_P03_PHASE_SWAP
    DAC_P03_CR0_HIBITS:   equ C0h
ELSE
    DAC_P03_CR0_HIBITS:   equ 80h
ENDIF
