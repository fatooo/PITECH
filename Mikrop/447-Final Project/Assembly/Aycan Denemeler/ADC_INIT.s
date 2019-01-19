;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
; ADC Registers
RCGCADC		EQU 	0x400FE638 ; ADC clock register
; ADC0 base address EQU 0x40038000
ADC0_ACTSS	EQU 0x40038000 ; Sample sequencer (ADC0 base address)
ADC0_RIS	EQU 0x40038004 ; Interrupt status
ADC0_IM		EQU 0x40038008 ; Interrupt select
ADC0_ISC	EQU 0x40038034 ; Interrupt status and clear
ADC0_EMUX	EQU 0x40038014 ; Trigger select
ADC0_PSSI	EQU 0x40038028 ; Initiate sample
ADC0_SSMUX3	EQU 0x400380A0 ; Input channel select
ADC0_SSCTL3	EQU 0x400380A4 ; Sample sequence control
ADC0_SSFIFO3	EQU 0x400380A8 ; Channel 3 results
ADC0_PP		EQU 0x40038FC4 ; Sample rate
; GPIO Registers
RCGCGPIO	EQU 0x400FE608 ; GPIO clock register
; PORT E base address EQU 0x40024000
PORTE_DEN	EQU 0x4002451C ; Digital Enable
PORTE_PCTL	EQU 0x4002452C ; Alternative function configuration
PORTE_AFSEL	EQU 0x40024420 ; Alternate function select
PORTE_AMSEL	EQU 0x40024528 ; Enable analog
data		EQU 0x20004000
	
	
***************************
;ADC1 FOR SAMPLING AIN1
***********************
ADC1_ACTSS	EQU 0x40039000 ; Sample sequencer (ADC1 base address)
ADC1_RIS	EQU 0x40039004 ; Interrupt status
ADC1_IM		EQU 0x40039008 ; Interrupt select
ADC1_ISC	EQU 0x40039034 ; Interrupt status and clear
ADC1_EMUX	EQU 0x40039014 ; Trigger select
ADC1_PSSI	EQU 0x40039028 ; Initiate sample
ADC1_SSMUX3	EQU 0x400390A0 ; Input channel select
ADC1_SSCTL3	EQU 0x400390A4 ; Sample sequence control
ADC1_SSFIFO3	EQU 0x400390A8 ; Channel 3 results
ADC1_PP		EQU 0x40039FC4 ; Sample rate	
; Start clocks for features to be used

;***************************************************************
;	INITIALIZE ADC FOR AIN0 AND AIN1 
; 	PE3 AND PE2 IS GOIN TO BE USED
;***************************************************************	
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA routines, READONLY, CODE
			THUMB
			EXPORT ADC_INIT

