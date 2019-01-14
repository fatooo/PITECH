;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT

SYSCTL_RCGCGPIO		EQU			0x400FE608 		;Enable GPIO
GPIO_PORTB_DIR  	EQU			0x40005400 		;Direction reg
GPIO_PORTB_AFSEL	EQU			0x40005420 		;Alternate function
GPIO_PORTB_DEN	    EQU			0x4000551C		;Digital enable
OUT_PORTB			EQU			0x4000500C		;00000011

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
			
			
SCREEN		LDR 		R1,= OUT_PORTB
			MOV			R0,#0x00
			STR			R0,[R1]
			NOP
			NOP
			NOP
			NOP
			NOP
;			BL			DELAY_100ms
			MOV			R0,#0x01
			STR			R0,[R1]
	
	
			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	