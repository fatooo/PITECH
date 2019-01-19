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
			EXTERN		DELAY_1ms
			EXTERN		DELAY_100ms
			EXPORT		ADDRESS_CHANGE

;***************************************************************
;	Main Function
;	Takes Coordinates in R4 and sends them to screen
;	Least Significant byte is X and Second one is Y
;	0000.0000.0000.0000.YYYY.YYYY.XXXX.XXXX
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

ADDRESS_CHANGE	PROC
			
			PUSH		{LR}
			PUSH		{R0-R6}
			
			
			
			LDR			R5,=OUT_PORTB_DC
			MOV			R1,#0x00
			STR			R1,[R5]			
			
			BL			DELAY_100ms
			
control		LDR			R5,=SSI0_SR
			LDR			R0,[R5]
			AND			R0,#0x02
			CMP			R0,#0x02
			BNE			control

			AND			R2,R4,#0xFF00		;Y coordinates
			LSR			R2,R2,#8			;shift 1 byte Right
			ADD			R2,R2,#0x40			
			LDR			R5,=SSI0_DR
			STR			R2,[R5]				;send Y coordinate
			
			BL			DELAY_100ms
			
			AND			R1,R4,#0xFF			;X coordinate
			ADD			R1,R1,#0x80
			LDR			R5,=SSI0_DR				
			STR			R1,[R5]				;Send X coordinate
			
			BL			DELAY_100ms
			
			LDR			R5,=OUT_PORTB_DC
			MOV			R1,#0xFF
			STR			R1,[R5]			
			
			POP			{R0-R6}
			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	