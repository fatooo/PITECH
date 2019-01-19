;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
SYSCTL_RCGCGPIO 	EQU 	0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCADC	 	EQU 	0x400FE638 ; ADC  Gate Control
	
GPIO_PORTE_DATA		EQU 	0x40024010 ; Access BIT2
GPIO_PORTE_DIR 		EQU 	0x40024400 ; Port Direction
GPIO_PORTE_AFSEL	EQU 	0x40024420 ; Alt Function enable
GPIO_PORTE_DEN 		EQU	 	0x4002451C ; Digital Enable
GPIO_PORTE_AMSEL 	EQU 	0x40024528 ; Analog enable
GPIO_PORTE_PCTL 	EQU 	0x4002452C ; Alternate Functions

ADC0_ACTSS			EQU		0x40038000 ; Active Sample Sequencer
ADC0_SSCTL3			EQU		0x400380A4 ; Sample Sequence Control 3
ADC0_EMUX			EQU		0x40038014 ; Event Multiplexer Select
ADC0_SSMUX3			EQU		0x400380A0 ; SS Input Mux. Select 3
ADC0_PC				EQU 	0x40038FC4 ; Peripheral Control	
	
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************	
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		sdata, DATA, READONLY
			THUMB
	
;***************************************************************
; Program section					      
;***************************************************************
;LABEL			DIRECTIVE	VALUE						COMMENT	
				AREA		main, CODE, READONLY
				THUMB
				ALIGN
				EXPORT		ADC_INIT		
	
ADC_INIT		PROC
				LDR 		R1, =SYSCTL_RCGCGPIO 		; start GPIO clock
				LDR			R0, [R1]
				ORR 		R0, R0, #0x10 				; set bit 4 for port E
				STR 		R0, [R1]
				NOP	 			
				NOP
				NOP
				
				LDR	 		R1, =GPIO_PORTE_AFSEL 		; alternative port function for PE3
				LDR 		R0, [R1]
				ORR	 		R0, R0, #0x08							
				STR 		R0, [R1]		
					
				LDR 		R1, =GPIO_PORTE_DIR 		; configure direction of PE3
				LDR 		R0, [R1]
				BIC 		R0, R0, #0x08 				; bit3 input
				STR			R0, [R1]
				
				LDR			R1,=GPIO_PORTE_DEN			; disable digital for PE3 (to ensure)
				LDR			R0, [R1]
				BIC 		R0, R0, #0x08
				STR			R0, [R1]
				
				LDR			R1, =GPIO_PORTE_AMSEL 		; enable analog for PE3
				LDR 		R0, [R1]
				ORR			R0, R0, #0x08							
				STR 		R0, [R1]				
								
				LDR 		R1, =SYSCTL_RCGCADC	 		; start GPIO clock
				LDR		 	R0, [R1]
				ORR 		R0, R0, #0x01 				; set bit 0 for ADC0
				STR 		R0, [R1]
				NOP					  					; allow clock to settle
				NOP
				NOP			
				NOP
				NOP
				NOP
				NOP
		
				LDR			R1,=ADC0_ACTSS				; clear bit 3 (disable SS3 for ADC0) ;before configuration
				LDR			R0, [R1]
				BIC			R0, R0, #0x08
				STR			R0, [R1]
				
				LDR			R1,=ADC0_EMUX
				LDR			R0, [R1]
				BIC			R0, R0, #0xF000				; clear bits(15:12) to trigger SS3 of ADC0 by ;software 
				STR			R0, [R1]
				
				LDR			R1,=ADC0_SSMUX3				; configure SS3 of ADC0 to take inputs from ;AIN0		
				LDR			R0, [R1]
				BIC			R0, R0, #0x0F				; write 0 to section 0 af SSMUX3
				STR			R0, [R1]
				
				LDR			R1,=ADC0_SSCTL3				; set bit2(IEN0) and bit3(END0) to ;enable interrupts from SS3 to ADC0
				LDR			R0, [R1]					; and to end the conversion after the 1st ;sample is converted
				ORR			R0, R0, #0x06
				STR			R0, [R1]
							
				LDR			R1,=ADC0_PC					; set sampling rate to 125 kbps
				MOV			R0, #0x01
				STR			R0, [R1]
				
				LDR			R1,=ADC0_ACTSS				; set bit 3 to enable SS3 for ADC0
				LDR			R0, [R1]
				ORR			R0, R0, #0x08
				STR			R0, [R1]					; ADC0 is ready to take one sample by SS3 from AIN0

				ENDP
				BX			LR
					
				ALIGN
				END	