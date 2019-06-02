
;
;Circuit Cellar Cypress PSOC Design Contest
;Contest Entry 201
;
;Title:				Reconfigurable Test System
;Version:			21/5/02
;Description:		This is the main code for reconfiguring and
;					operating the PSOC as a cascadable test POD
;					

export _main

include "m8c.inc"					;include m8c specific declarations 

;
;Some useful macro definitions
;


;
;load effective address of operand into A:X
;
macro	lea
		mov		a,#>@0
		mov		x,#<@0
endm

;
;and/or ABF_CR register bits (write only register)
;
macro	loadabf
		push	a
		mov		a,[ABF_TMP]
		M8C_SetBank1
		mov		reg[ABF_CR],a
		M8C_SetBank0
		pop		a
		endm
		
macro	andabf
		and		[ABF_TMP],#@0
		loadabf
endm

macro	orabf
		or		[ABF_TMP],#@0
		loadabf
endm
	
macro	loadddr0
		push	a
		mov		a,[PRTDM0_T+0]
		mov		reg[PRT0DM0],a
		mov		a,[PRTDM1_T+0]
		mov		reg[PRT0DM1],a
		pop		a
endm
	
macro	loadddr1
		push	a
		mov		a,[PRTDM0_T+1]
		mov		reg[PRT1DM0],a
		mov		a,[PRTDM1_T+1]
		mov		reg[PRT1DM1],a
		pop		a
endm
	
macro	loadddr2
		push	a
		mov		a,[PRTDM0_T+2]
		mov		reg[PRT2DM0],a
		mov		a,[PRTDM1_T+2]
		mov		reg[PRT2DM1],a
		pop		a
endm
	
;
;Carry set/clear
;
macro	clc
		and		F,#~4
endm

macro	sec
		or		F,#4
endm		

;
;Echo a character upstream
;
macro	echo
		push	a
		mov		a,#@0
		call	TxIN
		pop		a
endm

MAXLINE:		equ		16				;number of characters in a line

;
;Register memory usage
;		
area bss(RAM)
	TMP:		blk	1					;working register
	TMP2:		blk 1					;working mask register
	TMP3:		blk	1					;working index register
	ABF_TMP:	blk 1					;stores current state of ABF_CR
	PRTDM0_T:	blk 3					;stores current state of PRT0..2DM0
	PRTDM1_T:	blk	3					;stores current state of PRT0..2DM1
	PORT:		blk 2					;active port(s)
	NOSAMPLES:	blk 1					;number of samples to take
	GAINK:		blk	1					;gain constant
	RESULT:		blk 3					;averaging accumulator
	SAMPLECLK:	blk 1					;clock divider for ADC
	RX_STATUS:	blk 1					;temp uart rx status
	COMMBUF:	blk MAXLINE				;incoming command storage
	RAMPADDING:	blk	64-(19+MAXLINE)		;skip RX corruption area

;
;Code memory
;
area text(ROM,REL)

		
;
;Analog input section
;
include "doubleended.inc"
include "invert.inc"
include "singleended.inc"
include "adc.inc"

;
;Convert bit number to bit mask
;
MASK1LUT:
		db		1,2,4,8,16,32,64,128			;OR operation
MASK0LUT:
		db		~1,~2,~4,~8,~16,~32,~64,~128	;AND operation
		
;		
;Configure ADC for single ended input and initialise
;
;A=Input select P0[0]..P0[7]
;GAINK = gain
;
SingleEndedPort:
		and		a,#7
		mov		[TMP],a
		rrc		a						;check if port is odd or even
		jc		OddPort
EvenPort:
		mov		a,[TMP]
		index	MASK0LUT
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[PRTDM0_T+0]
		and		a,[TMP2]
		mov		reg[PRT0DM0],a			;select high Z on that pin
		mov		[PRTDM0_T+0],a			;update local latched value
		mov		a,[TMP]
		index	MASK1LUT
		mov		[TMP2],a
		mov		a,[PRTDM1_T+0]
		or		a,[TMP2]
		mov		reg[PRT0DM1],a
		mov		[PRTDM1_T+0],a

		orabf	40h						;select mux 3 (even ports)
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		and		[TMP],#128+64
		M8C_SetBank0
		mov		a,reg[AMX_IN]
		and		a,#~(128+64)
		or		a,[TMP]
		mov		reg[AMX_IN],a				;select even port
		jmp		DonePort				
OddPort:
		andabf	~40h						;select mux 2 (odd ports)
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		and		[TMP],#32+16
		M8C_SetBank0
		mov		a,reg[AMX_IN]				;select odd port
		and		a,#~(32+16)
		or		a,[TMP]
		mov		reg[AMX_IN],a
