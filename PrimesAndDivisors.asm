TITLE PrimesAndDivisors.asm
; **********************************************************
; Program Description: CSCI 2525, test 2 
; Author: Tegan Straley
; Creation Date: October 6, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                      
     promptMenu BYTE "Hello. Please enter the number of your choice...",0
     promptMenu1 BYTE "1. Run the Sieve of Eratosthenes",0
     promptMenu2 BYTE "2. Calculate the Divisors and Prime Divisors of a Number",0
     promptMenu3 BYTE "3. Quit",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1, 2, or 3",0
     promptPrimesFirst BYTE "You must run choice 1 before choice 2 for full functionality!",0
     primesFirst DWORD 0

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     call Randomize;                           ;seeds the random, only need to call once through program
     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                ;zeroed out all the registers
     mov esi, 1                                ;to compare with primesFirst

     Menu:                                     ;start of Menu label
     call Crlf
     mov edx, OFFSET promptMenu                ;outputs all the menu options to user
     call WriteString
     call Crlf
     mov edx, OFFSET promptMenu1
     call WriteString
     call Crlf
     mov edx, OFFSET promptMenu2
     call WriteString
     call Crlf
     mov edx, OFFSET promptMenu3
     call WriteString
     call Crlf
     mov edx, OFFSET promptChoice
     call WriteString

     mov al,0
     or al,1                ;to clear the zero flag

     call ReadInt           ;reads in the menu choice from user

     cmp eax,1
     jz Input1              ;if 1 goes to Input1
     cmp eax,2
     jz Input2              ;if 2 goes to Input2
     cmp eax,3
     jz Input3              ;if 3 goes to Input3
     jnz Error              ;error message is read out when 1, 2, or 3 is not inputted

     Error:                          ;Neither 1, 2, or 3 was inputted
		mov edx, OFFSET promptError
		call WriteString
		call Crlf
		jmp Menu                       ;tells user valid options and jumps back to Menu again

     EndProgram:
		call Crlf
		call WaitMsg 
		call Crlf
		INVOKE ExitProcess,0           ;exits program

     Input1:
		mov primesFirst, 1
		call Clrscr
		call sieve
		call displayPrimes
		jmp Menu                      ;jumps back to menu

     Input2:
		cmp esi, primesFirst
		jnz needToDoPrimes            ;to go to error message
		call Clrscr
		call AskUser
		call PrimeDivisors
		jmp Menu                      ;completed option 2

     needToDoPrimes:
		mov edx, OFFSET promptPrimesFirst
		call WriteString
		call Crlf
		jmp Menu                      ;after error displayed out, jumps back to menu

     Input3:
		jz EndProgram

INVOKE ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sieve PROC 
;Procedure fills arr with 1's if the position number isn't prime. All the rest of arr is filled with 0 if prime is true
;Receives: nothing 
;Returns: EDI and EAX start of arr
;Requires: nothing
 
 .data
     arr DWORD 100 DUP(0)                                         ;starts at 2 to 100
     count DWORD 0
     intI DWORD 2
     intJ DWORD 0
     intN DWORD 10                                               ;square root of 100 

 .code
     mov eax, OFFSET arr                ;starts EAX at arr
     mov ecx, intN                      ;ECX = 10
     mov esi, 1                         ;ESI = 1
     OUTSIDELOOP:
               push ecx                 ;esp = 10
               push eax                 ;esp = arr memory location
               mov eax, intI            ;EAX = intI 
               mul intI                 ;EAX = intI * intI
               mov intJ, eax            ;intJ = intI * intI
               mov ecx, eax             ;ECX = intI * intI
               dec ecx
               pop eax                  ;return the arr start location to EAX

               LOOPMOVE:
               add eax, TYPE DWORD                ;increment arr element by 1
               loop LOOPMOVE                      ;loops ECX = 100 - (intI*intI) times

               mov [eax], esi                     ;arr[j-1] = 1
               mov ebx, intI                      ;EBX = intI
               add intJ, ebx                      ; intJ += intI
               mov ecx, intJ                      ;ECX = intJ
               mov eax, OFFSET arr                ;EAX = beginning of arr
               cmp ecx, 100                       ;if ECX has reached 100 we don't want to fill anymore, too far!
               jae OUTOFINNER
               loop LOOPMOVE

               OUTOFINNER:
               pop ecx                            ;ECX counting down from 10 to 0
               inc intI                           ;for outer loop, intI increments by 1 each time 
               loop OUTSIDELOOP

               mov eax, OFFSET arr
               mov edi, OFFSET arr                ;store the beginning of arr in EAX for future use in other PROC's
               mov intI, 2
               mov intJ, 0

