;******************************************************************************
;*
;* Dateinname:		    Tastencounter03.asm
;* Version:			    1.0	
;*
;*Copyright (c) 2014, Fliiiix
;*All rights reserved.
;*
;*Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
;*
;*1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
;*
;*2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
;*
;*THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
;*THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
;*INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
;*HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
;*THE POSSIBILITY OF SUCH DAMAGE. 
;******************************************************************************

;*** Kontrollerangabe ***
.include "m8515def.inc"

		RJMP	Reset


;*** Konstanten ***
.equ	LED		    = PORTB		; Ausgabeport fuer LED
.equ	LED_D	    = DDRB		; Daten Direction Port fuer LED

.equ	SWITCH	    = PIND		; Eingabeport fuer SWITCH
.equ	SWITCH_D	= DDRD		; Daten Direction Port fuer SWITCH

;*** Variablen ***
.def 	mpr	        = R16		; Multifunktionsregister
.def	mpr1		= R17		; Multifunktionsregister



;******************************************************************************
; Hauptprogramm
;******************************************************************************

;*** Initialisierung ***
Reset:	SER	    mpr			        ; Output:= LED
		OUT	    LED_D, mpr

		CLR	    mpr			        ; Input:= Schalterwerte
		OUT	    SWITCH_D, mpr

		LDI	    mpr, LOW(RAMEND)    ; Stack initialisieren
		OUT	    SPL,mpr
		LDI	    mpr, HIGH(RAMEND)
		OUT	    SPH,mpr


;*** Hauptprogramm ***	
Main:	
		CLR		mpr						; clean register
		CLR		mpr1					; clean register

		IN		mpr, SWITCH				; load input value

COUNT:									; count pressed keys
		LSR		mpr						; shift values to the right
		BRCS	ADDONE					; add +1 to end resultat
		
		CPI		mpr, 0x00				; if null
		BRNE	COUNT					; loop with count if not 0x00

		OUT		LED, mpr1				; write to LED

		RJMP	Main					; while true loop	



;******************************************************************************
; Unterprogramme
;******************************************************************************
ADDONE:
		INC		mpr1					; +1 to ouput register
		RJMP	COUNT