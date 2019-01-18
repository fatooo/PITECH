;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
Field_Address		EQU			0x20000400

OUT_PORTB_DC		EQU			0x40005008		;00000010
OUT_PORTB_RESET		EQU			0x40005004		;00000001
SSI0_DR				EQU			0x40008008
SSI0_SR				EQU			0x4000800C
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
		
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA    	main, READONLY, CODE, ALIGN=2
			THUMB
			EXTERN		EMP_FIELD
			EXTERN		SPI_CONFIG
			EXTERN		SCREEN_INIT
			EXTERN		DELAY_100ms
			EXTERN		IREM_CO
			EXPORT  	__main					; Make available

;***************************************************************
;	Main Function
;	CE - PA3
;	Din- PA5
;	CLK- PA2
;	RST- PB0
;	DC - PB1
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
__main		PROC
			
			LDR			R5,=Field_Address		
			BL			EMP_FIELD
			BL			SPI_CONFIG
			BL 			SCREEN_INIT
			

						
			
			
			
address_change

;			LDR			R5,=OUT_PORTB_DC
;			MOV			R1,#0x00
;			STR			R1,[R5]
			
;			LDR			R5,=SSI0_DR				
;			MOV			R1,#0x43
;			STR			R1,[R5]
			
;			NOP
;			NOP
;			NOP
			
;			LDR			R5,=SSI0_DR				
;			MOV			R1,#0x8A
;			STR			R1,[R5]
;			
;			BL			DELAY_100ms
			
			
irem_co		LDR			R5,=OUT_PORTB_DC
			MOV			R1,#0xFF
			STR			R1,[R5]
			
			NOP
			NOP
			NOP

			BL			IREM_CO		
			

END_code	B			END_code
			
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END