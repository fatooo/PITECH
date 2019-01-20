INIT        

; System clock properties FOR 40 MHz        


; reg RCC2-> bit 30 DIV400=1->SYSDIV2LSB & SYSDIV2 CREATE A 7 BIT DIVISOR USING THE 400 MHz PLL OTPUT        
USE_RCC2    ;reg RCC2->bit 31 USERCC2=1-> THE RCC2 REGISTER FIELDS OVERRIDE THE RCC REGISTER FIELDS
            LDR R1, =SYSCTL_RCC2_R
            LDR R0, [R1]
            ORR R0, #SYSCTL_RCC2_USERCC2
            STR R0, [R1]

;bypass PLL while initializing
BYPASS        ;BYPASS PLL WHILE INITIALIZING
            LDR R1, =SYSCTL_RCC2_R
            LDR R0,[R1]
            ORR R0, #SYSCTL_RCC2_BYPASS2
            STR R0, [R1]
;configure for 16 MHz crystal            
XTAL_16MHZ    ;reg RCC->bit 10-6 XTAL=0XD-> XTAL =16 MHZ
            LDR R1, =SYSCTL_RCC_R
            LDR R0,[R1]
            BIC R0, #0x7C0 ; CLEAR XTAL FIELD
            ORR R0, #0x540 ;16 MHz CRYSTAL
            STR R0, [R1]
;configure for main oscillator source            
MOSC        ;reg RCC2->bit 6-4 OSCSRC2=0-> SELECT INPUT SOURCE FOR THE OSC = MOSC
            LDR R1, =SYSCTL_RCC2_R
            LDR R0,[R1]
            BIC R0, #SYSCTL_RCC2_OSCSRC2_M 
            ORR R0, #SYSCTL_RCC2_OSCSRC2_MO
            STR R0, [R1]
;activate PLL by clearing PWRDN
PLL_ON        ;reg RCC2->bit 13 PWRDN2=0-> THE PLL IS ON
            LDR R1, =SYSCTL_RCC2_R
            LDR R0,[R1]
            BIC R0, #0x2000
            STR R0, [R1]
;use 400 MHz PLL    
DIV400    ; reg RCC2-> bit 30 DIV400=1->SYSDIV2LSB & SYSDIV2 CREATE A 7 BIT DIVISOR USING THE 400 MHz PLL OTPUT            
            LDR R1, =SYSCTL_RCC2_R
            LDR R0, [R1]
            ORR R0, #SYSCTL_RCC2_DIV400
            STR R0, [R1]
;configure for 50 MHz clock
SYSDIV2        ;reg RCC2->bit 28-23 SYSDIV2=0x02-> SELECT INPUT SYSTEM CLOCK DIVISOR = 10    
            LDR R1, =SYSCTL_RCC2_R
            LDR R0,[R1]
            BIC R0, #0x1FC00000
            ORR R0, #0x01C00000
            STR R0, [R1]

;wait for the PLL to lock by polling PLLLRIS
PLL_LOCK_WAIT    ;WAIT FOR PLL LOCK                            
            LDR R1, =SYSCTL_PLLSTAT_R
            
READ_PLLSTAT
            LDR R0,[R1]
            CMP R0, #0x01
            BNE READ_PLLSTAT

;enable use of PLL by clearing BYPASS        
CLR_BYPASS2    ;reg RCC2->bit 11 BYPASS2=0-> SYSTEM CLOCK IS USED DIVIDED BY THE DIVISOR SPECIFIED BY SYSDIV2
            LDR R1, =SYSCTL_RCC2_R
            LDR R0,[R1]
            BIC R0, #SYSCTL_RCC2_BYPASS2
            STR R0, [R1]
            
;SPI0    properties - 2,5 MHZ SPH=0 SPO=0


;ACTIVATE SSI0
            MOV R0, #0x01
            LDR R1, =SYSCTL_RCGCSSI_R
            STR R0, [R1]

;ACTIVATE PORT A
            MOV R0, #0x01
            LDR R1, =SYSCTL_RCGCGPIO_R
            STR R0, [R1]

;ALLOW TIME TO FINISH ACTIVATING
            NOP
            NOP
            NOP
            NOP
            NOP

;MAKE PA6,7 OUT
            MOV R0, #0xC0
            LDR R1, =GPIO_PORTA_DIR_R
            STR R0, [R1]

;ENABLE ALT FUCNT ON PA2,3,5
            MOV R0, #0x2C
            LDR R1, =GPIO_PORTA_AFSEL_R
            STR R0, [R1]

