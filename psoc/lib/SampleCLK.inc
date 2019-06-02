;------------------------------------------------------------------------------
;  FILENAME:   SampleCLK.inc
;   VERSION:    REV B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Assembler include file of SampleCLK instance of timer8 
;     user module.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------

;--------------------------------
;  Interrupt registers and masks
;--------------------------------
;mask value for global int reg bit for counter8 instance
bSampleCLK_INT_MASK:         equ 08h  
;counter8 interrupt address
SampleCLK_INT_REG:           equ 0e1h  


;---------------------------------
;  Registers used by counter8
;---------------------------------
SampleCLK_CONTROL_REG:  equ 2fh                  ;Control register
SampleCLK_COUNTER_REG:  equ 2ch                  ;Counter register
SampleCLK_PERIOD_REG:   equ 2dh                  ;Period value register
SampleCLK_COMPARE_REG:  equ 2eh                  ;CompareValue register
SampleCLK_FUNC_REG: equ 2ch                      ;Function register
SampleCLK_INPUT_REG:    equ 2dh                  ;Input register
SampleCLK_OUTPUT_REG:   equ 2eh                  ;Output register

; end of file
