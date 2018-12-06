					AREA			sdata, DATA, READONLY
					THUMB
SYSCTL_RCGCGPIO		EQU			0x400FE608	
SYSCTL_RCGCTIMER 	EQU 		0x400FE604 		; GPTM Gate Control	
GPIO_PORTB_DATA		EQU			0x400053FC		; data address to all pins
GPIO_PORTB_DIR		EQU			0x40005400
GPIO_PORTB_PCTL		EQU			0x4000552C
GPIO_PORTB_AFSEL	EQU			0x40005420
GPIO_PORTB_AMSEL	EQU			0x40005528
GPIO_PORTB_DEN		EQU			0x4000551C
	
TIMER1_CFG			EQU 		0x40031000
TIMER1_CTL			EQU 		0x4003100C
TIMER1_TAMR			EQU 		0x40031004
TIMER1_TAILR		EQU			0x40031028 ; Timer interval	
TIMER1_TAPR			EQU			0x40031038

					AREA		main, CODE, READONLY
					THUMB
					ALIGN
					EXPORT		PULSE_INPUT_INIT		
					
PULSE_INPUT_INIT	PROC
					LDR			R1,=SYSCTL_RCGCGPIO	; initialize the clock for Port B
					LDR			R0, [R1]
					ORR			R0, R0, #0x06
					STR			R0, [R1]
					NOP
					NOP
					NOP
					
					LDR			R1,=GPIO_PORTB_DIR
					LDR			R0, [R1]
					BIC			R0, #0x10
					STR			R0, [R1]						;PB4 is input

					LDR			R1,=GPIO_PORTB_AFSEL
					ORR			R0, R0, #0x10						; PB4 is alternative
					STR			R0, [R1]
					
					LDR			R1,=GPIO_PORTB_PCTL
					LDR			R0, [R1]
					ORR			R0, #0x00070000
					STR			R0, [R1]						; PB4 is now allocated for T1CCP0			
					
					LDR			R1,=GPIO_PORTB_AMSEL			; disable Analog
					MOV			R0, #0
					STR			R0, [R1]

					LDR			R1,=GPIO_PORTB_DEN
					ORR			R0, R0, #0x10					; PB4 is digital enabled
					STR			R0, [R1]
					
					LDR 		R1, =SYSCTL_RCGCTIMER ; Start Timer1
					LDR 		R0, [R1]
					ORR			R0, R0, #0x02
					STR 		R0, [R1]
					NOP 		; allow clock to settle
					NOP
					NOP
					
					LDR 		R1, =TIMER1_CTL ; disable timer 1A during setup 
					LDR 		R0, [R1]
					BIC 		R0, R0, #0x1
					STR 		R0, [R1]
					
					LDR			R1,=TIMER1_CFG
					MOV			R0, #0x4
					STR			R0, [R1] 			;select 16 bit mode
					
					LDR 		R1, =TIMER1_TAMR
					MOV 		R0, #0x7 			; set to capture, Edge-time and count DOWN
					STR 		R0, [R1]
					
					LDR			R1, =TIMER1_CTL
					LDR			R0, [R1]
					ORR 		R0, R0, #0xE 			; BOTH EDGES, STALL ON
					STR 		R0, [R1] 
					
					LDR 		R1, =TIMER1_TAPR		 ; Time-extension, read 24 bits from TAR 
					MOV 		R0, #15 ; divide clock by 16
					STR 		R0, [R1] 
					
					LDR 		R1, =TIMER1_TAILR 		; write the reset value
					LDR			R0,=0xFFFF				; 0xFFFFF
					STR			R0, [R1]
					
					LDR			R1, =TIMER1_CTL
					LDR			R0, [R1]
					ORR 		R0, #1				;ENABLE TIMER 1A
					STR 		R0, [R1] 					
					
					ENDP
					BX			LR
					
					ALIGN
					END

					