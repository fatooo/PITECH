;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
NVIC_ST_CTRL 		EQU 		0xE000E010
NVIC_ST_RELOAD 		EQU 		0xE000E014
NVIC_ST_CURRENT 	EQU			0xE000E018
;SHP_SYSPRI3 		EQU 		0xE000ED20
RELOAD_VALUE 		EQU 		0x1499999 ;;; 1 saniye için degistir sonra
RELOAD_0			EQU         0x00000000
GPIO_PORTB_IN		EQU		 	0x400053C0				; B3 to B0
GPIO_PORTB_OUT 		EQU 		0x4000503C				; B7 to B4
Field_Address		EQU			0x20000400

OUT_PORTB_DC		EQU			0x40005008		;00000010
OUT_PORTB_RESET		EQU			0x40005004		;00000001
SSI0_DR				EQU			0x40008008
SSI0_SR				EQU			0x4000800C
	
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
				AREA routines, CODE, READONLY, ALIGN=2
				THUMB
				EXPORT INIT_SYSTICK
				EXTERN DATA_WRITE
				EXTERN ADDRESS_CHANGE
				EXTERN DELAY_1ms
;***************************************************************
;  INITIALIZE SYSTICK 
;  THIS CODE SECTION INITIALIZE SYSTICK OPERATION FOR TIMER FROM 20-0

;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
INIT_SYSTICK PROC
		
			PUSH {LR}
		
			LDR 		R1,=NVIC_ST_CTRL
			MOV 		R0,#0
			STR 		R0,[R1]
			LDR 		R1,=NVIC_ST_RELOAD
			LDR 		R0,=RELOAD_VALUE
			STR 		R0,[R1]
			LDR 		R1,=NVIC_ST_CURRENT
			STR 		R0,[R1]
			LDR 		R1,=NVIC_ST_CTRL
			MOV 		R0,#0x03
			STR 		R0,[R1]
			MOV 		R9,#21 ;
			
			POP			{LR}
			BX 			LR
			ENDP
			
		
;***************************************************************
;  My_SYSTICK CODE WORKS FOR COUNTING DOWNWARD AND SHOW IT ON THE SCREEEN ACCORDINGLY 
;  To retain the past location of the cursor address we use R6
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

			EXTERN 		WINNER   ; EXTERN THE SUBSYTEMS USED UN THIS MODULE
			EXTERN		LOSER
			EXTERN 		WINORLOSE
			EXTERN		END_CASE
			EXPORT 		My_SYSTICK
		
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT	
My_SYSTICK 	PROC   
			
			PUSH  		{LR}
			PUSH 		{R0- R6}  				; PUSHES IMPORTANT VALUES
			
			MOV 		R11, #1 				; FLAG FOR SECOND DIGIT  
												; INITIALIZE THE FLAG TO 1 IN ORDER TO WRITE 2 DIGITS EVERY OPERATION
			CMP			R9, #0 					; R9 keeps the value from 20 to 0
			BNE 		cont 					; if R9 is 0 clear the screen 
			LDR 		R1 , =NVIC_ST_CTRL  	; AFTER 20 SECONDS DISABLE THE SYSTICK TIMER
			MOV			R0 , #0
			STR 		R0 , [ R1 ]
			MOV 		R9, #21 				; If R9 is 0 mov R9 =20 again and end the operation	
			POP 		{R0-R6}	
			POP 		{LR}
			BL 			END_CASE    			; BRANCH TO THE DECISON SUBMODULE FOR WINLOSE CONDUTION 
				
			B 			FINISH   				; TO END THIS SUBMODULE AFTER THE END OF THE OPERATION


cont		SUB 		R9,#1 					; substract R9 
			MOV 		R10,#10 
			UDIV 		R8,R9,R10 				; R8 keeps the first data which is either 0 1 2
			MUL 		R0,R8,R10
			SUB 		R0,R9,R0 				; R0 keeps the second value
			
			LDR			R4,=0x0047
			BL			ADDRESS_CHANGE  		; GO TO TOP RIGHT CORNER
			
			CMP 		R8, #2 					; FIND THE FIRST AND SECOND DIGIT BY COMPARING
			BEQ 		write2 
			CMP 		R8,#1 
			BEQ 		write1
			CMP 		R8, #0 
			BEQ 		write0
	
write0  	MOV 		R4, #0x3e 
			BL 			DATA_WRITE		
			MOV 		R4,#0x51
			BL 			DATA_WRITE		
			MOV 		R4, #0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x45
			BL 			DATA_WRITE			
			MOV 		R4, #0x3e
			BL 			DATA_WRITE	
			B 			writebosluk
	
