TITLE GreatestCommonDivisor.asm
; **********************************************************
; Program Description: CSCI 2525, assignment 6
; Author: Tegan Straley
; Creation Date: October 19, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                       
     promptMenu BYTE "1. Run the program 'Greatest Common Divisor'",0
     promptExit BYTE "2. Quit",0
     promptRandom BYTE "1. Would you like to use randomly generated numbers ...",0
     prompt2numbers BYTE "2. Would you like to input your own numbers ...",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1 or 2",0
     promptNumber1 BYTE "Please enter one integer: ",0
     promptNumber2 BYTE "Please enter a second integer: ",0
     promptTooLarge BYTE "Reminder: integers can't be greater than 2147483647, lesser than -2147483648, or equal to zero!",0
     promptGCD BYTE "The GCD of ",0
     promptAnd BYTE " and ",0
     promptIs BYTE " is ",0
     number1 SDWORD ?
     number2 SDWORD ?
     savedNumber1 SDWORD ?
     savedNumber2 SDWORD ?
     greatestCommonD SDWORD ?
  
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     call Randomize                             ;seeds random generator
     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                 ;zeroed out all the registers

     Menu:  
     call Crlf                                  ;start of Menu label
     mov eax, 15                                ;outputs menu color in white
     call SetTextColor

     mov edx, OFFSET promptMenu                ;outputs all the menu options to user
     call WriteString
     call Crlf
     mov edx, OFFSET promptExit
     call WriteString
     call Crlf
     mov edx, OFFSET promptChoice
     call WriteString

     mov al,0
     or al,1                            		;to clear the zero flag

     call ReadInt                       		;reads in the menu choice from user

     cmp eax,1
     jz Input1                          		;if 1 goes to Input1
     cmp eax,2
     jz EndProgram                          	;if 2 goes to Input2
     jnz Error                            		;error message is read out when 1 or 2 is not inputted

     Error:                              		;Neither 1 or 2 was inputted
     mov edx, OFFSET promptError
     call WriteString
     call Crlf
     jmp Menu                       			;tells user valid options and jumps back to Menu again

     EndProgram:
     call WaitMsg 
     INVOKE ExitProcess,0           			;exits program

     Input1:
     call SubMenu
     jmp Menu                      				;jumps back to menu

INVOKE ExitProcess,0               				;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
subMenu PROC
;Procedure asks if user wants to get the GCD from randomly generated numbers or from entering
;Receives: Nothing
;Returns: Program executes the subsequent choice of how to generate the number1 and number2
;Requires: Nothing


     mov edx, OFFSET promptRandom                ;outputs all the menu options to user
     call WriteString
     call Crlf
     mov edx, OFFSET prompt2numbers
     call WriteString
     call Crlf
     mov edx, OFFSET promptChoice
     call WriteString

     mov al,0
     or al,1                					;to clear the zero flag

     call ReadInt           					;reads in the menu choice from user

     cmp eax,1
     jz Input1              					;if 1 goes to Input1
     cmp eax,2
     jz Input2              					;if 2 goes to Input2
     jnz Error              					;error message is read out when 1 or 2 is not inputted

     Error:                         			;Neither 1 or 2 was inputted
     mov edx, OFFSET promptError
     call WriteString
     call Crlf                 					;tells user valid options and jumps back to Menu again
                      
     Input1:                   					;user wants to use randomly generated numbers
     call Generate2num
     jmp FinishLabel

     Input2:                   					;user wants to input the numbers themselves
     call ReceiveInput

     FinishLabel:              					;both Input1 and Input2 should call GCD and DisplayGCD
     call GCD
     call DisplayGCD

RET                            ;returns next memory location saved after call of procedure
SubMenu ENDP                   ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ReceiveInput PROC
;Procedure asks user for two integers 
;Receives: Nothing
;Returns: first integer in number1 & second integer in number2
;Requires: Nothing

