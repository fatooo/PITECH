;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
OUT_PORTB_DC		EQU			0x40005008		;00000010

OLD_CURSOR_LOC_X	EQU			0x20001000		;1000
OLD_CURSOR_LOC_Y	EQU			0x20001001		;1001
MINEFIELD			EQU			0x20000600		;600-7F7
CURSOR				EQU			0x20000818		;818-81A
MINE				EQU			0x2000081B		;81B-81D

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
			EXPORT		MINE_CURSOR

;***************************************************************
;	Main Function
;	Takes Op mode, y location and x location
;	Data format M = 
;	0000.00MM.0000.0000.YYYY.YYYY.XXXX.XXXX
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
MINE_CURSOR	PROC
			PUSH		{LR}
			PUSH		{R0-R4}
					
			
			LDR			R5,=OLD_CURSOR_LOC_Y
			LDRB		R0,[R5]
			LSL			R0,R0,#8
			LDR			R5,=OLD_CURSOR_LOC_X
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
			LDR			R5,=OLD_CURSOR_LOC_Y
			LDRB		R0,[R5]
			LSR			R0,R0,#3				;Extract the fractional part
			LSL			R4,R0,#8								
			
			LDR			R5,=OLD_CURSOR_LOC_X
			LDRB		R1,[R5]		
			ADD			R4,R4,R1				;create Yloc-Xloc structure for address change
			BL			ADDRESS_CHANGE
			
			MOV			R3,#0x54				
			MUL			R2,R0,R3				;multiply Y coordinate with 84
			ADD			R2,R2,R1				;find vertical mode address of pixel
						
			LDR			R5,=MINEFIELD
			ADD			R5,R5,R2				;find corresponding address of R5
			MOV			R3,#3					;write 3 byte of data
			
minefield	LDRB		R4,[R5],#1
			BL			DATA_WRITE
			SUBS		R3,R3,#1
			BNE			minefield
			
			
			LDR			R3,=OLD_CURSOR_LOC_Y
			LDRB		R0,[R3]
			ANDS		R1,R0,#0x07				;control fractional part
			BEQ			Skip_clear
			
			LDR			R3,=OLD_CURSOR_LOC_Y
			LDRB		R0,[R3]
			LSR			R0,R0,#3				;Extract the fractional part
			LSL			R4,R0,#8								
			
			LDR			R3,=OLD_CURSOR_LOC_X
			LDRB		R1,[R3]		
			ADD			R4,R4,R1				;create Yloc-Xloc structure for address change
			ADD			R4,R4,#0x100			;jump to next line
			BL			ADDRESS_CHANGE
			
			ADD			R5,R5,#0x51
			MOV			R3,#3

minefield2	LDRB		R4,[R5],#1
			BL			DATA_WRITE
			SUBS		R3,R3,#1
			BNE			minefield2


;***************************************************************
; case determine stage
;***************************************************************


Skip_clear	POP			{R4}
			LSR			R3,R4,#0x18				;extact operation from coordinates
			
			LDR			R5,=OLD_CURSOR_LOC_X
			AND			R0,R4,#0xFF
			STRB		R0,[R5]
			LDR			R5,=OLD_CURSOR_LOC_Y
			AND			R0,R4,#0xFF00
			LSR			R0,R0,#8
			STRB		R0,[R5]
			
			
			CMP			R3,#0x01
			BEQ			mine
			CMP			R3,#0x02
			BEQ			mine
			B			on_screen
			
;***************************************************************
;mine placement stage
;***************************************************************

mine		LDR			R5,=OLD_CURSOR_LOC_X	;extract X coordinate
			LDRB		R0,[R5]
			LDR			R5,=OLD_CURSOR_LOC_Y	;extract Y coordinate
			LDRB		R1,[R5]
			AND			R2,R1,#0x07				;extract fractional Y coordinate
			LSR			R1,R1,#0x03				;extract whole part
			
			MOV			R3,#0x54				
			MUL			R3,R1,R3				;multiply Y coordinate with 84
			ADD			R3,R3,R0				;find vertical mode address of pixel
			
			LDR			R5,=MINEFIELD			;take minefield address for writing op
			ADD			R5,R5,R3				;adjust to mine location
			LDR			R6,=MINE				;take mine pattern
			MOV			R3,#3	
			
mine_memo	LDRB		R0,[R5]					
			LDRB		R1,[R6],#1
			LSL			R1,R1,R2				;shift with fractional part to adjust mine
			AND			R1,R1,#0xFF
			ORR			R1,R1,R0				;combine field data with mine data
			STRB		R1,[R5],#1				;write into the memory
			SUBS		R3,R3,#1
			BNE			mine_memo
			
			CMP			R2,#0x00				;if data is divided	repeat same step for
			BEQ			on_screen				;lower byte frames
			MOV			R3,#3
			
			ADD			R5,R5,#0x51
			SUB			R6,R6,#0x03
mine_memo2	LDRB		R1,[R6],#1
			LSL			R1,R1,R2
			LSR			R1,R1,#8
			LDRB		R0,[R5]
			ORR			R1,R1,R0
			STRB		R1,[R5],#1
			SUBS		R3,R3,#1
			BNE			mine_memo2
			
			B			on_screen		
			
;***************************************************************
;write screen stage
;***************************************************************			
			
on_screen	LDR			R5,=OLD_CURSOR_LOC_X	;extract X coordinate
			LDRB		R0,[R5]
			LDR			R5,=OLD_CURSOR_LOC_Y	;extract Y coordinate
			LDRB		R1,[R5]
			AND			R2,R1,#0x07				;extract fractional Y coordinate
			LSR			R1,R1,#0x03				;extract whole part
			
			LSL			R4,R1,#8
			ADD			R4,R4,R0
			BL			ADDRESS_CHANGE
			
			MOV			R3,#0x54				
			MUL			R3,R1,R3				;multiply Y coordinate with 84
			ADD			R3,R3,R0				;find vertical mode address of pixel

			LDR			R5,=MINEFIELD			;take playfield address for writing op
			ADD			R5,R5,R3				;adjust to ship location
			LDR			R6,=CURSOR				;take empty ship pattern
			MOV			R3,#3	

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
			
			
			LDR			R3,=OLD_CURSOR_LOC_X	;extract X coordinate from newly written memory
			LDRB		R0,[R3]
			LDR			R3,=OLD_CURSOR_LOC_Y	;extract Y coordinate from newly written memory
			LDRB		R1,[R3]
			LSR			R1,R1,#0x03				;extract whole part
			ADD			R1,R1,#0x01				;increment	Y location
			LSL			R1,R1,#0x08
			ADD			R4,R1,R0
			BL			ADDRESS_CHANGE
			
			MOV			R3,#3
			LDR			R6,=CURSOR				;take cursor pattern			
			ADD			R5,R5,#0x51
second_line	LDRB		R1,[R6],#1
			LSL			R1,R1,R2				;shift with fractional part to adjust cursor
			LSR			R1,R1,#8
			AND			R1,R1,#0xFF
			LDRB		R0,[R5]
			ORR			R4,R1,R0				;combine field data with mine data
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
		
			
			
			
			
			
			
			
			
			
			
			
			