DonePort:
		
		mov		a,reg[ACA02CR1]
		and		a,#~(2+4+16+8)
		or		a,#1+32						;select column input wrt ACA02
		mov		reg[ACA02CR1],a
		
		mov		a,[GAINK]
		call	SingleEnded_SetGain			;user selected gain
		mov		a,#SingleEnded_MEDPOWER
		call	SingleEnded_Start		
		
		lcall	Invert_Stop					;shut down inverting amp
		lcall	DoubleEnded_Stop			;shut down balanced amp
			
		M8C_SetBank0				
		and		reg[ASA12CR1],#~(128+64+32)	;select ASA12 input for ACA02
																		
		
		clc
		ret

;		
;Configure ADC for single ended inverted input and initialise
;
;A=Input select P0[0]..P0[7]
;GAINK = gain
;
SingleEndedInvPort:
		and		a,#7
		mov		[TMP],a
		rrc		a						;check if port is odd or even
		jc		OddPort2
EvenPort2:
		mov		a,[TMP]
		index	MASK0LUT
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[PRTDM0_T+0]
		and		a,[TMP2]
		mov		reg[PRT0DM0],a			;select high Z on that pin
		mov		[PRTDM0_T+0],a
		mov		a,[TMP]
		index	MASK1LUT
		mov		[TMP2],a
		mov		a,[PRTDM1_T+0]
		or		a,[TMP2]
		mov		reg[PRT0DM1],a
		mov		[PRTDM1_T+0],a

		orabf	40h				;select mux 3 (even ports)
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		and		[TMP],#128+64
		M8C_SetBank0
		mov		a,reg[AMX_IN]
		and		a,#~(128+64)
		or		a,[TMP]
		mov		reg[AMX_IN],a				;select even port
		jmp		DonePort2
OddPort2:
		andabf	~40h						;select mux 2 (odd ports)
		rlc		[TMP]
		rlc		[TMP]
		rlc		[TMP]
		and		[TMP],#32+16
		M8C_SetBank0
		mov		a,reg[AMX_IN]				;select odd port
		and		a,#~(32+16)
		or		a,[TMP]
		mov		reg[AMX_IN],a
DonePort2:
		
		mov		a,reg[ACA02CR1]
		and		a,#~(2+4+16+32+8)
		or		a,#1+32						;select column input
		mov		reg[ACA02CR1],a
		
		mov		a,[GAINK]
		call	SingleEnded_SetGain			;user selected gain
		mov		a,#SingleEnded_MEDPOWER
		call	SingleEnded_Start		
		
		mov		a,#Invert_MEDPOWER
		lcall	Invert_Start				;start inverting amp
		mov		a,#Invert_G1_00				;gain = -1.0
		lcall	Invert_SetGain
		lcall	DoubleEnded_Stop			;shut down balanced amp
			
		M8C_SetBank0				
		and		reg[ASA12CR1],#~(64+32)		;select ASA12 input for ACA03
		or		reg[ASA12CR1],#128
															
		
		clc
		ret
;
;Configure ADC for double ended input and initialise
;		
;A.MSN	= V+ input P0[0]..P0[7]
;A.LSN  = V- input P0[0]..P0[7]
;GAINK  = Gain
;
;Carry is clear if configuration is possible
;
DoubleEndedPort:
		
		mov		[TMP],a
		
		and		a,#7
		index	MASK0LUT
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[PRTDM0_T+0]
		and		a,[TMP2]
		mov		reg[PRT0DM0],a			;select high Z on that V- input
		mov		[PRTDM0_T+0],a
		mov		a,[TMP]
		and		a,#7
		index	MASK1LUT
		mov		[TMP2],a
		mov		a,[PRTDM1_T+0]
		or		a,[TMP2]
		mov		reg[PRT0DM1],a
		mov		[PRTDM1_T+0],a
		
		mov		[TMP],a
		rrc		a
		rrc		a
		rrc		a
		rrc		a
		and		a,#7
		index	MASK0LUT
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[PRTDM0_T+0]
		and		a,[TMP2]
		mov		reg[PRT0DM0],a			;select high Z on that V+ input
		mov		[PRTDM0_T+0],a
		mov		a,[TMP]
		rrc		a
		rrc		a
		rrc		a
		rrc		a
		and		a,#7
		index	MASK1LUT
		mov		[TMP2],a
		mov		a,[PRTDM1_T+0]
		or		a,[TMP2]
		mov		reg[PRT0DM1],a
		mov		[PRTDM1_T+0],a
			
		tst		[TMP],#1			;check if V+ and V- are even/odd or odd/even
		jnz		NegIsOdd
NegIsEven:		

		tst		[TMP],#16
		jz		InvalidConfig

		or		[TMP2],#1			;use invert

		mov		a,[TMP]
		rlc		[TMP]	
		rlc		[TMP]	
		rlc		[TMP]	
		rlc		[TMP]	
		and		[TMP],#240
		rrc		a
		rrc		a
		rrc		a
		rrc		a
		and		a,#15
		or		[TMP],a				;swap nibbles
		jmp		ValidConfig
						
