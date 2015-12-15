TITLE tictactoe.asm
; **********************************************************
; Program Description: CSCI 2525, Code Final
; Author: Tegan Straley
; Creation Date: November 30th, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                        
     promptTicTac BYTE "<<WELCOME TO TEGAN'S TIC TAC TOE PROGRAM>>",0
     promptMenu BYTE "Please enter the number of your choice...",0
     promptMenu1 BYTE "1. Player vs Computer",0
     promptMenu2 BYTE "2. Computer X vs. Computer O",0
     promptMenu3 BYTE "3. Quit",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1, 2, or 3",0
     winnerX DWORD 0
     winnerO DWORD 0
     winnerArrayX DWORD 0,0,0
     winnerArrayO DWORD 0,0,0
     tictacArray DWORD 9,9,9                      ;3 rows 3 columns     2D array specified by assignment
     Rowsize = ($ - tictacArray)
                 DWORD 9,9,9
                 DWORD 9,9,9

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC
                                         
     ;------------------------------------------;PROTO statements for the program          
     DisplayBoard PROTO, tictacBoard: PTR DWORD             
     humanChoice PROTO, tictacH: PTR DWORD
     compOChoice PROTO, tictacC: PTR DWORD
     compXChoice PROTO , tictacCC : PTR DWORD
     checkIfXWinner PROTO, tictacX: PTR DWORD, winnerXX: PTR DWORD, winnerArrayXX: PTR DWORD
     checkIfOWinner PROTO, tictacO: PTR DWORD, winnerOO: PTR DWORD, winnerArrayOO: PTR DWORD
     WinningDisplayBoard PROTO , tictacWinningBoard : PTR DWORD , winnerXXX: PTR DWORD , winnerOOO: PTR DWORD, winnerArrayXXX: PTR DWORD, winnerArrayOOO: PTR DWORD


     call Randomize;                           ;seeds the random, only need to call once through program
     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                
     mov edi, 0
     mov ebp, 0                                ;zeroed out all the registers                         

     Menu:                                     ;start of Menu label
    ;------------------To zero out the tictacArray/ reset variables
     mov ecx, 9                            
     mov esi, OFFSET tictacArray
     mov eax, 9
     mov winnerX, 0
     mov winnerO, 0
     LOOPZEROOUT:
          mov [esi], eax
          add esi, TYPE DWORD
     loop LOOPZEROOUT
     mov esi, OFFSET tictacArray

     ;-----------------Displays out the menu prompts 
     mov eax, white + (black * 16)               ;white letters w/ black background
     call SetTextColor
     call clrscr
     call Crlf
     mov eax, 3                                  ;read out the welcome in Cyan 
     call SetTextColor
     mov edx, OFFSET promptTicTac
     call WriteString
     mov eax, white + (black * 16)               ;white letters w/ black background
     call SetTextColor
     call Crlf
     mov edx, OFFSET promptMenu                  ;outputs all the menu options to user
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
     call WaitMsg
     jmp Menu                                 ;tells user valid options and jumps back to Menu again

     EndProgram: ;---if option 3 is chosen
     call Crlf
     call WaitMsg 
     call Crlf
     INVOKE ExitProcess,0                     ;exits program

     ;--------------------user invokes option 1
     Input1:                              
     call Crlf
     INVOKE humanChoice , ADDR tictacArray   ;--------1st X
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE compOChoice , ADDR tictacArray   ;--------1st O
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE humanChoice , ADDR tictacArray   ;--------2nd X
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE compOChoice , ADDR tictacArray   ;--------2nd O
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE humanChoice , ADDR tictacArray   ;--------3rd X , possibility of x winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfXWinner , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
          mov eax, 1
          cmp eax, winnerX
          jz ENDOFGAME
     INVOKE compOChoice , ADDR tictacArray   ;--------3rd O , possibility of o winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfOWinner , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
          mov eax, 1
          cmp eax, winnerO
          jz ENDOFGAME
     INVOKE humanChoice , ADDR tictacArray   ;--------4th X , possibility of x winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfXWinner , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
          mov eax, 1
          cmp eax, winnerX
          jz ENDOFGAME
     INVOKE compOChoice , ADDR tictacArray   ;--------4th O , possibility of o winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfOWinner , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
          mov eax, 1
          cmp eax, winnerO
          jz ENDOFGAME
     INVOKE humanChoice , ADDR tictacArray   ;--------5th/last X , possibility of x winner
     INVOKE checkIfXWinner , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
     jmp ENDOFGAME  ;----both option 1 and 2 have same procedures during ending (no matter what)

     ;--------------------user invokes option 2
     Input2:                                
     call Crlf
     INVOKE compXChoice , ADDR tictacArray   ;--------1st X
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE compOChoice , ADDR tictacArray   ;--------1st O
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE compXChoice , ADDR tictacArray   ;--------2nd X
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE compOChoice , ADDR tictacArray   ;--------2nd O
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE compXChoice , ADDR tictacArray   ;--------3rd X , possibility of x winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfXWinner , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
          mov eax, 1
          cmp eax, winnerX
          jz ENDOFGAME
     INVOKE compOChoice , ADDR tictacArray   ;--------3rd O , possibility of o winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfOWinner , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
          mov eax, 1
          cmp eax, winnerO
          jz ENDOFGAME
     INVOKE compXChoice , ADDR tictacArray   ;--------4th X , possibility of x winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfXWinner , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
          mov eax, 1
          cmp eax, winnerX
          jz ENDOFGAME
     INVOKE compOChoice , ADDR tictacArray   ;--------4th O , possibility of o winner
     INVOKE DisplayBoard , ADDR tictacArray
     INVOKE checkIfOWinner , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
          mov eax, 1
          cmp eax, winnerO
          jz ENDOFGAME
     INVOKE compXChoice , ADDR tictacArray   ;--------5th/last X , possibility of x winner
     INVOKE checkIfXWinner , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX

     ENDOFGAME:
          INVOKE WinningDisplayBoard , ADDR tictacArray , winnerX , winnerO , ADDR winnerArrayX , ADDR winnerArrayO
     call Waitmsg
     jmp Menu                                 ;jumps back to menu

     Input3:
     jz EndProgram

