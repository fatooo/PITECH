					AREA			main, CODE, READONLY
					THUMB
					ALIGN
					EXTERN			PULSE_INIT
					;EXPORT			__main
						
__main	
					BL				PULSE_INIT
loop				WFI
					B				loop
					END