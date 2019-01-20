;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT

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
			AREA 		routines,READONLY,CODE
			THUMB
			ALIGN
			EXPORT		EMP_FIELD

;***************************************************************
;	Main Function
;	Generates memorymap for empty playfield
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
EMP_FIELD	PROC
			PUSH		{R0-R4}
			
			MOV			R0,#0x00
			MOV			R1,#0x05
			
loop1		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop1			
			
			MOV			R0,#0x80
			MOV			R1,#0x42
			
loop2		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop2		
			
			
			MOV			R2,#0x4
grand_loop	
			MOV			R0,#0x00
			MOV			R1,#0x12
			
loop3		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop3	
			
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			
			MOV			R0,#0x00
			MOV			R1,#0x40
			
loop4		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop4				
			
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			
			SUBS		R2,R2,#1
			BNE			grand_loop	
	
	
			MOV			R0,#0x00
			MOV			R1,#0x12
			
loop5		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop5	
			
			MOV			R0,#0x01
			MOV			R1,#0x42
			
loop6		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop6		
			
			MOV			R0,#0x00
			MOV			R1,#0x0D
			
loop7		STRB		R0,[R5],#1
			SUBS		R1,R1,#1
			BNE			loop7	
			
			
			


			POP			{R0-R4}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END