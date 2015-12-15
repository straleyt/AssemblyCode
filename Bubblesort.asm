TITLE Bubblesort.asm
; **********************************************************
; Program Description: CSCI 2525, assignment 8
; Author: Tegan Straley
; Creation Date: November 12, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                       
     promptMenu BYTE "Hello. Please enter the number of your choice...",0
     promptMenu1 BYTE "1. Enter an array to be sorted",0
     promptMenu2 BYTE "2. Use a randomly filled array",0
     promptMenu3 BYTE "3. Quit",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1, 2, or 3",0
     array DWORD 101 DUP(0)                                         ;starts at 2 to 100
     arraylength DWORD 100
     bubblesortDoneYet DWORD 0 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     userArray PROTO , array: PTR DWORD
     displayArray PROTO , array: PTR DWORD,  bubblesortDoneYet:DWORD
     BubbleSort PROTO , array:PTR DWORD, arraylength:DWORD
     randomArray PROTO , array:PTR DWORD

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
     or al,1                                  ;to clear the zero flag

     call ReadInt                             ;reads in the menu choice from user

     cmp eax,1
     jz Input1                                ;if 1 goes to Input1
     cmp eax,2
     jz Input2                                ;if 2 goes to Input2
     cmp eax,3
     jz Input3                                ;if 3 goes to Input3
     jnz Error                                ;error message is read out when 1, 2, or 3 is not inputted

     Error:                                   ;Neither 1, 2, or 3 was inputted
     mov edx, OFFSET promptError
     call WriteString
     call Crlf
     jmp Menu                                 ;tells user valid options and jumps back to Menu again

     EndProgram:
     call Crlf
     call WaitMsg 
     call Crlf
     INVOKE ExitProcess,0                     ;exits program

     Input1:                                                               ;When user enters in 1 option
     mov arrayLength, 100
     call Clrscr                                                           ;clears the screen
     INVOKE userArray, ADDR array                      
     sub arrayLength, ecx                                                ;100 - ecx = how many elements in array
     call Clrscr
     mov bubblesortDoneYet, 0                                              ;bubblesort not done yet, displays out Unsorted Array: in displayArray
     INVOKE displayArray, ADDR array, bubblesortDoneYet
     call Crlf
     call WaitMsg                                                          ;user can see the unsorted array for as long as they want before sorting it
     call Clrscr
     INVOKE BubbleSort, ADDR array, arrayLength
     mov bubblesortDoneYet, 1
     INVOKE displayArray, ADDR array, bubblesortDoneYet
     jmp Menu                                                              ;jumps back to menu

     Input2:
     mov arrayLength, 100
     call Clrscr
     INVOKE randomArray, ADDR array
     mov bubblesortDoneYet, 0
     INVOKE displayArray, ADDR array, bubblesortDoneYet
     call Crlf
     call WaitMsg
     call Clrscr
     INVOKE BubbleSort, ADDR array, arrayLength
     mov bubblesortDoneYet, 1
     INVOKE displayArray, ADDR array, bubblesortDoneYet
     jmp Menu                      ;completed option 2


     Input3:
     jz EndProgram

INVOKE ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
userArray PROC , arraytofill: PTR DWORD
;Procedure asks user for up to 100 numbers (range 1-750) to go into an unsorted array
;Receives: array (named arraytofill)
;Returns: array (named arraytofill and it is filled)
;Requires: nothing
 
 .data                   
     promptArrayInstruction BYTE "Enter numbers 1 - 750. When done, enter 0 to complete array filling.",0
     promptNumber BYTE "Number: " ,0
     promptNotValidNumber BYTE "That's not a valid number! Try again.",0

 .code
     mov edx, 0                                   ;EDX = 0 (to help clear array)
     mov ecx, 100                                 ;ECX = 100
     mov esi, arraytofill                         ;ESI = beginning of arraytofill
     push esi                                     ;ESP = esi (start of array)
     ToClear:
          mov [esi], edx                          ;moves 0 in all elements of arraytofill
          add esi, TYPE DWORD                     ;increment ESI
     loop ToClear
     pop esi                                      ;return back beginning of arraytofill in esi
     mov ebx, 751                                 ;EBX = 751 to be compared on
     mov edx, OFFSET promptArrayInstruction       ;writes out array filling instructions for the user
     call WriteString
     call Crlf

     mov ecx, 100                                 ;ECX = 100
     UserArrayFillLoop:
          cmp ecx, 1                              ;is ECX = 1?
          je DoneFilling                          ;yes...jump when 100 numbers have been read in
          mov edx, OFFSET promptNumber            ;prompts "Number: "
          call WriteString
          call ReadInt                           ;read in number to fill array
          cmp ebx, eax                            ;compare eax with 751
          jbe promptNotValid                      ;if over, say error and try again
          cmp eax, 0                              ;if eax = 0, inputting is done and jump is DoneFilling
          jz DoneFilling
          dec ecx                                 ;if all above are false, we can dec ecx and fill array and increment array
          mov [esi], eax                          ;put integer into arraytofill
          add esi, TYPE DWORD
          jmp UserArrayFillLoop

          promptNotValid:
               call Crlf
               mov edx, OFFSET promptNotValidNumber
               call WriteString                   ;informs user number was negative or above 750
               call Crlf
               jmp UserArrayFillLoop

          DoneFilling:

