;;**********************************************************************
;;**********************************************************************
;;
;; PGA_A.ASM
;;
;; Assembler source for Programmable Gain Amplifier PGA_A
;;
;; Rev B, 2002 Mar 30
;;
;; Copyright (c) 2001-2002 Cypress Microsystems, Inc. All rights reserved.
;;
;;**********************************************************************
;;**********************************************************************
;;


export  SingleEnded_Start
export _SingleEnded_Start
export  SingleEnded_SetPower
export _SingleEnded_SetPower

export  SingleEnded_SetGain
export _SingleEnded_SetGain

export  SingleEnded_Stop
export _SingleEnded_Stop

;; -----------------------------------------------------------------
;;                         Register Definitions
;;
;; Uses 1 Continuous Time Block configured as shown. 
;;
;; * For a Mask/Val pair, this indicates that the value is
;;   determined by the user either through config-time parameteriza-
;;   tion or run-time manipulation.
;;
;; BIT FIELD	         Mask/Val Function
;; -----------------    	----- 	--------------------
;; GAIN_CR0.RES_RATIO_T2B	F0/*	User Parameter (by table)
;; GAIN_CR0.GAIN_ATTEN		08/*	Gain (by table)
;; GAIN_CR0.RES_SOURCE		04/1	Res source to output
;; GAIN_CR0.RES_REF		03/*	Res ref 
;;
;; GAIN_CR1.A_OUT		80/*	User Parameter (Output bus)
;; GAIN_CR1.COMP_EN		40/0	Comparator bus disabled
;; GAIN_CR1.CT_NEG_INPUT_MUX	38/4	Neg mux to analog f.b. tap
;; GAIN_CR1.CT_POS_INPUT_MUX	07/*	Pos mux, typically to col. input mux
;;
;; GAIN_CR2.CP_COMP		80/0	Latch transparent on PH1
;; GAIN_CR2.CK_COMP		40/0	Latch transparent
;; GAIN_CR2.CC_COMP		20/1	Mode OP-AMP (not comparator)
;; GAIN_CR2.BYPASS_OBUS		1C/0	Bypass OFF
;; GAIN_CR2.PWR_SELECT		03/*	Power OFF (0h) at start-up
;;
;; --------------------------------------------------------------------

include "SingleEnded.inc"
include "m8c.inc"
POWERMASK: equ 03h
GAINMASK: equ f8h
;;---------------------------------------------------------------------
;; StartSetPower:  Applies power setting to the module's PSoC block
;; SetPower: Applies power setting to the module's PSoC block
;; INPUTS: A contains the power setting 0=Off, 1=Low, 2=Med, 3=High
;;         Value is loaded from .inc file
;; OUTPUTS: None
;;---------------------------------------------------------------------
 SingleEnded_Start:
_SingleEnded_Start:
 SingleEnded_SetPower:
_SingleEnded_SetPower:

    and A, POWERMASK                         ; mask A to protect unchanged bits
    mov X, SP                                ; define temp store location
;
    push A                                   ; put power value in temp store
    mov A, reg[SingleEnded_GAIN_CR2]    ; read power value
    and A, ~POWERMASK                        ; clear power bits in A
    or  A, [X]                               ; combine power value with balance of reg.
    mov reg[SingleEnded_GAIN_CR2], A    ; move complete value back to register
    pop A
    ret

;;---------------------------------------------------------------------------------
;;	SetGain:
;;	INPUTS: Gain value and GAIN/ATTEN setting
;;		  Use gain set values from .inc file
;;	OUTPUTS: None
;;	Side Effects: Momentary gain glitch while gain set to 1.0, then to new value
;;
;;	Gain values shown are for example
;;	16.0	1	0 0 0 0			
;;	8.00	1	0 0 0 1
;;	....
;;	1.00	1	1 1 1 1
;;	0.93	0	1 1 1 0
;;	....
;;	0.12	0	0 0 0 1
;;	0.06	0	0 0 0 0
;;--------------------------------------------------------------------------------
 SingleEnded_SetGain:
_SingleEnded_SetGain:

    and A, GAINMASK                          ; mask A to protect unchanged bits
    mov X, SP                                ; define temp store location
;
    push A                                   ; put gain value in temp store
    mov A, reg[SingleEnded_GAIN_CR0]    ; read power value
    and A, ~GAINMASK                         ; clear gain bits in A
    or  A, [X]                               ; combine gain value with balance of reg.
    mov reg[SingleEnded_GAIN_CR0], A    ; move complete value back to register
    pop A
    ret

;;---------------------------------------------------------------------
;; Stop:  Cuts power to the user module
;;
;; INPUTS: None
;; OUPTUTS: None
;;---------------------------------------------------------------------
 SingleEnded_Stop:
_SingleEnded_Stop:

    and REG[SingleEnded_GAIN_CR2], ~POWERMASK
    ret

;;
