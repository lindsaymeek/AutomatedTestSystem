;$Id: //depot/Rel_3.1/BuildMediaPSoC/Executables/Templates/boot.tpl#3 $
;=============================================================================
;  FILENAME:   boot.asm
;   VERSION:   3.06
;      DATE:   2 April 2002
;
;  DESCRIPTION:
;   M8C Boot Code from Reset.
;
;   Copyright (c) Cypress MicroSystems 2001, 2002. All rights reserved.
;
; NOTES:
; PSoC Designer's Device Editor uses a template file, BOOT.TPL, located in
; the project's root directory to create BOOT.ASM. Any changes made to 
; BOOT.ASM will be  overwritten every time the project is generated; therfore
; changes should be made to BOOT.TPL not BOOT.ASM. Care must be taken when
; modifying BOOT.TPL so that replacement strings (such as @PROJECT_NAME)
; are not accidentally modified.
;
; The start of _main is at a fixed location so care must be taken when adding
; user code for the Sleep Interrupt. If too much code is added, the end of 
; BOOT.ASM will extend into _main and cause a linker error. The safest way
; to add code for the Sleep Interrupt is to CALL a separate routine that 
; contains the desired additional Sleep Interrupt code.
;=============================================================================

include ".\lib\`@PROJECT_NAME`_GlobalParams.inc"
include "m8c.inc"
include "m8ssc.inc"

;-----------------------------------------------------------------------------
; Optimization flags
;-----------------------------------------------------------------------------

C_LANGUAGE_SUPPORT: equ 0         ;Set to 0 to optimize for ASM only

;-----------------------------------------------------------------------------
; Export Declarations
;-----------------------------------------------------------------------------

export __start
export _exit
export __bss_start

export __lit_start
export __idata_start
export __data_start
export __func_lit_start
export __text_start


;-----------------------------------------------------------------------------
; Interrupt Vector Table
;-----------------------------------------------------------------------------
;
; Interrupt vector table entries are 4 bytes long and contain the code
; that services the interrupt (or causes it to be serviced).
;
;-----------------------------------------------------------------------------


    AREA    TOP(ROM, ABS)

    org 0                         ;Reset Interrupt Vector
    jmp __start                   ;First instruction executed following a Reset

    org 04h                       ;Supply Monitor Interrupt Vector
    halt                          ;Stop execution if power falls too low
    reti

    org 08h                       ;PSoC Block DBA00 Interrupt Vector
    `@INTERRUPT_2`
    reti

    org 0Ch                       ;PSoC Block DBA01 Interrupt Vector
    `@INTERRUPT_3`
    reti

    org 10h                       ;PSoC Block DBA02 Interrupt Vector
    `@INTERRUPT_4`
    reti

    org 14h                       ;PSoC Block DBA03 Interrupt Vector
    `@INTERRUPT_5`
    reti

    org 18h                       ;PSoC Block DCA04 Interrupt Vector
    `@INTERRUPT_6`
    reti

    org 1Ch                       ;PSoC Block DCA05 Interrupt Vector
    `@INTERRUPT_7`
    reti

    org 20h                       ;PSoC Block DCA06 Interrupt Vector
    `@INTERRUPT_8`
    reti

    org 24h                       ;PSoC Block DCA07 Interrupt Vector
    `@INTERRUPT_9`
    reti

    org 28h                       ;Analog Column 0 Interrupt Vector
    `@INTERRUPT_10`
    reti

    org 2Ch                       ;Analog Column 1 Interrupt Vector
    `@INTERRUPT_11`
    reti

    org 30h                       ;Analog Column 2 Interrupt Vector
    `@INTERRUPT_12`
    reti

    org 34h                       ;Analog Column 3 Interrupt Vector
    `@INTERRUPT_13`
    reti

    org 38h                       ;GPIO Interrupt Vector
    `@INTERRUPT_14`
    reti

    org 3Ch                       ;Sleep Timer Interrupt Vector
    jmp SleepTimerISR
    reti

;-----------------------------------------------------------------------------
;  Sleep Timer ISR
;-----------------------------------------------------------------------------
;  This code uses conditional compiler flags to enable code to initialize the 
;  External Crystal Oscillator (ECO) and the PLL_Lock mode of the Internal 
;  Main Oscillator (IMO).  If the ECO and the IMO PLL_Lock mode are not used,
;  the initialization code is not compiled.
;-----------------------------------------------------------------------------
IF SELECT_32K
    export  _ClockNotStable
    FIRST_TIME:       equ  2h
    SECOND_TIME:      equ  1h
    CLOCK_STABLE:     equ  0h
ENDIF

SleepTimerISR:
    push A

    NO_USER_SLEEP_ISR:  equ  1    ;Change this equate to 0 if adding ISR
	// Insert user Sleep Timer Interrupt code here. //
	// See NOTES at the top of this file.           //

    IF SELECT_32K
        mov A,[ClockNotStable]    ;ClockNotStable is also state of clock init
        jz   NormalSleep
        IF PLL_MODE        
            dec A
            jz  SecondTime        ;This case is only needed if PLL_Lock
        ENDIF
            jmp  FirstTime        ;This case is only needed if the ECO is used
    ENDIF

