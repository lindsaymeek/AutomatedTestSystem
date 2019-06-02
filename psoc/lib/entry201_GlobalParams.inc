;
;	This file contains equates to support oscillator register initialization
;

CPU_CLOCK:			equ	3h		;CPU clock value
CPU_CLOCK_MASK:		equ	7h		;CPU clock mask
CPU_CLOCK_JUST:		equ	3h		;CPU clock value justified
SELECT_32K:			equ	0h		;32K select value
SELECT_32K_MASK:	equ	80h		;32K select mask
SELECT_32K_JUST:	equ	0h		;32K select value justified
PLL_MODE:			equ	0h		;PLL mode value
PLL_MODE_MASK:		equ	40h		;PLL mode mask
PLL_MODE_JUST:		equ	0h		;PLL mode value justified
SLEEP_TIMER:		equ	0h		;Sleep Timer value
SLEEP_TIMER_MASK:	equ	18h		;Sleep Timer mask
SLEEP_TIMER_JUST:	equ	0h		;Sleep Timer value justified
VOLTAGE_RANGE:		equ 1h		;Voltage Range
SUPPLY_VOLTAGE:		equ 1h		;Supply Voltage 1 = 5.0V
								;				0 = 3.3V
;
; write only registers
;
ANALOG_IO_CONTROL:	equ 0h	;Analog IO Control register
PORT_0_BYPASS:		equ 0h	;Port 0 bypass register
PORT_0_DRIVE_0:		equ 0h	;Port 0 drive mode 0 register
PORT_0_DRIVE_1:		equ ffh	;Port 0 drive mode 1 register
PORT_0_INTENABLE:	equ 0h	;Port 0 interrupt enable register
PORT_0_INTCTRL_0:	equ 0h	;Port 0 interrupt control 0 register
PORT_0_INTCTRL_1:	equ 0h	;Port 0 interrupt control 1 register
PORT_1_BYPASS:		equ f0h	;Port 0 bypass register
PORT_1_DRIVE_0:		equ a0h	;Port 0 drive mode 0 register
PORT_1_DRIVE_1:		equ 5fh	;Port 0 drive mode 1 register
PORT_1_INTENABLE:	equ 0h	;Port 0 interrupt enable register
PORT_1_INTCTRL_0:	equ 0h	;Port 0 interrupt control 0 register
PORT_1_INTCTRL_1:	equ 0h	;Port 0 interrupt control 1 register
PORT_2_BYPASS:		equ 0h	;Port 0 bypass register
PORT_2_DRIVE_0:		equ 0h	;Port 0 drive mode 0 register
PORT_2_DRIVE_1:		equ 0h	;Port 0 drive mode 1 register
PORT_2_INTENABLE:	equ 0h	;Port 0 interrupt enable register
PORT_2_INTCTRL_0:	equ 0h	;Port 0 interrupt control 0 register
PORT_2_INTCTRL_1:	equ 0h	;Port 0 interrupt control 1 register
PORT_3_BYPASS:		equ 0h	;Port 0 bypass register
PORT_3_DRIVE_0:		equ 0h	;Port 0 drive mode 0 register
PORT_3_DRIVE_1:		equ 0h	;Port 0 drive mode 1 register
PORT_3_INTENABLE:	equ 0h	;Port 0 interrupt enable register
PORT_3_INTCTRL_0:	equ 0h	;Port 0 interrupt control 0 register
PORT_3_INTCTRL_1:	equ 0h	;Port 0 interrupt control 1 register
PORT_4_BYPASS:		equ 0h	;Port 0 bypass register
PORT_4_DRIVE_0:		equ 0h	;Port 0 drive mode 0 register
PORT_4_DRIVE_1:		equ 0h	;Port 0 drive mode 1 register
PORT_4_INTENABLE:	equ 0h	;Port 0 interrupt enable register
PORT_4_INTCTRL_0:	equ 0h	;Port 0 interrupt control 0 register
PORT_4_INTCTRL_1:	equ 0h	;Port 0 interrupt control 1 register
PORT_5_BYPASS:		equ 0h	;Port 0 bypass register
PORT_5_DRIVE_0:		equ 0h	;Port 0 drive mode 0 register
PORT_5_DRIVE_1:		equ 0h	;Port 0 drive mode 1 register
PORT_5_INTENABLE:	equ 0h	;Port 0 interrupt enable register
PORT_5_INTCTRL_0:	equ 0h	;Port 0 interrupt control 0 register
PORT_5_INTCTRL_1:	equ 0h	;Port 0 interrupt control 1 register
