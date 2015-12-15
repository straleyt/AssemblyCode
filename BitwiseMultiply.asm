TITLE BitwiseMultiply.asm
; **********************************************************
; Program Description: CSCI 2525, assignment 6 extra credit
; Author: Tegan Straley
; Creation Date: October 22, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                       ;No global variables needed for this program
     promptMenu BYTE "1. Run the program 'Bitwise Multiply'",0
     promptExit BYTE "2. Quit",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1 or 2",0
     promptMultiplicand BYTE "The multiplicand being used is ",0
     promptMultiplier BYTE "The multiplier being used is ",0
     promptProduct BYTE "The product is ",0

     multiplicand DWORD 3d              
     multiplier DWORD 4d                 
                                        ; 7 * 47 = 329                
      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                		;zeroed out all the registers

     Menu:  
     call Crlf                                   	;start of Menu label
     mov eax, 15                                	;outputs menu color in white
     call SetTextColor

     mov edx, OFFSET promptMenu                		;outputs all the menu options to user
     call WriteString
     call Crlf
     mov edx, OFFSET promptExit
     call WriteString
     call Crlf
     mov edx, OFFSET promptChoice
     call WriteString

     mov al,0
     or al,1                		;to clear the zero flag

     call ReadInt           		;reads in the menu choice from user

     cmp eax,1
     jz Input1              		;if 1 goes to Input1
     cmp eax,2
     jz EndProgram          		;if 2 goes to EndProgram
     jnz Error              		;error message is read out when 1 or 2 is not inputted

     Error:                         ;Neither 1 or 2 was inputed
     mov edx, OFFSET promptError
     call WriteString
     call Crlf
     jmp Menu                       ;tells user valid options and jumps back to Menu again

     EndProgram:
     call WaitMsg 
     INVOKE ExitProcess,0           ;exits program

     Input1:
     call DisplayMandM             ;Display Multiplicand and Multiplier
     mov eax, multiplier           ;EAX = 47 to assignment specification
     mov ebx, multiplicand         ;EBX = 7 to assignment specification
     call BitwiseMultiply
     call DisplayProduct
     jmp Menu                      ;jumps back to menu

INVOKE ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplayMandM PROC USES EDX
;Procedure displays out to user what is filled in for multiplicand and multiplier in .data section. 
;(this procedure wasn't needed in the assignment just a nice addition)
;Receives: Nothing
;Returns: displayed out both what the multiplicand and multipler are
;Requires: Nothing

mov edx, OFFSET promptMultiplicand
call WriteString
mov eax, multiplicand
call WriteDec                               ;displays out unsigned decimal multiplicand
call Crlf
mov edx, OFFSET promptMultiplier
call WriteString
mov eax, multiplier
call WriteDec                               ;displays out unsigned decimal multiplier                               
call Crlf

RET                            				;returns next memory location saved after call of procedure
DisplayMandM ENDP                 			;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BitwiseMultiply PROC
;Procedure uses bitwise multipication and addition to get a resulting product
;Receives: EAX = multiplier EBX = multiplicand
;Returns: EAX = as final product 
;Requires: Nothing

mov edx, eax             		;EDX = multiplier
mov eax, 0               		;product will go into EAX. Should be empty to begin.

jz ENDOFPROCEDURE        		;if EBX = 0 the ZERO FLAG was set in last operation
								;jump if zero = skip past all the multiplication return 0 = EAX as product
L1:
     shr edx, 1                    ;lower most bit goes into CARRY FLAG
     jnc INCREASEMULTIPLICAND      ;jump is CARRY was 0
     add eax, ebx                  ;if CARRY was set, add highest bit into eax = product
                                   ;keeps adding EBX into EAX, EDX amount of times.
     INCREASEMULTIPLICAND:    
          shl ebx, 1               ;shift highest bit of EBX into CARRY, increases EBX by factor of 2 to offset how many times bit in EDX is seen
          jnc L1                   ;if EBX didn't shift anything to CARRY, go back to L1

ENDOFPROCEDURE:

RET                             	 ;returns next memory location saved after call of procedure
BitwiseMultiply ENDP                 ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplayProduct PROC
;Procedure displays out the end resulting product of the program
;Receives: EAX = product 
;Returns: displays out product 
;Requires: Nothing

mov edx, OFFSET promptProduct
call WriteString
call WriteDec
call Crlf

RET                                 ;returns next memory location saved after call of procedure
DisplayProduct ENDP                 ;end of procedure
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end main