NormalSleep:
    pop A                         ;normal sleep 
    reti

   IF SELECT_32K
   FirstTime:
   ; 1st time through the SleepISR. Will arrive here 1 second after boot
   ; the External Crystal Oscillator (ECO) is now stable.
   ; If both ECO and PLL_Lock, then turn on PLL_Lock and wait for it to 
   ; stabilize. Set SleepClock to 64 Hz, set PLL Mode bit, set CPU_Clock to
   ; 3 MHz, set ClockNotStable to SECOND_TIME. The clock initialization is
   ; not yet complete.
   ; If ECO but not PLL_Lock, set SleepClock to user selection, set 
   ; ClockNotStable to CLOCK_STABLE. The clock initialization is complete.

      IF PLL_MODE
         M8C_SetBank1
         IF (CPU_CLOCK_JUST & 04h)   ;CPU setting in Device Editor is <3MHz
            ;Enable PLL, set sleep timer to 64Hz and CPU per Device Editor
            mov reg[OSC_CR0],(SELECT_32K_JUST | PLL_MODE_JUST | OSC_CR0_Sleep_64Hz |CPU_CLOCK_JUST)
         ELSE             ;CPU setting in Device Editor is >=3MHz
            ;Enable PLL, set sleep timer to 64Hz and CPU clock to 3MHz
            mov reg[OSC_CR0],(SELECT_32K_JUST | PLL_MODE_JUST | OSC_CR0_Sleep_64Hz | OSC_CR0_CPU_3MHz)
         ENDIF
         M8C_SetBank0
         mov [ClockNotStable],SECOND_TIME
      ELSE
         ;Set the sleep timer, PLL (disabled) & CPU per Device Editor
         M8C_SetBank1
         mov reg[OSC_CR0],(SELECT_32K_JUST | PLL_MODE_JUST | SLEEP_TIMER_JUST | CPU_CLOCK_JUST)
         M8C_SetBank0
         mov [ClockNotStable],CLOCK_STABLE
         IF NO_USER_SLEEP_ISR     ;turn off Sleep Int if no longer needed
            M8C_DisableIntMask INT_MSK0,INT_MSK0_Sleep
         ENDIF
      ENDIF
      pop A
      reti
   ENDIF
   
   IF PLL_MODE
SecondTime:    
      ; 2nd time through SleepISR. Compiled only if PLL_Mode set to Ext Lock
      M8C_SetBank1
      ; Set the sleep timer and CPU per Device Editor
      mov reg[OSC_CR0],(SELECT_32K_JUST | PLL_MODE_JUST | SLEEP_TIMER_JUST | CPU_CLOCK_JUST)
      M8C_SetBank0
      mov [_ClockNotStable],CLOCK_STABLE
      IF NO_USER_SLEEP_ISR
         M8C_DisableIntMask INT_MSK0,INT_MSK0_Sleep
      ENDIF
      pop A
      reti
   ENDIF

   IF (PLL_MODE & ~SELECT_32K)
      These lines intentionally generate syntax errors to alert you that you
      have selected an invalid state.  Setting PLL Mode to Ext Lock without
      32K_Select set to External is not allowed.
   ENDIF

