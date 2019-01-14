;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
SYSCTL_RCGCGPIO		EQU			0x400FE608 		;Enable GPIO
GPIO_PORTA_DIR  	EQU			0x40004400 		;Direction reg
GPIO_PORTA_AFSEL	EQU			0x40004420 		;Alternate function
GPIO_PORTA_PCTL		EQU			0x4000452C		;Port Control
GPIO_PORTA_DEN	    EQU			0x4000451C		;Digital enable
	
SYSCTL_RCGCSSI		EQU			0x400FE61C		;Enable SSI
SSI0_CR0			EQU			0x40008000		;SSI Control 0
SSI0_CR1			EQU			0x40008004		;SSI Control 1
SSI0_CPSR			EQU			0x40008010		;Clock Prescale
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
			AREA		main, CODE, READONLY
			THUMB
			ALIGN
			EXPORT		SPI_CONFIG

;***************************************************************
;	Main Function
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
SPI_CONFIG	PROC
	
GPIO_INIT	LDR 		R1,=SYSCTL_RCGCGPIO		; Initalize Clock
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x01 
			STR			R0,[R1]
			NOP 
			NOP
			NOP			
			NOP 								; let GPIO clock stabilize 	
	
			LDR 		R1,=GPIO_PORTA_DIR		;Set Direction of Pins
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x2C				;PA2,PA3,PA5 are output
			BIC			R0,R0,#0x10				;PA4 is input
			STR			R0,[R1]
			
			LDR 		R1,=GPIO_PORTA_DEN		;Digitally enable ports
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x3C 
			STR			R0,[R1]
			
			LDR 		R1,=GPIO_PORTA_AFSEL	;Enable Alternate Functions
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x3C 
			STR			R0,[R1]
			
			LDR 		R1,=GPIO_PORTA_PCTL		;Route SSI interface to pins
			LDR 		R0,[R1]
			LDR			R2,=0x222200
			ORR 		R0,R0,R2			
			STR			R0,[R1]
	

SPI_INIT	LDR 		R1,=SYSCTL_RCGCSSI		; Initalize Clock
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x01 
			STR			R0,[R1]
			NOP 
			NOP
			NOP			
			NOP 
			NOP
			
			LDR 		R1,=SSI0_CR1			;Disable SSI interface
			LDR 		R0,[R1]
			BIC 		R0,R0,#0x02 
			STR			R0,[R1]
	
	
	
	
	
			BX			LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END