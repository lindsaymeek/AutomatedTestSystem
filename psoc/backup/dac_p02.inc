;;************************************************************************
;;************************************************************************
;;
;;  DAC_P02.inc (from DAC6.inc user module template)
;;  Rev C, 2002 Mar 30
;;
;; Assembler declarations for the DAC6 user module interface.
;;
;; Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************

DAC_P02_OFF:              equ 00h
DAC_P02_LOWPOWER:         equ 01h
DAC_P02_MEDPOWER:         equ 02h
DAC_P02_HIGHPOWER:        equ 03h

DAC_P02_CR0:              equ 9ch
DAC_P02_CR1:              equ 9dh
DAC_P02_CR2:              equ 9eh
DAC_P02_CR3:              equ 9fh

DAC_P02_OffsetBinary:     equ 04h
DAC_P02_TwosComplement:   equ 02h
DAC_P02_SignAndMagnitude: equ 01h
DAC_P02_RawRegister:      equ 00h

DAC_P02_DATAFORMAT:       equ 7h
DAC_P02_OFFSETBINARY:     equ DAC_P02_DATAFORMAT & DAC_P02_OffsetBinary
DAC_P02_TWOSCOMPLEMENT:   equ DAC_P02_DATAFORMAT & DAC_P02_TwosComplement
DAC_P02_SIGNANDMAGNITUDE: equ DAC_P02_DATAFORMAT & DAC_P02_SignAndMagnitude

DAC_P02_PHASE_Normal:     equ 0
DAC_P02_PHASE_Swapped:    equ 1
DAC_P02_PHASE_SWAP:       equ DAC_P02_PHASE_Normal

IF DAC_P02_PHASE_SWAP
    DAC_P02_CR0_HIBITS:   equ C0h
ELSE
    DAC_P02_CR0_HIBITS:   equ 80h
ENDIF
