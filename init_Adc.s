
;******************************************************************************
;                                                                             *
;    Filename            :  init_adc.s                                        *
;    Date                :  05/17/2004                                        *
;    File Version        :  1.0                                               *
;                                                                             *
;    Other Files Required: p30F6014.gld, p30f6014.inc                         *
;    Tools Used:MPLAB IDE       : 6.50.00                                     *
;               ASM30 Assembler : 1.20.01                                     *
;               Linker          : 1.20.01                                     *
;                                                                             *
;                                                                             *
;******************************************************************************
;    Additional Notes:                                                        *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************

; -----------------------------------------------------------------------------
;    INCLUDE FILES
; -----------------------------------------------------------------------------
		.include "p30f4013.inc"
		.include "device_Fcy.inc"


; -----------------------------------------------------------------------------
;    Global Declarations
; -----------------------------------------------------------------------------
		.global  _Init_ADC
		
		
 		.text

; -----------------------------------------------------------------------------
; Subroutine: Initialization of ADC Module
; -----------------------------------------------------------------------------
_Init_ADC:
		push  w0
 		clr   ADCON1               ; ensure registers to known state
 		clr   ADCON2
 		clr   ADCON3
 		clr   ADCHS
 		clr   ADCSSL     

; set port configuration here 		
 		bclr  ADPCFG, #PCFG0       ; ensure AN3/RB3 is analog
 	 	bclr  ADPCFG, #PCFG1       ; ensure AN4/RB4 is analog
 	 	bclr  ADPCFG, #PCFG2       ; ensure AN5/RB5 is analog
		bclr  ADPCFG, #PCFG8
 
; set channel scanning here 	
 		mov   #0x80E4, w0          ; auto sampling and convert
 		mov   w0, ADCON1           ; with default read-format mode
 
; Scan for CH0+, Use MUX A, BUFM = 0 (one 16-word buffer), SMPI = 4 per interrupt
		mov   #0x040C, w0
		mov   w0,  ADCON2
				
; A/D Conversion Tad ( minimum Tad = 667nS )
; Autosampling of 3 Tad	

;.if  XTx4PLL          ; Tcy = 135ns, so 12/2 * Tcy = Tad min
;		mov   #0x0A12, w0
;.endif/

;.if   XTx8PLL         ; Tcy = 68ns, so 24/2 * Tcy = Tad min
;		mov   #0x0A12, w0
;.endif

;.if   XTx16PLL        ; Tcy = 34ns, so 46/2 * Tcy = Tad min
		mov   #0x100F, w0
;.endif
 	
		mov   w0,  ADCON3
;ADCPCFG		
		mov   #0xFEF8, w0
 		mov   w0, ADPCFG 
; set channel scanning here 	
 		mov   #0x0107, w0
 		mov   w0, ADCSSL           ; scan for AN0, AN1 and AN2  AN8

		bclr  IFS0, #ADIF		  ; clear the interrupt flag
		bset  IEC0, #ADIE		  ; enable interrupt

		mov   #adc_temp,w4	
		
		bset  ADCON1, #ADON       ; enable ADC		
 		pop   w0
    
		return

		.end

;*********************************************************************
;                                                                    *
;                       Software License Agreement                   *
;                                                                    *
;   The software supplied herewith by Microchip Technology           *
;   Incorporated (the "Company") for its dsPIC controller            *
;   is intended and supplied to you, the Company's customer,         *
;   for use solely and exclusively on Microchip dsPIC                *
;   products. The software is owned by the Company and/or its        *
;   supplier, and is protected under applicable copyright laws. All  *
;   rights are reserved. Any use in violation of the foregoing       *
;   restrictions may subject the user to criminal sanctions under    *
;   applicable laws, as well as to civil liability for the breach of *
;   the terms and conditions of this license.                        *
;                                                                    *
;   THIS SOFTWARE IS PROVIDED IN AN "AS IS" CONDITION.  NO           *
;   WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING,    *
;   BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND    *
;   FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. THE     *
;   COMPANY SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL,  *
;   INCIDENTAL OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.  *
;                                                                    *
;*********************************************************************

; -----------------------------------------------------------------------------
;         END OF FILE
; -----------------------------------------------------------------------------