;***************************************************************
;	ADC_INIT FUNCTION INITIALIZED ADC1 AND ADC0
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT				
ADC_INIT	PROC
	
	PUSH {LR}
	LDR R1, =RCGCADC ; Turn on ADC clock
	LDR R0, [R1]
	ORR R0, R0, #0x03 ; set bit 0 to enable ADC0 AND ADC1 clock
	STR R0, [R1]
	NOP
	NOP
	NOP ; Let clock stabilize
	LDR R1, =RCGCGPIO ; Turn on GPIO clock
	LDR R0, [R1]
	ORR R0, R0, #0x10 ; set bit 4 to enable port E clock
	STR R0, [R1]
	NOP
	NOP
	NOP ; Let clock stabilize
	; Setup GPIO to make PE3 input for ADC0
	; Enable alternate functions
	LDR R1, =PORTE_AFSEL
	LDR R0, [R1]
	ORR R0, R0, #0x0C ; set bit 3 to enable alt functions on PE3 AND SET BIT 2 TO ENABLE PE2
	STR R0, [R1]
	; PCTL does not have to be configured
	; since ADC0 is automatically selected when
	; port pin is set to analog. 
	; Disable digital on PE3
	LDR R1, =PORTE_DEN
	LDR R0, [R1]
	BIC R0, R0, #0x0C ; clear bit 3 to disable analog on PE3 AND PE2
	STR R0, [R1]
	; Enable analog on PE3
	LDR R1, =PORTE_AMSEL
	LDR R0, [R1]
	ORR R0, R0, #0x0C ; set bit 3 to enable analog on PE3
	STR R0, [R1]
	; Disable sequencer while ADC setup
	
	
	;;;ENABLE ADC0 AND ADC PORTS 
	;;ADC SETUPS WILL BE DONE 
	
	
	LDR R1, =ADC0_ACTSS
	LDR R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3
	STR R0, [R1]
	; Select trigger source
	LDR R1, =ADC0_EMUX
	LDR R0, [R1]
	BIC R0, R0, #0xF000 ; clear bits 15:12 to select SOFTWARE trigger
	STR R0, [R1]
	; Select input channel
	LDR R1, =ADC0_SSMUX3
	LDR R0, [R1]
	BIC R0, R0, #0x000F ; clear bits 3:0 to select AIN0
	STR R0, [R1]
	; Config sample sequence
	LDR R1, =ADC0_SSCTL3
	LDR R0, [R1]
	ORR R0, R0, #0x06 ; set bit 1 (END0)
	STR R0, [R1]
	; Set sample rate
	LDR R1, =ADC0_PP
	LDR R0, [R1]
	ORR R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps
	STR R0, [R1]
	; Done with setup, enable sequencer
	LDR R1, =ADC0_ACTSS
	LDR R0, [R1]
	ORR R0, R0, #0x08 ; set bit 3 to enable seq 3
	STR R0, [R1] ; sampling enabled but not initiated yet

		; ADC1 INITIALIZATION
		
	LDR R1, =ADC1_ACTSS
	LDR R0, [R1]
	BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3
	STR R0, [R1]
	; Select trigger source
	LDR R1, =ADC1_EMUX
	LDR R0, [R1]
	BIC R0, R0, #0xF000 ; clear bits 15:12 to select SOFTWARE trigger
	STR R0, [R1]
	; Select input channel
	LDR R1, =ADC1_SSMUX3
	LDR R0, [R1]
	ORR R0 , #0x1; 
	BIC R0, R0, #0xE ; clear bits 3:0 to select AIN1
	STR R0, [R1]
	; Config sample sequence
	LDR R1, =ADC1_SSCTL3
	LDR R0, [R1]
	ORR R0, R0, #0x06 ; set bit 1 (END0)
	STR R0, [R1]
	; Set sample rate
	LDR R1, =ADC1_PP
	LDR R0, [R1]
	ORR R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps
	STR R0, [R1]
	; Done with setup, enable sequencer
	LDR R1, =ADC1_ACTSS
	LDR R0, [R1]
	ORR R0, R0, #0x08 ; set bit 3 to enable seq 3
	STR R0, [R1] ; sampling enabled but not initiated yet
	
	POP {LR}
	BX LR
	ENDP   ;; END OF INITIALIZATION
		
		
		
;***************************************************************
;	ADC_READ_SHIP FUNCTION READS THE AIN0 AND AIN1 DATA 
;   RETURNS YDATA XDATA IN R4 REGISTER
; 	COMPUTATION FOR SHIP PLACEMENT MADE IN THIS SUBMODULE
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT						
		
				EXPORT ADC_READ_SHIP	
			
ADC_READ_SHIP 	PROC
				PUSH {LR}
*******************************
; READ AIN0 FIRST 
; PE3 CONTROLS X DATA
; VERTICAL MOVEMENT
; KEEPS DATA IN R5
*******************************
				
				LDR R3, =ADC0_RIS ; interrupt address
				LDR R4, =ADC0_SSFIFO3 ; result address
				LDR R2, =ADC0_PSSI ; sample sequence initiate address
				LDR R6,= ADC0_ISC ; interrupt status and clear
	; initiate sampling by enabling sequencer 3 in ADC0_PSSI
Smpl0 			LDR R0, [R2]
				ORR R0, R0, #0x08 ; set bit 3 for SS3 in PSSI
				STR R0, [R2]
	; check for sample complete (bit 3 of ADC0_RIS set)
Cont0 			LDR R0, [R3]
				ANDS R0, R0, #8 ;RIS bit
				BEQ Cont0
				LDR R5,[R4]   ; R5 KEEPS THE ADC0 READING
				MOV R0, #8
				LDR R6,= ADC0_ISC
				STR R0, [R6] ; clear flag in ISC
*******************************
; READ AIN1 
; PE2 CONTROLS Y DATA
; HORIZONTAL MOVEMENT
; KEEPS DATA IN R1
*******************************	
	
ADC1_READ
				LDR R3, =ADC1_RIS ; interrupt address
				LDR R4, =ADC1_SSFIFO3 ; result address
				LDR R2, =ADC1_PSSI ; sample sequence initiate address
				LDR R6,= ADC1_ISC ; interrupt status and clear

Smpl1 			LDR R0, [R2]
				ORR R0, R0, #0x08 ; set bit 3 for SS3 in PSSI
				STR R0, [R2]
					; check for sample complete (bit 3 of ADC0_RIS set)