;-----------------------------------------------------------------------------
;  Start of Execution
;-----------------------------------------------------------------------------
__start:
    mov A,__bss_end               ;Set top of stack to end of used RAM
    swap SP,A
    ;-------------------------------------------------------------------------
    ; Set clock trim if the operating voltage is 3.3V. On power up, 5V is
    ; loaded, so this is only needed for 3.3V operation.
    ;-------------------------------------------------------------------------
    IF (SUPPLY_VOLTAGE)               ; 1 means 5.0V
    ELSE                              ; 0 means 3.3V
       mov  [bSSC_TABLE_TableId], 1   ; Point to the Trim table
       SSC_Action TABLE_READ          ; Perform a table read supervisor call
       M8C_SetBank1
       mov  A, [OSCILLATOR_TRIM_3V]   
       mov  reg[IMO_TR], A            ; Load the 3V trim oscillator setting
       mov  A, [VOLTAGE_TRIM_3V]
       mov  reg[BDG_TR], A            ; Load the bandgap trim setting for 3V
       IF (CPU_CLOCK_JUST ^ OSC_CR0_CPU_24MHz)
       ELSE
          These lines intentionally generate syntax errors to alert you
          that you have selected an invalid state.  The CPU_CLock cannot
          be run at 24 MHz when the chip operating voltage is below 4.75V
       ENDIF
    ENDIF


    ;-------------------------------------------------------------------------
    ; Initialize oscillator register
    ;-------------------------------------------------------------------------
    IF SELECT_32K
       ;If 32K is set to External, turn the pins used by the crystal to Hi-Z.
       ;Then, set the sleep timer to 1Hz & reset the sleep timer.  (Don't turn
       ;on the ECO yet, because if the Sleep Timer happens to time out it will
       ;enable the ECO too soon).  Then enable ECO, enable sleep interrupt,
       ;and initialize ClockNotStable, which can be used as a flag in _main to
       ;indicate that the clocks are stable.  It is also used as a state
       ;variable for the clock initialization.
    
       M8C_SetBank1
       mov reg[PRT1DM0],00h       ;P1[0] & P1[1] Drive Mode to High Z because
       mov reg[PRT1DM1],03h       ; LoadConfigInit not run yet.
       mov reg[ECO_TR],0Fh        ;adjust ECO trim
       IF (CPU_CLOCK_JUST ^ OSC_CR0_CPU_24MHz)
          ; set sleep to 1 sec and CPU to 12MHz during configuration
          mov reg[OSC_CR0], (OSC_CR0_CPU_12MHz | OSC_CR0_Sleep_1Hz)
       ELSE
          ; set sleep to 1 sec and CPU to 24MHz
          mov reg[OSC_CR0], (OSC_CR0_CPU_24MHz | OSC_CR0_Sleep_1Hz)
       ENDIF
       M8C_SetBank0

       M8C_ClearWDTAndSleep       ;reset the sleep timer
       M8C_SetBank1
       or  reg[OSC_CR0],SELECT_32K_JUST  ;enable the ECO

       M8C_SetBank0
       M8C_EnableIntMask INT_MSK0, INT_MSK0_Sleep
       mov [ClockNotStable],FIRST_TIME  ;initialize ClockNotStable
    ELSE    ; If 32K is set to Internal, then no further initialization needed
       M8C_SetBank1
       IF (CPU_CLOCK_JUST ^ OSC_CR0_CPU_24MHz)
          ; set sleep to 1 sec and CPU to 12MHz during configuration
          mov reg[OSC_CR0], (SELECT_32K_JUST | PLL_MODE_JUST | SLEEP_TIMER_JUST | OSC_CR0_CPU_12MHz)
       ELSE
          ; set sleep to 1 sec and CPU to 24MHz
          mov reg[OSC_CR0], (SELECT_32K_JUST | PLL_MODE_JUST | SLEEP_TIMER_JUST | CPU_CLOCK_JUST )
       ENDIF
       M8C_SetBank0
    ENDIF

    ; default CT block RTopMux to OUT and RBotMux to AGND
    mov reg[ACA00CR0],05h
    mov reg[ACA01CR0],05h
    mov reg[ACA02CR0],05h
    mov reg[ACA03CR0],05h
    lcall LoadConfigInit          ;Configure PSoC blocks per Dev Editor

    IF C_LANGUAGE_SUPPORT
       call InitCRunTime          ;Initialize for C language
    ENDIF
    IF (CPU_CLOCK_JUST ^ OSC_CR0_CPU_24MHz)
       ; Set the CPU clock to the user's selection
       M8C_SetBank1
       mov reg[OSC_CR0], (SELECT_32K_JUST | PLL_MODE_JUST | SLEEP_TIMER_JUST | CPU_CLOCK_JUST)
       M8C_SetBank0
    ENDIF    

    mov reg[INT_VC],0             ;Clear any pending interrupts which may
                                  ; have been set during the boot process. 
    IF SELECT_32K
       M8C_EnableGInt             ;Enable global interrupts
    ENDIF

    lcall _main                   ;Call main
_exit:
    jmp _exit

IF C_LANGUAGE_SUPPORT
;-----------------------------------------------------------------------------
;;    C Runtime Environment Initialization
;-----------------------------------------------------------------------------

InitCRunTime:
    ;-----------------------------
    ; clear bss segment
    ;-----------------------------
    mov A,0
    mov [__r0],<__bss_start
BssLoop:
    cmp [__r0],<__bss_end
    jz BssDone
    mvi [__r0],A
    jmp BssLoop
BssDone:
    ;----------------------------
    ; copy idata to data segment
    ;----------------------------
    mov A,>__idata_start
    mov X,<__idata_start
    mov [__r0],<__data_start
IDataLoop:
    cmp [__r0],<__data_end
    jz IDataDone
    push A
    romx
    mvi [__r0],A
    pop A
    inc X
    adc A,0
    jmp IDataLoop
IDataDone:
    ret

ENDIF
;------------------------------------------------------
;;  RAM segments for C CONST, static & global items
;------------------------------------------------------

    AREA lit
__lit_start:

    AREA idata
__idata_start:

	AREA func_lit
__func_lit_start:

;---------------------------------------------
;         CODE segment for general use
;---------------------------------------------
	AREA text(rom)
__text_start:

;---------------------------------------------
;         Begin RAM area usage
;---------------------------------------------
    AREA data(ram)
__data_start:

    AREA virtual_registers(ram)
__virtual_registers_end:

IF SELECT_32K              ;Used to track initialization of ECO and PLL
   AREA eco_pll(ram)
   ClockNotStable:
   _ClockNotStable:      BLK   1
ENDIF


;---------------------------------------------
;         RAM segment for general use
;---------------------------------------------
    AREA bss(ram)
__bss_start:

; end of file