NegIsOdd:

		and		[TMP2],#~1			;don't use invert
		tst		[TMP],#16
		jz		ValidConfig
InvalidConfig:
		sec
		ret							;both odd.. error!

ValidConfig:
		M8C_SetBank0
		mov		a,reg[AMX_IN]	
		and		a,#~(1+2)			;mask column 0 (V-) mux select
		tst		[TMP],#2
		jz		NoSet0
		or		a,#1
NoSet0:
		tst		[TMP],#4
		jz		NoSet1
		or		a,#2
NoSet1:
		and		a,#~(4+8)			;mask column 1 (V+) mux select
		tst		[TMP],#32
		jz		NoSet2
		or		a,#4
NoSet2:
		tst		[TMP],#64
		jz		NoSet3
		or		a,#8
NoSet3:
		mov		reg[AMX_IN],a
		
		mov		a,#DoubleEnded_MEDPOWER		;power up differential amp
		lcall	DoubleEnded_Start
		mov		a,#DoubleEnded_G2_00		;nominal gain of 2.0
		lcall	DoubleEnded_SetGain
		
		M8C_SetBank0
		and		reg[ACA02CR1],#~(1+2+4+16+8)		;select ACA02 input to ACA01/AGND
		or		reg[ACA02CR1],#32
		
		mov		a,[GAINK]
		call	SingleEnded_SetGain			;user selected gain
		mov		a,#SingleEnded_MEDPOWER
		call	SingleEnded_Start			;power up cascade opamp

		tst		[TMP2],#1					;invert enabled?
		jnz		InvertOn					;yes, turn it on
								
InvertOff:

		M8C_SetBank0				
		and		reg[ASA12CR1],#~(128+64+32)	;select ASA12 input for ACA02
														
											
		lcall	Invert_Stop					;shut down unused opamp
		jmp		InvertDone
		
InvertOn:

		M8C_SetBank0					
		or		reg[ASA12CR1],#128
		and		reg[ASA12CR1],#~(64+32)		;select ASA12 input to ACA03
																					
					
		mov		a,#Invert_MEDPOWER
		lcall	Invert_SetGain				;nominal gain of 1.0
		mov		a,#Invert_G1_00
		call	Invert_Start	

InvertDone:

		clc
		ret

;
;Initialise ADC and sample clock
;		
;Sample rate = Data clock / (65*256)	must be between 7.8 and 480 
;
InitADC:
		mov		[NOSAMPLES],#1
		mov		[SAMPLECLK],#25				;57 hz
		call	SampleCLK_DisableInt
		lcall	ADC_Stop
		lcall	Invert_Stop
		call	SingleEnded_Stop
		lcall	DoubleEnded_Stop
		ret
		
;
;Initialise ADC and take some samples, apply averaging filter
;		
;Sample rate = Data clock / (65*256)	must be between 7.8 and 480 
;
;Carry is set if sample rate is invalid
;
;Returns data in X:A
;
RunADC:		
		cmp		[NOSAMPLES],#0
		jz		ADCInvalid
		mov		a,[SAMPLECLK]
		cmp		a,#3
		jc		ADCInvalid
		mov		a,[SAMPLECLK]
		cmp		a,#184
		jc		ADCOK
ADCInvalid:
		sec
		ret
ADCOK:	

		call	SampleCLK_WritePeriod
		
		mov		a,[SAMPLECLK]
		clc
		rrc		a							;compare = 50% duty
		call	SampleCLK_WriteCompareValue
		call	SampleCLK_Start
		
		mov		a,#ADC_HIGHPOWER
		lcall	ADC_Start

		call	SettleDelay
		
		mov		[RESULT],#0
		mov		[RESULT+1],#0
		mov		[RESULT+2],#0				;reset accumulator
		
		mov		a,[NOSAMPLES]				;how many samples
		mov		[TMP2],a
  		lcall 	ADC_GetSamples				;start sampler
		
LoopADC:
        ADC_ISDATA			        ;poll flag
      	jz 		LoopADC				;wait for ADC
        ADC_CLEARFLAG		        ;reset flag
        
        ADC_GETDATA			        ;get data
        swap	a,x
        add		a,8					;convert to unsigned
        swap	a,x
		add		[RESULT],a
		swap	a,x
		adc		[RESULT+1],a
		adc		[RESULT+2],#0
		dec		[TMP2]
		jnz		LoopADC

		lcall	ADC_Stop

		cmp		[NOSAMPLES],#1
		jz		SkipDiv				;any need to divide?

;		
;Divide 24-bit result by number of 8-bit number of samples
;
		mov		[TMP2],#24
		mov		[TMP],#0
		clc