ASKNUMBER1:
 mov eax, 0
 mov edx, OFFSET promptTooLarge              ;displays the gentle reminder of acceptable numbers
 call WriteString
 call Crlf
 mov edx, OFFSET promptNumber1               ;prompts for number1
 call WriteString
 call Crlf
 call ReadInt                                ;receives possible number1 in EAX
 cmp eax, 0
 je ASKNUMBER1                               ;if input was larger/smaller than DWORD, EAX goes to 0
 mov number1, eax                            ;number1 = EAX
 mov savedNumber1, eax                       ;savedNumber1 = EAX (used for output in DisplayGCD procedure)
 call Crlf

 ASKNUMBER2:
 mov eax, 0
 mov edx, OFFSET promptTooLarge              ;displays the gentle reminder of acceptable numbers
 call WriteString
 call Crlf
 mov edx, OFFSET promptNumber2               ;prompts for number2
 call WriteString
 call Crlf
 call ReadInt                                ;receives possible number2 in EAX
 cmp eax, 0
 je ASKNUMBER2                               ;if input was larger/smaller than DWORD, EAX goes to 0
 mov number2, eax                            ;number2 = EAX
 mov savedNumber2, eax                       ;savedNumber1 = EAX (used for output in DisplayGCD procedure)
 call Crlf


RET                             	;returns next memory location saved after call of procedure
ReceiveInput ENDP                 ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Generate2num PROC
;Procedure sets two randomly generated numbers between -1250 and +1250 as number1 and number2
;Receives: Nothing
;Returns: two randomly generated numbers between -1250 and +1250 as number1 and number2
;Requires: Nothing

mov eax, 2501                 ;RandomRange will be from 0 to 2500
call RandomRange
sub eax, 1250                 ;random number between -1250 and 1250
mov number1, eax              ;set number1 from EAX
mov savedNumber1, eax


mov eax, 2501                 ;RandomRange will be from 0 to 2500
call RandomRange
sub eax, 1250                 ;random number between -1250 and 1250
mov number2, eax              ;set number2 from EAX
mov savedNumber2,eax

RET                             	;returns next memory location saved after call of procedure
Generate2num ENDP                 	;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GCD PROC 
;Procedure makes both number1 and number2 positive, then by division finds the GCD of the two integers
;Receives: number1, number2
;Returns: eax = the greatestCommonD (GCD)
;Requires: number1 and number2 to have SDWORD integers

cmp number1, 0
jge CHECK2                    ;is number1 positive? if yes, jump to check number2
neg number1                   ;if it negative, negate it!
CHECK2:
cmp number2,0
jge DONTNEGATE                ;is number2 positive? if yes, jump to finding the GCD
neg number2                   ;if it negative, negate it!


DONTNEGATE:
mov eax, number1              ;EAX = number1
mov ebx, number2              ;EBX = number2
mov edx, 0                    ;remainder is set to 0

cmp eax, ebx                  ;is number1 < number2 ?
jg L1                         ;we want eax to be the larger number
     mov eax, number2         ;swap to make EAX be larger... EAX = number2
     mov ebx, number1         ;EBX = number1

L1:
     mov edx, 0
     div ebx                       ; EAX/EBX => answer in EAX, remainder in EDX
     cmp edx, 0                    ;is the remainder (EDX) = 0 ?
     jle L2                        ;if it is, we have found the GCD! jump lower or equal
     mov eax, ebx                  ;if still remainder.. make previous divisor now dividend , EAX <= EBX (that's an arrow)
     mov ebx, edx                  ;if still remainder.. make remainder the new divisor , EBX <= EDX (that's an arrow)
     jmp L1

     L2:
          mov greatestCommonD, ebx      ;greatestCommonD is the GCD of number1 and number2



RET                             ;returns next memory location saved after call of procedure
GCD ENDP                 		;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplayGCD PROC
;Procedure displays out the greatest common divisor of number1 and number2
;Receives: greatestCommonD in EAX
;Returns: Nothing, just outputs to the screen
;Requires: number for greatestCommonD in EAX

mov edx, OFFSET promptGCD
call WriteString

mov eax, savedNumber1
call WriteInt                                ;we want to display sign

mov edx, OFFSET promptAnd
call WriteString

mov eax, savedNumber2
call WriteInt                                ;we want to display sign

mov edx, OFFSET promptIs
call WriteString

mov eax, greatestCommonD 
call WriteDec                                ;write out an unsigned GCD

mov al, '.'
call WriteChar 

call Crlf                          ;jumps back to start of Menu upon return

RET                             ;returns next memory location saved after call of procedure
DisplayGCD ENDP                 ;end of procedure
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end main