NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
;SHP_SYSPRI3 	EQU 0xE000ED20
RELOAD_VALUE 	EQU 0x1599999
GPIO_PORTB_IN		EQU 0x400053C0				; B3 to B0
GPIO_PORTB_OUT 		EQU 0x4000503C				; B7 to B4
				AREA init_isr, CODE, READONLY, ALIGN=2
				THUMB
				EXPORT INIT_SYSTICK
			;	EXTERN ccwturn
INIT_SYSTICK PROC

		LDR R1 , =NVIC_ST_CTRL
		MOV R0 , #0
		STR R0 , [ R1 ]
		LDR R1 , =NVIC_ST_RELOAD
		LDR R0 , =RELOAD_VALUE
		STR R0 , [ R1 ]
		LDR R1 , =NVIC_ST_CURRENT
		STR R0 , [ R1 ]
		;LDR R1 , =SHP_SYSPRI3 
		;MOV R0 , #0x40000000
		;STR R0 , [ R1 ]
		LDR R1 , =NVIC_ST_CTRL
		MOV R0 , #0x03
		STR R0 , [ R1 ]
		
		BX LR
		ENDP
			
			
		EXPORT My_SYSTICK
My_SYSTICK PROC   
				
			CMP R9, #0 ; r9 keeps the value from 20 to 0
			BEQ clearcase ; if r9 is 0 clear the screen 
			SUB R9, #1 ; substract r9 
			MOV R10, #10 ;
			UDIV R8,R9 , r10 ; r8 keeps the first data which is either 0 1 2
			MUL r7, r8, r10;
			SUB R7 , r9 ,r7 ; R7 keeps the second value
			
			
			BL     ;; Adres yazma modulüne git 
			
			
			
			
			
	
		 
					CMP 			R9 , #1               ; R0 keeps clockwise vs counterclockwise data 
					BEQ 			CCW
					CMP 			R9 , #0 
					BEQ 			CW
					BNE 			finish1
CCW					LDR				R1,=GPIO_PORTB_OUT	 
					LSL 			R5, R5, #1 			
					MOV             R6, R5 
					CMP				R5,#0x10			
					BNE 			load1
					MOV				R5, #0x1 
					MOV 			R6, #0x1 
load1 				STR				R6,[R1]					; store r6 to output pin connecting to motor
					B 				finish1			
CW       			LDR				R1,=GPIO_PORTB_OUT		; same operations for clockwise operation
					LSR 			R5, R5, #1 			
					MOV             R6, R5 ;
					CMP				R5,#0x0			
					BNE 			load
					MOV				R5, #0x8;
					MOV 			R6, #0x8 ;
load 				STR				R6,[R1]		;

finish1		CMP R8 , #0 ;
			BEQ UP
			CMP R8 , #1 ;
			BEQ	DOWN
			BNE finish
UP     	 	LSR R7, R7, #1  ; every speed up increases speed slowly R7 is 1000000 initially 
			;SUB R7,R3   ; R7 is equal to its 3/4 
			CMP R7 , # 0x6000
			BGT	finish
			LDR R7, =0x6000 ;
			
DOWN 		LSL R7, R7, #1  ; every speed up increases speed slowly R7 is 1000000 initially 
		;	ADD R7,R3   ; R7 is equal to its 5/4 
			B finish	
finish		LDR R1 , =NVIC_ST_RELOAD
			STR R7 , [ R1 ]
			MOV R8 , #2 ; this means it does not change until sup or sdown is pressed
			BX LR 
			ENDP
			END