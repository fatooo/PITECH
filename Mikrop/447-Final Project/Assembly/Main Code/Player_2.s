;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
ONESEC            	EQU 		0x00516155     	; approximately 1s delay at ~16 MHz clock
HALFSEC				EQU 		0x0028B0AA		; approximately 0.5s delay at ~16 MHz clock
QUARTERSEC         	EQU 		0x00145855     	; approximately 0.25s delay at ~16 MHz clock
FIFTHSEC           	EQU 		0x001046AA     	; approximately 0.2s delay at ~16 MHz clock
TENTHSEC			EQU 		0x00082355		; approximately 0.1s delay at ~16 MHz clock

EMPTY_FIELD			EQU			0x20000400		;400-5F7
PLAYFIELD			EQU			0x20000600		;600-7F7
MINE_MEMO			EQU			0x20001150		;1150-1199
GP_MEMORY			EQU			0x20006000		;6000-60FF Zero array for random use

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
			EXTERN 		ADC_READ_CURSOR  				; INCLUDE ADC READING MODULES
			EXTERN 		delay
			EXTERN 		PortF_Input
			EXTERN 		MINE_CURSOR
			EXTERN		ADDRESS_CHANGE
			EXTERN		DATA_WRITE
			EXTERN		INIT_SYSTICK
			EXPORT		PLAYER_2

;***************************************************************
;	Main Function
;	PortF_Input reads button status to R0
;	If R0 is 01 or 10 button is present the turn of second player starts			
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT

PLAYER_2	PROC
			PUSH		{LR}
			
wait		BL  		PortF_Input     		; read all of the switches on Port F
			CMP 		R0,#0x00 ;  
			BEQ 		wait
			CMP 		R0,#0x11;
			BEQ 		wait
			
			LDR 		R4,=0x0000 				;Reset cursor location
			BL 			ADDRESS_CHANGE 
			
			LDR 		R0, =0x1F8
			LDR 		R5,= PLAYFIELD			; Write playfield on the screen
sneak_peak	LDRB 		R4 ,[R5], #1			; for sneak peak
			BL 			DATA_WRITE
			SUBS 		R0, R0, #1
			BNE 		sneak_peak	

			LDR 		R0, =HALFSEC       		; R0 = FIFTHSEC (delay 0.2 second) 0.1 DELAY
			BL  		delay  
			
			LDR 		R0,=0x1F8
			LDR 		R5,=EMPTY_FIELD			; clears playfield for mine placement
clear_field	LDRB 		R4,[R5],#1
			BL 			DATA_WRITE
			SUBS 		R0,R0,#1
			BNE 		clear_field	
			
			
			BL			INIT_SYSTICK			; Starts timer block for mine placement phase

;***************************************************************

			LDR 		R0, =TENTHSEC           ; R0 = FIFTHSEC (delay 0.2 second) 0.1 DELAY
			BL  		delay                   ; delay at least (3*R0) cycles
			
			LDR			R5,=GP_MEMORY			; create a clear spot in memory 
			MOV			R0,#00
			STR			R0,[R5]
				
read_loc	BL 			ADC_READ_CURSOR         ; READ CURSOR LOCATION 		
			
			LDR			R5,=GP_MEMORY			
			LDR			R0,[R5]
			CMP			R0,#0x00				; if memory is empty read button data
			BNE			Skip_button				; else skip it
			
			BL  		PortF_Input             ; read all of the switches on Port F
			LSL 		R0,R0, #24				; SHIFT 24 TIMES
			ADD 		R4,R4, R0 				; R4 KEEPS STATUS OF PUSHBUTTONS AND XY DATA		
			LSR 		R0,#24 					; SHIFT RIGHT AGAIN
			
			
			CMP 		R0, #0x11   
			BEQ 		CONT					; NO MINE	
			CMP 		R0, #0x00;
			BEQ 		CONT  					; NO MINE
			
			LDR			R5,=GP_MEMORY
			MOV			R0,#0x0F
			STR			R0,[R5]
			
mine_memory	
			LDR			R5,=MINE_MEMO			; take to write memory address
			LDR			R1,[R5]					; take pointer memory address
			SUBS		R0,R1,R5				; find the number of placed ships
			CMP			R0,#0x14				; if the 5th memory location is received
			BEQ			FINISH					; do not write and skip to end
			
			STR			R4,[R1]					; store mine coordinate in pointed memory 
			ADD			R1,R1,#4				; increment R1 for next mine memory location
			STR			R1,[R5]					; save next memory address		

CONT 		BL 			MINE_CURSOR			
			B   		read_loc


Skip_button	SUB			R0,R0,#1				; Decrement no read counter at GP_MEMO
			STR			R0,[R5]
			B			CONT

FINISH		CMP 		R9, #0
			BNE 		FINISH			
			
			POP			{LR}
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END	
			
			
			
			
			
			
			
			
			
			
			