RET                                                ;returns next memory location saved after call of procedure
sieve ENDP                                        

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayPrimes PROC 
;Procedure displays out the primes below 100 using the arr (which was passed in by eax)
;Receives: beginning of arr in EAX
;Returns: displayed out prime numbers
;Requires: nothing
 
 .data
     outputPrompt BYTE "The primes less than 100 are: ",0
     commaPrompt BYTE ", ",0   
     AtNumberToDisplay DWORD 1                              ;number of times to increment in arr
     ActualNumber DWORD 2                                   ;actual number to display out to user

 .code
 mov edx, OFFSET outputPrompt
 call WriteString                       ;to write out prompt
 mov ecx, 99                            ;to display out 2 to 100 (computes which are primes to display out along the way)
 mov esi, 1                             ;ESI = 1

 Displaying:
     push eax                           ;save beginning of arr
     push ecx                           ;esp = ECX
     mov ecx, AtNumberToDisplay

     LOOPTONEXTNUMBER:
     add eax, TYPE DWORD                ;increments arr to next position
     loop LOOPTONEXTNUMBER

     cmp [eax], esi               		;does [eax] not prime?
     pop ecx                      	 	;esp = ecx
     jz DontDisplay               	 	;if [eax] = 1 , number isn't prime
     mov eax, ActualNumber         		;if number is prime
     call WriteDec
     cmp ecx, 4                    		;since 97 is the highest number outputted if ecx if below this we don't display comma
     jbe dontDisplayComma
     mov edx, OFFSET commaPrompt   		;to display the comma and space for simplicity for user to read
     call WriteString

     dontDisplayComma:

     DontDisplay:   
          pop eax                  		;eax  = beginning of arr again
          inc AtNumberToDisplay    		;onto next number
          inc ActualNumber         		;onto next number
          loop Displaying

          call Crlf

          mov ActualNumber, 2
          mov AtNumberToDisplay, 1

RET                           ;returns next memory location saved after call of procedure
displayPrimes ENDP                 

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AskUser PROC 
;Procedure asks user for an unsigned integer below 100
;Receives: nothing 
;Returns: EBX = user integer
;Requires: nothing
 
 .data
 promptForInt BYTE "Enter an integer:  ", 0h
 promptIntChoice BYTE "Unsigned integer < 100: ",0              

 .code  

 PROMPTINGFORINT:  
 mov edx, 0
 mov edx, OFFSET promptForInt                     ;displays out prompt
 call WriteString                                 ;displays out 'Integer: ' for easy user application
 call ReadDec                                     ;reads in unsigned integer
 cmp eax, 0
 jz PROMPTINGFORINT                               ;did eax read in as a negative or > 100?
 cmp eax, 101
 jb DONEANDDONE                                   ;if yes, ask for different integer
 jmp PROMPTINGFORINT

 DONEANDDONE:
 mov ebx, eax                                     ;to store user integer into EBX


