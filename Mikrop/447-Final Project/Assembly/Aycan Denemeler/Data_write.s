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
			EXPORT		DATA_WRITE

;***************************************************************
;	Main Function
;	Takes Data in R4 and sends it to screen
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

DATA_WRITE	PROC
			PUSH		{LR}
			
control		LDR			R5,=SSI0_SR
			LDR			R0,[R5]
			AND			R0,#0x02
			CMP			R0,#0x02
			BNE			control
			
			NOP
			
			LDR			R5,=SSI0_DR				
			STR			R4,[R5]
	
			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	