INVOKE ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
humanChoice PROC, tictacH: PTR DWORD
;Procedure lets the user choose a spot to place an 'x' on the gameboard (1-9), and fills the array in the appropriate spot with a 1
;Receives: tictacH (named tictacArray in main)
;Returns: tictacH (named tictacArray in main) filled with some position being a 1(value of an 'x')
;Requires: nothing              

.data
promptPlayerStart BYTE "PLAYER X START (select from 1 - 9) : ",0
promptOccupied BYTE "Sorry, that square has already been chosen! Try again...",0
promptNotValidNumber BYTE "Hey, I said choose 1 - 9! Don't give me a number like that!",0

.code
call Crlf
call Crlf

HUMANCHOICEENTER:
mov esi, tictacH
mov edx, OFFSET promptPlayerStart       ;prompts user that it is their turn
call WriteString
call ReadDec
mov ecx, 9     ;---should be 1 - 9! if doesn't jump then falls through to error message
cmp ecx, eax
jz YES1THRU9
mov ecx, 8
cmp ecx, eax
jz YES1THRU9
mov ecx, 7
cmp ecx, eax
jz YES1THRU9
mov ecx, 6
cmp ecx, eax
jz YES1THRU9
mov ecx, 5
cmp ecx, eax
jz YES1THRU9
mov ecx, 4
cmp ecx, eax
jz YES1THRU9
mov ecx, 3
cmp ecx, eax
jz YES1THRU9
mov ecx, 2
cmp ecx, eax
jz YES1THRU9
mov ecx, 1
cmp ecx, eax
jz YES1THRU9

;------------user didn't give a number 1 - 9 error prompt
call Crlf
mov edx, OFFSET promptNotValidNumber
call WriteString
call Crlf
call Crlf
jmp HUMANCHOICEENTER

YES1THRU9:
mov ecx, eax
cmp ecx, 1                              ;is their choice = 1?
jz CHOICE1                              ;if yes jump to CHOICE1, no need to increment through array
dec ecx
LOOPTOCHECKVALID:
     add esi, TYPE DWORD
     loop LOOPTOCHECKVALID

CHOICE1:       
mov ebx, 9
cmp [esi], ebx                          ;is array position = 9?
jz OKAYCHOICE                           ;if yes, position was empty (dash '-'), okay to now fill
mov edx, OFFSET promptOccupied          ;if no, inform user to try again
call Crlf
call WriteString
call Crlf
call Crlf
jmp HUMANCHOICEENTER                    ;...& loops back around

OKAYCHOICE:
mov ebx, 1                              ;moves 'x' into position
mov [esi], ebx                          ;1 = X, 0 = O, and 9 = empty

