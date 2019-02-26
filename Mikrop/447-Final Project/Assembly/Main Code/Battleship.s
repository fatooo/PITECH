OUT_PORTB_DC		EQU			0x40005008		;00000010
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN		DELAY_1ms
			EXTERN		DELAY_100ms
			EXTERN		DATA_WRITE
			EXTERN 		ADDRESS_CHANGE
			EXTERN      PortF_Input
			EXPORT		Battleship

;***************************************************************
;	YOU WIN!! IS GOING TO BE SHOWN ON SCREEN
;	
;	
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

Battleship	PROC
			
			PUSH		{LR}  
			LDR	R4,=0x00
			BL	ADDRESS_CHANGE
			MOV			R6,#600
loop		MOV			R4,#0x00
			BL			DATA_WRITE
			SUBS		R6,R6,#1
			BNE			loop

			
			;MOV	R4,r8  ;;trial for 
			
			
			LDR	R4,=0x0215
			BL	ADDRESS_CHANGE
 
  ;{0x7f, 0x49, 0x49, 0x49, 0x36} // 42 B
 
		MOV R4, #0x7f
		BL DATA_WRITE		
		MOV r4,#0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x36
		BL DATA_WRITE
			
	
			   ;{0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
		MOV R4, #0x7e
		BL DATA_WRITE		
		MOV r4,#0x11
		BL DATA_WRITE	
		MOV R4, #0x11
		BL DATA_WRITE	
		MOV R4, #0x11
		BL DATA_WRITE	
		MOV R4, #0x7e
		BL DATA_WRITE
		
			  ;{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
	
		MOV R4, #0x01
		BL DATA_WRITE		
		MOV r4,#0x01
		BL DATA_WRITE	
		MOV R4, #0x7f
		BL DATA_WRITE	
		MOV R4, #0x01
		BL DATA_WRITE	
		MOV R4, #0x01
		BL DATA_WRITE
			  		  ;{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
	
		MOV R4, #0x01
		BL DATA_WRITE		
		MOV r4,#0x01
		BL DATA_WRITE	
		MOV R4, #0x7f
		BL DATA_WRITE	
		MOV R4, #0x01
		BL DATA_WRITE	
		MOV R4, #0x01
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
			    ;0x7f, 0x08, 0x08, 0x08, 0x7f} // 48 H
		MOV R4, #0x7f 
		BL DATA_WRITE		
		MOV r4,#0x08
		BL DATA_WRITE	
		MOV R4, #0x08
		BL DATA_WRITE	
		MOV R4, #0x08
		BL DATA_WRITE	
		MOV R4, #0x7f
		BL DATA_WRITE
		
		
			
			
			
			  ;,{0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
		MOV R4, #0x00 
		BL DATA_WRITE		
		MOV r4,#0x41
		BL DATA_WRITE	
		MOV R4, #0x7f
		BL DATA_WRITE	
		MOV R4, #0x41
		BL DATA_WRITE	
		MOV R4, #0x00
		BL DATA_WRITE
	  ; ,{0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
	  
		MOV R4, #0x7f 
		BL DATA_WRITE		
		MOV r4,#0x09
		BL DATA_WRITE	
		MOV R4, #0x09
		BL DATA_WRITE	
		MOV R4, #0x09
		BL DATA_WRITE	
		MOV R4, #0x06
		BL DATA_WRITE
		
 
		
wait		BL  		PortF_Input             ; read all of the switches on Port F
			CMP 		R0, #0x00   
			BEQ 		wait
			
			CMP 		R0, #0x11;
			BEQ 		wait
			
			-
			
			
			POP {LR}
			BX LR
			ENDP
			ALIGN
			END	