;  Personalization tables 
export LoadConfigTBL_entry201_Bank1
export LoadConfigTBL_entry201_Bank0
LoadConfigTBL_entry201_Bank1:
;  Global Register values
	db		61h, 13h		; AnalogClockSelect register
	db		60h, efh		; AnalogColumnClockSelect register
	db		62h, 00h		; AnalogIOControl register
	db		63h, 00h		; AnalogModulatorControl register
	db		e1h, 00h		; OscillatorControl_1 register
	db		00h, 00h		; Port_0_DriveMode_0 register
	db		01h, ffh		; Port_0_DriveMode_1 register
	db		02h, 00h		; Port_0_IntCtrl_0 register
	db		03h, 00h		; Port_0_IntCtrl_1 register
	db		04h, a0h		; Port_1_DriveMode_0 register
	db		05h, 5fh		; Port_1_DriveMode_1 register
	db		06h, 00h		; Port_1_IntCtrl_0 register
	db		07h, 00h		; Port_1_IntCtrl_1 register
	db		08h, 00h		; Port_2_DriveMode_0 register
	db		09h, 00h		; Port_2_DriveMode_1 register
	db		0ah, 00h		; Port_2_IntCtrl_0 register
	db		0bh, 00h		; Port_2_IntCtrl_1 register
	db		0ch, 00h		; Port_3_DriveMode_0 register
	db		0dh, 00h		; Port_3_DriveMode_1 register
	db		0eh, 00h		; Port_3_IntCtrl_0 register
	db		0fh, 00h		; Port_3_IntCtrl_1 register
	db		10h, 00h		; Port_4_DriveMode_0 register
	db		11h, 00h		; Port_4_DriveMode_1 register
	db		12h, 00h		; Port_4_IntCtrl_0 register
	db		13h, 00h		; Port_4_IntCtrl_1 register
	db		14h, 00h		; Port_5_DriveMode_0 register
	db		15h, 00h		; Port_5_DriveMode_1 register
	db		16h, 00h		; Port_5_IntCtrl_0 register
	db		17h, 00h		; Port_5_IntCtrl_1 register
	db		e3h, 84h		; VoltageMonitorControl register
;  Instance name ADC, User Module ADCINC12
;       Instance name ADC, Block Name ADC(ASA12)
;       Instance name ADC, Block Name CNT(DBA01)
	db		24h, 21h		;ADC_CounterFN
	db		25h, 62h		;ADC_CounterSL
	db		26h, 00h		;ADC_CounterOS
;       Instance name ADC, Block Name TMR(DBA00)
	db		20h, 20h		;ADC_TimerFN
	db		21h, 12h		;ADC_TimerSL
	db		22h, 00h		;ADC_TimerOS
;  Instance name BAUDCLK, User Module Counter8
;       Instance name BAUDCLK, Block Name CNTR8(DBA02)
	db		28h, 31h		;BAUDCLK_FUNC_REG   
	db		29h, 15h		;BAUDCLK_INPUT_REG  
	db		2ah, 04h		;BAUDCLK_OUTPUT_REG 
;  Instance name DAC_P02, User Module DAC6
;       Instance name DAC_P02, Block Name DAC(ASA23)
;  Instance name DAC_P03, User Module DAC6
;       Instance name DAC_P03, Block Name DAC(ASB20)
;  Instance name DAC_P04, User Module DAC6
;       Instance name DAC_P04, Block Name DAC(ASB22)
;  Instance name DAC_P05, User Module DAC6
;       Instance name DAC_P05, Block Name DAC(ASA21)
;  Instance name DoubleEnded, User Module INSAMP
;       Instance name DoubleEnded, Block Name INV(ACA00)
;       Instance name DoubleEnded, Block Name NON_INV(ACA01)
;  Instance name Invert, User Module AMPINV_A
;       Instance name Invert, Block Name INVAMP(ACA03)
;  Instance name SampleCLK, User Module Counter8
;       Instance name SampleCLK, Block Name CNTR8(DBA03)
	db		2ch, 31h		;SampleCLK_FUNC_REG   
	db		2dh, 15h		;SampleCLK_INPUT_REG  
	db		2eh, 00h		;SampleCLK_OUTPUT_REG 