DivLoop:
		rlc		[RESULT]
		rlc		[RESULT+1]
		rlc		[RESULT+2]
		rlc		[TMP]
		jc		DivOver
		mov		a,[TMP]
		sub		a,[NOSAMPLES]
		jc		DivUnder
		mov		[TMP],a
		dec		[TMP2]
		jz		DivDone
		sec
		jmp		DivLoop
		
DivOver:
		mov		a,[NOSAMPLES]
		sub		[TMP],a
		dec		[TMP2]
		jz		DivDone
		sec
		jmp		DivLoop
		
DivUnder:
		dec		[TMP2]
		jz		DivDone
		clc
		jmp		DivLoop

DivDone:
		rlc		[RESULT]
		rlc		[RESULT+1]
		rlc		[RESULT+2]
SkipDiv:
		sub		[RESULT+1],8
		mov		a,[RESULT]
		mov		x,[RESULT+1]		
		clc		
		ret
		

;
;Digital input/output section
;

;
;Set data direction on pin for strong drive
;
;Inputs:	A=Port / Bit
;
;Outputs:	X=Port Offset
;			A=Port / Bit
;
SetDDROut:
		mov		[TMP],a
		rrc		a
		rrc		a
		rrc		a		
		and		a,#3				;port number
		swap	a,x
		mov		a,[TMP]
		and		a,#7
		index	MASK1LUT			;lookup mask for OR'ing
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[X+PRTDM0_T]
		or		a,[TMP2]
		mov		reg[X+PRT0DM0],a
		mov		[X+PRTDM0_T],a
		mov		a,[TMP]
		mov		a,#7
		index	MASK0LUT
		mov		[TMP2],a
		mov		a,[X+PRTDM1_T]
		and		a,[TMP2]
		mov		reg[X+PRT0DM1],a	;strong drive
		mov		[X+PRTDM1_T],a
		mov		a,[TMP]
		M8C_SetBank0
		ret

;
;Set data direction on pin for pulldown
;
;Inputs:	A=Port / Bit
;
;Outputs:	X=Port Offset
;			A=Port / Bit
;
SetDDRPulldown:
		mov		[TMP],a
		rrc		a
		rrc		a
		rrc		a		
		and		a,#3				;port number
		swap	a,x
		mov		a,[TMP]
		and		a,#7
		index	MASK0LUT			;lookup mask for AND'ing
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[X+PRTDM0_T]
		and		a,[TMP2]
		mov		reg[X+PRT0DM0],a
		mov		[X+PRTDM0_T],a
		mov		a,[X+PRTDM1_T]
		and		a,[TMP2]
		mov		reg[X+PRT0DM1],a	;pulldown
		mov		[X+PRTDM1_T],a
		mov		a,[TMP]
		M8C_SetBank0
		call	SettleDelay
		ret

;
;Set data direction on pin for pullup
;
;Inputs:	A=Port / Bit
;
;Outputs:	X=Port Offset
;			A=Port / Bit
;
SetDDRPullup:
		mov		[TMP],a
		rrc		a
		rrc		a
		rrc		a		
		and		a,#3				;port number
		swap	a,x
		mov		a,[TMP]
		and		a,#7
		index	MASK1LUT			;lookup mask for OR'ing
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[X+PRTDM0_T]
		or		a,[TMP2]
		mov		reg[X+PRT0DM0],a
		mov		[X+PRTDM0_T],a
		mov		a,[X+PRTDM1_T]
		or		a,[TMP2]
		mov		reg[X+PRT0DM1],a	;pullup
		mov		[X+PRTDM1_T],a
		mov		a,[TMP]
		M8C_SetBank0
		call	SettleDelay
		ret

;
;Set data direction on pin for high Z input
;
;Inputs:	A=Port / Bit
;
;Outputs:	X=Port Offset
;			A=Port / Bit
;
SetDDRIn:
		mov		[TMP],a
		rrc		a
		rrc		a
		rrc		a		
		and		a,#3				;port number
		swap	a,x
		mov		a,[TMP]
		and		a,#7
		index	MASK0LUT			;lookup mask
		mov		[TMP2],a
		M8C_SetBank1
		mov		a,[X+PRTDM0_T]
		and		a,[TMP2]
		mov		reg[X+PRT0DM0],a
		mov		[X+PRTDM0_T],a
		mov		a,[TMP]
		mov		a,#7
		index	MASK1LUT
		mov		[TMP2],a
		mov		a,[X+PRTDM1_T]
		or		a,[TMP2]
		mov		reg[X+PRT0DM1],a	;high Z
		mov		[X+PRTDM1_T],a
		mov		a,[TMP]
		M8C_SetBank0
		call	SettleDelay
		ret
				