RET                                     ;returns next memory location saved after call of procedure
humanChoice ENDP                                    

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compOChoice PROC , tictacC : PTR DWORD
;Procedure randomly chooses out number 1 - 9 to fill tictacC array with 0 ('o') value. Waits approx. 2 seconds before returning.
;Receives: tictacC (named tictacArray in main)
;Returns: tictacC (named tictacArray in main) filled with some position being a 0(value of an 'o')
;Requires: nothing              

.data
promptComputerStart BYTE "COMPUTER O START (selecting in progress...)",0

.code
call Crlf
call Crlf
mov edx, OFFSET promptComputerStart               ;informs user computer O is choosing
call WriteString
mov esi, tictacC                                  ;ESI = start of tictacC array

RANDOMCOMPCHOICE:
mov esi, tictacC
mov eax, 9
call RandomRange                                  ;RandomRange returns back 0 - 8
add eax, 1                                        ;now range is 1 - 9 (correct range)
mov ecx, eax
cmp ecx, 1                                        ;was computer O's choice = 1?
jz CHOICE2                                        ;if yes jump to CHOICE2, no need to increment through array                    
dec ecx
LOOPTOCHECKVALID:
     add esi, TYPE DWORD
     loop LOOPTOCHECKVALID
CHOICE2:
mov ebx, 9
cmp [esi], ebx                                    ;1 = X, 0 = O, and 9 = empty
jz OKAYCOMPCHOICE
jmp RANDOMCOMPCHOICE

OKAYCOMPCHOICE:
mov ebx, 0
mov [esi], ebx                                    ;1 = X, 0 = O, and 9 = empty


;-----------------computer to delay 2 seconds
push ebp
mov ebp, 20000
mov eax, 20000
delay2:
dec bp                   ;counts down and does a lot of operations to "wait" two seconds
nop
jnz delay2
dec eax
cmp eax,0    
jnz delay2
pop ebp

RET                                                          ;returns next memory location saved after call of procedure
compOChoice ENDP                                       

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compXChoice PROC , tictacCC : PTR DWORD
;Procedure randomly chooses out number 1 - 9 to fill tictacC array with 0 ('x') value. Waits approx. 2 seconds before returning.
;(works the same as compOChoice!)
;Receives: tictacCC (named tictacArray in main)
;Returns: tictacC (named tictacArray in main) filled with some position being a 0(value of an 'o')
;Requires: nothing              

.data
promptOComputerStart BYTE "COMPUTER X START (selecting in progress...)",0

.code
call Crlf
call Crlf
mov edx, OFFSET promptOComputerStart
call WriteString
mov esi, tictacCC


RANDOMCOMPCHOICECX:
mov esi, tictacCC
mov eax, 9
call RandomRange                                  ;RandomRange returns back 0 - 8
add eax, 1                                        ;now range is 1 - 9 (correct range)
mov ecx, eax
cmp ecx, 1                                        ;was computer X's choice = 1?
jz CHOICE2CX                                      ;if yes jump to CHOICE2CX, no need to increment through array   
dec ecx
LOOPTOCHECKVALIDCX:
     add esi, TYPE DWORD
     loop LOOPTOCHECKVALIDCX
CHOICE2CX:
mov ebx, 9
cmp [esi], ebx
jz OKAYCOMPCHOICECX
jmp RANDOMCOMPCHOICECX

OKAYCOMPCHOICECX:
mov ebx, 1
mov [esi], ebx        ;1 = X, and 0 = O


;-----------------computer to delay 2 seconds
push ebp
mov ebp, 20000
mov eax, 20000
delay2:
dec bp
nop
jnz delay2
dec eax
cmp eax,0    
jnz delay2
pop ebp

RET                                                     ;returns next memory location saved after call of procedure
compXChoice ENDP                                   

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplayBoard PROC , tictacBoard : PTR DWORD
;Procedure displays out a simple tic tac toe board with the x's, o's, and dashes filled in. 
;Receives: tictacBoard (named tictacArray in main)
;Returns: nothing, just the displayed out board to the user
;Requires: nothing              

.data
xCoord BYTE 2
yCoord BYTE 0
promptPipes BYTE "    |   |    ",0
displayOutCounter DWORD 0

.code
mov xCoord, 2                                ;reset xCoord = 2 
mov yCoord, 0                                ;reset yCoord = 2 
mov displayOutCounter, 0                     ;reset displayOutCounter = 0
mov esi, tictacBoard
call Clrscr
mov ecx, 3
;------------------to display the pipes
DISPLAYPIPES:
     mov edx, OFFSET promptPipes
     call WriteString
     call Crlf
     loop DISPLAYPIPES

