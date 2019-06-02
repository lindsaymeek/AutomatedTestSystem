;------------------------------------------------------------------------------
;  FILENAME:   UARTIN.inc
;   VERSION:   Rev B, 2002 Mar 30
;------------------------------------------------------------------------------
;  DESCRIPTION:
;     Assembler include file of UARTIN instance of UART 
;     user module.
;------------------------------------------------------------------------------
;	Copyright (c) Cypress MicroSystems 2000-2002. All Rights Reserved.
;------------------------------------------------------------------------------
;mask value for global int reg bit for TX instance
bUARTIN_TX_INT_MASK:        equ 80h  
;TX interrupt address
UARTIN_TX_INT_REG:          equ 0e1h  
;mask value for global int reg bit for RX instance
bUARTIN_RX_INT_MASK:        equ 40h  
;RX interrupt address
UARTIN_RX_INT_REG:          equ 0e1h  
     
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
UARTIN_TX_CONTROL_REG:  equ 3fh                  ;Control register
UARTIN_TX_SHIFT_REG:    equ 3ch                  ;TX Shift Register register
UARTIN_TX_BUFFER_REG:   equ 3dh                  ;TX Buffer Register
UARTIN_TX_FUNC_REG: equ 3ch                      ;Function register
UARTIN_TX_INPUT_REG:    equ 3dh                  ;Input register
UARTIN_TX_OUTPUT_REG:   equ 3eh                  ;Output register

;---------------------------------
;  Registers used by RX
;---------------------------------
UARTIN_RX_CONTROL_REG:  equ 3bh                  ;Control register
UARTIN_RX_SHIFT_REG:    equ 38h                  ;RX Shift Register register
UARTIN_RX_BUFFER_REG:   equ 3ah                  ;RX Buffer Register
UARTIN_RX_FUNC_REG: equ 38h                      ;Function register
UARTIN_RX_INPUT_REG:    equ 39h                  ;Input register
UARTIN_RX_OUTPUT_REG:   equ 3ah                  ;Output register

; end of file
