;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
OUT_PORTB_DC		EQU			0x40005008		;00000010

OLD_SHIP_LOC_X		EQU			0x20001000		;1000
OLD_SHIP_LOC_Y		EQU			0x20001001		;1001
PLAYFIELD			EQU			0x20000600		;600-7F7
SHIP_EMPTY			EQU			0x20000800		;800-807
SHIP_CIVIL			EQU			0x20000808		;808-80F
SHIP_BATTLE			EQU			0x20000810		;810-817
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
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN		DELAY_1ms
			EXTERN		ADDRESS_CHANGE
			EXTERN		DATA_WRITE
			EXPORT		SHIP_CURSOR

;***************************************************************
;	Main Function
;	Takes Op mode, y location and x location
;	Data format M = 
;	0000.00MM.0000.0000.YYYY.YYYY.XXXX.XXXX
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

SHIP_CURSOR	PROC
			PUSH		{LR}
			PUSH		{R0-R4}
			
			LDR			R5,=OLD_SHIP_LOC_Y
			LDRB		R0,[R5]
			LSL			R0,R0,#8
			LDR			R5,=OLD_SHIP_LOC_X
			LDRB		R1,[R5]
			ADD			R0,R0,R1
			LDR			R2,=0xFFFF
			AND			R1,R4,R2				;Compare new location with old one
			PUSH		{R4}					;Save R4 
			CMP			R1,R0
			BEQ			Skip_clear				;if they are same skip clear phase
;***************************************************************
;clear screen stage
;***************************************************************
Clear			
			LDR			R5,=OLD_SHIP_LOC_Y
			LDRB		R0,[R5]
			LSR			R0,R0,#3				;Extract the fractional part
			LSL			R4,R0,#8								
			
			LDR			R5,=OLD_SHIP_LOC_X
			LDRB		R1,[R5]		
			ADD			R4,R4,R1				;create Yloc-Xloc structure for address change
			BL			ADDRESS_CHANGE
			
			MOV			R3,#0x54				
			MUL			R2,R0,R3				;multiply Y coordinate with 84
			ADD			R2,R2,R1				;find vertical mode address of pixel
						
			LDR			R5,=PLAYFIELD
			ADD			R5,R5,R2				;find corresponding address of R5
			MOV			R3,#8					;write 8 byte of data
			
playfield	LDRB		R4,[R5],#1
			BL			DATA_WRITE
			SUBS		R3,R3,#1
			BNE			playfield
			
			
			LDR			R3,=OLD_SHIP_LOC_Y
			LDRB		R0,[R3]
			ANDS		R1,R0,#0x07				;control fractional part
			BEQ			Skip_clear
			
			LDR			R3,=OLD_SHIP_LOC_Y
			LDRB		R0,[R3]
			LSR			R0,R0,#3				;Extract the fractional part
			LSL			R4,R0,#8								
			
			LDR			R3,=OLD_SHIP_LOC_X
			LDRB		R1,[R3]		
			ADD			R4,R4,R1				;create Yloc-Xloc structure for address change
			ADD			R4,R4,#0x100			;jump to next line
			BL			ADDRESS_CHANGE
			
			ADD			R5,R5,#0x4C
			MOV			R3,#8

playfield2	LDRB		R4,[R5],#1
			BL			DATA_WRITE
			SUBS		R3,R3,#1
			BNE			playfield2

;***************************************************************
; case determine stage
;***************************************************************

Skip_clear	POP			{R4}
			LSR			R3,R4,#0x18				;extact operation from coordinates
			
			LDR			R5,=OLD_SHIP_LOC_X
			AND			R0,R4,#0xFF
			STRB		R0,[R5]
			LDR			R5,=OLD_SHIP_LOC_Y
			AND			R0,R4,#0xFF00
			LSR			R0,R0,#8
			STRB		R0,[R5]
			
			
			CMP			R3,#0x01
			BEQ			civilian
			CMP			R3,#0x10
			BEQ			battleship
			B			on_screen

;***************************************************************
;Civilian ship stage
;***************************************************************

civilian	LDR			R5,=OLD_SHIP_LOC_X		;extract X coordinate
			LDRB		R0,[R5]
			LDR			R5,=OLD_SHIP_LOC_Y		;extract Y coordinate
			LDRB		R1,[R5]
			AND			R2,R1,#0x07				;extract fractional Y coordinate
			LSR			R1,R1,#0x03				;extract whole part
			
			MOV			R3,#0x54				
			MUL			R3,R1,R3				;multiply Y coordinate with 84
			ADD			R3,R3,R0				;find vertical mode address of pixel
			
			LDR			R5,=PLAYFIELD			;take playfield address for writing op
			ADD			R5,R5,R3				;adjust to ship location
			LDR			R6,=SHIP_CIVIL			;take civilian ship pattern
			MOV			R3,#8	
			
