;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT

SYSCTL_RCGCGPIO		EQU			0x400FE608 		;Enable GPIO
GPIO_PORTB_DIR  	EQU			0x40005400 		;Direction reg
GPIO_PORTB_AFSEL	EQU			0x40005420 		;Alternate function
GPIO_PORTB_DEN	    EQU			0x4000551C		;Digital enable
OUT_PORTB_RESET		EQU			0x40005004		;00000001
OUT_PORTB_DC		EQU			0x40005008		;00000010

SSI0_DR				EQU			0x40008008
SSI0_SR				EQU			0x4000800C
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
            AREA       	sdata, DATA, READONLY
            THUMB
		
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN		DELAY_100ms
			EXPORT		SCREEN_INIT

;***************************************************************
;	Main Function
;	PB0 is RESET
;	PB1 is D/C
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
SCREEN_INIT	PROC
	
			PUSH		{LR}
	
GPIO_INIT	LDR 		R1,=SYSCTL_RCGCGPIO		; Initalize Clock
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x02 
			STR			R0,[R1]
			NOP 
			NOP
			NOP			
			NOP 								;let GPIO clock stabilize 	
	
			LDR 		R1,=GPIO_PORTB_DIR		;Set Direction of Pins
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x03				;PB0,PB1 are output
			STR			R0,[R1]
			
			LDR 		R1,=GPIO_PORTB_DEN		;Digitally enable ports
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x03 
			STR			R0,[R1]
			
			LDR 		R1,=GPIO_PORTB_AFSEL	;Disable Alternate Functions
			LDR 		R0,[R1]
			BIC 		R0,R0,#0x03 
			STR			R0,[R1]
			
			
SCREEN		LDR 		R1,= OUT_PORTB_RESET
			MOV			R0,#0xFF
			STR			R0,[R1]
			BL			DELAY_100ms
			MOV			R0,#0x00
			STR			R0,[R1]
			BL			DELAY_100ms
			MOV			R0,#0xFF
			STR			R0,[R1]
	

			LDR			R5,=OUT_PORTB_DC
			MOV			R1,#0x00
			STR			R1,[R5]
			NOP
			NOP
			NOP
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x21
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0xBF
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x16
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x13
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x20
			STR			R1,[R5]	
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x0C
			STR			R1,[R5]
						
			BL			DELAY_100ms

			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	