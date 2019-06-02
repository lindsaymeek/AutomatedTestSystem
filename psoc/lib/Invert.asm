;;************************************************************************
;;************************************************************************
;;
;;  AMPINV_A.ASM
;;
;;  Assembler source for the Continuous Time Inverting Amplifier
;;
;;  REV C, 2002 Mar 30
;;
;;  Copyright: Cypress MicroSystems 2001. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************
;;

export  Invert_Start
export _Invert_Start
export  Invert_SetPower
export _Invert_SetPower
export  Invert_SetGain
export _Invert_SetGain
export  Invert_Stop
export _Invert_Stop

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
    ;; BIT FIELD             Mask/Val   Function
    ;; -----------------        -----   --------------------
    ;;
    ;; INVAMP_CR0.RMux           F0/*   User Parameter (by table)
    ;; INVAMP_CR0.GAIN           08/1   Gain
    ;; INVAMP_CR0.RTMux          04/1   Res source to output
    ;; INVAMP_CR0.RBMux          03/*   User Parameter
    ;;
    ;; INVAMP_CR1.AnalogBus      80/*   User Parameter (init: DISABLE)
    ;; INVAMP_CR1.CmpBus         40/0   Comparator bus disabled
    ;; INVAMP_CR1.NMux           38/4    Neg mux to analog f.b. tap
    ;; INVAMP_CR1.PMux           07/3    Pos mux to AGND
    ;;
    ;; INVAMP_CR2.CPhase         80/0    Latch transparent on PH1
    ;; INVAMP_CR2.CLatch         40/0    Latch transparent
    ;; INVAMP_CR2.Comp           20/1    Mode OP-AMP (not comparator)
    ;; INVAMP_CR2.OMux           1C/0    Bypass OFF
    ;; INVAMP_CR2.Power          03/0    Power OFF at start-up


include "Invert.inc"
include "m8c.inc"
POWERMASK: equ 03h
GAINMASK: equ f0h

;;---------------------------------------------------------------------------
;; Start / SetPower - Applies power setting to the module's SoCblocs
;;
;; INPUTS: A contains the power setting 0=Off, 1=Low, 2=Med, 3=High
;; OUTUTS: None
;;---------------------------------------------------------------------------
 Invert_Start:
_Invert_Start:
 Invert_SetPower:
_Invert_SetPower:

        and  A, POWERMASK       ; isolate bits of interest
        mov  X, SP              ; establish pointer to temp memory
        push A                  ; stash new setting
        mov  A, REG[Invert_INVAMP_CR2]
        and  A, ~POWERMASK      ; clear previous power setting
        or   A, [X]             ; set power to new value
        mov  REG[Invert_INVAMP_CR2], A
        pop  A                  ; clean up stack
        ret

;;---------------------------------------------------------------------------------
;;	SetGain:
;;	INPUTS: Gain value 
;;		  Use gain set values from .inc file
;;	OUTPUTS: None
;;	Side Effects: Momentary gain glitch while gain set to 1.0, then to new value
;;
;;	Gain values shown are for example
;;	-16.0	1	0 0 0 0			
;;	-7.00	1	0 0 0 1
;;	....
;;	-1.00	1	0 1 1 1
;;	-0.77	0	1 0 0 0
;;	....
;;	0.12	0	1 1 0 1
;;	0.06	0	1 1 1 0
;;--------------------------------------------------------------------------------
 Invert_SetGain:
_Invert_SetGain:

    and A, GAINMASK                          ; mask A to protect unchanged bits
    mov X, SP                                ; define temp store location
    push A                                   ; put gain value in temp store
    mov A, reg[Invert_INVAMP_CR0]  ; read current gain value
    and A, ~GAINMASK                         ; clear gain bits in A
    or  A, [X]                               ; combine gain value with balance of reg.
    mov reg[Invert_INVAMP_CR0], A  ; move complete value back to register
    pop A
    ret

;;---------------------------------------------------------------------------
;; Stop - Cuts power to the user module.
;;
;; INPUTS:  None
;; OUTPUTS: None
;;---------------------------------------------------------------------------
 Invert_Stop:
_Invert_Stop:

        and REG[Invert_INVAMP_CR2], FCh
        ret