RET                                                    ;returns next memory location saved after call of procedure
userArray ENDP                                        

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
randomArray PROC  , arraytorandomfill: PTR DWORD
;Procedure fills arraytorandomfill (i.e. array) with numbers 1 - 750 
;Receives: array (named arraytorandomfill) 
;Returns: array (named arraytorandomfill)
;Requires: nothing
 
 .data
     randVal DWORD ?

 .code
     mov ecx, 100                            ;ECX = 100
     mov esi, arraytorandomfill              ;ESI = beginning of arraytorandomfill

     toLoopRandom:
          mov eax, 750                       ;random range will be 0 - 749
          call RandomRange                   ;EAX = random number
          inc eax                            ;random number now range 1 - 750 
          mov [esi], eax                     ;fill arraytorandomfill with random number
          add esi, TYPE DWORD                ;increment array
     loop toLoopRandom

RET                                                ;returns next memory location saved after call of procedure
randomArray ENDP                                    
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DisplayArray PROC , filledarray: PTR DWORD,  bubblesortDoneYetAnswer:DWORD
;Procedure displays out either an unsorted array or a sorted array to the user in a methodical way
;Receives: array (named filledarray), bubblesortDoneYetAnswer (either 0 or a 1)
;Returns: same as received, also the array displayed out to the user
;Requires: nothing
 
 .data
 headerUnsorted BYTE "Unsorted array: ",0
 headerSorted BYTE "Sorted array: ",0
 xCoord BYTE 0
 yCoord BYTE 1

 .code
 mov xCoord, 0                                    ;to reset row back to 0 spot
 mov yCoord, 1                                    ;to reset column to 1 
 mov ecx, 0                                       ;ECX = 0
 cmp bubblesortDoneYetAnswer, ecx
 jz DisplayUnSorted
     mov edx, OFFSET headerSorted                 ;displays "Sorted array: "
     call WriteString
     call Crlf
     jmp DoneWithHeader
 DisplayUnSorted:
     mov edx, OFFSET headerUnsorted               ;displays "Unsorted array: "               
     call WriteString
     call Crlf

DoneWithHeader:
mov esi, filledarray                              ;ESI = filledarray

OutputtingAll:
mov ecx, 10                                       ;ECX = 10
     
TimeToDisplay:
     mov dh, yCoord                               ;DH = yCoord 
     mov dl, xCoord                               ;DL = xCoord
     call Gotoxy                                  ;Irvine call to move cursor
     mov eax, [esi]                               ;EAX = element at position esi
     cmp eax, 0                                   ;Is EAX = 0?
     jz DoneOutputting                            ;yes, done with outputting
     call WriteDec                                ;no, then output the number!
     add esi, TYPE DWORD                          ;increment esi
     add xCoord, 6                                ;increment xCood to display 6 distance  
loop TimeToDisplay

mov xCoord, 0                                     ;reset xCoord to be beginning of line
inc yCoord                                        ;inc yCoord (i.e row)
jmp OutputtingAll
 
DoneOutputting:

RET                                                ;returns next memory location saved after call of procedure
DisplayArray ENDP                                     

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

BubbleSort PROC , sortArray: PTR DWORD, arrayLengths:DWORD
;Procedure bubblesorts the array given in in ascending order
;Receives: array (named sortArray), arrayLength (named arrayLengths)
;Returns: same as receives
;Requires: nothing

 .code
 cmp arrayLengths, 1                              ;if sortArray is 1 long, array is sorted
 jz ENDOFBUBBLESORT
 mov ecx, arrayLengths                            ;ECX = n/arrayLengths
 dec ecx                                          ;ECX - 1

 BEGINSWAPPING:
 mov esi, sortArray                               ;ESI = beginning of sortArray
 push ecx                                         ;ESP = ecx

 STARTOFLOOPSWAP:        
     mov edx, [esi]                               ; EDX = element of array
     mov eax, [esi + 4]                           ; EAX = next element of array
     cmp eax,  edx                                ;is EAX > EDX?
     ja DONTSWAP                                  ;yes... leave it!
     mov [esi], eax                               ;no...swap!
     mov [esi + 4], edx
 DONTSWAP:
     add esi, TYPE DWORD                          ;increment sortArray
     loop STARTOFLOOPSWAP                         ;loop ecx times

pop ecx                                           ;ECX = what arrayLengths was at the start
loop BEGINSWAPPING                                ;loop arrayLengths times again to fully sort (horrible big-O time)

ENDOFBUBBLESORT:

RET                                                     ;returns next memory location saved after call of procedure
BubbleSort ENDP                             

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end main