;------------------to display the rest of the characters
mov tictacBoard, esi
cmp tictacBoard, 1
DOITAGAIN:
mov ecx, 3

LOOPDISPLAY:
     push edx          
     mov dh, yCoord                               ;dh = yCoord
     mov dl, xCoord                               ;dl = xCoord
     call Gotoxy                                  ;moves cursor to (x,y) on screen
     pop edx     

     mov ebx, 9
     cmp [esi], ebx
     jz DISPLAYDASH      ;array = 9 -> display dash
     mov ebx, 1
     cmp [esi], ebx
     jz DISPLAYx         ;array = 1 -> display x
     mov ebx, 0
     cmp [esi], ebx
     jz DISPLAYo         ;array = 0 -> display o

     DISPLAYx:
          mov eax, 'x'
          call WriteChar
          jmp TOLOOPNEXTCHAR

     DISPLAYo:
          mov eax, 'o'
          call WriteChar
          jmp TOLOOPNEXTCHAR

     DISPLAYDASH:
          mov eax, '-'
          call WriteChar

     TOLOOPNEXTCHAR:
          add xCoord, 4
          add esi, TYPE DWORD

loop LOOPDISPLAY                   ;only loops 3 times to fill one row    

mov xCoord, 2                      ;reset xCoord = 2
add yCoord, 1                      ;inc to next line
add displayOutCounter, 1
mov edx, 2 
cmp displayOutCounter, edx         ;have we displayed out 2 rows?
jbe DOITAGAIN                      ;if yes we need 1 more row

RET                                ;returns next memory location saved after call of procedure
DisplayBoard ENDP                                        

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

checkIfXWinner PROC , tictacX : PTR DWORD, winnerXX: PTR DWORD, winnerArrayXX: PTR DWORD
;Procedure does algorithms to see if there are any rows with 3 x's in it. It fills out winnerArrayXX with the positions of the winning x's and
;fills winnerXX with a 1 if there is indeed a winning line.
;Receives: tictacX (named tictacArray in main), winnerXX (named winnerX in main), and winnerArrayXX (named winnerArrayX in main)
;Returns: everything it received but filled with the proper values. 
;Requires: nothing              

.data
TimeThroughX DWORD 0

.code
mov esi, tictacX    ;ESI = beginning of tictacX array
mov eax, 0
mov TimeThroughX, 0
;---------------------------------------for the rows
mov ecx, 3

CHECKFORROWS:
     push ecx                      ;ESP = ecx
     mov eax, 0
     mov ecx, 3
     LOOPFORROWS:
          mov ebx, [esi]
          add eax, ebx
          add esi, TYPE DWORD
          loop LOOPFORROWS

     pop ecx                       ;ECX value returned

;--------to set the winnerArrayXX values
     mov edx, 0
     cmp edx, TimeThroughX
     jz XFIRSTTIME
     mov edx, 1
     cmp edx, TimeThroughX
     jz XSECONDTIME
     mov edx, 2
     cmp edx, TimeThroughX
     jz XTHIRDTIME

     XFIRSTTIME:                   ;first row 1, 2, 3 set
     mov edi, winnerArrayXX
     mov edx, 1                    ;EDX = 1
     mov [edi], edx                ;winnerArrayXX[0] = EDX
     add edi, TYPE DWORD
     mov edx, 2
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 3
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHX

     XSECONDTIME:                  ;second row 4, 5, 6 set
     mov edi, winnerArrayXX
     mov edx, 4
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 6
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHX

     XTHIRDTIME:                   ;third row 7, 8, 9 set
     mov edi, winnerArrayXX
     mov edx, 7
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 8
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 9
     mov [edi], edx

     ENDFOTIMESTHROUGHX:

add TimeThroughX, 1 

;--------to check if we have a winner
mov edx, 3          ;since 1+1+1 = 3 check if sum = 3
cmp eax, edx
jz XWINNER

mov ebx,1
cmp ecx, ebx        ;since loop got to big, must dec ecx and jump instead
jz DONEX
sub ecx, 1
jmp CHECKFORROWS
     
DONEX:

;--------------------------------------------for the columnns
mov ecx, 3
mov TimeThroughX, 0                          ;reset TimeThroughX = 0
mov esi, tictacX                             ;reset esi to beginning of array
CHECKFORCOLS:
     push ecx
     mov eax, 0
     mov ecx, 3
     LOOPFORCOLS:
          mov ebx, [esi]
          add eax, ebx
          add esi, TYPE DWORD
          add esi, TYPE DWORD
          add esi, TYPE DWORD           
          loop LOOPFORCOLS
     pop ecx