Cont1 			LDR R0, [R3]
				ANDS R0, R0, #8 ;RIS bit
				BEQ Cont1
				LDR R1,[R4]   ; R1 KEEPS THE ADC1 READING
				MOV R0, #8
				LDR R6,= ADC1_ISC
				STR R0, [R6] ; clear flag in ISC
	
****************
; R1 KEEPS AIN1 READING
; R5 KEEPS AIN0 READING
; XDATA AND YDATA TRANSFORMS TO THE PIXEL VALUE
; R4 KEEPS [YDATA, XDATA] 
; LEAST SIGNIFICANT 4 BITS SHOWS X DATA
; BITS FROM 3-7 SHOWS YDATA

**********

COMPUTE  

			LDR R3, =56 ; R3 IS THE DIVISOR
			UDIV R5, R5, R3 ; 
			ADD R5, #9 ; R5 KEEPS THE X
	
			LDR R3, =24 ;
			UDIV R1, R1, R3;
			ADD R1, #9 ;  ; R1 KEEPS THE Y DATA
		
		
			LSL R1,R1,#8 ; SHIFT Y DATA
			ADD R4, R1, R5 ; ADD XDATA YDATA 
			; R4 IS IN FROM [YDATA, XDATA]
		

	
			POP{LR}  ; END OF THE OPERATION
			BX LR
	
			ENDP  ; RETURN R4 
				
				
				
				
				
;***************************************************************
;	ADC_READ_CURSOR FUNCTION READS THE AIN0 AND AIN1 DATA 
;   RETURNS YDATA XDATA IN R4 REGISTER
; 	COMPUTATION FOR CURSOR PLACEMENT MADE IN THIS SUBMODULE
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT						
								
			EXPORT ADC_READ_CURSOR
			
ADC_READ_CURSOR PROC
				PUSH {LR}
				LDR R3, =ADC0_RIS ; interrupt address
				LDR R4, =ADC0_SSFIFO3 ; result address
				LDR R2, =ADC0_PSSI ; sample sequence initiate address
				LDR R6,= ADC0_ISC ; interrupt status and clear
	; initiate sampling by enabling sequencer 3 in ADC0_PSSI
Smpl0_CURSOR 	LDR R0, [R2]
				ORR R0, R0, #0x08 ; set bit 3 for SS3 in PSSI
				STR R0, [R2]
	; check for sample complete (bit 3 of ADC0_RIS set)
Cont0_CURSOR 	LDR R0, [R3]
				ANDS R0, R0, #8 ;RIS bit
				BEQ Cont0
				LDR R5,[R4]   ; R5 KEEPS THE ADC0 READING
				MOV R0, #8
				LDR R6,= ADC0_ISC
				STR R0, [R6] ; clear flag in ISC
	
	
ADC1_READ_CURSOR
				LDR R3, =ADC1_RIS ; interrupt address
				LDR R4, =ADC1_SSFIFO3 ; result address
				LDR R2, =ADC1_PSSI ; sample sequence initiate address
				LDR R6,= ADC1_ISC ; interrupt status and clear

Smpl1_CURSOR 	LDR R0, [R2]
				ORR R0, R0, #0x08 ; set bit 3 for SS3 in PSSI
				STR R0, [R2]
	; check for sample complete (bit 3 of ADC0_RIS set)
Cont1_CURSOR    LDR R0, [R3]
				ANDS R0, R0, #8 ;RIS bit
				BEQ Cont1
				LDR R1,[R4]   ; R1 KEEPS THE ADC1 READING
				MOV R0, #8
				LDR R6,= ADC1_ISC
				STR R0, [R6] ; clear flag in ISC
	
****************
; R1 KEEPS ADC1 READING
; R5 KEEPS ADC0 READING

**********

COMPUTE_CURSOR  

				LDR R3, =62 ; R3 IS THE DIVISOR
				UDIV R5, R5, R3 ; 
				ADD R5, #9 ; R5 KEEPS THE X
	
				LDR R3, =30 ;
				UDIV R1, R1, R3;
				ADD R1, #9 ;  ; R1 KEEPS THE Y DATA
		
		
				LSL R1,R1,#8 ; SHIFT Y DATA
				ADD R4, R1, R5 ; ADD XDATA YDATA 
				; R4 IS IN FROM [YDATA, XDATA]
			
				POP{LR}  ; RETURN R4 DATA 
				BX LR
	
				ENDP
					
	ALIGN		
	END