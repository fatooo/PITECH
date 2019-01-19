;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
GPIO_PORTF_DATA_R  EQU 0x400253FC
GPIO_PORTF_DIR_R   EQU 0x40025400
GPIO_PORTF_AFSEL_R EQU 0x40025420
GPIO_PORTF_PUR_R   EQU 0x40025510
GPIO_PORTF_DEN_R   EQU 0x4002551C
GPIO_PORTF_LOCK_R  EQU 0x40025520
GPIO_PORTF_CR_R    EQU 0x40025524
GPIO_PORTF_AMSEL_R EQU 0x40025528
GPIO_PORTF_PCTL_R  EQU 0x4002552C
GPIO_LOCK_KEY      EQU 0x4C4F434B  ; Unlocks the GPIO_CR register
RED       EQU 0x02
BLUE      EQU 0x04
GREEN     EQU 0x08
SW1       EQU 0x10                 ; on the left side of the Launchpad board
SW2       EQU 0x01                 ; on the right side of the Launchpad board
SYSCTL_RCGCGPIO_R  EQU   0x400FE608



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
			EXPORT		PUSHBUTTON
			EXTERN WINNER
			EXTERN LOSER

;***************************************************************
;	Main Function
;	CE - PA3
;	Din- PA5
;	CLK- PA2
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
PUSHBUTTON	;------------PortF_Init------------
                    ; initialize input and output pins of Port F
loop
    LDR R0, =FIFTHSEC               ; R0 = FIFTHSEC (delay 0.2 second)
    BL  delay                       ; delay at least (3*R0) cycles
    BL  PortF_Input                 ; read all of the switches on Port F
    CMP R0, #0x01                   ; R0 == 0x01?
    BEQ sw1pressed                  ; if so, switch 1 pressed
    CMP R0, #0x10                   ; R0 == 0x10?
    BEQ sw2pressed                  ; if so, switch 2 pressed
    CMP R0, #0x00                   ; R0 == 0x00?
    BEQ bothpressed                 ; if so, both switches pressed
    CMP R0, #0x11                   ; R0 == 0x11?
    B   loop
   ;B FINISH
sw1pressed

	BL WINNER 
	B loop
	;B FINISH
sw2pressed

	BL LOSER
    B   loop
  ;B FINISH
bothpressed
    MOV R0, #RED                  ; R0 = GREEN (green LED on)
    BL  PortF_Output                ; turn the RED LED on
    B   loop
   ;B FINISH 
   
   
   


;------------delay------------
; Delay function for testing, which delays about 3*count cycles.
; Input: R0  count
; Output: none
ONESEC             EQU 5333333      ; approximately 1s delay at ~16 MHz clock
QUARTERSEC         EQU 1333333      ; approximately 0.25s delay at ~16 MHz clock
FIFTHSEC           EQU 1066666      ; approximately 0.2s delay at ~16 MHz clock
delay
    SUBS R0, R0, #1                 ; R0 = R0 - 1 (count = count - 1)
    BNE delay                       ; if count (R0) != 0, skip to 'delay'
    BX  LR                          ; return

;------------PortF_Init------------


;------------PortF_Input------------
; Read and return the status of the switches.

PortF_Input
    LDR R1, =GPIO_PORTF_DATA_R ; pointer to Port F data
    LDR R0, [R1]               ; read all of Port F
    AND R0,R0,#0x11            ; just the input pins PF0 and PF4
    BX  LR                     ; return R0 with inputs      GPIO PORTF DATA KEEPS THE PUSH BUTTON OPTIONS

;------------PortF_Output------------

PortF_Output
    LDR R1, =GPIO_PORTF_DATA_R ; pointer to Port F data
    STR R0, [R1]               ; write to PF3-1
FINISH   BX  LR                    

    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file