;
;Drive digital output high
;		
;A	P0[0]..P2[7]
;
SetDigitalOutput:
		and		a,#7
		index	MASK1LUT
		mov		[TMP2],a			;lookup bit
		M8C_SetBank0
		mov		reg[X+PRT0DR],a
		or		a,[TMP2]
		mov		a,reg[X+PRT0DR]		;set bit				
		ret		
		
;
;Drive digital output low
;		
;A	P0[0]..P2[7]
;
ClrDigitalOutput:
		and		a,#7
		index	MASK0LUT
		mov		[TMP2],a			;lookup bit
		M8C_SetBank0
		mov		reg[X+PRT0DR],a
		and		a,[TMP2]
		mov		a,reg[X+PRT0DR]		;clear bit				
		ret		
		
;
;Read digital input
;
;A	P0[0]..P2[7]
;
;Returns result in Z (Z=1 if bit is clear)
;
ReadDigitalInput:
		and		a,#7
		index	MASK1LUT
		mov		[TMP2],a
		M8C_SetBank0
		mov		a,reg[X+PRT0DR]
		and		a,[TMP2]
		ret
;
;Analog output section (DAC6)
;
include "dac_p02.inc"
include "dac_p03.inc"
include "dac_p04.inc"
include "dac_p05.inc"

;
;Control signal routing for DAC outputs
;
InitDAC:
		mov		[ABF_TMP],#0			;turn off all outputs, reset latch
		loadabf
		
		call	DAC_P03_Off
		call	DAC_P05_Off
		call	DAC_P04_Off
		call	DAC_P02_Off
		ret

;
;Turn off DAC indicated by bit in A
;		
DisableDAC:
		sub		a,#2
		clc
		rlc		a
		jacc	DisableLUT
		
DisableLUT:
		jmp		DAC_P02_Off
		jmp		DAC_P03_Off
		jmp		DAC_P04_Off
		jmp		DAC_P05_Off
		
DAC_P03_On:
		M8C_SetBank1
		or		[PRTDM1_T+0],8				;high-Z mode for P0[3]
		and		[PRTDM0_T+0],~8
		loadddr0
		M8C_SetBank0
		mov		a,#DAC_P03_MEDPOWER
		call	DAC_P03_Start

		orabf	8							;enable output buffer
		ret
		
DAC_P03_Off:
		M8C_SetBank1
		and		[PRTDM1_T+0],~8				;pulldown mode for P0[3]
		and		[PRTDM0_T+0],~8
		loadddr0
		M8C_SetBank0
		andabf	~8							;disable output buffer

		call	DAC_P03_Stop
		ret
		
DAC_P05_On:
		M8C_SetBank1
		or		[PRTDM1_T+0],20h			;high-Z mode for P0[5]
		and		[PRTDM0_T+0],~20h
		loadddr0
		M8C_SetBank0
		mov		a,#DAC_P05_MEDPOWER
		call	DAC_P05_Start

		orabf	20h							;enable output buffer 			
		ret
		
DAC_P05_Off:
		M8C_SetBank1
		and		[PRTDM1_T+0],~20h			;pulldown mode for P0[5]
		and		[PRTDM0_T+0],~20h
		loadddr0
		M8C_SetBank0
		andabf	~20h						;disable output buffer

		call	DAC_P05_Stop
		ret
		
DAC_P04_On:
		M8C_SetBank1
		or		[PRTDM1_T+0],10h			;high-Z mode for P0[4]
		and		[PRTDM0_T+0],~10h
		loadddr0
		M8C_SetBank0
		mov		a,#DAC_P04_MEDPOWER
		call	DAC_P04_Start

		orabf	10h							;enable output buffer 				
		ret
		
DAC_P04_Off:
		M8C_SetBank1
		and		[PRTDM1_T+0],~10h			;pulldown mode for P0[4]
		and		[PRTDM0_T+0],~10h
		loadddr0
		M8C_SetBank0
		andabf	~10h						;disable output buffer

		call	DAC_P04_Stop
		ret
		
DAC_P02_On:
		M8C_SetBank1
		or		[PRTDM1_T+0],4   			;high-Z mode for P0[2]
		and		[PRTDM0_T+0],~4
		loadddr0
		M8C_SetBank0
		mov		a,#DAC_P02_MEDPOWER
		call	DAC_P02_Start

		orabf	4							;enable output buffer			
		ret
		
DAC_P02_Off:
		M8C_SetBank1
		and		[PRTDM1_T+0],~4  			;pulldown mode for P0[2]
		and		[PRTDM0_T+0],~4
		loadddr0
		M8C_SetBank0
		andabf	~4							;disable output buffer

		call	DAC_P02_Stop
		ret
		
_main:

		
		call	InitComms
		call	InitDAC
		call	InitADC
						
		M8C_EnableGInt

		call	SettleDelay
		call	Signon
				
