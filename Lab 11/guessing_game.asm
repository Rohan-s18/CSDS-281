; Author Rachel Tjarksen
; rst68@case.edu
; guessing_game.asm

	
; CPU configuration
; (16F84 with RC osc, watchdog timer off, power-up timer on)

	processor 16f84A
	include <p16F84A.inc>
	__config _RC_OSC & _WDT_OFF & _PWRTE_ON

; Using the macros from the thunderbird asm file

IFSET macro fr,bit,label ;test if a certain bit in a certain file register is equal to 1, if not equal branch to label
	btfss fr,bit ; if (fr.bit) then execute code following macro
	goto label ; else goto label	
      endm

IFCLR macro fr,bit,label ;test if a certain bit in a certain file register is equal to 0, if not equal branch to label
	btfsc fr,bit ; if (! fr.bit) then execute code following macro
	goto label ; else goto label
	  endm

IFEQ macro fr,lit,label ;test if the current value of the file regiser is equal to the literal, if not branch out to label
	movlw lit
	xorwf fr,W
	btfss STATUS,Z ; (fr == lit) then execute code following macro
	goto label ; else goto label
	 endm

IFNEQ macro fr,lit,label ;test if the current value of the file regiser is not equal to the literal, if equal then branch out to label
	movlw lit
	xorwf fr,W 
	btfsc STATUS,Z ; (fr != lit) then execute code following macro
	goto label ; else goto label
	 endm

MOVLF macro lit,fr ;write something to the file register. copy to working than working to file
	movlw lit
	movwf fr
	  endm

MOVFF macro from,to ;copy the content of one file register to another through the working register
	movf from,W
	movwf to
  	  endm

; file register variables

nextS equ 0x0C 	; next state 
octr equ 0x0D	; outer-loop counter for delays
ictr equ 0x0E	; inner-loop counter for delays
 
; input bits
G1 equ 0 ;RA0
G2 equ 1 ;RA1
G3 equ 2 ;RA2
G4 equ 3 ;RA3
 
 ; "One-hot" encoded state definitions 
S1 equ B'000001' ; L1 is on
S2 equ B'000010' ; L2 is on
S3 equ B'000100' ; L3 is on
S4 equ B'001000' ; L4 is on
SE equ B'010000' ; Error light is on (Incorrect Guess)
SO equ B'100000' ; Win light is on (Correct guess)
 
 
;-------------------------------------------------------Actual Code is Here-----------------------------------------------

	org 0x00	
reset:	goto	init	

	org	0x08 	; beginning of user code
init:	
; Don't need to configure input pins
    
; Configuring RB5-0 as output pins
    bsf STATUS, RP0
    movlw B'11000000'
    movwf TRISB 
    bcf STATUS, RP0


MOVLF S1, nextS ;S1 is starting state
    
mloop:	; main loop
    
    stateChange:
    ;We always come to this line after a state change
    MOVFF nextS, PORTB 
    goto delay
    
    ;We come here after every 'delay' call
    ;This segment of code tells us what state we are currently in and it branches out to that state block
    StateChecker:
    ;Here I am comparing the PORTB Pins with the State Literals to see what stte we are in
    IFNEQ PORTB, S1, State1Block        
    IFNEQ PORTB, S2, State2Block
    IFNEQ PORTB, S3, State3Block
    IFNEQ PORTB, S4, State4Block
    IFNEQ PORTB, SO, StateOKBlock
    goto StateERBlock
   
    ;these are my possible states S1-S4, SOK, SER
    ;in them I compute the next state equations the go to the proper setter label
    ;in order to set the next state
    
;Helper labels to get to SER/SOK
    
SOKHelper:
    MOVLF SO, nextS
    goto stateChange

SERHelper:
   MOVLF SE, nextS
   goto stateChange

State1Block: 
    IFCLR PORTA, G4, SERHelper
    IFCLR PORTA, G3, SERHelper
    IFCLR PORTA, G2, SERHelper
    IFCLR PORTA, G1, SOKHelper
    MOVLF S2, nextS
    goto stateChange
    
    
State2Block: 
    IFCLR PORTA, G4, SERHelper
    IFCLR PORTA, G3, SERHelper
    IFCLR PORTA, G1, SERHelper
    IFCLR PORTA, G2, SOKHelper
    MOVLF S3, nextS
    goto stateChange
    
    
State3Block: 
    IFCLR PORTA, G4, SERHelper
    IFCLR PORTA, G2, SERHelper
    IFCLR PORTA, G1, SERHelper
    IFCLR PORTA, G3, SOKHelper
    MOVLF S4, nextS
    goto stateChange
    
State4Block: 
    IFCLR PORTA, G3, SERHelper
    IFCLR PORTA, G2, SERHelper
    IFCLR PORTA, G1, SERHelper
    IFCLR PORTA, G4, SOKHelper
    MOVLF S1, nextS
    goto stateChange
    
StateOKBlock:
    IFCLR PORTA, G4, SOKHelper
    IFCLR PORTA, G3, SOKHelper
    IFCLR PORTA, G2, SOKHelper
    IFCLR PORTA, G1, SOKHelper
    MOVLF S1, nextS
    goto stateChange
     
StateERBlock: 
    IFCLR PORTA, G4, SERHelper
    IFCLR PORTA, G3, SERHelper
    IFCLR PORTA, G2, SERHelper
    IFCLR PORTA, G1, SERHelper
    MOVLF S1, nextS
    goto stateChange

;following labels are simple setters for the next state


    

    

       		
delay: ; create a delay of about 0.9 seconds
	MOVLF	d'32',octr ; initialize outer loop counter to 32 (2 times 16)
d1:	clrf	ictr	; initialize inner loop counter to 256
d2: decfsz	ictr,F	; if (--ictr != 0) loop to d2
	goto 	d2		 	
	decfsz	octr,F	; if (--octr != 0) loop to d1 
	goto	d1 
	goto StateChecker
;DELAY around 986.2 ms
	
endloop: ; end of main loop
	goto	mloop

	end		; end of program code

