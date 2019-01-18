;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
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
			EXPORT		IREM_CO

;***************************************************************
;	Main Function
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
IREM_CO		PROC
			
			PUSH	{LR}
	
			LDR			R5,=SSI0_DR				; I
			MOV			R1,#0x00
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x7D
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
			
			BL			DELAY_100ms
			
			LDR			R5,=SSI0_DR				; R
			MOV			R1,#0x7F 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x09 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x19 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x29 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x46
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
			
			BL			DELAY_100ms
			
			LDR			R5,=SSI0_DR				; E
			MOV			R1,#0x7F
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x49 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x49 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x49 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
	
			BL			DELAY_100ms
			
			LDR			R5,=SSI0_DR				; M
			MOV			R1,#0x7F 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x02 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x0C 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x02 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x7F
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
			
			BL			DELAY_100ms
			
			LDR			R5,=SSI0_DR				;SPACE
			MOV			R1,#0x00
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
	
			BL			DELAY_100ms
			
			LDR			R5,=SSI0_DR				; C
			MOV			R1,#0x3E
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x22
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
	
			BL			DELAY_100ms
			
			LDR			R5,=SSI0_DR				; O
			MOV			R1,#0x3E
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x41 
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x3E
			STR			R1,[R5]
			
			LDR			R5,=SSI0_DR
			MOV			R1,#0x00
			STR			R1,[R5]
	
	
	
	
	
	
	
			POP			{LR}
	
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	