;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
Field_Address		EQU			0x20000400

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
			EXPORT  	__main					; Make available

;***************************************************************
;	Main Function
;***************************************************************	
;LABEL		DIRECTIVE	VALUE					COMMENT
__main		PROC
			
			LDR			R5,=Field_Address		
			BL			EMP_FIELD
			BL			SPI_CONFIG
			
	
	
			
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ENDP
			ALIGN
			END