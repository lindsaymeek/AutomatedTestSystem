;------------------------------------------------------------------------------
;  FILENAME:   BAUDCLK.inc
;   VERSION:    REV B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Assembler include file of BAUDCLK instance of timer8 
;     user module.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------

;--------------------------------
;  Interrupt registers and masks
;--------------------------------
;mask value for global int reg bit for counter8 instance
bBAUDCLK_INT_MASK:         equ 04h  
;counter8 interrupt address
BAUDCLK_INT_REG:           equ 0e1h  


;---------------------------------
;  Registers used by counter8
;---------------------------------
BAUDCLK_CONTROL_REG:    equ 2bh                  ;Control register
BAUDCLK_COUNTER_REG:    equ 28h                  ;Counter register
BAUDCLK_PERIOD_REG: equ 29h                      ;Period value register
BAUDCLK_COMPARE_REG:    equ 2ah                  ;CompareValue register
BAUDCLK_FUNC_REG:   equ 28h                      ;Function register
BAUDCLK_INPUT_REG:  equ 29h                      ;Input register
BAUDCLK_OUTPUT_REG: equ 2ah                      ;Output register

; end of file
