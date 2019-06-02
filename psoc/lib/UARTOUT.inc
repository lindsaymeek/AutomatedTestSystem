;------------------------------------------------------------------------------
;  FILENAME:   UARTOUT.inc
;   VERSION:   Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Assembler include file of UARTOUT instance of UART 
;     user module.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------
;mask value for global int reg bit for TX instance
bUARTOUT_TX_INT_MASK:        equ 10h  
;TX interrupt address
UARTOUT_TX_INT_REG:          equ 0e1h  
;mask value for global int reg bit for RX instance
bUARTOUT_RX_INT_MASK:        equ 20h  
;RX interrupt address
UARTOUT_RX_INT_REG:          equ 0e1h  
     
;------------------------------------
;  Parity masks
;------------------------------------
UART_PARITY_NONE:       equ   00h
UART_PARITY_EVEN:       equ   02h
UART_PARITY_ODD:        equ   06h
                              
;------------------------------------
;  TX Status Register masks
;------------------------------------
UART_TX_COMPLETE:       equ   20h
UART_TX_BUFFER_EMPTY:   equ   10h

;------------------------------------
;  RX Status Register masks
;------------------------------------
UART_RX_ACTIVE:         equ   10h
UART_RX_COMPLETE:       equ   08h
UART_RX_PARITY_ERROR:   equ   80h
UART_RX_OVERRUN_ERROR:  equ   40h
UART_RX_FRAMING_ERROR:  equ   20h
UART_RX_NO_ERROR:       equ   E0h


;---------------------------------
;  Registers used by TX
;---------------------------------
UARTOUT_TX_CONTROL_REG: equ 33h                  ;Control register
UARTOUT_TX_SHIFT_REG:   equ 30h                  ;TX Shift Register register
UARTOUT_TX_BUFFER_REG:  equ 31h                  ;TX Buffer Register
UARTOUT_TX_FUNC_REG:    equ 30h                  ;Function register
UARTOUT_TX_INPUT_REG:   equ 31h                  ;Input register
UARTOUT_TX_OUTPUT_REG:  equ 32h                  ;Output register

;---------------------------------
;  Registers used by RX
;---------------------------------
UARTOUT_RX_CONTROL_REG: equ 37h                  ;Control register
UARTOUT_RX_SHIFT_REG:   equ 34h                  ;RX Shift Register register
UARTOUT_RX_BUFFER_REG:  equ 36h                  ;RX Buffer Register
UARTOUT_RX_FUNC_REG:    equ 34h                  ;Function register
UARTOUT_RX_INPUT_REG:   equ 35h                  ;Input register
UARTOUT_RX_OUTPUT_REG:  equ 36h                  ;Output register

; end of file
