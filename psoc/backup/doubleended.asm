;;************************************************************************
;;************************************************************************
;;
;; INSAMP.asm
;;
;; Assembler source for Instrumentation Amplifier
;;
;; Rev A, 2002 Mar 30
;;
;; Copyright (c) 2000-2002 Cypress Microsystems, Inc. All rights reserved.
;;
;;************************************************************************
;;************************************************************************
;;

export  DoubleEnded_Start
export _DoubleEnded_Start
export  DoubleEnded_SetPower
export _DoubleEnded_SetPower

export  DoubleEnded_SetGain
export _DoubleEnded_SetGain

export  DoubleEnded_Stop
export _DoubleEnded_Stop

;; -----------------------------------------------------------------
;;                         Register Definitions
;; -----------------------------------------------------------------
;;
;; Uses 2 Continuous Time Blocks configured as shown. This API depends
;; on knowing the exact personalization of CR0 and CR3 bitfields
;; for time efficiency.
;;
;; * For a Mask/Val pair, this indicates that the value is
;;   determined by the user either through config-time parameteriza-
;;   tion or run-time manipulation.
;;
;; BIT FIELD	         Mask/Val Function
;; -----------------    	----- 	--------------------
;; NON_INV_CR0.RES_RATIO_T2B	F0/*	User Parameter (by table)
;; NON_INV_CR0.GAIN_ATTEN	08/1	Gain
;; NON_INV_CR0.RES_SOURCE	04/1	Res source to output
;; NON_INV_CR0.RES_REF		03/0	Res ref to INV output
;;
;; NON_INV_CR1.A_OUT		80/*	User Parameter (Output bus)
;; NON_INV_CR1.COMP_EN		40/0	Comparator bus disabled
;; NON_INV_CR1.CT_NEG_INPUT_MUX	38/4	Neg mux to analog f.b. tap
;; NON_INV_CR1.CT_POS_INPUT_MUX	07/1	Pos mux to col. input mux
;;
;; NON_INV_CR2.CP_COMP		80/0	Latch transparent on PH1
;; NON_INV_CR2.CK_COMP		40/0	Latch transparent
;; NON_INV_CR2.CC_COMP		20/1	Mode OP-AMP (not comparator)
;; NON_INV_CR2.BYPASS_OBUS	1C/0	Bypass OFF
;; NON_INV_CR2.PWR_SELECT	03/0	Power OFF at start-up
;;
;; INV_CR0.RES_RATIO_T2B	F0/*	User Parameter (by table)
;; INV_CR0.GAIN_ATTEN		08/1	Gain
;; INV_CR0.RES_SOURCE		04/1	Res source to output	
;; INV_CR0.RES_REF		03/*	User Parameter
;;
;; INV_CR1.A_OUT		80/0	Output bus disabled		
;; INV_CR1.COMP_EN		40/0	Comparator bus disabled
;; INV_CR1.CT_NEG_INPUT_MUX	38/4	Neg mux to analog f.b. tap
;; INV_CR1.CT_POS_INPUT_MUX	07/1	Pos mux to col. input mux
;;
;; INV_CR2.CP_COMP		80/0	Latch transparent on PH1
;; INV_CR2.CK_COMP		40/0	Latch transparent
;; INV_CR2.CC_COMP		20/0	Mode OP-AMP (not comparator)
;; INV_CR2.BYPASS_OBUS		1C/0	Bypass OFF
;; INV_CR2.PWR_SELECT		03/0	Power OFF at start-up

include "DoubleEnded.inc"
include "m8c.inc"
POWERMASK: equ 03h                           ;Power field mask for CR2
GAINMASK:  equ F0h                           ;Gain field mask for CR0


;; -----------------------------------------------------------------
;; Start/SetPower - Applies power setting to the module's PSoC blocks
;; 
;; INPUTS: A contains the power setting 0=Off, 1=Low, 2=Med, 3=High
;; OUTUTS: None
;; -----------------------------------------------------------------

 DoubleEnded_Start:
_DoubleEnded_Start:
 DoubleEnded_SetPower:
_DoubleEnded_SetPower:

    and A, POWERMASK                         ; mask A to protect unchanged bits
    mov X, SP                                ; define temp store location

    push A                                   ; put power value in temp store
    mov A, reg[DoubleEnded_INV_CR2]     ; read power value
    and A, ~POWERMASK                        ; clear power bits in A
    or  A, [X]                               ; combine power value with balance of reg.
    mov reg[DoubleEnded_INV_CR2], A

    mov A, reg[DoubleEnded_NON_INV_CR2] ; read power value
    and A, ~POWERMASK                        ; clear power bits in A
    or  A, [X]                               ; combine power value with balance of reg.
    mov reg[DoubleEnded_NON_INV_CR2], A
    pop A
    ret


;; -----------------------------------------------------------------
;; SetGain - Applies gain set values to the module's PSoC blocks
;; 
;; INPUTS: A contains the gain setting per values in .inc
;;         Values in range of 00h to 07h, upper 4 bits only
;;         Gain value applied to NON_INV block
;;         Difference (E0h-gain value) applied to _INV block
;; OUTUTS: None
;; -----------------------------------------------------------------

 DoubleEnded_SetGain:
_DoubleEnded_SetGain:

    and A, GAINMASK                          ; mask A to protect unchanged bits
    mov X, SP                                ; set base address for local variable

    push A                                   
    mov A, reg[DoubleEnded_NON_INV_CR0] ; read gain value
    and A, ~GAINMASK                         ; clear gain bits in A
    or  A, [X]                               ; combine gain value with balance of reg.
    mov reg[DoubleEnded_NON_INV_CR0], A 

    mov A, E0h                               ; load gain complement value
    sub a, [X]                               ; calculate gain value for -INV block
    push A                                   
    mov A, reg[DoubleEnded_INV_CR0]     ; read gain complement value
    and A, ~GAINMASK                         ; clear gain bits in A
    or  A, [X+1]                               ; combine gain value with balance of reg.
    mov reg[DoubleEnded_INV_CR0], A     
    pop A
    pop A
    ret



;; -----------------------------------------------------------------
;; Stop - Cuts power to the user module.
;;
;; INPUTS:  None
;; OUTPUTS: None
;; -----------------------------------------------------------------

 DoubleEnded_Stop:
_DoubleEnded_Stop:

      
    and reg[DoubleEnded_NON_INV_CR2], FCh
    and reg[DoubleEnded_INV_CR2], FCh
        RET
