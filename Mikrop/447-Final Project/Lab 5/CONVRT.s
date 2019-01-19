;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	routines,	 	READONLY, CODE
			THUMB
			EXPORT		CONVRT
				
CONVRT		PROC
			PUSH{R0-R4}
			
										;R4 contains hexadecimal number 
;			LDR			R5,=0x20000400 	;Memory location of ASCII codes stars	
			LDR			R0,=0x00		;Initilize R0 as zero	
loop		MOV			R1,#10			;Make R1 as A
			UDIV		R3, R4, R1		;Divide R4(dividend) by R1(divider) save value in R3(division)	
			MUL			R1, R3			;R3*R1->R1
			SUB			R2, R4, R1		;By subtraction, get remainder as the first least sig digit of decimal num
			ADD			R2,#0x30		;Add 0x30 and have ASCII equivalent
		
			PUSH{R2}					;PUSH R2 in order to write decimal in proper order
			ADD			R0,#1			;R0 is counter of how many digits decimal number has			
			CBZ			R3,  End1		;If R3=0 go to End1
			MOV			R4, R3			;Save division into dividend to get next decimal digit
			B			loop						
			
End1		POP{R2}						;POP R2 containing ASCII codes
			STRB		R2,[R5],#1		;Store R2 into memory pointed by R5	and increment memory location
			SUB			R0,#1			;Check R0 counter
			CBZ			R0, End2
			B			End1
			
End2		;LDR			R0,=0x09		
			;STRB		R0,[R5]	,#1			;Put 0x04 at the end of the string for ending OutStr
						
			;LDR		R5,=0x20000400
			
			ENDP	
			
			POP{R0-R4}
			BX		LR
				
			ALIGN
			END