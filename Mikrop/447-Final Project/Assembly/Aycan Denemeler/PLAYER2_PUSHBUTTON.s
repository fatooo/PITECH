;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT


SHIP1					EQU			0x20001100
SHIP2					EQU			0x20001110
SHIP3					EQU			0x20001120	
SHIP4					EQU			0x20001130

CURSOR1					EQU			0x20001150
CURSOR2					EQU			0x20001160
CURSOR3					EQU			0x20001170
CURSOR4					EQU			0x20001180
NVIC_ST_CTRL 		EQU 		0xE000E010


;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************	
		
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			ALIGN
			EXTERN PortF_Input
			


;------------delay------------
; Delay function for testing, which delays about 3*count cycles.
; Input: R0  count
; Output: none
ONESEC             EQU 5333333      ; approximately 1s delay at ~16 MHz clock
QUARTERSEC         EQU 1333333      ; approximately 0.25s delay at ~16 MHz clock
FIFTHSEC           EQU 1066666      ; approximately 0.2s delay at ~16 MHz clock
TENTHSEC			EQU 533333	
			EXPORT delay2
delay2		PROC
			;PUSH {LR}
			SUBS R0, R0, #1                 ; R0 = R0 - 1 (count = count - 1)
			BNE delay2                       ; if count (R0) != 0, skip to 'delay'
		;	POP{LR}
			BX  LR                          ; return
			ENDP


;***************************************************************
;	THIS IS THE LOOP TO CHECK WHETHER THE PUSH BUTTON IS PRESSED OR NOT
; 	POLLING OPERATION
;  	BRANCHS TO VISUALIZING SHIP SUBROUTINE
;	BRANCHS TO ADC MODULES TO GET THE LOCATION
;***************************************************************	
			EXTERN ADC_READ_SHIP  ; INCLUDE ADC READING MODULES
			EXTERN ADC_READ_CURSOR

			EXTERN ADDRESS_CHANGE	
			EXTERN WINORLOSE
			EXPORT PLAYER2_PUSHBUTTON
;LABEL		DIRECTIVE	VALUE					COMMENT

PLAYER2_PUSHBUTTON	PROC
			PUSH {LR}
loop
			LDR R0, =FIFTHSEC               ; R0 = FIFTHSEC (delay 0.2 second) 0.1 DELAY
			BL  delay2                       ; delay at least (3*R0) cycles
			BL ADC_READ_CURSOR               ;;; READ SHIP LOCATION 
			BL  PortF_Input                 ; read all of the switches on Port F
			LSL R0,R0, #24; ;; SHIFT 24 TIMES
			ADD R4, R4, R0 ;  R4 KEEPS STATUS OF PUSHBUTTONS AND XY DATA		
			LSR R0, #24 ; SHIFT RIGHT AGAIN
			;;; CHECK STATUS FOR MAPPING CONDITION
;;;;; CHECK IF THE SHIP HAS A COLLISION WITH PREVIOUSLY DEPLOYED SHIP
			CMP R0, #0x11 ;  
			BEQ CONT	;NO DEPLOYMENT	
			CMP R0, #0x00;
			BEQ CONT  ; NO DEPLOYMENT
			LDR R0, =CURSOR1									
nextlocation	LDR R1, [R0] ; R0 KEEPS THE SHIP 1 VALUE ADDRESS
						; R1 KEEPS THE SHIP1 LOCATIONDATA
				CMP R1, #0 ; IF EMPTY BLOCK 
				BEQ  MAPPING				
				AND R5,R0, #0xF0 ;   AND IT R5 SHOWS THE 2ND DIGIT 
				CMP R5, #0x80 ; 
				BEQ FINISH  ; end this push button loop  4MINES DEPLOYED				
				ADD R0, #0x10
				B	   nextlocation						
MAPPING			STR R4, [R0] 			
CONT 			;BL MINE_CURSOR_			
				B   loop								
FINISH		   	CMP R9, #0

				BNE 		FINISH
			
			

			POP{LR}   
			BX LR
			ENDP
	


			ALIGN                           ; 
			END                             ; end of file