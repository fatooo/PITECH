NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
;SHP_SYSPRI3 	EQU 0xE000ED20
RELOAD_VALUE 	EQU 0x1599999 ;;; 1 saniye için degistir sonra
GPIO_PORTB_IN		EQU 0x400053C0				; B3 to B0
GPIO_PORTB_OUT 		EQU 0x4000503C				; B7 to B4
				AREA routines, CODE, READONLY, ALIGN=2
				THUMB
				EXPORT INIT_SYSTICK
				EXTERN DATA_WRITE
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

			MOV R11, #1 ;FLAG FOR SECOND DIGIT
			CMP R9, #0 ; r9 keeps the value from 20 to 0
			BNE cont ; if r9 is 0 clear the screen 
			MOV R9, #20 ; If R9 is 0 mov R9 =20 again and end the operation
			;B  winlose ;     goes to end of the moduke win or lose
cont		SUB R9, #1 ; substract r9 
			MOV R10, #10 ;
			UDIV R8,R9 , r10 ; r8 keeps the first data which is either 0 1 2
			MUL r7, r8, r10;
			SUB R7 , r9 ,r7 ; R7 keeps the second value
			
			CMP R8 , #2 ; 
			BEQ write2 
			CMP R8,#1; 
			BEQ write1
			CMP R8, #0 ;
			BEQ write0
	
write0  MOV R4, #0x3e 
		BL DATA_WRITE
		
		MOV r4,#0x51
		BL DATA_WRITE
		
		MOV R4, #0x49
		BL DATA_WRITE
	
		MOV R4, #0x45
		BL DATA_WRITE
			
		MOV R4, #0x3e
		BL DATA_WRITE
		
		B writebosluk

	

write1  MOV R4, #0x00 
		BL DATA_WRITE
		MOV r4,#0x42
		BL DATA_WRITE
		MOV R4, #0x7F
		BL DATA_WRITE
		MOV R4, #0x40
		BL DATA_WRITE
		MOV R4, #0x00
		BL DATA_WRITE
		B writebosluk

write2   MOV R4, #0x42 
		BL DATA_WRITE		
		MOV r4,#0x61
		BL DATA_WRITE	
		MOV R4, #0x51
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x46
		BL DATA_WRITE
		B writebosluk


write3   MOV R4, #0x21 
		BL DATA_WRITE		
		MOV r4,#0x41
		BL DATA_WRITE	
		MOV R4, #0x45
		BL DATA_WRITE	
		MOV R4, #0x4b
		BL DATA_WRITE	
		MOV R4, #0x31
		BL DATA_WRITE
		B writebosluk

write4   MOV R4, #0x18 
		BL DATA_WRITE		
		MOV r4,#0x14
		BL DATA_WRITE	
		MOV R4, #0x12
		BL DATA_WRITE	
		MOV R4, #0x7f
		BL DATA_WRITE	
		MOV R4, #0x10
		BL DATA_WRITE
		B writebosluk

write5  MOV R4, #0x27 
		BL DATA_WRITE		
		MOV r4,#0x45
		BL DATA_WRITE	
		MOV R4, #0x45
		BL DATA_WRITE	
		MOV R4, #0x45
		BL DATA_WRITE	
		MOV R4, #0x39
		BL DATA_WRITE
		B writebosluk


write6   MOV R4, #0x3c 
		BL DATA_WRITE		
		MOV r4,#0x4a
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x30
		BL DATA_WRITE
		B writebosluk


write7  MOV R4, #0x01 
		BL DATA_WRITE		
		MOV r4,#0x71
		BL DATA_WRITE	
		MOV R4, #0x09
		BL DATA_WRITE	
		MOV R4, #0x05
		BL DATA_WRITE	
		MOV R4, #0x03
		BL DATA_WRITE
		B writebosluk


write8  MOV R4, #0x36 
		BL DATA_WRITE		
		MOV r4,#0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x36
		BL DATA_WRITE
		B writebosluk


write9   MOV R4, #0x06 
		BL DATA_WRITE		
		MOV r4,#0x49
		BL DATA_WRITE	
		MOV R4, #0x49
		BL DATA_WRITE	
		MOV R4, #0x29
		BL DATA_WRITE	
		MOV R4, #0x1e
		BL DATA_WRITE
		B writebosluk
			
writebosluk 
			MOV R4, #0x00 
			BL DATA_WRITE
			CMP R11, #0
			BEQ FINISH
			SUB R11, #1

			CMP R7, #0;
			BEQ write0
			CMP R7, #1;
			BEQ write1
			CMP R7, #2;
			BEQ write2
			CMP R7, #3;
			BEQ write3
			CMP R7, #4;
			BEQ write4
			CMP R7, #5;
			BEQ write5
			CMP R7, #6;
			BEQ write6
			CMP R7, #7;
			BEQ write7
			CMP R7, #8;
			BEQ write8
			CMP R7, #9;
			BEQ write9
			
FINISH			
			BX LR 
			ENDP
			END