;  Instance name SingleEnded, User Module PGA_A
;       Instance name SingleEnded, Block Name GAIN(ACA02)
;  Instance name UARTIN, User Module UART
;       Instance name UARTIN, Block Name RX(DCA06)
	db		38h, 05h		;UARTIN_RX_FUNC_REG   
	db		39h, c1h		;UARTIN_RX_INPUT_REG  
	db		3ah, 00h		;UARTIN_RX_OUTPUT_REG 
;       Instance name UARTIN, Block Name TX(DCA07)
	db		3ch, 0dh		;UARTIN_TX_FUNC_REG   
	db		3dh, 01h		;UARTIN_TX_INPUT_REG  
	db		3eh, 05h		;UARTIN_TX_OUTPUT_REG 
;  Instance name UARTOUT, User Module UART
;       Instance name UARTOUT, Block Name RX(DCA05)
	db		34h, 05h		;UARTOUT_RX_FUNC_REG   
	db		35h, e1h		;UARTOUT_RX_INPUT_REG  
	db		36h, 00h		;UARTOUT_RX_OUTPUT_REG 
;       Instance name UARTOUT, Block Name TX(DCA04)
	db		30h, 0dh		;UARTOUT_TX_FUNC_REG   
	db		31h, 01h		;UARTOUT_TX_INPUT_REG  
	db		32h, 07h		;UARTOUT_TX_OUTPUT_REG 
	db		ffh
LoadConfigTBL_entry201_Bank0:
;  Global Register values
	db		60h, 28h		; AnalogColumnInputSelect register
	db		63h, 05h		; AnalogReferenceControl register
	db		65h, 00h		; AnalogSyncControl register
	db		e6h, 00h		; DecimatorControl register
	db		02h, 00h		; Port_0_Bypass register
	db		01h, 00h		; Port_0_IntEn register
	db		06h, f0h		; Port_1_Bypass register
	db		05h, 00h		; Port_1_IntEn register
	db		0ah, 00h		; Port_2_Bypass register
	db		09h, 00h		; Port_2_IntEn register
	db		0eh, 00h		; Port_3_Bypass register
	db		0dh, 00h		; Port_3_IntEn register
	db		12h, 00h		; Port_4_Bypass register
	db		11h, 00h		; Port_4_IntEn register
	db		16h, 00h		; Port_5_Bypass register
	db		15h, 00h		; Port_5_IntEn register
;  Instance name ADC, User Module ADCINC12
;       Instance name ADC, Block Name ADC(ASA12)
	db		88h, 90h		;ADC_AtoDcr0
	db		89h, 00h		;ADC_AtoDcr1
	db		8ah, 60h		;ADC_AtoDcr2
	db		8bh, f0h		;ADC_AtoDcr3
;       Instance name ADC, Block Name CNT(DBA01)
	db		27h, 00h		;ADC_CounterCR0
	db		25h, 00h		;ADC_CounterDR1
	db		26h, 00h		;ADC_CounterDR2
;       Instance name ADC, Block Name TMR(DBA00)
	db		23h, 00h		;ADC_TimerCR0
	db		21h, 00h		;ADC_TimerDR1
	db		22h, 00h		;ADC_TimerDR2
;  Instance name BAUDCLK, User Module Counter8
;       Instance name BAUDCLK, Block Name CNTR8(DBA02)
	db		2bh, 00h		;BAUDCLK_CONTROL_REG
	db		29h, 9ch		;BAUDCLK_PERIOD_REG 
	db		2ah, 4eh		;BAUDCLK_COMPARE_REG
;  Instance name DAC_P02, User Module DAC6
;       Instance name DAC_P02, Block Name DAC(ASA23)
	db		9ch, 80h		;DAC_P02_CR0
	db		9dh, 40h		;DAC_P02_CR1
	db		9eh, a0h		;DAC_P02_CR2
	db		9fh, 30h		;DAC_P02_CR3