main_loop:	
		call	GetLine			;Get command line
		jz		main_loop		;Skip length=0
		call	ProcessCmd		;Process command line
		jmp		main_loop		;Loop 4 ever


;
;Communications section
;
include "baudclk.inc"
include "uartin.inc"
include "uartout.inc"

;
;Initialise both UARTs
;
InitComms:

		mov		[PRTDM0_T+0],#0
		mov		[PRTDM1_T+0],#0			
		mov		[PRTDM0_T+1],#0
		mov		[PRTDM1_T+1],#0			
		mov		[PRTDM0_T+2],#0
		mov		[PRTDM1_T+2],#0			;initialise latch storage registers

		or		[PRTDM0_T+1],#128+32	;P1[7],P1[5]=Strong out (TX)
		or		[PRTDM1_T+1],#64+16 	;P1[6],P1[4]=High Z     (RX)
		
		M8C_SetBank1
		loadddr0
		loadddr1
		loadddr2
		M8C_SetBank0					;load DDRs

		mov		a,#UART_PARITY_NONE
		call	UARTIN_Start
		mov		a,#UART_PARITY_NONE
		call	UARTOUT_Start
		call	BAUDCLK_Start
		ret

;
;Transmit A upstream 
;
TxIN:
		tst		reg[UARTIN_TX_CONTROL_REG],UART_TX_BUFFER_EMPTY
 		jz		TxIN
 		call	UARTIN_SendData
		ret	

;
;Transmit a newline upstream
;
NewLine:
		mov		a,#10
		call	TxIN
		mov		a,#13
		jmp		TxIN

;
;Transmit a 16-bit hex digit upstream
;
;X:A=Value
;		
DumpHex16:
		push	a
		swap	a,x
		call	DumpHex
		pop		a
		jmp		DumpHex
		

;
;Transmit a 8-bit hex digit upstream
;
;A=Value
;		
DumpHex:
		mov		[TMP2],a
		rrc		a
		rrc		a
		rrc		a
		rrc		a
		and		a,#15
		index	HEXLUT
		call	TxIN
		mov		a,[TMP2]
		and		a,#15
		index	HEXLUT
		jmp		TxIN

;
;Hex digit codes
;
HEXLUT:
		ds		"0123456789ABCDEF"
		
;
;Dump null terminated string pointed to by A:X
;
DumpString:
		mov		[TMP],a
		romx
		jz		DumpDone
		call	TxIN
		mov		a,[TMP]
		inc		x
		jnz	    DumpString
		inc		a
		jnz		DumpString
DumpDone:
		ret
			
;
;Transmit A downstream 
;
TxOUT:
		tst		reg[UARTOUT_TX_CONTROL_REG],UART_TX_BUFFER_EMPTY
 		jz		TxOUT
 		call	UARTOUT_SendData
		ret	
;
;Receive A from upstream controller (blocking)
;If a byte is received from downstream controller, 
;	echo it to upstream controller for daisy chaining
;
RxIN:
		call	bUARTOUT_ReadRxStatus
		mov		[RX_STATUS],a
		and		a,#UART_RX_COMPLETE
		jz		NoRxOUT
		tst		[RX_STATUS],#UART_RX_NO_ERROR
		jnz		NoRxOUT
		call	bUARTOUT_ReadRxData			;fetch data
		cmp		a,#0
		jz		NoRxOUT						;screen nulls
		call	TxIN						;pass it up
NoRxOUT:
		call	bUARTIN_ReadRxStatus
		mov		[RX_STATUS],a
		and		a,#UART_RX_COMPLETE
		jz		RxIN
		tst		[RX_STATUS],#UART_RX_NO_ERROR
		jnz		RxIN
		call	bUARTIN_ReadRxData
		cmp		a,#0
		jz		RxIN						;screen nulls
		ret

;
;Print the signon message
;	
Signon:
		lea		Signon_MSG
		call	DumpString
		call	NewLine
		ret

Signon_MSG:
		asciz		"Pod Online"

;
;Get a LF terminated line from the upstream controller
;Strip LF,CR and NULL terminate it
;
;Returns string length in A (not including NULL)
;
LF:		equ		10
CR:		equ		13

GetLine:

		mov		[TMP3],#COMMBUF			;set up storage pointer
GetSyncLoop:
		call	RxIN					;get a char (blocking)
		cmp		a,#'!'					;scan for start character
		jnz		GetSyncLoop				;ignore everything 
GetCmdLoop:
		call	RxIN					;get a char (blocking)
		cmp		a,#CR					;terminate character?
		jz		GetDone
		cmp		a,#31					;disregard control chars
		jc		GetCmdLoop
		mvi		[TMP3],a				;store char, advance ptr
		cmp		[TMP3],COMMBUF+MAXLINE-1	;out of storage space?
		jnz		GetCmdLoop				;no, next char
