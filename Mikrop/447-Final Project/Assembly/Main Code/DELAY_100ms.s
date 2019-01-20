;SYMBOL		DIRECTIVE	VALUE			COMMENT
Delay		EQU			0x30D40			;number of loops need for 100ms (=200000)
	
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		routines,READONLY,CODE
			THUMB
			EXPORT		DELAY_100ms

;LABEL		DIRECTIVE	VALUE			COMMENT

DELAY_100ms	
			PUSH		{R0}

			LDR			R0,=Delay			
loop									;Each loop took 0.500 탎 
			SUBS		R0,R0,#1		;0.083 탎
			NOP							;0.083 탎
			NOP							;0.083 탎
			NOP							;0.083 탎
			NOP							;0.083 탎
			NOP							;0.083 탎
			BNE			loop			;0.250 탎

			POP			{R0}

			BX			LR
			
			ALIGN
			END