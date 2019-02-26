;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT


OUT_PORTB_DC		EQU			0x40005008		;00000010
OUT_PORTB_RESET		EQU			0x40005004		;00000001
SSI0_DR				EQU			0x40008008
SSI0_SR				EQU			0x4000800C
	
EMPTY_FIELD			EQU			0x20000400		;400-5F7
PLAYFIELD			EQU			0x20000600		;600-7F7
SHIP_EMPTY			EQU			0x20000800		;800-807
SHIP_CIVIL			EQU			0x20000808		;808-80F
SHIP_BATTLE			EQU			0x20000810		;810-817
OLD_SHIP_LOC_X		EQU			0x20001000		;1000
OLD_SHIP_LOC_Y		EQU			0x20001001		;1001	
SHIP_MEMO			EQU			0x20001100		;1100-1149
CURSOR_MEMO			EQU			0x20001150		;1150-1199
	
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
		
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA    	main, READONLY, CODE, ALIGN=2
			THUMB
				
			EXTERN		EMP_FIELD
			EXTERN		SPI_CONFIG
			EXTERN		SCREEN_INIT
			EXTERN		DELAY_100ms
			EXTERN		DELAY_1ms
			EXTERN		IREM_CO
			EXTERN		DATA_WRITE
			EXTERN		INIT_SYSTICK
			EXTERN		My_SYSTICK
			EXTERN		ADDRESS_CHANGE
			EXTERN 		PUSHBUTTON
			EXTERN 		PORTF_INIT
			EXTERN 		ADC_INIT
			EXTERN 		WINNER
			EXTERN 		WINORLOSE
			EXTERN 		PLAYER2_PUSHBUTTON 
			EXTERN 		MEMORY_MAP
			EXTERN 		ADC_READ_SHIP
			EXTERN		PLAYER_1
			EXTERN		PLAYER_2
			EXTERN		PLAYER2S_TURN
			EXTERN		PLAYER1S_TURN
			EXTERN     Battleship
			EXPORT  	__main					; Make available

;***************************************************************
;	Main Function
;	CE - PA3
;	Din- PA5
;	CLK- PA2
;	RST- PB0
;	DC - PB1
;  	PE1- ADC XDATA POT
; 	PE2- ADC YDATA POT
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
__main		PROC
			BL 			MEMORY_MAP
			BL			SPI_CONFIG
			BL 			SCREEN_INIT
			BL 			ADC_INIT
			BL   		PORTF_INIT	
			BL          Battleship
			BL 			PLAYER1S_TURN
			LDR 		R4, = 0x00 
			BL 			ADDRESS_CHANGE 
			LDR 		R0,=0x1F8
			LDR 		R5,=EMPTY_FIELD
LOOP  		LDRB 		R4,[R5],#1
			BL 			DATA_WRITE
			SUBS 		R0,R0,#1
			BNE 		LOOP			
			BL			PLAYER_1
			BL 			PLAYER2S_TURN
			BL			PLAYER_2


END_code	
			B			__main
			
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END