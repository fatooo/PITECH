OUT_PORTB_DC		EQU			0x40005008		;00000010
	
EMPTY_FIELD			EQU			0x20000400		;400-5F7
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN		DELAY_1ms
			EXTERN		DELAY_100ms
			EXTERN		DATA_WRITE
			EXTERN 		ADDRESS_CHANGE
			EXTERN		__main
			EXTERN 		PortF_Input
			EXPORT		LOSER

;***************************************************************
;	LOSER IS GOING TO BE SHOWN ON SCREEN
;	
;	
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

LOSER	PROC
			LDR	R4,=0x00
			BL	ADDRESS_CHANGE
			;PUSH		{LR}   
			MOV			R6,#600
loop		MOV			R4,#0x00
			BL			DATA_WRITE
			SUBS		R6,R6,#1
			BNE			loop

			
			LDR	R4,=0x021F
			BL	ADDRESS_CHANGE
			
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
			;POP {LR}
			;BX LR
wait		BL  		PortF_Input             ; read all of the switches on Port F
			CMP 		R0, #0x00   
			BEQ 		wait
			
			CMP 		R0, #0x11;
			BEQ 		wait
			
			BL __main 
			ENDP
***********************

; THIS CODE WRITES PLAYER2'S TURN ON SCREEN

*********************
			EXPORT PLAYER2	
				
PLAYER2  PROC
					
			PUSH		{LR}   

			MOV			R6,#600
loop1		MOV			R4,#0x00
			BL			DATA_WRITE
			SUBS		R6,R6,#1
			BNE			loop1
			
		LDR	R4,=0x0206
		BL	ADDRESS_CHANGE
			
			  ;{0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
			
		MOV R4, #0x7F
		BL DATA_WRITE		
		MOV r4,#0x09
		BL DATA_WRITE	
		MOV R4, #0x09
		BL DATA_WRITE	
		MOV R4, #0x09
		BL DATA_WRITE	
		MOV R4, #0x06
		BL DATA_WRITE
			
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
			    ;{0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
	
		MOV R4, #0x7E
		BL DATA_WRITE		
		MOV r4,#0x11
		BL DATA_WRITE	
		MOV R4, #0x11
		BL DATA_WRITE	
		MOV R4, #0x11
		BL DATA_WRITE	
		MOV R4, #0x7E
		BL DATA_WRITE	
		
				  ;{0x07, 0x08, 0x70, 0x08, 0x07} // 59 Y
		MOV R4, #0x07
		BL DATA_WRITE		
		MOV r4,#0x08
		BL DATA_WRITE	
		MOV R4, #0x70
		BL DATA_WRITE	
		MOV R4, #0x08
		BL DATA_WRITE	
		MOV R4, #0x07
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
		
			  ;   ,{0x42, 0x61, 0x51, 0x49, 0x46} // 32 2
		MOV R4, #0x42 
		BL DATA_WRITE		
		MOV r4,#0x61
		BL DATA_WRITE	
		MOV R4, #0x51
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x46
		BL DATA_WRITE	
		  ;{0x00, 0x05, 0x03, 0x00, 0x00} // 27 '
		  
		MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x05
		BL DATA_WRITE	
		MOV R4, #0x03
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE	
		MOV R4, #0x00
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
		; SPACE
			MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x00
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE
		
		  ;{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
		
		MOV R4, #0x01 
		BL DATA_WRITE		
		MOV r4,#0x01
		BL DATA_WRITE	
		MOV R4, #0x7F
		BL DATA_WRITE	
		MOV R4, #0x01
		BL DATA_WRITE	
		MOV R4, #0x01
		BL DATA_WRITE	
		
					    ;{0x3f, 0x40, 0x40, 0x40, 0x3f} // 55 U
		MOV R4, #0x3F 
		BL DATA_WRITE		
		MOV r4,#0x40
		BL DATA_WRITE	
		MOV R4, #0x40
		BL DATA_WRITE	
		MOV R4, #0x40
		BL DATA_WRITE	
		MOV R4, #0x3F
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
		
			  ;   ,{0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N
		MOV R4, #0x7F 
		BL DATA_WRITE		
		MOV r4,#0x04
		BL DATA_WRITE	
		MOV R4, #0x08
		BL DATA_WRITE	
		MOV R4, #0x10
		BL DATA_WRITE	
		MOV R4, #0x7F
		BL DATA_WRITE	
				
			
			POP {LR}
			
			
			BX LR
			
			
		;	B __main
		ENDP
			ALIGN
			END	