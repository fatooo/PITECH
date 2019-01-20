;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
; SHOWS THE MEMORY LOCATION TO POSTION AND TYPES OF SHIPS AND CURSORS
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
; ADC Registers

SHIP1					EQU			0x20001100
SHIP2					EQU			0x20001110
SHIP3					EQU			0x20001120
SHIP4					EQU			0x20001130

CURSOR1					EQU			0x20001150
CURSOR2					EQU			0x20001160
CURSOR3					EQU			0x20001170
CURSOR4					EQU			0x20001180

;***************************************************************

;***************************************************************	
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA routines, READONLY, CODE
			THUMB
			EXPORT WINORLOSE
			EXTERN WINNER
			EXTERN LOSER

;***************************************************************
;	WINORLOSE ROUTINE GIVES WINNER OR LOSER AS OUTPUT
; 	WINNING CONDITIONS ARE CHECKED 
;***************************************************************	
WINORLOSE 	PROC
	
	PUSH {LR}
	PUSH{R0-R6}
	
				LDR R0, = SHIP1   ; R0 KEEPS THE LOCATION IN THE MEMORY  OF SHIPS
						; DONT CHANGE MEMORY FROM NOW ON
nextship		LDR R1, [R0]  ; LOAD SHIP1 VALUE 
				LSR R2, R1, #24 ; R2 KEEPS THE STATUS
				;STATUS REGISTERS ARE 01 OR 10  SHOWS CIVILIAN OR BATTLESHIPS
				LDR R3,= CURSOR1  ; R3 KEEPS CURSOR LOCATION FOR FIRST CURSOR
				CMP R2, #2 ; CHECK IF IT IS BATTLESHIP 
				BEQ BATTLESHIP
				CMP R2, #1
				BEQ CIVILIAN
********
; R0 KEEPS THE SHIP LOCATION IN THE MOMORY
; R3 KEEPS THE CURSOR LOCATION
;R1 KEEPS THE SHIP DATA 
; R4 KEEPS THE CURSOR DATA
******

BATTLESHIP  		LDR R4, [R3] 
					AND  R2, R1, #0x0FF00  ; r2 now keeps y data of the ship
					AND  R5, R4, #0x0FF00 ; R5 KEEPS THE Y DATA OF CURSOR
					
					SUBS R5, R2  ;  if the cursor data on top of the other data check new
					BLT checknewcursor;
					
					CMP R5, #8 ; COMPARE IF THE CURSOR IN THE SHIP AREA 
					BGT checknewcursor
					
					AND  R2, R1, #0x00FF  ; r2 now keeps x data of the ship
					AND  R5, R4, #0x00FF ; R5 KEEPS THE x DATA OF CURSOR
					
					SUBS R5, R2  ;  if the cursor data on top of the other data check new
					BLT checknewcursor;
					
					CMP R5, #8 ; COMPARE IF THE CURSOR IN THE SHIP AREA 
					BGT checknewcursor
					
					B checknewship ; a cursor in this area has been found check new ship
									
;;;; CHECK NEXT CURSOR UNTILL A MATCH FOUND ELSE B LOSE CONDITION					
					
checknewcursor   	AND R5,R3, #0xF0 ;   AND IT R5 SHOWS THE 2ND DIGIT 
					CMP R5, #0x80 ; CURSOR SHOWS THE LAST CURSOR LOCATION
					BEQ LOSE
					ADD R3,R3, #0x10; INCREASE THE CURSOR LOCATION
					B BATTLESHIP
					


CIVILIAN			LDR R4, [R3] 
					AND  R2, R1, #0x0Ff00  ; r2 now keeps y data of the ship
					AND  R5, R4, #0x0Ff00 ; R5 KEEPS THE Y DATA OF CURSOR
					
					SUBS R5, R2  ;  if the cursor data on top of the other data check new
					BLT checknewcursor_civil;
					
					CMP R5, #8 ; COMPARE IF THE CURSOR IN THE SHIP AREA 
					BGT checknewcursor_civil
					
					AND  R2, R1, #0x00Ff  ; r2 now keeps x data of the ship
					AND  R5, R4, #0x00Ff ; R5 KEEPS THE x DATA OF CURSOR
					
					SUBS R5, R2  ;  if the cursor data on top of the other data check new
					BLT checknewcursor_civil;
					
					CMP R5, #8 ; COMPARE IF THE CURSOR IN THE SHIP AREA 
					BGT checknewcursor_civil
					
					B LOSE ; if the cursor in the civil area branch to lose
										
					
;;;; CHECK NEXT CURSOR UNTILL A MATCH FOUND ELSE B LOSE CONDITION					


checknewcursor_civil   	AND R5,R3, #0xF0 ;   AND IT R5 SHOWS THE 2ND DIGIT 
						CMP R5, #0x80 ; CURSOR SHOWS THE LAST CURSOR LOCATION
						BEQ checknewship
						ADD R3,R3, #0x10; INCREASE THE CURSOR LOCATION
						B CIVILIAN



checknewship    	AND R5,R0, #0xF0 ;   AND IT R5 SHOWS THE 2ND DIGIT 
					CMP R5, #0x30 ; SHIP SHOWS THE LAST SHIP LOCATION
					BEQ WIN
					ADD R0,R0, #0x10; INCREASE THE CURSOR LOCATION
					B nextship		
	
LOSE    BL LOSER 
		B FINISH


WIN		BL WINNER
		B FINISH

FINISH   
	POP{R0-R6}
	POP{LR}
	BX LR 
	ENDP 
	ALIGN	
	END
				
				