GetDone:
		mov		a,#0
		mvi		[TMP3],a				;null terminate string
		sub		[TMP3],#COMMBUF+1		;work out length
		mov		a,[TMP3]
		ret					

;
;Process a command
;
ProcessCmd:
		mov		[TMP3],#COMMBUF			;initialise pointer
		
		mvi		a,[TMP3]				;fetch address byte
		jz		ProcessDone				;unexepected NULL
		
		cmp		a,#'0'					;command for this pod?
		jz		ProcessMatch			;yes, interpret command
				
ProcessEcho:
		jc		ProcessDone				;invalid address - discard
		
		dec		a						;consume one hop 
		push	a
		mov		a,#'!'					;command header
		call	TxOUT
		pop		a
		call	TxOUT					;address
EchoLoop:
		mvi		a,[TMP3]				;echo command downstream
		jz		EchoDone
		call	TxOUT
		cmp		[TMP3],#COMMBUF+MAXLINE
		jnz		EchoLoop
EchoDone:
		mov		a,#CR
		call	TxOUT					;terminate
ProcessDone:
		ret

;
;Command destination is this unit - 
;process command and generate appropriate response 
;
ProcessMatch:

		mvi		a,[TMP3]		;Fetch command
		jz		ProcessDone		;Unexpected NULL - discard
		cmp		a,#'W'			;Write DAC
		jz		ProcessAnaOut
		cmp		a,#'='			;Write digital output
		jz		ProcessDigOut
		cmp		a,#'?'
		jz		ProcessDigIn	;Read digital input
		cmp		a,#'R'
		jnz		ProcessDone		;Unsupported command - discard

;
;Read analog input command
;
;Command syntax !0R+-GGNNDD	
;
;+		Positive Input Port 0 (0..7). Note that 8 is the ground.
;-		Negative Input Port 0 (0..7)
;GG		Gain constant
;NN		Number of samples
;DD		Sampling frequency
;
ProcessAnaIn:
		call	GetHexDigit				;Scan + input
		jc		CmdError
		cmp		a,#9
		jnc		CmdError
		mov		[PORT],a
		call	GetHexDigit				;Scan - input
		jc		CmdError
		cmp		a,#9
		jnc		CmdError
		mov		[PORT+1],a

		call	GetHexByte
		jc		CmdError
		mov		[GAINK],a
		call	GetHexByte
		jc		CmdError
		mov		[NOSAMPLES],a		
		call	GetHexByte
		jc		CmdError
		mov		[SAMPLECLK],a

		cmp		[PORT+1],#8			;Single ended +VE input
		jz		Single
		cmp		[PORT],#8			;Single ended -VE input
		jz		SingleInverted
Double:
		mov		a,[PORT]
		rlc		a
		rlc		a
		rlc		a
		rlc		a
		and		a,#240
		or		a,[PORT+1]
		call	DoubleEndedPort
		jc		CmdError			;Not possible?
		mov		a,#'*'
		call	TxIN
		call	RunADC
		jc		CmdError
		call	DumpHex16
		call	NewLine				
		ret

Single:
		mov		a,[PORT]
		cmp		a,#8
		jz		CmdError
		call	SingleEndedPort
		mov		a,#'*'
		call	TxIN
		call	RunADC
		jc		CmdError
		call	DumpHex16
		call	NewLine
		ret

SingleInverted:
		mov		a,[PORT+1]
		cmp		a,#8
		jz		CmdError
		call	SingleEndedInvPort
		mov		a,#'*'
		call	TxIN
		call	RunADC
		jc		CmdError
		call	DumpHex16
		call	NewLine
		ret

;
;Read digital input command
;								
;
;Command syntax !0?PBM		P=Port 0..1 B=Bit 0..7 M=Set DDR (1=Yes 0=No)
;
ProcessDigIn:

		call	GetPortBit			;Scan port & bit settings
		jc		CmdError
		
		call	GetHexDigit			;Scan mode setting
		jc		CmdError
		cmp		a,#0				;Don't force DDR?
		jz		SkipDDR				;Yes, skip it
		mov		a,[PORT]
		call	SetDDRIn
SkipDDR:
		mov		a,#'*'
		call	TxIN
		mov		a,[PORT]
		call	ReadDigitalInput
		jnz		DigIsHigh
DigIsLow:
		mov		a,#'0'
		call	TxIN
		call	NewLine
		ret
DigIsHigh:
		mov		a,#'1'
		call	TxIN
		call	NewLine
		ret

