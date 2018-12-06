GPIO_PORTB_IN		EQU 0x4000603C				; B3 to B0 pins
GPIO_PORTB_OUT 		EQU 0x40006300				; B7 
SYSCTL_RCGCGPIO		EQU	0x400FE608
GPIO_PORTB_DATA		EQU	0x400063FC 
GPIO_PORTB_DIR		EQU	0x40006400
GPIO_PORTB_AFSEL	EQU	0x40006420
GPIO_PORTB_DEN		EQU	0x4000651C
IOB					EQU	0xF0
GPIO_PORTB_PUR      EQU 0x40006510	
					AREA    sdata, READONLY, CODE
					THUMB
					EXTERN DELAY100				; Add delay subroutine for debugging
					EXPORT ledingen
ledingen			PROC									; initialization 
					LDR			R1,=SYSCTL_RCGCGPIO 
					LDR			R0 , [R1]
					ORR 		R0 , R0,#0x06
					STR 		R0 , [R1]
					NOP
					NOP
					NOP 
					LDR 		R1 , =GPIO_PORTB_DIR 
					LDR 		R0 , [R1]
					BIC 		R0 , #0xFF
					ORR 		R0 , #0xC0    ; B7 and  B6 are outputs
					STR 		R0 , [R1]
					LDR 		R1 , =GPIO_PORTB_AFSEL  	;disable AFSEL as stated in manual
					LDR 		R0 , [R1]
					BIC 		R0 , #0xFF
					STR 		R0 , [R1]
					LDR 		R1 , =GPIO_PORTB_DEN		;digital outputs will be considered so enable Digital Enable register
					LDR 		R0 , [R1]
					ORR 		R0 , #0xFF
					STR 		R0 , [R1] 
					CMP 		R4, #0x40 ;
					BGT     	sol
sag					LDR	 		R1,=GPIO_PORTB_OUT	
					LDR 		R0, =0xBF;
					STR 	 	R0,[R1]	;
					B   		finish 			
sol					LDR	 		R1,=GPIO_PORTB_OUT	
					LDR 		R0, =0x7F;
					STR 	 	R0,[R1]	;
finish				BX 			LR

					ENDP