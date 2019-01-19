OUT_PORTB_DC		EQU			0x40005008		;00000010
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN		DELAY_1ms
			EXTERN		DELAY_100ms
			EXTERN		DATA_WRITE
			EXTERN 		ADDRESS_CHANGE
			EXPORT		LOSER

;***************************************************************
;	LOSER IS GOING TO BE SHOWN ON SCREEN
;	
;	
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

LOSER	PROC
			
			PUSH		{LR}   
			MOV			R6,#600
loop		MOV			R4,#0x00
			BL			DATA_WRITE
			SUBS		R6,R6,#1
			BNE			loop

			
			LDR	R4,=0x021F
			BL	ADDRESS_CHANGE
		;	LDR			R5,=OUT_PORTB_DC
		;	MOV			R1,#0xFF
		;	STR			R1,[R5]
		;	BL			DELAY_1ms
			
			  ;  ,{0x7f, 0x40, 0x40, 0x40, 0x40} // 4c L
		MOV R4, #0x7F
		BL DATA_WRITE		
		MOV r4,#0x40
		BL DATA_WRITE	
		MOV R4, #0x40
		BL DATA_WRITE	
		MOV R4, #0x40
		BL DATA_WRITE	
		MOV R4, #0x40
		BL DATA_WRITE
			  
			  
			    ;0x3e, 0x41, 0x41, 0x41, 0x3e} // 4f O
				
		MOV R4, #0x3E 
		BL DATA_WRITE		
		MOV r4,#0x41
		BL DATA_WRITE	
		MOV R4, #0x41
		BL DATA_WRITE	
		MOV R4, #0x41
		BL DATA_WRITE	
		MOV R4, #0x3E
		BL DATA_WRITE
			    ;  ,{0x46, 0x49, 0x49, 0x49, 0x31} // 53 S
		MOV R4, #0x46 
		BL DATA_WRITE		
		MOV r4,#0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x31
		BL DATA_WRITE
		

			
			
			  ;  ,{0x7f, 0x49, 0x49, 0x49, 0x41} // 45 E
		MOV R4, #0x7F 
		BL DATA_WRITE		
		MOV r4,#0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x41
		BL DATA_WRITE
	  ; ,{0x7f, 0x09, 0x19, 0x29, 0x46} // 52 R
	  
		MOV R4, #0x7F 
		BL DATA_WRITE		
		MOV r4,#0x09
		BL DATA_WRITE	
		MOV R4, #0x19
		BL DATA_WRITE	
		MOV R4, #0x29
		BL DATA_WRITE	
		MOV R4, #0x46
		BL DATA_WRITE
		
 
	
			
			
			POP {LR}
			BX LR
			ENDP
			ALIGN
			END	