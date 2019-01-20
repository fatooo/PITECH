; ADC Registers
RCGCADC	EQU 0x400FE638 ; ADC clock register
; ADC0 base address EQU 0x40038000
ADC0_ACTSS	EQU 0x40038000 ; Sample sequencer (ADC0 base address)
ADC0_RIS	EQU 0x40038004 ; Interrupt status
ADC0_IM	EQU 0x40038008 ; Interrupt select
ADC0_ISC	EQU 0x40038034 ; Interrupt status and clear
ADC0_EMUX	EQU 0x40038014 ; Trigger select
ADC0_PSSI	EQU 0x40038028 ; Initiate sample
ADC0_SSMUX3	EQU 0x400380A0 ; Input channel select
ADC0_SSCTL3	EQU 0x400380A4 ; Sample sequence control
ADC0_SSFIFO3	EQU 0x400380A8 ; Channel 3 results
ADC0_PP	EQU 0x40038FC4 ; Sample rate
; GPIO Registers
RCGCGPIO	EQU 0x400FE608 ; GPIO clock register
; PORT E base address EQU 0x40024000
PORTE_DEN	EQU 0x4002451C ; Digital Enable
PORTE_PCTL	EQU 0x4002452C ; Alternative function configuration
PORTE_AFSEL	EQU 0x40024420 ; Alternate function select
PORTE_AMSEL	EQU 0x40024528 ; Enable analog
data	EQU 0x20004000
	
	
	
ADC1_ACTSS	EQU 0x40039000 ; Sample sequencer (ADC1 base address)
ADC1_RIS	EQU 0x40039004 ; Interrupt status
ADC1_IM	EQU 0x40039008 ; Interrupt select
ADC1_ISC	EQU 0x40039034 ; Interrupt status and clear
ADC1_EMUX	EQU 0x40039014 ; Trigger select
ADC1_PSSI	EQU 0x40039028 ; Initiate sample
ADC1_SSMUX3	EQU 0x400390A0 ; Input channel select
ADC1_SSCTL3	EQU 0x400390A4 ; Sample sequence control
ADC1_SSFIFO3	EQU 0x400390A8 ; Channel 3 results
ADC1_PP	EQU 0x40039FC4 ; Sample rate	
; Start clocks for features to be used

;***************************************************************
;	INITIALIZE ADC FOR AIN0 AND AIN1 
; PE3 AND PE2 IS GOIN TO BE USED
;***************************************************************	
	AREA routines, READONLY, CODE
	THUMB
	EXPORT ADC_READ
ADC_READ	PROC