;--------to set the winnerArrayXX values
     mov edx, 0
     cmp edx, TimeThroughX
     jz XXFIRSTTIME
     mov edx, 1
     cmp edx, TimeThroughX
     jz XXSECONDTIME
     mov edx, 2
     cmp edx, TimeThroughX
     jz XXTHIRDTIME

     XXFIRSTTIME:                  ;first column 1, 4, 7
     mov edi, winnerArrayXX
     mov edx, 1
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 4
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 7
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHXX

     XXSECONDTIME:                 ;second column 2, 5, 8
     mov edi, winnerArrayXX
     mov edx, 2
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 8
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHXX

     XXTHIRDTIME:                  ;third column 3, 6, 9
     mov edi, winnerArrayXX
     mov edx, 3
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 6
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 9
     mov [edi], edx

     ENDFOTIMESTHROUGHXX:
;--------to check if we have a winner
     mov edx, 3
     cmp eax, edx
     jz XWINNER
 
     mov edx, 1
     cmp edx, TimeThroughX         ;has the first column been checked? 
     jz ADD2COLUMNSXX              ;if yes, need to increment by 1 for second loop
     mov esi, tictacX
     add esi, TYPE DWORD
     jmp DONEADDINGCOLUMNSXX
     ADD2COLUMNSXX:
     mov esi, tictacX              ;if anything else we add 2 for checking the third column
     add esi, TYPE DWORD
     add esi, TYPE DWORD

     DONEADDINGCOLUMNSXX:
     mov ebx, 1
     cmp ecx, ebx                  ;is ecx downto 1?
     jz DONEXX                     ;if yes, don't loop through anymore
     sub ecx, 1     
     add TimeThroughX, 1
     jmp CHECKFORCOLS

     DONEXX:

;--------------------------------------------for the diagonals
     mov esi, tictacX              ;esi = beginning of tictacX array
     mov ebx, 0
     mov eax, [esi]                ;adding position 1 of board, no need to increment
     add ebx, eax
     mov ecx, 2
     LOOPDIAGONALX:
          add esi, TYPE DWORD           ;upper left to lower right diagonal ( 1, 5, 9)
          add esi, TYPE DWORD
          add esi, TYPE DWORD
          add esi, TYPE DWORD           ;needs to increment 4 
          mov eax, [esi]
          add ebx, eax
     loop LOOPDIAGONALX

     mov edi, winnerArrayXX             ;assignment of the winnerArrayXX values. 1, 5, 9
     mov edx, 1
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 9
     mov [edi], edx

     mov edx, 3                         ;finding winner? If sum/ebx = 3 then yes
     cmp ebx, edx
     jz XWINNER

     mov eax,0
     mov ebx, 0
     mov esi, tictacX                   ;reset variables
     add esi, TYPE DWORD
     add esi, TYPE DWORD                ;hard-coded, needs to start at position 3 of board
     mov eax, [esi]
     add ebx, eax

     mov ecx, 2
     LOOPDIAGONAL2X:
          add esi, TYPE DWORD           ;upper right to lower left diagonal ( 3,5,7)
          add esi, TYPE DWORD
          mov eax, [esi]
          add ebx, eax
     loop LOOPDIAGONAL2X

     mov edi, winnerArrayXX             ;assignment of the winnerArrayXX values. 1, 5, 9
     mov edx, 3
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 7
     mov [edi], edx

     mov edx, 3     ;finding winner? If sum/ebx = 3 then yes
     cmp ebx, edx
     jz XWINNER

jmp XENDING         ;if no winner is found, must skip over XWINNER

;---------------------------------found a winner
XWINNER:
     mov edx, winnerXX
     mov eax, 1
     mov [edx], eax                ;set dereferenced address to 1

XENDING:

RET                                                          ;returns next memory location saved after call of procedure
checkIfXWinner ENDP                                         

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

checkIfOWinner PROC , tictacO : PTR DWORD, winnerOO: PTR DWORD, winnerArrayOO: PTR DWORD
;Procedure does algorithms to see if there are any rows with 3 o's in it. It fills out winnerArrayOO with the positions of the winning o's and
;fills winnerOO with a 0 if there is indeed a winning line.
;Receives: tictacO (named tictacArray in main), winnerOO (named winnerO in main), and winnerArrayOO (named winnerArrayO in main)
;Returns: everything it received but filled with the proper values. 
;Requires: nothing              

