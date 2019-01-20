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
			EXPORT 		END_CASE
;***************************************************************
;	WINORLOSE ROUTINE GIVES WINNER OR LOSER AS OUTPUT
; 	WINNING CONDITIONS ARE CHECKED 
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
END_CASE 	PROC
			PUSH 		{LR}
			PUSH		{R0-R6}
	
			LDR			R5,=SHIP_MEMO	
			ADD			R1,R5,#4
			;STR			R1
	
	
	
	
	
	
	
	
	
	
	
	
			POP			{R0-R6}
			POP			{LR}
			BX 			LR 
;***************************************************************
; End of the program  section
;***************************************************************
			ENDP 
			ALIGN	
			END
				
				

	
	
	
	