;
;Interpret the port/bit combination
;
GetPortBit:

		call	GetHexDigit
		jc		PortBitErr
		cmp		a,#2			;Port 0 or 1
		jnc		PortBitErr
		rlc		a
		rlc		a
		rlc		a
		and		a,#8			;Shift up
		mov		[PORT],a		;Save
		call	GetHexDigit
		jc		PortBitErr
		cmp		a,#8
		jnc		PortBitErr		;Bit 0..7
		or		[PORT],a
		clc
		ret
PortBitErr:
		sec
		ret

;
;Drive digital output command
;		
;
;Command syntax !0=PBMS		P=Port 0..1 B=Bit 0..7 M=Mode S=State
;
;
ProcessDigOut:

		call	GetPortBit
		jc		CmdError
			
		mov		a,[PORT]
		rrc		a
		rrc		a
		rrc		a
		and		a,#3			;Port 0?
		jnz		SkipDACOFF		;No, skip
		mov		a,[PORT]
		and		a,#7			;P02..P05?
		cmp		a,#2
		jc		SkipDACOFF
		cmp		a,#6
		jnc		SkipDACOFF
		call	DisableDAC
		
SkipDACOFF:
		
		call	GetHexDigit		;Mode
		jc		CmdError
		
		and		a,#3
		clc
		rlc		a		
		jacc	ModeLUT
		
ModeLUT:
		jmp		SetPulldownMode
		jmp		SetStrongMode
		jmp		SetHighZMode
		jmp		SetPullupMode
		
SetHighZMode:
		mov		a,[PORT]
		call	SetDDRIn
		jmp		DoneMode
		
SetPulldownMode:
		mov		a,[PORT]
		call	SetDDRPulldown
		jmp		DoneMode

SetPullupMode:
		mov		a,[PORT]
		call	SetDDRPullup
		jmp		DoneMode
		
SetStrongMode:
		mov		a,[PORT]
		call	SetDDROut
		
		;fall thru
								
DoneMode:
		call	GetHexDigit		;State (Clear/Set)
		jc		CmdError		
		cmp		a,#0
		jz		ClrDig
SetDig:
		mov		a,[PORT]
		call	SetDigitalOutput
		ret
ClrDig:
		mov		a,[PORT]
		call	ClrDigitalOutput
		ret
		
CmdError:
		mov		a,#'?'
		call	TxIN
		ret
		
;
;Command syntax !0WPGG		P=Port 2,3,4 or 5	GG=Gain 00..3D
;
ProcessAnaOut:
		call	GetHexDigit			;port
		jc		CmdError
		mov		[PORT],a
		sub		a,#2
		jc		CmdError
		cmp		a,#4				;make sure it lies within 2..5
		jnc		CmdError
		clc
		rlc		a		
		jacc	DACLUT
		
DACLUT:
		jmp		Ctrl_DAC_P02
		jmp		Ctrl_DAC_P03
		jmp		Ctrl_DAC_P04
		jmp		Ctrl_DAC_P05

Ctrl_DAC_P02:
		call	GetHexByte
		jc		CmdError
		cmp		a,#$3e
		jnc		CmdError
		call	DAC_P02_WriteStall
		call	DAC_P02_On
		ret

Ctrl_DAC_P03:
		call	GetHexByte
		jc		CmdError
		cmp		a,#$3e
		jnc		CmdError
		call	DAC_P03_WriteStall
		call	DAC_P03_On
		ret

Ctrl_DAC_P04:
		call	GetHexByte
		jc		CmdError
		cmp		a,#$3e
		jnc		CmdError
		call	DAC_P04_WriteStall
		call	DAC_P04_On
		ret

Ctrl_DAC_P05:
		call	GetHexByte
		jc		CmdError
		cmp		a,#$3e
		jnc		CmdError
		call	DAC_P05_WriteStall
		call	DAC_P05_On
		ret

;
;Interpret next two character as a hex byte and return in A
;
GetHexByte:
		call	GetHexDigit
		jc		GetHexDone
		rlc		a
		rlc		a
		rlc		a
		rlc		a
		and		a,#240		
		mov		[TMP],a
		call	GetHexDigit
		jc		GetHexDone
		or		a,[TMP]
GetHexDone:
		ret
		
;
;Interpret next character as a hex digit and return in A
;
;Carry is set if digit was invalid
;
GetHexDigit:
		mvi		a,[TMP3]
		jz		InvalidDigit
		cmp		a,#'0'
		jc		InvalidDigit
		sub		a,#'0'
		cmp		a,#10
		jc		ValidDigit
		sub		a,#7
		cmp		a,#16
		jnc		InvalidDigit
ValidDigit:
		clc
		ret
InvalidDigit:
		sec
		ret		

;
;Wait for pin to settle before sampling
;		
SettleDelay:
		mov		x,#104			;10 ms
		mov		a,#0
SettleLp:
		inc		a				;96 us per iteration (2313 cyc)
		jnz		SettleLp
		dec		x
		jnz		SettleLp
		ret
		