TITLE strings.asm
; **********************************************************
; Program Description: CSCI 2525, assignment 9
; Author: Tegan Straley
; Creation Date: November 20, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.data                                                                       ;No global variables needed for this program
     promptMenu BYTE "Hello. Please enter the number of your choice...",0
     promptMenu1 BYTE "1. str_cat --concatenates a string to the end of a target string",0
     promptMenu2 BYTE "2. str_n_cat --copy n characters of the source string to the end of a target string",0
     promptMenu3 BYTE "3. str_str --locate a subtring in a string (target = substring) ",0
     promptMenu4 BYTE "4. Quit",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1, 2, 3, or 4",0

     source BYTE "                          ",0
     target BYTE "                          ",0
     promptNewWord BYTE "Your new word is : ",0
     targetByteCount DWORD ?
     sourceByteCount DWORD ?
     nlength DWORD ?

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     fillSource PROTO , source: PTR DWORD                             ;PROTO statements for the program
     fillTarget PROTO , target: PTR DWORD
     str_cat PROTO , source: PTR DWORD, target: PTR DWORD      
     str_n_cat PROTO , source: PTR DWORD, target: PTR DWORD   
     str_str PROTO , source: PTR DWORD, target: PTR DWORD         

     call Randomize;                           ;seeds the random, only need to call once through program
     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                ;zeroed out all the registers                         

     Menu:                                     ;start of Menu label
     call clrscr
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
     mov edx, OFFSET promptMenu4
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
     cmp eax,4
     jz Input4                                ;if 4 goes to Input4
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

     Input1:                                  ;When user enters 1
     INVOKE fillSource , ADDR source
     mov sourceByteCount, ecx
     INVOKE fillTarget , ADDR target
     mov targetByteCount, ecx
     call Crlf
     mov ebx, sourceByteCount                ;passing the counts by register
     mov ecx, targetByteCount
     INVOKE str_cat, ADDR source, ADDR target
     mov edx, OFFSET promptNewWord
     call WriteString
     mov edx, OFFSET target                  ;To write out the newly catenated string
     call WriteString
     call Crlf
     call Waitmsg

     jmp Menu                                                    ;jumps back to menu

     Input2:                                  ;When user enters 2
     INVOKE fillSource , ADDR source
     mov sourceByteCount, ecx
     INVOKE fillTarget , ADDR target
     mov targetByteCount, ecx
     call Crlf
     mov ebx, sourceByteCount
     mov ecx, targetByteCount
     call fillnVariable                                          
     INVOKE str_n_cat, ADDR source, ADDR target                  ;EAX = n 
     mov edx, OFFSET promptNewWord
     call WriteString
     mov edx, OFFSET target
     call WriteString
     call Crlf
     call Waitmsg
     jmp Menu                                                     ;completed option 2

     Input3:                                  ;When user enters 3
     INVOKE fillSource , ADDR source
     mov sourceByteCount, ecx
     INVOKE fillTarget , ADDR target
     mov targetByteCount, ecx
     call Crlf
     mov ebx, sourceByteCount
     mov ecx, targetByteCount
     INVOKE str_str, ADDR source, ADDR target 
     call same_string                                            ;calls same_string function
     call Crlf
     call Waitmsg
     jmp Menu                                                    ;completed option 3

     Input4:
     jz EndProgram

INVOKE ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fillSource PROC , sourceArray: PTR DWORD 
;Procedure asks user for a souce word to use later on in following procedures
;Receives: source (passed in as parameter)
;Returns: ecx = SbyteCount
;Requires: nothing
 
 .data                   
 promptFillSource BYTE "Please enter a word for the source word...",0
 promptSourceError BYTE "Too long of a word! Try again...",0
 promptSource BYTE "Source: ",0
 SbyteCount DWORD ?
 sourceBuffer BYTE 25 DUP(0)

 .code
 mov esi, sourceArray                        ;ESI = beginning of sourceArray
 mov edx, 0                                  ;EDX = 0
 mov ecx, 25                                 ;ECX = 25
