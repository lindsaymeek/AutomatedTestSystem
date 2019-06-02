
;;************************************************************************
;;************************************************************************
;;
;; Invert.inc (from AMPINV_A.inc user module template)
;;  REV C, 2002 MAR 30
;;
;; Assembler declarations for the AMPINV_A user module interface.
;;
;; Copyright (c) Cypress MicroSystems 2001. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************

Invert_OFF:        equ 0
Invert_LOWPOWER:   equ 1
Invert_MEDPOWER:   equ 2
Invert_HIGHPOWER:  equ 3

Invert_G15_0:       equ 00h
Invert_G7_00:       equ 10h
Invert_G4_33:       equ 20h
Invert_G3_00:       equ 30h
Invert_G2_20:       equ 40h
Invert_G1_67:       equ 50h
Invert_G1_28:       equ 60h
Invert_G1_00:       equ 70h
Invert_G0_78:       equ 80h
Invert_G0_60:       equ 90h
Invert_G0_46:       equ A0h
Invert_G0_33:       equ B0h
Invert_G0_23:       equ C0h
Invert_G0_14:       equ D0h
Invert_G0_06:       equ E0h

Invert_INVAMP_CR0:  equ 7dh
Invert_INVAMP_CR1:  equ 7eh
Invert_INVAMP_CR2:  equ 7fh
