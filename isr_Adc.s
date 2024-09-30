
;******************************************************************************
;                                                                             *
;    Filename            :  isr_adc.s                                         *
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

.include "p30f4013.inc"


;Global Declarations for routines in Program Memory 
.global __ADCInterrupt

;Global Declarations for variables in Data Memory 
.global   _PotRP1
.global   _PotRP2
.global   TempSens


;Memory Allocation for variables in Data Memory 
.section .data
PotRP1:   .space 2
PotRP2:   .space 2
TempSens:  .space 2
adc_ptr: .space 2
adc_temp:  .space 512
adc_temp_fin: .space 2

	.global adc_temp,PotRP1,PotRP2, TempSens


;User code section in Program Memory
.section .text

__ADCInterrupt:
	push.d w0
    push w4

	  	bset   LATC,#RC13		; impulsion de test.
		bclr   LATC,#RC13

	mov   ADCBUF0, w1	   	; Save off the Potentiometer and 
	MOV   #0X41,W1						; Temperature sensor values
	mov   w1, U2TXREG
			
	mov   ADCBUF1, w1
	mov   w0, PotRP1

	mov   ADCBUF2, w1
	mov   w0, PotRP1
	
	mov   ADCBUF3, w1
	mov   w0, PotRP1


	;mov       adc_ptr,w4			;lecture de AN6
	;mov   w1,[w4++]
	;mov	  w4,adc_ptr
	
	;moV  #adc_temp_fin,w0
	;CP   w4,w0
	;bra  LT, exit				; fin de table?
	;mov #adc_temp,w4			; remise début de table


exit:
		bset   LATC,#RC13		; impulsion de test.
		bclr   LATC,#RC13

	bclr  ADCON1,#0			; reset bit DONE
	bclr  IFS0, #ADIF       ; reset interrupt flag
	pop w4
	pop.d w0

	retfie

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

      
    