.data
TimeThroughO DWORD 0

.code
mov esi, tictacO    ;ESI = beginning of tictacO array
mov eax, 0
mov TimeThroughO, 0
;---------------------------------------for the rows
mov ecx, 3

CHECKFORROWSO:
     push ecx                      ;ESP = ecx
     mov eax, 0
     mov ecx, 3
     LOOPFORROWSO:
          mov ebx, [esi]
          add eax, ebx
          add esi, TYPE DWORD
          loop LOOPFORROWSO

     pop ecx                       ;ECX value returned

;--------to set the winnerArrayOO values
     mov edx, 0
     cmp edx, TimeThroughO
     jz OFIRSTTIME
     mov edx, 1
     cmp edx, TimeThroughO
     jz OSECONDTIME
     mov edx, 2
     cmp edx, TimeThroughO
     jz OTHIRDTIME

     OFIRSTTIME:                   ;first row 1, 2, 3 set
     mov edi, winnerArrayOO
     mov edx, 1                    ;EDX = 1
     mov [edi], edx                ;winnerArrayOO[0] = EDX
     add edi, TYPE DWORD
     mov edx, 2
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 3
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHO

     OSECONDTIME:                  ;second row 4, 5, 6 set
     mov edi, winnerArrayOO
     mov edx, 4
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 6
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHO

     OTHIRDTIME:                   ;third row 7, 8, 9 set
     mov edi, winnerArrayOO
     mov edx, 7
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 8
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 9
     mov [edi], edx

     ENDFOTIMESTHROUGHO:

add TimeThroughO, 1 

;--------to check if we have a winner
mov edx, 0          ;since 0+0+0 = 0 check if sum = 0
cmp eax, edx
jz OWINNER

mov ebx,1
cmp ecx, ebx        ;since loop got to big, must dec ecx and jump instead
jz DONEO
sub ecx, 1
jmp CHECKFORROWSO
     
DONEO:

;--------------------------------------------for the columnns
mov ecx, 3
mov TimeThroughO, 0                          ;reset TimeThroughO = 0
mov esi, tictacO                             ;reset esi to beginning of array
CHECKFORCOLSO:
     push ecx
     mov eax, 0
     mov ecx, 3
     LOOPFORCOLSO:
          mov ebx, [esi]
          add eax, ebx
          add esi, TYPE DWORD
          add esi, TYPE DWORD
          add esi, TYPE DWORD           
          loop LOOPFORCOLSO
     pop ecx

;--------to set the winnerArrayOO values
     mov edx, 0
     cmp edx, TimeThroughO
     jz OOFIRSTTIME
     mov edx, 1
     cmp edx, TimeThroughO
     jz OOSECONDTIME
     mov edx, 2
     cmp edx, TimeThroughO
     jz OOTHIRDTIME

     OOFIRSTTIME:                  ;first column 1, 4, 7
     mov edi, winnerArrayOO
     mov edx, 1
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 4
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 7
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHOO

     OOSECONDTIME:                 ;second column 2, 5, 8
     mov edi, winnerArrayOO
     mov edx, 2
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 8
     mov [edi], edx
     jmp ENDFOTIMESTHROUGHOO

     OOTHIRDTIME:                  ;third column 3, 6, 9
     mov edi, winnerArrayOO
     mov edx, 3
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 6
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 9
     mov [edi], edx

     ENDFOTIMESTHROUGHOO:
;--------to check if we have a winner
     mov edx, 0
     cmp eax, edx
     jz OWINNER
 
     mov edx, 1
     cmp edx, TimeThroughO         ;has the first column been checked? 
     jz ADD2COLUMNSOO              ;if yes, need to increment by 1 for second loop
     mov esi, tictacO
     add esi, TYPE DWORD
     jmp DONEADDINGCOLUMNSOO
     ADD2COLUMNSOO:
     mov esi, tictacO              ;if anything else we add 2 for checking the third column
     add esi, TYPE DWORD
     add esi, TYPE DWORD

     DONEADDINGCOLUMNSOO:
     mov ebx, 1
     cmp ecx, ebx                  ;is ecx downto 1?
     jz DONEOO                     ;if yes, don't loop through anymore
     sub ecx, 1     
     add TimeThroughO, 1
     jmp CHECKFORCOLSO

     DONEOO:

;--------------------------------------------for the diagonals
     mov esi, tictacO              ;esi = beginning of tictacO array
     mov ebx, 0
     mov eax, [esi]                ;adding position 1 of board, no need to increment
     add ebx, eax
     mov ecx, 2
     LOOPDIAGONALO:
          add esi, TYPE DWORD           ;upper left to lower right diagonal ( 1, 5, 9)
          add esi, TYPE DWORD
          add esi, TYPE DWORD
          add esi, TYPE DWORD           ;needs to increment 4 
          mov eax, [esi]
          add ebx, eax
     loop LOOPDIAGONALO

     mov edi, winnerArrayOO             ;assignment of the winnerArrayOO values. 1, 5, 9
     mov edx, 1
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 9
     mov [edi], edx

     mov edx, 0                         ;finding winner? If sum/ebx = 0 then yes
     cmp ebx, edx
     jz OWINNER

     mov eax,0
     mov ebx, 0
     mov esi, tictacO                   ;reset variables
     add esi, TYPE DWORD
     add esi, TYPE DWORD                ;hard-coded, needs to start at position 3 of board
     mov eax, [esi]
     add ebx, eax

     mov ecx, 2
     LOOPDIAGONAL2O:
          add esi, TYPE DWORD           ;upper right to lower left diagonal ( 3,5,7)
          add esi, TYPE DWORD
          mov eax, [esi]
          add ebx, eax
     loop LOOPDIAGONAL2O

     mov edi, winnerArrayOO             ;assignment of the winnerArrayOO values. 1, 5, 9
     mov edx, 3
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 5
     mov [edi], edx
     add edi, TYPE DWORD
     mov edx, 7
     mov [edi], edx

     mov edx, 0     ;finding winner? If sum/ebx = 0 then yes
     cmp ebx, edx
     jz OWINNER

jmp OENDING         ;if no winner is found, must skip over OWINNER

;---------------------------------found a winner
OWINNER:
     mov edx, winnerOO
     mov eax, 1
     mov [edx], eax                ;set dereferenced address to 1

OENDING:

RET                                                          ;returns next memory location saved after call of procedure
checkIfOWinner ENDP                                         

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WinningDisplayBoard PROC , tictacWinningBoard : PTR DWORD , winnerXXX : PTR DWORD , winnerOOO : PTR DWORD, winnerArrayXXX : PTR DWORD, winnerArrayOOO : PTR DWORD
;Procedure displays out the winning triplet highlighted in the tic tac toe board game.
;         Procedure also displays out which character won, O or X. If game was a cats game, that is noted and nothing highlighted. 
;Receives: tictacWinningBoard, winnerXXX, winnerOOO, winnerArrayXXX, winnerArrayOOO
;Returns: nothing changed but the displayed out board and congradulations if it was not a cats game. 
;Requires: nothing              

.data
xCoordW BYTE 2
yCoordW BYTE 0
promptPipesW BYTE "    |   |    ",0
displayOutCounterW DWORD 0
promptXWinner BYTE "    X is the champion!",0
promptOWinner BYTE "    O is the champion!",0
promptNoWinner BYTE "IT'S A CATS GAME! You two are equally matched it seems...",0
DisplayNumberW DWORD 1
promptCongrats BYTE "<<<< CONGRATULATIONS >>>>",0
promptCongrats2 BYTE "<<<<<<<<<<<<<>>>>>>>>>>>>>",0

.code
mov DisplayNumberW, 1              ;reset variables
mov xCoordW, 2
mov yCoordW, 0
mov displayOutCounterW, 0
mov esi, tictacWinningBoard
call Clrscr
mov ecx, 3
DISPLAYPIPESW:;-------------------------to display the pipes of the board
     mov edx, OFFSET promptPipesW
     call WriteString
     call Crlf
     loop DISPLAYPIPESW

mov tictacWinningBoard, esi             ;ESI = beginning of board array
DOITAGAINW:
mov ecx, 3