civ_memo	LDRB		R0,[R5]					
			LDRB		R1,[R6],#1
			LSL			R1,R1,R2				;shift with fractional part to adjust ship
			AND			R1,R1,#0xFF
			ORR			R1,R1,R0				;combine field data with ship data
			STRB		R1,[R5],#1				;write into the memory
			SUBS		R3,R3,#1
			BNE			civ_memo
			
			CMP			R2,#0x00				;if data is divided	repeat same step for
			BEQ			on_screen				;lower byte frames
			MOV			R3,#8
			
			ADD			R5,R5,#0x4C
			SUB			R6,R6,#0x08
civ_memo2	LDRB		R1,[R6],#1
			LSL			R1,R1,R2
			LSR			R1,R1,#8
			LDRB		R0,[R5]
			ORR			R1,R1,R0
			STRB		R1,[R5],#1
			SUBS		R3,R3,#1
			BNE			civ_memo2
			
			B			on_screen
			
;***************************************************************
;Battleship stage
;***************************************************************

battleship	LDR			R5,=OLD_SHIP_LOC_X		;extract X coordinate
			LDRB		R0,[R5]
			LDR			R5,=OLD_SHIP_LOC_Y		;extract Y coordinate
			LDRB		R1,[R5]
			AND			R2,R1,#0x07				;extract fractional Y coordinate
			LSR			R1,R1,#0x03				;extract whole part
			
			MOV			R3,#0x54				
			MUL			R3,R1,R3				;multiply Y coordinate with 84
			ADD			R3,R3,R0				;find vertical mode address of pixel
			
			LDR			R5,=PLAYFIELD			;take playfield address for writing op
			ADD			R5,R5,R3				;adjust to ship location
			LDR			R6,=SHIP_BATTLE			;take battle ship pattern
			MOV			R3,#8	
			
bat_memo	LDRB		R0,[R5]					
			LDRB		R1,[R6],#1
			LSL			R1,R1,R2				;shift with fractional part to adjust ship
			AND			R1,R1,#0xFF
			ORR			R1,R1,R0				;combine field data with ship data
			STRB		R1,[R5],#1				;write into the memory
			SUBS		R3,R3,#1
			BNE			bat_memo
			
			CMP			R2,#0x00				;if data is divided	repeat same step for
			BEQ			on_screen				;lower byte frames
			MOV			R3,#8
			
			ADD			R5,R5,#0x4C
			SUB			R6,R6,#0x08
bat_memo2	LDRB		R1,[R6],#1
			LSL			R1,R1,R2
			LSR			R1,R1,#8
			LDRB		R0,[R5]
			ORR			R1,R1,R0
			STRB		R1,[R5],#1
			SUBS		R3,R3,#1
			BNE			bat_memo2	

			B			on_screen
		
;***************************************************************
;write screen stage
;***************************************************************			
			
on_screen	LDR			R5,=OLD_SHIP_LOC_X		;extract X coordinate
			LDRB		R0,[R5]
			LDR			R5,=OLD_SHIP_LOC_Y		;extract Y coordinate
			LDRB		R1,[R5]
			AND			R2,R1,#0x07				;extract fractional Y coordinate
			LSR			R1,R1,#0x03				;extract whole part
			
			LSL			R4,R1,#8
			ADD			R4,R4,R0
			BL			ADDRESS_CHANGE
			
			MOV			R3,#0x54				
			MUL			R3,R1,R3				;multiply Y coordinate with 84
			ADD			R3,R3,R0				;find vertical mode address of pixel

			LDR			R5,=PLAYFIELD			;take playfield address for writing op
			ADD			R5,R5,R3				;adjust to ship location
			LDR			R6,=SHIP_EMPTY			;take empty ship pattern
			MOV			R3,#8	

first_line	LDRB		R0,[R5],#1		
			LDRB		R1,[R6],#1
			LSL			R1,R1,R2				;shift with fractional part to adjust ship
			AND			R1,R1,#0xFF		
			ORR			R4,R1,R0				;combine field data with ship data
			BL			DATA_WRITE				;write to screen
			SUBS		R3,R3,#1
			BNE			first_line
			
			
			CMP			R2,#0x00				;if data is divided	repeat same step for
			BEQ			endline					;lower byte frames
			MOV			R3,#8
			
			LDR			R3,=OLD_SHIP_LOC_X		;extract X coordinate from newly written memory
			LDRB		R0,[R3]
			LDR			R3,=OLD_SHIP_LOC_Y		;extract Y coordinate from newly written memory
			LDRB		R1,[R3]
			LSR			R1,R1,#0x03				;extract whole part
			ADD			R1,R1,#0x01				;increment	Y location
			LSL			R1,R1,#0x08
			ADD			R4,R1,R0
			BL			ADDRESS_CHANGE
			
			MOV			R3,#8
			LDR			R6,=SHIP_EMPTY			;take empty ship pattern			
			ADD			R5,R5,#0x4C
second_line	LDRB		R1,[R6],#1
			LSL			R1,R1,R2				;shift with fractional part to adjust ship
			LSR			R1,R1,#8
			LDRB		R0,[R5]
			ORR			R4,R1,R0				;combine field data with ship data
			BL			DATA_WRITE				;write to screen
			SUBS		R3,R3,#1
			BNE			second_line	

endline
			
			POP			{R0-R4}
			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	
