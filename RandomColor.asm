TITLE RandomColor.asm
; **********************************************************
; Program Description: CSCI 2525, assignment 5
; Author: Tegan Straley
; Creation Date: October 6, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                       ;No global variables needed for this program
     promptMenu BYTE "Hello. Please enter the number of your choice...",0
     promptMenu1 BYTE "1. Run the Sieve of Eratosthenes",0
     promptMenu2 BYTE "2. Calculate the Divisors and Prime Divisors of a Number",0
     promptMenu3 BYTE "3. Quit",0
     promptError BYTE "Input Error... please try again...Enter either 1, 2, or 3",0
     promptN BYTE "Enter a positive integer less than 50: ",0
     promptNError BYTE "Error. Please enter a positive integer less than 50!"
     promptj BYTE "Enter a positive integer for the lower bounds: ",0
     promptjError BYTE "Error. Please just enter an integer!",0
     promptk BYTE "Enter a positive integer greater than the lower bounds: ",0
     promptkError BYTE"Error. Please enter a positive integer greater than the lower bounds!",0
     N DWORD ?     
     j DWORD ? 
     k DWORD ?                 
     array1 DWORD 50 DUP(?), 0
     randNum DWORD ?                    ;to hold randNum for what color array1 will be
     firstExecution BYTE 0              ;sets to 1 when user has gone through Input1: once
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     call Randomize;                           ;seeds the random, only need to call once through program
     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                ;zeroed out all the registers

     Menu:                                     ;start of Menu label

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
     mov eax, 2                     ;sets wait message color to green, matching menu color
     call SetTextColor
     call WaitMsg 
     INVOKE ExitProcess,0           ;exits program

     Input1:
     mov firstExecution, 1         ;program knows that N, j, and k have been set after this label is complete
     call usrInput                 ;executes procedure usrInput
     call ArrayFill                ;executes procedure ArrayFill
     call RandomColor              ;executes procedure RandomColor
     jmp Menu                      ;jumps back to menu

     Input2:
     cmp firstExecution, 0
     jz Input1
     call ArrayFill                ;executes procedure ArrayFill
     call RandomColor              ;executes procedure RandomColor
     jmp Menu

     Input3:
     jz EndProgram

