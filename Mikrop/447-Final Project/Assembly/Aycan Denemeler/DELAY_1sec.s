;SYMBOL		DIRECTIVE	VALUE			COMMENT
Delay		EQU			0x1E8480			;number of loops need for 1sec (=2000000)
	
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			EXPORT		DELAY_1sec

;LABEL		DIRECTIVE	VALUE			COMMENT

DELAY_1sec	
			PUSH		{R0}

			LDR			R0,=Delay			
loop									;Each loop took 0.500 �s 
			SUBS		R0,R0,#1		;0.083 �s
			NOP							;0.083 �s
			NOP							;0.083 �s
			NOP							;0.083 �s
			NOP							;0.083 �s
			NOP							;0.083 �s
			BNE			loop			;0.250 �s

			POP			{R0}

			BX			LR
			
			ALIGN
			END