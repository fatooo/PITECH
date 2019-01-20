;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
GPIO_PORTF_DATA_R  	EQU 		0x400253FC
GPIO_PORTF_DIR_R   	EQU 		0x40025400
GPIO_PORTF_AFSEL_R 	EQU 		0x40025420
GPIO_PORTF_PUR_R   	EQU 		0x40025510
GPIO_PORTF_DEN_R   	EQU 		0x4002551C
GPIO_PORTF_LOCK_R  	EQU 		0x40025520
GPIO_PORTF_CR_R    	EQU 		0x40025524
GPIO_PORTF_AMSEL_R 	EQU 		0x40025528
GPIO_PORTF_PCTL_R  	EQU 		0x4002552C
GPIO_LOCK_KEY      	EQU 		0x4C4F434B  ; Unlocks the GPIO_CR register
RED       			EQU 		0x02
BLUE      			EQU 		0x04
GREEN     			EQU 		0x08
SW1       			EQU 		0x10                 ; on the left side of the Launchpad board
SW2       			EQU 		0x01                 ; on the right side of the Launchpad board
SYSCTL_RCGCGPIO_R  	EQU   		0x400FE608

SHIP1				EQU			0x20001100
SHIP2				EQU			0x20001110
SHIP3				EQU			0x20001120
SHIP4				EQU			0x20001130

CURSOR1				EQU			0x20001150
CURSOR2				EQU			0x20001160
CURSOR3				EQU			0x20001170
CURSOR4				EQU			0x20001180
	
EMPTY_FIELD			EQU			0x20000400		;400-5F7
PLAYFIELD			EQU			0x20000600		;600-7F7


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
			EXTERN 		WINNER
			EXTERN 		LOSER
			EXTERN SHIP_CURSOR
;***************************************************************
; PORTF INITIALIZATION
; INITIALIZE PF0 AND PF4 FOR PUSH BUTTONS ON THE BOARD
;***************************************************************	
;LABEL		DIRECTIVE	VALUE						COMMENT
			EXPORT		PORTF_INIT
				
PORTF_INIT  PROC
	
			PUSH 		{LR}
			LDR 		R1, =SYSCTL_RCGCGPIO_R		; 1) activate clock for Port F
			LDR 		R0, [R1]                 
			ORR 		R0, R0, #0x20               ; set bit 5 to turn on clock
			STR 		R0, [R1]                  
			NOP
			NOP                             		; allow time for clock to finish
			
			LDR 		R1, =GPIO_PORTF_LOCK_R      ; 2) unlock the lock register
			LDR 		R0, =0x4C4F434B             ; unlock GPIO Port F Commit Register
			STR 		R0, [R1]                    
			
			LDR 		R1, =GPIO_PORTF_CR_R        ; enable commit for Port F
			MOV 		R0, #0xFF                   ; 1 means allow access
			STR 		R0, [R1]                    
			
			LDR 		R1, =GPIO_PORTF_AMSEL_R     ; 3) disable analog functionality
			MOV 		R0, #0                      ; 0 means analog is off
			STR 		R0, [R1]                    
			
			LDR 		R1, =GPIO_PORTF_PCTL_R      ; 4) configure as GPIO
			MOV 		R0, #0x00000000             ; 0 means configure Port F as GPIO
			STR 		R0, [R1]                  
			
			LDR 		R1, =GPIO_PORTF_DIR_R       ; 5) set direction register
			MOV 		R0,#0x0E                    ; PF0 and PF7-4 input, PF3-1 output
			STR 		R0, [R1]                    
			
			LDR 		R1, =GPIO_PORTF_AFSEL_R     ; 6) regular port function
			MOV 		R0, #0                      ; 0 means disable alternate function 
			STR 		R0, [R1]                    
			
			LDR 		R1, =GPIO_PORTF_PUR_R       ; pull-up resistors for PF4,PF0
			MOV 		R0, #0x11                   ; enable weak pull-up on PF0 and PF4
			STR 		R0, [R1]              
			
			LDR 		R1, =GPIO_PORTF_DEN_R       ; 7) enable Port F digital port
			MOV 		R0, #0xFF                   ; 1 means enable digital I/O
			STR 		R0, [R1]   
			POP			{LR}
			BX  		LR      
			ENDP

;***************************************************************
; Adjustable Delay
; Delay function for testing, which delays about 3*count cycles.
; Input: R0  count
; Output: none
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
ONESEC            	EQU 		5333333      	; approximately 1s delay at ~16 MHz clock
HALFSEC				EQU 		2666666
QUARTERSEC         	EQU 		1333333      	; approximately 0.25s delay at ~16 MHz clock
FIFTHSEC           	EQU 		1066666      	; approximately 0.2s delay at ~16 MHz clock
TENTHSEC			EQU 		533333	
			
;***************************************************************	
;LABEL		DIRECTIVE	VALUE				COMMENT	
			EXPORT 		delay
						
delay		PROC
			SUBS 		R0, R0, #1   		; R0 = R0 - 1 (count = count - 1)
			BNE 		delay               ; if count (R0) != 0, skip to 'delay'
			BX  		LR                  ; return
			ENDP


;***************************************************************
; PortF_Input
; Read and return the status of the switches.
; R0 keeps the data according to push buttons
;***************************************************************
;LABEL		DIRECTIVE	VALUE						COMMENT
			EXPORT 		PortF_Input
PortF_Input	PROC
			PUSH 		{LR}
			LDR 		R1,=GPIO_PORTF_DATA_R 		; pointer to Port F data
			LDR 		R0,[R1]               		; read all of Port F
			AND 		R0,R0,#0x11            		; just the input pins PF0 and PF4
			POP 		{LR}
			BX  		LR                     		; return R0 with inputs     
			ENDP							   		; GPIO PORTF DATA KEEPS THE PUSH BUTTON OPTIONS


			ALIGN                           ; 
			END                             ; end of file