INVOKE ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
usrInput PROC
;Procedure asks for an integer inputs from user for N,j,and k
;and passes the integer inputs in their appropriate variables back to calling procedure
;Receives: nothing 
;Returns: N (# of lines to print in RandStr procedure)
;         j (Lower bound of numbers to be in array1)
;         k (upper bound of numbers to be in array1)
;Requires: nothing
 
LabelPromptN:
mov edx, OFFSET promptN
call WriteString              ;writes out promptN to screen from EDX
call ReadInt                  ;reads in integer from user, puts it in EAX
mov N,eax                     ;N = unsigned dec from user
cmp N,50                      ;compares if N is < 50 and N > 0
ja LabelPromptN               ;if not, displays out promptN again to input a different N value
cmp N, 0
je LabelPromptN               ;N cannot equal 0

LabelPromptj:
mov edx, OFFSET promptj
call WriteString              ;writes out promptj to screen from EDX
call ReadDec                  ;reads in unsigned decimal from user, puts it in EAX
mov j,eax                     ;j = integer from user, (if j is a negative turns j into 0)

LabelPromptk:

mov edx, OFFSET promptk
call WriteString              ;writes out promptk to screen from EDX
call ReadDec                  ;reads in unsigned decimal from user, puts it in EAX
mov k,eax                     ;k = integer from user,f (if k is a negative turns k into 0)
mov ebx,j                     ;EBX = j
cmp ebx,eax                  ;compares if j <= k
jae LabelPromptk               ; ... if not, runs LabelPromptk: again


RET                           ;returns next memory location saved after call of procedure
usrInput ENDP                 ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ArrayFill PROC
;Procedure fills array1 with N random integers all in the range of j through k. 
;Receives: array1 into esi, N into ecx
;Returns: array1 is now full of N random integers from j through k, returns esi is at beginning of array1
;Requires: that procedure usrInput executed correctly

     inc k                                   ;to have random range include k (range goes from 0 to k-1 normally)
     mov esi, OFFSET array1                  ;ESI = pointer to array1
     mov ecx, N                              ;ECX = N (for loop to execute N times)
     push esi

     Loop1:                             ;executes N times to fill array1

          GettingRandom: 
               mov eax, k               ;EAX = k (upperbound of what random should be)
               call RandomRange         ;EAX = a random value 0 to k
               clc                      ;Clears carry flag
               cmp eax,j                ;compares eax to j
               jc GettingRandom         ;if eax < j then carry flag will of been set, jumpback and repeat

               mov [esi], eax           ;array1 at esi is now filled
               add esi, TYPE DWORD      ;increments where esi is for next loop to fill array1 properly
     loop Loop1 ;;;;;END OF LOOP1

     pop esi

RET                                ;returns next memory location saved after call of procedure
ArrayFill ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RandomColor PROC
;Procedure that prints out 20 lines of array1. Each instance of array1 is colored either 
;blue, white, or green based on probability.
;Receives: begninning of array1 in esi, 20 in ecx.
;Returns: doesn't return any new values except for the 20 instaces of colored array1's displayed out to the screen.
;Requires: that both ArrayFill and usrInput have executed correctly.

     mov ecx,20                           ;ECX = 20 to output 20 array1's 

     ColorLoop:
          push ecx
          push esi

          mov eax, 10                     ;EAX = 10 , (n-1) top value for RandomRange
          call RandomRange                ;EAX = ????????h (random value 0 to 25)
          mov randNum,eax

          mov al,0                        ;AL = 0
          or al,1                         ;clears Zero Flag (ZF = 0) prior to each loop
          
          mov ecx,N                       ;ECX = N , to output how many numbers in array1 user specified

          cmp randNum,0
          cmp randNum,1
          cmp randNum,2
          jz MakeWhite                    ;if randNum = 0, 1, 2 -> make array1 white

          cmp randNum,3
          jz MakeBlue                     ;if randNum = 3 -> make array1 blue

          cmp randNum,4
          cmp randNum,5
          cmp randNum,6
          cmp randNum,7
          cmp randNum,8
          cmp randNum,9
          jz MakeGreen                    ;if randNum = 4, 5, 6, 7, 8, 9 -> make array1 white

          DisplayNumRow:
          mov eax, [esi]                  ;EAX = [esi]
          call WriteDec
          mov eax, 32d                    ;32d = space in char
          call WriteChar
          add esi, TYPE DWORD             ;increments esi to next DWORD in array1
          dec ecx                         ;decrement ecx because loop too long for normal loop, using flags instead
          mov al,0                        ;AL = 0
          or al,1                         ;clears Zero Flag (ZF = 0) prior to each loop
          cmp ecx,0                       ;if ECX = 0 then done with printing to screen
          jz IfLoopisZero
          jnz DisplayNumRow

          MakeWhite:                      ;to set text color to specified color
          mov eax, 15
          call SetTextColor
          jmp DisplayNumRow

          MakeBlue::                      ;to set text color to specified color
          mov eax,1
          call SetTextColor
          jmp DisplayNumRow

          MakeGreen::                     ;to set text color to specified color
          mov eax, 2
          call SetTextColor 
          jmp DisplayNumRow

          IfLoopisZero:                   ;done with displaying out one line of array1
          call Crlf
          pop esi
          pop ecx                         ;to get back outer N value
          dec ecx                         ;decrements N
          mov al,0                        ;AL = 0
          or al,1                         ;clears Zero Flag (ZF = 0) prior to each loop
          cmp ecx,0                       ;If done with N times, ends procedure and jumps back to main
          jnz ColorLoop

RET                           ;returns next memory location saved after call of procedure
RandomColor ENDP                  ;end of UserInt procedure
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end main