RET                           ;returns next memory location saved after call of procedure
AskUser ENDP                    

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrimeDivisors PROC 
;Procedure displays out heading and the user integer as well as the divisors of integer and prime divisors of integer
;          displays out from the user integer down to 2
;Receives: EBX = user integer , EDI = start of arr
;Returns: displayed out information, doesn't 
;Requires: nothing
 
 .data
 promptHeading BYTE "n     Divisors                                    Prime Divisors",0
 commaDPrompt BYTE ", ",0   
 promptSpaces BYTE "    ",0
 arrayD DWORD 100 DUP(1)
 userInputNum DWORD ?
 xCoord BYTE 50
 yCoord BYTE 2

 .code    
 mov userInputNum, ebx                            ;userInputNum = n 
 mov edx, OFFSET promptHeading                    ;to write out the headings
 call WriteString
 call Crlf                                        ;moves cursor to next newline
 mov eax, userInputNum                            ;EAX = n
 mov yCoord, 2

 LOOPPRINTD:
     push edi                                     ;esp = start of arr
     mov esi, OFFSET arrayD                       ;ESI start of arrayD
     push esi                                     ;esp = start of arrayD
     mov userInputNum, eax                        ;reset userInputNum as decremented eax (eax is decremented before jumping back up to LOOPPRINTD)
     mov ecx, userInputNum                        ;loops for user integer amount of times / ECX = n
     dec ecx                                      ;ECX = n-1
     push eax                                     ;esp = EAX (saves what n value loop is on)
     call WriteDec                                ;write out n
     mov edx, OFFSET promptSpaces                 ;shift out same amount of spaces each time
     call WriteString

     NORMALDIVISOR:
     mov edx, 0                                   ;EDX = 0
     push eax                                     ;esp = n number SECOND PUSH
     mov edx, userInputNum                        ;EDX = userInputNum
     cmp edx, 1                                   ;has userInputNum decremented down to 1?
     jz NotDivisor                                ;if yes, don't display out
     mov edx, 0
     div userInputNum                             ;EAX / userInputNum = Quotient in eax and Remainder in edx
     cmp edx, 0                                   ;is remainder 0?
     jnz NotDivisor                               ;if != 0, not a divisor
     mov eax, userInputNum                        ;if yes = 0, write out what ebx/divisor was
     call WriteDec   

     push ecx                                     ;esp = ECX 
     push esi                                     ;esp = ESI start of arrayD
     sub esi, TYPE DWORD                          ;start arrayD moved back a position
     mov edx, 0                                   ;EDI = 0 (used for filling of arrayD)
     mov ecx, userInputNum                        ;ECX = n
          LOOPMOVEtoarrayD:                       ;(to fill arrayD with the divisors of n)
          add esi, TYPE DWORD                     ;increment arr element by 1
          loop LOOPMOVEtoarrayD                   ;loop userInputNum of times to get to correct position in arrayD
          mov [esi], edx                          ;arrayD[userInputNum] = 0 , means number is divisor
     pop esi                                      ;esi = arrayD back at beginning
     pop ecx                                      ;ECX = n-1 again

     cmp ecx, 1                                   ;if ecx = 1, don't display last comma
     jbe NotDivisor                               ;don't display out the last comma

     mov edx, OFFSET commaDPrompt                 
     call WriteString                             ;to write out ', '

     NotDivisor:
     dec userInputNum                             ;decrements what userInputNum is, number used to divide by n
     pop eax                                      ;EAX = n

     Loop NORMALDIVISOR                           ;loops n-1 times, prints out all the divisors (not including 1)

     push edx                                     ;to output the prime divisors , essential to Clrscr before PROC!
     mov dh, yCoord                               ;dh = yCoord
     mov dl, xCoord                               ;dl = xCoord
     call Gotoxy                                  ;moves cursor to (x,y) on screen
     pop edx                                      

     inc YCoord                                   ;move to next line/row

     STARTOFPRIMEDIVISORS:
     push ecx                                     ;esp = ECX (which is n-1)
     mov ecx, 99                                  ;ECX = 99

     StartToCheckPrimes:
          push esi                                     ;esp = ESI start of arrayD
          push edi                                     ;esp = EDI start of arr
          push ecx                                     ;esp = 99

          incrementingBoth:                            ;to compare values in both arrays
               add esi, TYPE DWORD                     ;increment arrayD 99 to 1 times
               add edi, TYPE DWORD                     ;increment arr 99 to 1 times
          loop incrementingBoth
                                     
          pop ecx                                      ;returns ECX (number somewhere 99 down to 1)     
          mov ebx, 1
          cmp [esi], ebx                               ;is arrayD filled with 1?
          jz LOOPAGAINFORPRIMES                        ;if yes no possible prime divisor
          
          mov ebx, 0          
          cmp [edi], ebx                               ;are both arr and arrayD 0 at this position?
          jnz LOOPAGAINFORPRIMES                       ;if no, not a prime divisor!
                     
          mov eax, ecx                                 ;EAX = ECX
          inc eax                                      ;write out correct number for the prime divisor
          call WriteDec
          cmp ecx, 1                                   ;Is ECX = 1?
          jz LOOPAGAINFORPRIMES                        ;if yes, ecx = 1, don't display last comma
          mov edx, OFFSET commaDPrompt
          call WriteString                             ;to write out ', '

          LOOPAGAINFORPRIMES:                              
               pop edi                                 ;returns edi to beginning of arr
               pop esi                                  ;returns esi to beginning of arrayD
          loop StartToCheckPrimes

     push edi                                          ;esp = start of arr     
     mov ecx, 99              
          LOOPMOVEtoarrayDagain:                       ;to empty out array with zeros for next n value
               add esi, TYPE DWORD                     ;increment arr element by 1
               mov edi, 1                              ;EDI = 1 
               mov [esi], edi                          ;arrayD = 1 all places, to reset for next loop
          loop LOOPMOVEtoarrayDagain         
     pop edi

     call Crlf
     dec userInputNum                                  ;userInputNum -= 1

     pop ecx                                           ;ECX returns back to n

     pop eax                                           ;return EAX as n
     pop esi                                           ;ESI back to beginning at arrayD
     pop edi                                           ;EDI back to beginning at arr

     dec eax                                           ;decrement EAX for next loop
     cmp eax, 1                                        ;don't loop if at 1 = n
     ja LOOPPRINTD

RET                                   					;returns next memory location saved after call of procedure
PrimeDivisors ENDP                    					
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end main