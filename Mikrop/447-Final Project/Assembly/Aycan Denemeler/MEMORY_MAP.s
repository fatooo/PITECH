;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
EMPTY_FIELD			EQU			0x20000400		;400-5F7
PLAYFIELD			EQU			0x20000600		;600-7F7
MINEFIELD			EQU			0x20002000		;2000-21F
SHIP_EMPTY			EQU			0x20000800		;800-807
SHIP_CIVIL			EQU			0x20000808		;808-80F
SHIP_BATTLE			EQU			0x20000810		;810-817
FLAG_BATTLE			EQU			0x20000810		;for fun
FLAG_CARRIER		EQU			0x20000808		;for fun
CURSOR				EQU			0x20000818		;818-81A
MINE				EQU			0x2000081B		;81B-81D
OLD_SHIP_LOC_X		EQU			0x20001000		;1000
OLD_SHIP_LOC_Y		EQU			0x20001001		;1001
OLD_CURSOR_LOC_X	EQU			0x20001002		;1002
OLD_CURSOR_LOC_Y	EQU			0x20001003		;1003
SHIP_MEMO			EQU			0x20001100		;1100-1149
CURSOR_MEMO			EQU			0x20001150		;1150-1199
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
			EXTERN		EMP_FIELD
			EXPORT		MEMORY_MAP

;***************************************************************
;	Main Function
;	Generates the pixel map of necessary objects in the memory
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
MEMORY_MAP	PROC
			PUSH		{LR}
			
			LDR			R5,=EMPTY_FIELD
			BL			EMP_FIELD
			
			LDR			R5,=PLAYFIELD
			BL			EMP_FIELD
			
			LDR			R5,=MINEFIELD
			BL			EMP_FIELD
			
empty_ship
			LDR			R5,=SHIP_EMPTY
			
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0xFF
			STRB		R0,[R5],#1			
			
					
Civilian_ship
			LDR			R5,=SHIP_CIVIL
			
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x99
			STRB		R0,[R5],#1
			MOV			R0,#0xA5
			STRB		R0,[R5],#1
			MOV			R0,#0xA5
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0x81
			STRB		R0,[R5],#1
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			
			
Battleship
			LDR			R5,=SHIP_BATTLE
			
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			MOV			R0,#0xDB
			STRB		R0,[R5],#1
			MOV			R0,#0xA5
			STRB		R0,[R5],#1
			MOV			R0,#0xDB
			STRB		R0,[R5],#1
			MOV			R0,#0xDB
			STRB		R0,[R5],#1
			MOV			R0,#0xA5
			STRB		R0,[R5],#1
			MOV			R0,#0xDB
			STRB		R0,[R5],#1
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			
Cursor		LDR			R5,=CURSOR
			
			MOV			R0,#0x40
			STRB		R0,[R5],#1
			MOV			R0,#0xE0
			STRB		R0,[R5],#1
			MOV			R0,#0x40
			STRB		R0,[R5],#1
			
Mine		LDR			R5,=MINE
			
			MOV			R0,#0xA0
			STRB		R0,[R5],#1
			MOV			R0,#0x40
			STRB		R0,[R5],#1
			MOV			R0,#0xA0
			STRB		R0,[R5],#1
			
old_memo	MOV			R1,#0x10
			LDR			R5,=OLD_SHIP_LOC_X
			MOV			R0,#0x00
loop		STRB		R0,[R5],#1			
			SUBS		R1,R1,#1
			BNE			loop
			
			
Clean_ship_cursor_memo
			MOV			R1,#0xFF
			LDR			R5,=SHIP_MEMO
			MOV			R0,#0x00
loop2		STRB		R0,[R5],#1			
			SUBS		R1,R1,#1
			BNE			loop2
	
flagship
			LDR			R5,=FLAG_BATTLE
			
			MOV			R0,#0x20
			STRB		R0,[R5],#1
			MOV			R0,#0x60
			STRB		R0,[R5],#1
			MOV			R0,#0xCC
			STRB		R0,[R5],#1
			MOV			R0,#0xDE
			STRB		R0,[R5],#1
			MOV			R0,#0xFF
			STRB		R0,[R5],#1
			MOV			R0,#0xD2
			STRB		R0,[R5],#1
			MOV			R0,#0xE0
			STRB		R0,[R5],#1
			MOV			R0,#0x60
			STRB		R0,[R5],#1

Carrier
			LDR			R5,=FLAG_CARRIER
			
			MOV			R0,#0x20
			STRB		R0,[R5],#1
			MOV			R0,#0x60
			STRB		R0,[R5],#1
			MOV			R0,#0xF8
			STRB		R0,[R5],#1
			MOV			R0,#0xE2
			STRB		R0,[R5],#1
			MOV			R0,#0xE1
			STRB		R0,[R5],#1
			MOV			R0,#0xF8
			STRB		R0,[R5],#1
			MOV			R0,#0x62
			STRB		R0,[R5],#1
			MOV			R0,#0x21
			STRB		R0,[R5],#1


	
	
			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END