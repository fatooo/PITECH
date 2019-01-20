;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
; SHOWS THE MEMORY LOCATION TO POSTION AND TYPES OF SHIPS AND CURSORS
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT

SHIP_MEMO			EQU			0x20001100		;1100-1149
MINE_MEMO			EQU			0x20001150		;1150-1199
GP_MEMORY_10		EQU			0x20006010		;6010-6020 Zero array for random use
	
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
			AREA 		routines, READONLY, CODE
			THUMB
			EXTERN 		WINNER
			EXTERN 		LOSER
			EXTERN		__main
			EXPORT 		END_CASE
;***************************************************************
;	WINORLOSE ROUTINE GIVES WINNER OR LOSER AS OUTPUT
; 	WINNING CONDITIONS ARE CHECKED 
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
END_CASE 	PROC
	
			LDR			R5,=SHIP_MEMO			;re-adjust pointer to starting point
			ADD			R1,R5,#4
			STR			R1,[R5]
	
			LDR			R5,=MINE_MEMO			;re-adjust pointer to starting point
			ADD			R1,R5,#4
			STR			R1,[R5]
	
			LDR			R5,=GP_MEMORY_10		;set the win condition. At the end if
			MOV			R1,#0xFF				;this byte is FF then Player 2 wins
			STRB		R1,[R5]					;or else Player 1 wins
			
			
ship_sel	LDR			R5,=SHIP_MEMO			;take ship data
			LDR			R6,[R5]
			LDR			R0,[R6]
			LSR			R1,R0,#24				;find ship type
			CMP			R1,#0x01				
			BEQ			civilian		
			
;***************************************************************	

battleship	LDR			R5,=MINE_MEMO			;take mine data
			LDR			R6,[R5]
			LDR			R1,[R6]
			
x_comp_b	AND			R2,R0,#0xFF				;take x dimension of ship			
			AND			R3,R1,#0xFF				;take x dimension of mine
			
			CMP			R3,R2
			BMI			no_hit_batt
			ADD			R2,R2,#8
			CMP			R3,R2
			BPL			no_hit_batt
			
y_comp_b	AND			R2,R0,#0xFF00			;take y dimension of ship
			LSR			R2,R2,#8
			AND			R3,R1,#0xFF00			;take y dimension of mine
			LSR			R3,R3,#8
			
			CMP			R3,R2
			BMI			no_hit_batt
			ADD			R2,R2,#8
			CMP			R3,R2
			BPL			no_hit_batt
			
			B			incr_ship
			
no_hit_batt	LDR			R5,=MINE_MEMO			;take ship address data
			LDR			R0,[R5]
			SUB			R1,R0,R5
			CMP			R1,#0x10				;if the 4th mine failed P1 wins
			BEQ			Win_P1
			ADD			R0,R0,#4
			STR			R0,[R5]
			B			battleship
			
;***************************************************************		
			
civilian	LDR			R5,=MINE_MEMO			;take mine data
			LDR			R6,[R5]
			LDR			R1,[R6]
			
x_comp_c	AND			R2,R0,#0xFF				;take x dimension of ship			
			AND			R3,R1,#0xFF				;take x dimension of mine

			CMP			R3,R2
			BMI			no_hit_civ
			ADD			R2,R2,#8
			CMP			R3,R2
			BPL			no_hit_civ
			
y_comp_c	AND			R2,R0,#0xFF00			;take y dimension of ship
			LSR			R2,R2,#8
			AND			R3,R1,#0xFF00			;take y dimension of mine
			LSR			R3,R3,#8
			
			CMP			R3,R2
			BMI			no_hit_civ
			ADD			R2,R2,#8
			CMP			R3,R2
			BPL			no_hit_civ

			B			Win_P1

no_hit_civ	LDR			R5,=MINE_MEMO			;take ship address data
			LDR			R0,[R5]
			SUB			R1,R0,R5
			CMP			R1,#0x10				;if is there a hit P1 wins
			BEQ			incr_ship
			ADD			R0,R0,#4
			STR			R0,[R5]
			B			civilian
	
;***************************************************************	

incr_ship	
			LDR			R5,=SHIP_MEMO			;take ship address data
			LDR			R1,[R5]
			SUB			R0,R1,R5
			CMP			R0,#0x10
			BEQ			Win_P2
			ADD			R1,R1,#4
			STR			R1,[R5]
			LDR			R5,=MINE_MEMO			;reset mine pointer
			ADD			R1,R5,#4
			STR			R1,[R5]			
			B			ship_sel
	
;***************************************************************	

Win_P1		BL			LOSER
Win_P2		BL			WINNER

			BL			__main

			BX 			LR 
;***************************************************************
; End of the program  section
;***************************************************************
			ENDP 
			ALIGN	
			END
				