ToClear:
     mov [esi], edx                          ;moves 0 in all elements of sourceArray
     add esi, TYPE BYTE                      ;increment ESI
loop ToClear

 mov edx, OFFSET promptFillSource
 call WriteString
 call Crlf
 mov edx, OFFSET promptSource                ;writes out to prompt user 
 call WriteString
 
 mov edx, OFFSET sourceBuffer
 mov ecx, SIZEOF sourceBuffer
 call ReadString                             ;fills sourceBuffer with string from user
 mov SbyteCount, eax                         

 cld                                         ;clears directional flag
 mov esi, OFFSET sourceBuffer                ;ESI = beginning of sourceBuffer
 mov edi, sourceArray                        ;EDI = sourceArray
 mov ecx, SbyteCount                         ;ECX = SbyteCount to copy over
 rep movsb                                   ;copies what is in esi to edi

 mov ecx, SbyteCount                         ;pass back SbyteCount in ecx

RET                                                    ;returns next memory location saved after call of procedure
fillSource ENDP                                         ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fillTarget PROC , targetArray: PTR DWORD 
;Procedure asks user for a target word to use later on in following procedures
;Receives: target (passed in as parameter)
;Returns: TbyteCount in ECX
;Requires: nothing
 
 .data                  
 promptFillTarget BYTE "Please enter a word for the target word...",0
 promptTarget BYTE "Target: ",0
 targetBuffer BYTE 25 DUP(0)
 TbyteCount DWORD ?

 .code
mov esi, targetArray                         ;ESI = beginning of targetArray
mov edx, 0                                   ;EDX = 0
mov ecx, 25    
ToClearTarget:
     mov [esi], edx                          ;moves 0 in all elements of targetArray
     add esi, TYPE BYTE                      ;increment ESI
loop ToClearTarget
 
 mov edx, OFFSET promptFillTarget
 call WriteString
 call Crlf
 mov edx, OFFSET promptTarget                ;prompt the user to enter in a target word
 call WriteString
 
 mov edx, OFFSET targetBuffer
 mov ecx, SIZEOF targetBuffer
 call ReadString                             ;targetArray is filled in 
 mov TbyteCount, eax


 cld
 mov esi, OFFSET targetBuffer
 mov edi, targetArray
 mov ecx, TbyteCount
 rep movsb                                   ;copies targetBuffer over into targetArray

 mov ecx, TbyteCount

RET                                          ;returns next memory location saved after call of procedure
fillTarget ENDP                              ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fillnVariable PROC
;Procedure asks and receives a value for n 
;Receives: nothing
;Returns: nVariable in EAX
;Requires: nothing
 
 .data                
 promptnVariable BYTE "Please enter a word for the number of letters you want from the source...",0
 promptN BYTE "Number of letters (n): ",0
 promptWarningN BYTE "Your source word isn't even that long! Try again...",0


 .code
 BeginningOfN:
mov edx, OFFSET promptnVariable         ;prompt user to enter in an 'n' variable
call WriteString
call Crlf
mov edx, OFFSET promptN
call WriteString
call ReadInt
cmp eax, ebx                            ;comparing source length to what was given in
jb AllOkayN                             ;if n is < source length, n value is okay
mov edx, OFFSET promptWarningN          ;tell user the n value needs to be smaller
call WriteString
call Crlf
jmp BeginningOfN

AllOkayN:

RET                                     ;returns next memory location saved after call of procedure
fillnVariable ENDP                      ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

str_cat PROC , sourceCat: PTR DWORD, targetCat: PTR DWORD
;Procedure adds on the source word to the end of the target word
;Receives: ECX = targetByteCount, EBX = sourceByteCount
;Returns: target now has attached word on the end
;Requires: nothing              

 .code
 mov edi, targetCat                ;EDI = targetCat
 mov esi, sourceCat                ;ESI = sourceCat
 cld                               ;clear direction flag            
