OUT_PORTB_DC		EQU			0x40005008		;00000010
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN		DELAY_1ms
			EXTERN		DELAY_100ms
			EXTERN		DATA_WRITE
			EXTERN 		ADDRESS_CHANGE
			EXPORT		WINNER

;***************************************************************
;	YOU WIN!! IS GOING TO BE SHOWN ON SCREEN
;	
;	
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

WINNER	PROC
			
			PUSH		{LR}   
			MOV			R6,#600
loop		MOV			R4,#0x00
			BL			DATA_WRITE
			SUBS		R6,R6,#1
			BNE			loop

			
			;MOV	R4,r8  ;;trial for 
			
			
			LDR	R4,=0x0215
			BL	ADDRESS_CHANGE

			
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
		
		MOV R4 , #00
		BL DATA_WRITE
		MOV R4 , #00
		BL DATA_WRITE
		MOV R4 , #00
		BL DATA_WRITE	
		MOV R4 , #00
		BL DATA_WRITE
		MOV R4 , #00
		BL DATA_WRITE
			
			
			
			  ;{0x3f, 0x40, 0x38, 0x40, 0x3f} // 57 W
		MOV R4, #0x3F 
		BL DATA_WRITE		
		MOV r4,#0x40
		BL DATA_WRITE	
		MOV R4, #0x38
		BL DATA_WRITE	
		MOV R4, #0x40
		BL DATA_WRITE	
		MOV R4, #0x3F
		BL DATA_WRITE
	  ;{0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
	  
		MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x41
		BL DATA_WRITE	
		MOV R4, #0x7F
		BL DATA_WRITE	
		MOV R4, #0x41
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE
		
 ;{0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N		
				  
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
		
		  ;{0x00, 0x00, 0x5f, 0x00, 0x00} // 21 !
						  
		MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x00
		BL DATA_WRITE	
		MOV R4, #0x5F
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE
		
			MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x00
		BL DATA_WRITE	
		MOV R4, #0x5F
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE
				MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x00
		BL DATA_WRITE	
		MOV R4, #0x5F
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE
		
	
			
			
			POP {LR}
			BX LR
			ENDP
			ALIGN
			END	