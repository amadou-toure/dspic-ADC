;******************************************************************************
;                                                                             *
;******************************************************************************
;    Filename            :  In_ADC.s  
;                                                                             *
;    Author              :  Alain Royal                                       *
;    Company             :  Institut Teccart                                  *
;                                        *
;    Date                :  26/10/2006                                        *
;    File Version        :  1.20                                              *
;                                                                             *
;    Files Required: p30F6014.gld, p30f6014.inc                       		  *
;    Fichiers nécessaires:
;                                                *
;                Init_ADC.s                                        			  *
;				 isr_Adc.s
;																			  *
;    Tools Used:MPLAB GL : 6.60                                               *
;               Compiler : 1.10                                               *
;               Assembler: 1.10                                               *
;               Linker   : 1.10                                               *
;                                                                  	          *
;******************************************************************************
;																			  *
;******************************************************************************
; Description:                                                        		  *
;   Crétion d'un sinus à l'aide d'une table de données en mémoire programme	  *
;	avec le DCI et le Codec SI3021											  *
;                                                                             *
;******************************************************************************

        .equ __30F4013, 1
        .include "p30f4013.inc"
;		.include "\alain\travaux\DSPic\demo\dspicdem_v1_1\common.inc"


;..............................................................................
;Configuration bits:
;..............................................................................

       config __FOSC, CSW_FSCM_OFF & XT_PLL4    ;Turn off clock switching and
                                            ;fail-safe clock monitoring and
                                            ;use the External Clock as the
                                            ;system clock

 ;       config __FWDT, WDT_OFF              ;Turn off Watchdog Timer

;        config __FBORPOR, PBOR_ON & BORV_27 & PWRT_16 & MCLR_EN
                                            ;Set Brown-out Reset voltage and
                                            ;and set Power-up Timer to 16msecs
                                            
 ;       config __FGS, CODE_PROT_OFF         ;Set Code Protection Off for the 
                                            ;General Segment

;..............................................................................
;Program Specific Constants (literals used in code)
;..............................................................................

        .equ SAMPLES, 64         ;Number of samples

;..............................................................................
;Global Declarations:
;..............................................................................

        .global __reset          ;The label for the first line of code. 
		.global __INT1Interrupt

;..............................................................................
;Uninitialized variables in Near data memory (Lower 8Kb of RAM)
;..............................................................................

          .section .bss
Reserved: 	.space 0x24			; Espaces reservés 


;------------------------------------------------------------------------------
;Program Specific Constants (literals used in code)

	.equ	Fcy, #7372800

;===========================================================================================
;Code Section in Program Memory
;..............................................................................

.text                             ;Start of Code section
__reset:
        MOV #__SP_init, W15       ;Initalize the Stack Pointer
        MOV #__SPLIM_init, W0     ;Initialize the Stack Pointer Limit Register
        MOV W0, SPLIM
        NOP  
init:	
		rcall _Init_UART 
		;rcall _Init_PORTA
		rcall _Init_PORTC

		rcall _Init_ADC

main:

        BRA     main             


;========================================================================================
;========================================================================================
;Subroutine: Initialization de la page PSV  sur "SineTable"
;..............................................................................

;-------------------------------------------------------------------------------
_Init_PORTC:
	push w0
		mov #0xFFFF,w0
		mov w0,LATC
		mov #0x9fff,w0
		mov w0,TRISC
		bclr LATC,#RC13
	pop w0
	return
_Init_UART:
    
	    mov #0b1000000000000000, w0
	    mov w0,U2MODE
	    mov #0b0000010000000000, w0
	    mov w0,U2STA
	    mov #3, w0
	    mov w0, U2BRG
	    return
		
;-------------------------------------------------------------------------------
; Initialisation des interrupteurs "S1" avec INT1 et "S2" avec INT2.
;-------------------------------------------------------------------------------
_Init_PORTA:
		bclr IFS1,#INT1IF	; reset des "Flags"
		bclr IFS1,#INT2IF		
		bset TRISA,#12		; pin 12 et 13 en entrées
		bset TRISA,#13		
		bset IEC1,#INT1IE	; permission d'interruption
		bset IEC1,#INT2IE		
	return

;------------------------------------------------------------------------------
; Interruption
;------------------------------------------------------------------------------
__INT1Interrupt:
	push w0
		btg LATC,#RC13		; bascule l'état du led 1.


	bclr IFS1,#INT1IF	
	pop w0			
	retfie
;------------------------------------------------------------------------------
__INT2Interrupt:
	push w0
		btg LATC,#RC14


	bclr IFS1,#INT2IF		
	pop w0
	retfie


;--------End of All Code Sections ---------------------------------------------

.end                               ;End of program code in this file



