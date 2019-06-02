;;************************************************************************
;;************************************************************************
;;
;;  DAC_P03.ASM (from DAC6.asm user module template)
;;  Rev C, 2002 Mar 30
;;
;;  Assembler source for 6-bit Switched Capacitor DAC API
;;
;;  Copyright (c) Cypress MicroSystems 2001-2002. All Rights Reserved.
;;
;;************************************************************************
;;************************************************************************
;;

export  DAC_P03_Start
export _DAC_P03_Start
export  DAC_P03_SetPower
export _DAC_P03_SetPower

export  DAC_P03_WriteBlind
export _DAC_P03_WriteBlind
export  DAC_P03_WriteStall
export _DAC_P03_WriteStall

export  DAC_P03_Stop
export _DAC_P03_Stop

;; -----------------------------------------------------------------
;;                         Register Definitions
;; -----------------------------------------------------------------
;;
;; Uses 1 Switched Cap Block configured as shown. This API depends
;; on knowing the exact personalization of CR0 and CR3 bitfields
;; for time efficiency.
;;
;; * For a Mask/Val pair, this simply indicates that the value is
;;   determined by the user either through config-time parameteriza-
;;   tion or run-time manipulation.
;;
;; BIT FIELD         Mask/Val Function
;; -----------------    ----- --------------------
;; CR0.FCap             80/1  Feedback cap size 32
;; CR0.ClockPhase       40/0  Normal phase
;; CR0.ASign            20/*  User parameter
;; CR0.ACap             1F/*  User parameter
;;
;; CR1.ACMux            E0/2  (SCA) A:VRef High, C:Don't Care
;; CR1.AMux             E0/4  (SCB) VRef High
;; CR1.BCap             1F/0  Prune B-input branch
;;
;; CR2.AnalogBus        80/*  User Parameter: Output Bus Enable
;; CR2.CmpBus           40/0  Comparator Bus Disable
;; CR2.AutoZero         20/1  Auto-Zero enabled on Phi 1
;; CR2.CCap             1F/0  Prune C-input branch
;;
;; CR3.ARefSelect       C0/0  Use AGND (to invert)
;; CR3.FSW1             20/1  Feedback Cap Used
;; CR3.FSW2             10/1  Feedback Cap Grounded for AZ
;; CR3.BMux             0C/0  (SCA) Don't Care - this branch pruned
;; CR3.BSW              08/0  (SCB) Don't Care - this branch pruned
;; CR3.BMux             04/0  (SCB) Don't Care - this branch pruned
;; CR3.PWR              03/*  User Parameter: Power, def=OFF
;;

include "DAC_P03.inc"
include "m8c.inc"

cOFFSET:   equ 31               ; Conversion term for offset binary to 2's C
bPWRMASK:  equ 03h              ; Power bitfield in Switched Cap CR3 reg
bCR3:      equ 30h              ; Except for power bits, CR3 ALWAYS looks
                                ;    like this regardless of SC block type
                                ;    or where the DAC gets mapped.

area text (ROM, REL)

;;---------------------------------------------------------------------------
;; Start / SetPower - Applies power setting to the module's SoCblocs
;;
;; INPUTS: A contains the power setting 0=Off, 1=Low, 2=Med, 3=High
;; OUTUTS: None
;;---------------------------------------------------------------------------
 DAC_P03_Start:
_DAC_P03_Start:
 DAC_P03_SetPower:
_DAC_P03_SetPower:
        and A, bPWRMASK
        or  A, bCR3             ; Set all other bits in addition to power
        mov reg[DAC_P03_CR3], A
        ret

;;---------------------------------------------------------------------------
;; WriteBlind
;; ----------
;;
;; Modify the DAC's update value without worrying about the clocks
;;   Lowest overhead, but output may not settle to correct value until the
;;   phi2 of next full cycle following the write.
;;
;; INPUTS: The accumulator, A, contains the input in the appropriate format.
;;   The data format is determined by the setting of the DataFormat parameter
;;   in the Device Editor.
;;
;; OUTPUTS: Analog output voltage reflects new value
;;---------------------------------------------------------------------------
 DAC_P03_WriteBlind:
_DAC_P03_WriteBlind:

  IF DAC_P03_OFFSETBINARY
    ;; Data is an unsigned byte value in [0..62] (i.e., 63 unique values).
    ;; Following converts it to 2's complement:
    sub  A, cOFFSET         ; Apply the offset
  ENDIF
  IF DAC_P03_OFFSETBINARY | DAC_P03_TWOSCOMPLEMENT
    ;; Data is a byte in standard 2's complement form with value in [-31..+31]
    ;; Following converts it to Sign & Magnitude form "00smmmmm"
    ;;   where sign, "s", is 1 for negative numbers; 0 for positive
    ;;   and "m" is the magnitude.
    asl  A                  ; Multiply by 2 and put sign in Carry flag
    jnc  BlindPositive
    ;; Neg to pos by "Invert & Add 1" procedure, but data is shifted!
    cpl  A                  ; bit 0 is a "1" so, following 1 byte "inc" works
    inc  A                  ;   (otherwise, we'd have to "add A, 2")
    or   A, 40h             ; Make it negative by forcing sign bit
    jmp  BlindMagSet
BlindPositive:
    nop
    nop
    nop
    jmp  BlindMagSet
BlindMagSet:
    asr  A                  ; Divide by two to finish up
  ENDIF

    ;; Data is in Sign & Magnitude form.
    ;; Set FCap and ClockPhase bits
    or   A, DAC_P03_CR0_HIBITS
    mov  reg[DAC_P03_CR0], A
    ret

;;---------------------------------------------------------------------------
;; WriteStall
;; ----------
;;
;; Modify the DAC's update value, stalling the CPU if necessary.
;;   This routine should be used with fast analog clocks or when the
;;   resulting interrupt latencies, comparable to the update period,
;;   can be tolerated comfortably.
;;
;; INPUTS: The accumulator, A, contains the input in the appropriate format.
;;   The data format is determined by the setting of the DataFormat parameter
;;   in the Device Editor.
;;
;; OUTPUTS: Analog output voltage reflects new value
;;---------------------------------------------------------------------------
 DAC_P03_WriteStall:
_DAC_P03_WriteStall:

  IF DAC_P03_OFFSETBINARY
    ;; Data is an unsigned byte value in [0..62] (i.e., 63 unique values).
    ;; Following converts it to 2's complement:
    sub  A, cOFFSET         ; Apply the offset
  ENDIF
  IF DAC_P03_OFFSETBINARY | DAC_P03_TWOSCOMPLEMENT
    ;; Data is a byte in standard 2's complement form with value in [-31..+31]
    ;; Following converts it to Sign & Magnitude form "00smmmmm"
    ;;   where sign, "s", is 1 for negative numbers; 0 for positive
    ;;   and "m" is the magnitude.
    asl  A                  ; Multiply by 2 and put sign in Carry flag
    jnc  StallPositive
    cpl  A                  ; "Invert" step of complement 2's complement
    inc  A                  ; "Add 1"  step of complement 2's complement
    or   A, 40h             ; Make it negative
    jmp  StallMagSet
StallPositive:
    nop
    nop
    nop
    jmp  StallMagSet
StallMagSet:
    asr  A                  ; Divide by two to finish conversion
  ENDIF

    ;; Data is in Sign & Magnitude form.
    ;; Set FCap and ClockPhase bits
    or   A, DAC_P03_CR0_HIBITS
    M8C_Stall
    mov  reg[DAC_P03_CR0], A
    M8C_Unstall
    ret

;;---------------------------------------------------------------------------
;; Stop - Cuts power to the user module.
;;
;; INPUTS:  None
;; OUTPUTS: None
;;---------------------------------------------------------------------------
 DAC_P03_Stop:
_DAC_P03_Stop:
    and reg[DAC_P03_CR3], ~bPWRMASK
    ret
