					AREA		sdata, DATA, READONLY
					THUMB
						
						
Width				DCB			0x0D
					DCB			0x0D
					DCB			"Pulse width(us) : "
					DCB			0x04	
Duty				DCB			0x0D
					DCB			"Duty Cycle(%): "	
					DCB			0x04
Period				DCB			0x0D
					DCB			"Period(us): "
					DCB			0x04

					
TIMER1_RIS			EQU			0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 		0x40031024 ; Timer Interrupt Clear	
TIMER1_TAR			EQU			0x40031048 ; Timer register	
TIMER1_TAV			EQU			0x40031050 ; Free Running Timer A value	
TIMER1_TAILR		EQU			0x40031028 ; Timer interval		
TIMER1_CTL			EQU 		0x4003100C
TIMER1_TAMR			EQU 		0x40031004	
SYSCTL_RCGCTIMER 	EQU 		0x400FE604
TIMER1_CFG			EQU 		0x40031000
TIMER1_TAPR			EQU			0x40031038

GPIO_PORTB_DATA		EQU			0x400053FC	
					
					AREA			main, CODE, READONLY
					THUMB
					ALIGN
					EXTERN			PULSE_INIT
					EXTERN			PULSE_INPUT_INIT	
					EXTERN			CONVRT
					EXTERN			OutStr
					EXTERN 			ledingen
					EXPORT			__main
						
__main				PROC
					MOV				R8, #0
					MOV				R9, #0
					BL				PULSE_INIT
					BL				PULSE_INPUT_INIT
					
testif				LDR				R1,=TIMER1_RIS
					LDR				R0, [R1]
					TEQ				R0, #0x04
					BNE				testif
					
					LDR				R1,=GPIO_PORTB_DATA	
					LDR				R0, [R1]
					BIC				R0, #0x0F
					TEQ				R0, #0x10	;determine the edge
					BEQ				posedge
					BNE				negedge
					
					
posedge				LDR				R1,=TIMER1_TAR
					LDR				R3, [R1]			;R3 holds THE LOW TIME
					LDR				R6,=0xFFFFF	
					SUB				R3, R6, R3
					LSR				R3, #4		
					ADD				R9, #1				;set the flag for first measurement is done
					B				finit
					
negedge				LDR				R1,=TIMER1_TAR
					LDR				R2, [R1]			;R2 holds the PERIOD
					LDR				R6,=0xFFFFF
					SUB				R2, R6, R2
					LSR				R2, #4
					ADD				R9, #1				;set the flag for second measurement is done
					B				output

output				MOV				R6 ,#100			;calculate percentage value
					SUB				R3, R2, R3
					;SUB				R3, #3				; slight modification to correct 
					ADD				R2,	#3					;MODIFICATION
					LDR				R5,=Width
					BL				OutStr
					MOV				R4, R3
					BL				CONVRT				;convert decimal number to ascii codes
					BL				OutStr
					
					LDR				R5,=Period
					BL				OutStr
					MOV				R4, R2
						
					BL				CONVRT
					BL				OutStr
					BL   			ledingen
					
					LDR				R5,=Duty
					BL				OutStr
					MUL				R3, R3, R6		
					UDIV			R4, R3, R2			
					BL				CONVRT
					BL				OutStr
							

finit				LDR				R1,=TIMER1_ICR		; clearing interrupt flags 
					LDR				R0, [R1]
					ORR				R0, R0, #0x04
					STR				R0, [R1]			; CBERIS in GPTM_RIS is cleared
					TEQ				R9, #2
					BNE				testif
					
					
waitfor				WFI
					B				waitfor		 ;squarewave output through PF2 continues
					ENDP
					END
					