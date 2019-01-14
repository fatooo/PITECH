;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
Field_Address		EQU			0x20000400

OUT_PORTB_DC		EQU			0x40005008		;00000010
OUT_PORTB_Reset		EQU			0x40005004		;00000001
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
			EXPORT  	__main					; Make available

;***************************************************************
;	Main Function
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
__main		PROC
			
			LDR			R5,=Field_Address		
			BL			EMP_FIELD
			BL			SPI_CONFIG
			BL 			SCREEN_INIT
			
;check		LDR 		R5,=SSI0_SR
;			LDR			R0,[R5]
;			ANDS  		R0,R0,#0x02 
;			BEQ  		check
			
			LDR			R5,=OUT_PORTB_DC
			MOV			R1,#0x00
			STR			R1,[R5]
			
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x21
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x90
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x20
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x0C
			STR			R1,[R5]
			
;busy		LDR 		R5,=SSI0_SR
;			LDR			R0,[R5]
;			ANDS  		R0,R0,#0x10
;			BEQ  		busy
			
			
			
			
			LDR			R5,=OUT_PORTB_DC
			MOV			R1,#0x02
			STR			R1,[R5]
			
loop		MOV			R2,#1
			
;check2		LDR 		R5,=SSI0_SR
;			LDR			R0,[R5]
;			ANDS  		R0,R0,#0x02 
;			BEQ  		check2
			
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0xFF
			STR			R1,[R5]
			
;busy2		LDR 		R5,=SSI0_SR
;			LDR			R0,[R5]
;			ANDS  		R0,R0,#0x10
;			BEQ  		busy2
	
;			SUBS		R2,R2,#1
;			BNE			loop
			
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END