;DISABLE ALT FUNCT ON PA6,7
            LDR R1, =GPIO_PORTA_AFSEL_R
            LDR R0, [R1]
            BIC R0, #0xC0
            STR R0, [R1]

;ENABLE DIGITAL IO ON PA2,3,5,6,7
            MOV R0, #0xEC
            LDR R1, =GPIO_PORTA_DEN_R
            STR R0, [R1]

;CONFIGURE PA6,7 AS GPIO; 2,3,6 AS SSI
            LDR R1, =GPIO_PORTA_PCTL_R
            LDR R0, [R1]
            MOV32 R2, #0xFF0F00FF
            AND R0,R0,R2
            MOV32 R2, #0x00202200
            ORR R0, R0, R2
            STR R0, [R1]

;DISABLE ANALOG FUNCTIONALITY ON PA2,3,5,6,7
            LDR R1, =GPIO_PORTA_AMSEL_R
            LDR R0, [R1]
            BIC R0, #0xEC

;DISABLE SSI
            LDR R1, =SSI0_CR1_R
            LDR R0, [R1]
            BIC R0, #SSI_CR1_SSE
            STR R0, [R1]

;MASTER MODE 
            LDR R1, =SSI0_CR1_R
            LDR R0, [R1]
            BIC R0, #SSI_CR1_MS
            STR R0, [R1]

;CONFIGURE FOR PLL BAUD CLOCK SOURCE
            LDR R1, =SSI0_CC_R
            LDR R0, [R1]
            BIC R0, #0xF
            STR R0, [R1]

;SYSCLK=40MHZ
;SPICLK=SYSCLK/(CPSRDVSR*(SCR+1))
;SPICLK=40/(4*(3+1))=2.5
;SET CPSRDVSR=4
            MOV R0, #0x04
            LDR R1, =SSI0_CPSR_R
            STR R0, [R1]

;SCR=3
            LDR R1, =SSI0_CR0_R
            LDR R0, [R1]
            BIC R0, #0xFF00
            ORR R0, #0x0300
            STR R0, [R1]

;SPH=0 ;SPO=0
            LDR R1, =SSI0_CR0_R
            LDR R0, [R1]
            BIC R0, #SSI_CR0_SPH
            BIC R0, #SSI_CR0_SPO
            STR R0, [R1]

;FRF=0 FREESCALE SPI
            LDR R1, =SSI0_CR0_R
            LDR R0, [R1]
            BIC R0, #0x30
            STR R0, [R1]

;DSS = 8 BIT DATA
            LDR R1, =SSI0_CR0_R
            LDR R0, [R1]
            BIC R0, #SSI_CR0_DSS_M
            ORR R0, #SSI_CR0_DSS_8
            STR R0, [R1]

;ENABLE SSI
            LDR R1, =SSI0_CR1_R
            LDR R0, [R1]
            ORR R0, #SSI_CR1_SSE
            STR R0, [R1]

;RESET THE LCD TO A KNOWN STATE
            MOV R0, #0x00
            LDR R1, =GPIO_PORTA_DATA_R
            STR R0, [R1]

;DELAY MIN 100 NS
            NOP
            NOP
            NOP
            NOP
            NOP

;RESET HIGH (NEGATIVE LOGIC)
            MOV R0, #0x80
            LDR R1, =GPIO_PORTA_DATA_R
            STR R0, [R1]
            
            NOP
            NOP
            NOP
            NOP
            NOP

;SET LCD Vop
            

            
            MOV R0, #0x21
            LDR R1, =SSI0_DR_R
            STR R0, [R1]
            


;0xB1,0xBF,0x80,0xFF, TWEAKING
            MOV R0, #0xB1
            LDR R1, =SSI0_DR_R
            STR R0, [R1]
            


;SET TEMP COEFFICIENT
            MOV R0, #0x04
            LDR R1, =SSI0_DR_R
            STR R0, [R1]
            


;LCD BIAS MODE
            MOV R0, #0x14
            LDR R1, =SSI0_DR_R
            STR R0, [R1]
            


;WE MUST SEND 0x20 BEFORE MODIFYING THE DISPLAY CONTROLE MODE
            MOV R0, #0x20
            LDR R1, =SSI0_DR_R
            STR R0, [R1]
            


;SET DISPLAY CONTROL TO NORMAL MODE
            
            MOV R0, #0x0D
            LDR R1, =SSI0_DR_R
            STR R0, [R1]

            LDR R1, =GPIO_PORTA_DATA_R
            LDR R0, [R1]
            BIC R0, #0xF0
            ORR R0, #0x40
            STR R0, [R1]
            
            MOV R0, #0x7F
            LDR R1, =SSI0_DR_R
            STR R0, [R1]
LABEL        B LABEL