LOOPDISPLAYW:
     push edx                                 
     mov dh, yCoordW                               ;dh = yCoord
     mov dl, xCoordW                               ;dl = xCoord
     call Gotoxy                                  ;moves cursor to (x,y) on screen
     pop edx     

     ;---------------------put color back to white on black
     mov eax, white + (black * 16)      
     call SetTextColor

     mov ebx, 9
     cmp [esi], ebx
     jz DISPLAYDASHW          ;to display -
     mov ebx, 1
     cmp [esi], ebx
     jz DISPLAYxW             ;to display x
     mov ebx, 0
     cmp [esi], ebx
     jz DISPLAYoW             ;to display o

     DISPLAYxW:
          mov eax, 0
          cmp eax, winnerXXX                      ;is winnerXXX = 0?
          push ecx
          jz DISPLAYJUSTX                         ;if yes, x did not win. 
          mov eax, WinnerArrayXXX                 ;if no, x won the game
          mov ebx, DisplayNumberW                 ;EBX = DisplayNumberW
          mov ecx, 3
          LOOPCHECKXWINNER:
               cmp [eax], ebx                     ;if DisplayNumberW is same as what is found in winner Array then display
               jz DISPLAYCOLORX
               add eax, TYPE DWORD
          loop LOOPCHECKXWINNER
          jmp DISPLAYJUSTX                        ;if none found to be same, no color added
          DISPLAYCOLORX:
          mov eax, black + (yellow * 16)           ;black letters w/ white background
          call SetTextColor                       ;irvine library function
          DISPLAYJUSTX:
          pop ecx
          mov eax, 'x'
          call WriteChar
          jmp TOLOOPNEXTCHARW

     DISPLAYoW:
          mov eax, 0
          push ecx
          cmp eax, winnerOOO                      ;is winnerOOO = 0?
          jz DISPLAYJUSTO                         ;if yes, x did not win. 
          mov eax, WinnerArrayOOO                 ;if no, x won the game
          mov ebx, DisplayNumberW                 ;EBX = DisplayNumberW
          mov ecx, 3
          LOOPCHECKOWINNER:
               cmp [eax], ebx
               jz DISPLAYCOLORO
               add eax, TYPE DWORD
          loop LOOPCHECKOWINNER
          jmp DISPLAYJUSTO                        ;if none found to be same, no color added
          DISPLAYCOLORO:
          mov eax, black + (yellow * 16)           ;black letters w/ white background
          call SetTextColor                       ;irvine library function
          DISPLAYJUSTO:
          pop ecx
          mov eax, 'o'
          call WriteChar
          jmp TOLOOPNEXTCHARW

     DISPLAYDASHW:                                ;dashes never have color
          mov eax, '-'
          call WriteChar

     TOLOOPNEXTCHARW:
          add xCoordW, 4                          ;inc x coordinate
          add esi, TYPE DWORD
          add DisplayNumberW, 1
          mov eax, white + (black * 16)           ;set color back to white lettering w/ black background
          call SetTextColor

     mov ebx, 1                                   ;since loop would be too far, must dec ecx by hand
     cmp ecx, ebx
     jz DONEDISPLAYINGXXX     
     sub ecx, 1
     jmp LOOPDISPLAYW                             ;loops 3 times (for each row)

     DONEDISPLAYINGXXX:  

mov xCoordW, 2                                    ;reset x coordinate back to first column
add yCoordW, 1                                    ;inc to next row
add displayOutCounterW, 1
mov edx, 2
cmp displayOutCounterW, edx                       ; if displayOutCounterW hasn' reached 3, need to do agian
jbe DOITAGAINW  


;----------to display CONGRATULATIONS
call Crlf
call Crlf
mov eax,winnerOOO   
cmp winnerXXX, eax                      ;if both XXX and OOO are the same, no one won
jnz NOTCATSGAME
mov edx, OFFSET promptNoWinner
call WriteString
jmp GAMEOVER                            ;CATS GAME

NOTCATSGAME:
mov eax, yellow + (cyan * 16) 
call SetTextColor
mov edx, OFFSET promptCongrats          ;-------congratulation banner 
call WriteString
call Crlf
mov eax, white + (black * 16)           ;set color back to white lettering w/ black background
call SetTextColor

mov eax, 1
cmp winnerXXX, eax
jnz TRYOWINNER
mov edx, OFFSET promptXWinner
call WriteString                        ;X WINNER
jmp BANNER2

TRYOWINNER:                             ; if none of the above, o wins!
mov edx, OFFSET promptOWinner
call WriteString                        ;O WINNER

BANNER2:
call Crlf
mov eax, yellow + (cyan * 16) 
call SetTextColor
mov edx, OFFSET promptCongrats2          ;-------congratulation2 banner 
call WriteString
call Crlf
mov eax, white + (black * 16)           ;set color back to white lettering w/ black background
call SetTextColor

GAMEOVER:
call Crlf
call Crlf

RET                                                          ;returns next memory location saved after call of procedure
WinningDisplayBoard ENDP                                      

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end main