;  Instance name DAC_P03, User Module DAC6
;       Instance name DAC_P03, Block Name DAC(ASB20)
	db		90h, 80h		;DAC_P03_CR0
	db		91h, 80h		;DAC_P03_CR1
	db		92h, a0h		;DAC_P03_CR2
	db		93h, 30h		;DAC_P03_CR3
;  Instance name DAC_P04, User Module DAC6
;       Instance name DAC_P04, Block Name DAC(ASB22)
	db		98h, 80h		;DAC_P04_CR0
	db		99h, 80h		;DAC_P04_CR1
	db		9ah, a0h		;DAC_P04_CR2
	db		9bh, 30h		;DAC_P04_CR3
;  Instance name DAC_P05, User Module DAC6
;       Instance name DAC_P05, Block Name DAC(ASA21)
	db		94h, 80h		;DAC_P05_CR0
	db		95h, 40h		;DAC_P05_CR1
	db		96h, a0h		;DAC_P05_CR2
	db		97h, 30h		;DAC_P05_CR3
;  Instance name DoubleEnded, User Module INSAMP
;       Instance name DoubleEnded, Block Name INV(ACA00)
	db		71h, 7dh		;DoubleEnded_INV_CR0
	db		72h, 21h		;DoubleEnded_INV_CR1
	db		73h, 20h		;DoubleEnded_INV_CR2
;       Instance name DoubleEnded, Block Name NON_INV(ACA01)
	db		75h, 7ch		;DoubleEnded_NON_INV_CR0
	db		76h, 21h		;DoubleEnded_NON_INV_CR1
	db		77h, 20h		;DoubleEnded_NON_INV_CR2
;  Instance name Invert, User Module AMPINV_A
;       Instance name Invert, Block Name INVAMP(ACA03)
	db		7dh, 7ch		;Invert_INVAMP_CR0
	db		7eh, 23h		;Invert_INVAMP_CR1
	db		7fh, 20h		;Invert_INVAMP_CR2
;  Instance name SampleCLK, User Module Counter8
;       Instance name SampleCLK, Block Name CNTR8(DBA03)
	db		2fh, 00h		;SampleCLK_CONTROL_REG
	db		2dh, 9ch		;SampleCLK_PERIOD_REG 
	db		2eh, 4eh		;SampleCLK_COMPARE_REG
;  Instance name SingleEnded, User Module PGA_A
;       Instance name SingleEnded, Block Name GAIN(ACA02)
	db		79h, fdh		;SingleEnded_GAIN_CR0
	db		7ah, 21h		;SingleEnded_GAIN_CR1
	db		7bh, 20h		;SingleEnded_GAIN_CR2
;  Instance name UARTIN, User Module UART
;       Instance name UARTIN, Block Name RX(DCA06)
	db		3bh, 00h		;UARTIN_RX_CONTROL_REG
	db		39h, 00h		;UARTIN_
	db		3ah, 00h		;UARTIN_RX_BUFFER_REG 
;       Instance name UARTIN, Block Name TX(DCA07)
	db		3fh, 00h		;UARTIN_TX_CONTROL_REG
	db		3dh, 00h		;UARTIN_TX_BUFFER_REG 
	db		3eh, 00h		;UARTIN_
;  Instance name UARTOUT, User Module UART
;       Instance name UARTOUT, Block Name RX(DCA05)
	db		37h, 00h		;UARTOUT_RX_CONTROL_REG
	db		35h, 00h		;UARTOUT_
	db		36h, 00h		;UARTOUT_RX_BUFFER_REG 
;       Instance name UARTOUT, Block Name TX(DCA04)
	db		33h, 00h		;UARTOUT_TX_CONTROL_REG
	db		31h, 00h		;UARTOUT_TX_BUFFER_REG 
	db		32h, 00h		;UARTOUT_
	db		ffh


; PSoC Configuration file trailer PsocConfig.asm