loopToCorrectTarget:               ;ECX already has targetByteCount in it
     add edi, TYPE BYTE
     loop loopToCorrectTarget      ;gets edi pointing to end of target word

 mov ecx, ebx                      ;ECX = sourceByteCount
 rep movsb                         ;copies source word to end of target word

RET                                                    ;returns next memory location saved after call of procedure
str_cat ENDP                                         ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
str_n_cat PROC , sourceNCat: PTR DWORD, targetNCat: PTR DWORD
;Procedure catenates 'n' number of letters from source word on the back of target word
;Receives:  ECX = targetByteCount, EBX = sourceByteCount, EAX = nlength
;Returns: target now has attached word on the end
;Requires: nothing

 .code
 mov edi, targetNCat                ;EDI = targetCat
 mov esi, sourceNCat                ;ESI = sourceCat
 cld                                ;clear direction flag 
loopToCorrectTarget:                ;ECX already has targetByteCount in it
     add edi, TYPE BYTE
     loop loopToCorrectTarget       ;gets edi pointing to end of target word

 mov ecx, eax                      ;ECX = nlength
 rep movsb                         ;copies source word to end of target word

RET                                                    ;returns next memory location saved after call of procedure
str_n_cat ENDP                                         ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

str_str PROC , sourceString: PTR DWORD, targetString: PTR DWORD 
;Procedure checks if there is the substring(target), in the source word
;Receives: ECX = targetByteCount, EBX = sourceByteCount
;Returns: the zero flag being set if the substring was found. EAX = the position the subtring was found
;Requires: nothing
 
 .data                   
 targetSubstringLength DWORD ?
 sourceSubstringLength DWORD ?
 countingVari DWORD 1

 .code                         
 mov countingVari, 1                    ;reset countingVari
 mov esi, sourceString                  ;ESI = beginning of sourceString array             
 mov edi, targetString                  ;EDI = beginning of targetString array

 cmp ebx, ecx                           ; is the source array length > target array length?
 jb NoEqualString                       ; if no, substring can't possibly be in the string

mov targetSubstringLength, ecx          ;save target array length into local variable
mov sourceSubstringLength, ebx          ;save source array length into local variable
mov ecx,sourceSubstringLength           ;ECX = sourceSubstringLength

 LoopForString:
     push ecx                           ;ESP = ecx
     cld                                ;clears the direction flag
     mov ecx, targetSubstringLength
     repe cmpsb                         ;compares edi and esi
     pop ecx                            ;returns ecx
     jz FoundEqual                      ;ZF set if substring found
     push ecx
     mov edi, targetString
     mov esi, sourceString              ;restores edi and esi to the beginning
     mov ecx, countingVari
     LOOPFORSOURCE:
          add esi, TYPE BYTE            ;move source array up countingVari each loop
     loop LOOPFORSOURCE
     inc countingVari
     pop ecx

loop LoopForString
jmp NoEqualString                       ;if code reaches this spot, no substring was found!

FoundEqual:
mov eax, sourceSubstringLength
sub eax, ecx                            ;as assignment requires
cmp eax, eax                            ;makes sure to set zero flag
NoEqualString:

RET                                                    ;returns next memory location saved after call of procedure
str_str ENDP                                         ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
same_string PROC
;Procedure displays out to user if a substring was found and at what position
;Receives: if ZF is set & EAX as the position found
;Returns: displays out to user the information
;Requires: nothing
 
 .data                   
 promptFound BYTE "Yes! The same target word was found at location: ",0
 promptNotFound BYTE "No. The target word was not found in the source array...",0

 .code                  
 jnz NotSameString                      ;ZF not set 
 mov edx, OFFSET promptFound            ;write out promptFound and position
 call WriteString
 call WriteInt
 jmp EndOfSameString

 NotSameString:                         ;displays out promptNotFound
 mov edx, OFFSET promptNotFound
 call WriteString

 EndOfSameString:


RET                                                    ;returns next memory location saved after call of procedure
same_string ENDP                                         ;end of usrInput procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end main