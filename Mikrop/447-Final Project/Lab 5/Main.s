;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT

ADC0_ACTSS			EQU			0x40038000 		; Active Sample Sequencer
ADC0_SSCTL3			EQU			0x400380A4 		; Sample Sequence Control 3
ADC0_EMUX			EQU			0x40038014 		; Event Multiplexer Select
ADC0_SSMUX3			EQU			0x400380A0 		; SS Input Mux. Select 3
ADC0_PC				EQU 		0x40038FC4 		; Peripheral Control
ADC0_PSSI			EQU			0x40038028 		; Processor SS Initiate	
ADC0_RIS			EQU			0x40038004 		; Raw Interrupt Status
ADC0_SSFIFO3		EQU			0x400380A8 		; SSFIFO3 Buffer Reg. (Value of Oldest Sample)		
ADC0_ISC			EQU			0x4003800C 		; Interrupt Status Clear				

Data_address		EQU			0x20000400

;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************	
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
		
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA    	main, READONLY, CODE, ALIGN=2
			THUMB
			EXTERN		CONVRT
			EXTERN		OutStr
			EXTERN		ADC_INIT
			EXPORT  	__main					; Make available


;***************************************************************
;	Main Function
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
__main		PROC
			BL			ADC_INIT				;initialize ADC
			MOV			R6, #0x80				;Register to store past reading
			
start		LDR			R5, =ADC0_PSSI			; set bit 3 to start SS3 for ADC0
			LDR			R0, [R5]
			ORR			R0, R0, #0x08
			STR			R0, [R5]
							

read		LDR			R5, =ADC0_RIS
			LDR			R0, [R5]
			TEQ			R0, #0x08				; since ADC0 uses SS3 in this example, check for bit3
;			BNE			read

			LDR			R5, =ADC0_SSFIFO3
			LDR			R1, [R5]				; read the value from FIFO3	
			
			LDR			R5, =ADC0_ISC
			MOV			R0, #0x08
			STR			R0, [R5]				; clear bit 3 for SS3 of ADC0
			
					
			
			
compare		ADD			R2,R6,#0xF9				; Add 0.2 V to read value			
			SUBS		R2,R2,R1				; Subtract new value from old value + 0.2 V
			BMI			Hex2X					; if new value is more than 0.2 V higher writes the value
			SUB			R2,R6,#0xF9				; subtracts 0.2 V from read value
			SUBS		R2,R2,R1				; Subtract new value from old value + 0.2 V
			BPL			Hex2X					; if new value is more than 0.2 V lower writes the value
			B			start					; if the change is smaller than 0.2 V
			
			
Hex2X		MOV			R6,R1					;Archive the new read value
			MOV			R2,	#0
loop
								;our X value
			CMP			R1, #0x4D8				;Compare with 1V threshold to find X value
			BMI			Hex2YZ					;If smaller, then find YZ component
			ADD			R2,R2,#1				;increase X by one
			SUB			R1,R1,#0x4D9			;subract 1 Volt from read value
			B			loop
			
Hex2YZ		MOV			R0,#0xD
			UDIV		R3,R1,R0				; divide remaining part of read to obtain YZ
			
XYZ			LDR			R5, =Data_address	
			MOV			R4,R2					
			BL			CONVRT					; Convert X value to ASCII and updates data address
			MOV			R0, #0x2E				; ASCII code of dot
			STR			R0,[R5],#1
			
			CMP			R3,#10
;			BMI			dual
;			MOV			R0, #0x30
;			STR			R0,[R5],#1
			
dual		MOV			R4,R3
			BL			CONVRT
			MOV			R0, #0x0D				;ASCII code for end of line
			STR			R0,[R5],#1
			MOV			R0, #0x04				;ASCII code of end of transmission
			STR			R0,[R5],#1
			
			LDR			R5, =Data_address		;reset data adress
			BL			OutStr					
			
			B			start
			
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END