write1  	MOV 		R4, #0x00 
			BL 			DATA_WRITE
			MOV 		R4,#0x42
			BL 			DATA_WRITE
			MOV 		R4, #0x7F
			BL 			DATA_WRITE
			MOV 		R4, #0x40
			BL 			DATA_WRITE
			MOV 		R4, #0x00
			BL 			DATA_WRITE
			B 			writebosluk

write2   	MOV 		R4, #0x42 
			BL 			DATA_WRITE		
			MOV 		R4,#0x61
			BL 			DATA_WRITE	
			MOV 		R4, #0x51
			BL 			DATA_WRITE	
			MOV 		R4, #0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x46
			BL 			DATA_WRITE
			B 			writebosluk


write3   	MOV 		R4, #0x21 
			BL 			DATA_WRITE		
			MOV 		R4,#0x41
			BL 			DATA_WRITE	
			MOV 		R4, #0x45
			BL 			DATA_WRITE	
			MOV 		R4, #0x4b
			BL 			DATA_WRITE	
			MOV 		R4, #0x31
			BL 			DATA_WRITE
			B 			writebosluk

write4  	MOV 		R4, #0x18 
			BL 			DATA_WRITE		
			MOV 		R4,#0x14
			BL 			DATA_WRITE	
			MOV 		R4, #0x12
			BL 			DATA_WRITE	
			MOV 		R4, #0x7f
			BL 			DATA_WRITE	
			MOV 		R4, #0x10
			BL 			DATA_WRITE
			B 			writebosluk

write5  	MOV 		R4, #0x27 
			BL 			DATA_WRITE		
			MOV 		R4,#0x45
			BL 			DATA_WRITE	
			MOV			R4, #0x45
			BL 			DATA_WRITE	
			MOV 		R4, #0x45
			BL 			DATA_WRITE	
			MOV 		R4, #0x39
			BL 			DATA_WRITE
			B 			writebosluk


write6   	MOV 		R4, #0x3c 
			BL 			DATA_WRITE		
			MOV 		R4,#0x4a
			BL 			DATA_WRITE	
			MOV 		R4, #0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x30
			BL 			DATA_WRITE
			B 			writebosluk


write7 		MOV 		R4, #0x01 
			BL 			DATA_WRITE		
			MOV 		R4,#0x71
			BL 			DATA_WRITE	
			MOV 		R4, #0x09
			BL 			DATA_WRITE	
			MOV 		R4, #0x05
			BL 			DATA_WRITE	
			MOV 		R4, #0x03
			BL 			DATA_WRITE
			B 			writebosluk


write8  	MOV 		R4, #0x36 
			BL 			DATA_WRITE		
			MOV 		R4,#0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x49
			BL			DATA_WRITE	
			MOV 		R4, #0x36
			BL			DATA_WRITE
			B			writebosluk

write9   	MOV 		R4, #0x06 
			BL 			DATA_WRITE		
			MOV 		R4,#0x49
			BL			DATA_WRITE	
			MOV 		R4, #0x49
			BL 			DATA_WRITE	
			MOV 		R4, #0x29
			BL 			DATA_WRITE	
			MOV 		R4, #0x1e
			BL 			DATA_WRITE
			B 			writebosluk
			
writebosluk 
			CMP 		R11, #0 				; CHECK THE FLAG TO KNOW IF THE SECOND DIGIT PRINTED
			BEQ 		FINISH  				; IF 2 DIGITS PRINTED END THE OPERATION 
			
			MOV 		R4, #0x00 
			BL 			DATA_WRITE 
			SUB 		R11, #1 				; ELSE PRINT THE SECOND DIGIT AND DECREASE THE FLAG

			CMP 		R0, #0;
			BEQ 		write0
			CMP 		R0, #1;
			BEQ 		write1
			CMP 		R0, #2;
			BEQ 		write2
			CMP 		R0, #3;
			BEQ 		write3
			CMP 		R0, #4;
			BEQ 		write4
			CMP 		R0, #5;
			BEQ 		write5
			CMP 		R0, #6;
			BEQ 		write6
			CMP 		R0, #7;
			BEQ 		write7
			CMP 		R0, #8;
			BEQ 		write8
			CMP 		R0, #9;
			BEQ 		write9
			
FINISH		
			POP 		{R0-R6}	
			POP 		{LR}
			BX 			LR 
			
			ENDP
			ALIGN
			END