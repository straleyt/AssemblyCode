TITLE Encrypt.asm
; **********************************************************
; Program Description: CSCI 2525, assignment 6
; Author: Tegan Straley
; Creation Date: October 19, 2015
; **********************************************************

INCLUDE Irvine32.inc     ;Includes the Irvine32 library of functions
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     MAXIMUM = 140                                                          ;Max number of character we will encrypt to 

.data                                                                       
     promptMenu BYTE "1. Run the program 'Encrypt'",0
     promptExit BYTE "2. Quit",0
     promptString BYTE "1. Would you like to enter a word to be encrypted?",0
     promptDefaultString BYTE "2. Would you like to use the default string to be encrypted?",0
     promptChoice BYTE "Choice: ",0
     promptError BYTE "Input Error... please try again...Enter either 1 or 2",0
     defaultStringSentence BYTE "Encryption using a rotation key",0
     key SBYTE -2,4,1,0,-3,5,2,-4,-4,6
     promptInput BYTE "Please enter the english sentence you wish to encrypt: ",0
     promptEncrypted BYTE "Done! The encrypted sentence is now: ",0
     promptDecryptQuestion BYTE "Would you like to decrypt your thread?",0
     promptYN BYTE "Please enter Y/y or N/n:",0
     promptDecrypted BYTE "Done! The decrypted sentence is now: ",0
     numOfKeyElements DWORD 10
     newWord BYTE MAXIMUM+1 DUP(0)
     newWordSize DWORD ?
     YesOrNo BYTE ?
     YesOrNoErrorMsg BYTE "Hey, I said Y, y, n, or N! Try again!",0 
      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
main PROC

     mov eax, 0           
     mov ebx, 0
     mov ecx, 0
     mov edx, 0                                ;zeroed out all the registers

     Menu:  
     call Crlf                                 ;start of Menu label
     mov eax, 15                               ;outputs menu color in white
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
     or al,1                ;to clear the zero flag

     call ReadInt           ;reads in the menu choice from user

     cmp eax,1
     jz Input1              ;if 1 goes to Input1
     cmp eax,2
     jz EndProgram          ;if 2 goes to EndProgram
     jnz Error              ;error message is read out when 1 or 2 is not inputted

     Error:                          ;Neither 1 or 2 was inputed
     mov edx, OFFSET promptError
     call WriteString
     call Crlf
     jmp Menu                       ;tells user valid options and jumps back to Menu again

     EndProgram:
     call WaitMsg 
     INVOKE ExitProcess,0           ;exits program

     Input1:
     call SubMenuProc              	;go to SubMenu
     jmp Menu                      	;jumps back to menu

INVOKE ExitProcess,0               	;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SubMenuProc PROC
;Procedure asks user if they want to encrypt or decrypt their sentence
;Receives: Nothing
;Returns: executes following procedures if chosen
;Requires: Nothing

  SubMenu:
     mov edx, OFFSET promptDefaultString                ;outputs all the menu options to user
     call WriteString
     call Crlf
     mov edx, OFFSET promptString
     call WriteString
     call Crlf
     mov edx, OFFSET promptChoice
     call WriteString


     mov al,0
     or al,1                		;to clear the zero flag

     call ReadInt           		;reads in the menu choice from user

     cmp eax,1
     jz DefaultString                ;if 1 goes to Input1
     cmp eax,2
     jz InputtedString               ;if 2 goes to EndProgram
     jnz Error                       ;error message is read out when 1 or 2 is not inputted

     Error:                          ;Neither 1 or 2 was inputted
          mov edx, OFFSET promptError
          call WriteString
          call Crlf
          jmp SubMenu                ;tells user valid options and jumps back to Menu again

     DefaultString:
          call AssignString         
          jmp BothShouldDo           ;now newWord is filled

     InputtedString:
          call ReceiveInput          ;can just fall through to BothShouldDo
     
     BothShouldDo:
          call Encryption            ;Encrypts the newWord
          call DisplaySentence       ;Procedure displays what was encrypted

     Question:
          call Crlf
          mov edx, OFFSET promptDecryptQuestion
          call WriteString                        ;asks user if they want to decrypt
          call Crlf
          mov edx, OFFSET promptYN
          call WriteString
          call ReadChar
          mov YesOrNo, al                         ;AL = YesOrNo

          cmp YesOrNo, 'n'
          je BackToMain
          cmp YesOrNo, 'N'
          je BackToMain
          cmp YesOrNo, 'y'
          je DecryptionTime
          cmp YesOrNo, 'Y'
          je DecryptionTime                       ;if user doesn't input any, program falls through to error
          
          call Crlf
          mov edx, OFFSET YesOrNoErrorMsg
          call WriteString
          jmp Question

          DecryptionTime:
               call Decryption
               call DisplayDSentence

          BackToMain:

RET                             ;returns next memory location saved after call of procedure
SubMenuProc ENDP                 ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AssignString PROC
;Procedure asks user for a sentence to encrypt
;Receives: Nothing
;Returns: newWord is filled with string to use
;Requires: Nothing

mov esi,0
mov ecx, SIZEOF defaultStringSentence        ;ecx counts down from 32 (default case)
mov newWordSize, ecx                         ;newWordSize = 32

LOOPTOFILL:
     mov al, defaultStringSentence[esi]
     mov newWord[esi], al                    ;filling the newWord with default sentence
     inc esi
     loop LOOPTOFILL


RET                             			;returns next memory location saved after call of procedure
AssignString ENDP                 			;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ReceiveInput PROC USES EDX ECX
;Procedure asks user for a sentence to encrypt
;Receives: Nothing
;Returns: newWord is filled with string to use
;Requires: Nothing

 mov edx, OFFSET promptInput
 call WriteString
 mov edx, OFFSET newWord           ;EDX = start of newWord
 mov ecx, MAXIMUM                  ;doesn't read in more than 140/MAXIMUM characters
 call ReadString                   ;automatically puts the new string into newWord
 mov newWordSize, eax              ;EAX = SIZEOF newWord

RET                               ;returns next memory location saved after call of procedure
ReceiveInput ENDP                 ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Encryption PROC USES EDX ESI ECX
;Procedure encrypts by way of rotation of the key
;Receives: newWord = what to be encrypted, newWordSize = SIZEOF newWord
;Returns: newWord = newWord that is encrypted by rotation  
;Requires: Nothing
 
 mov edx, 0
 mov esi,0
 mov ecx, newWordSize
 call Crlf

 LOOP1:
     push ecx                      ;ESP = ecx
     cmp key[edx],0                ;is key[edx] negative?
     jl LESSTHANZERO               ;if yes ...
     mov cL, key[edx]              ;rotation uses cL
     ror newWord[esi], cL          ;rotates right cL amount of bits
     inc esi                       ;increment both esi and edx
     inc edx
     jmp DONEROTATING

     LESSTHANZERO:
     neg key[edx]                  ;change sign of key[edx] to positive
     mov cL, key[edx]
     rol newWord[esi],cL           ;rotates left cL amount of bits
     neg key[edx]                  ;change sign of key[edx] back to negative
     inc esi
     inc edx                       ;increment both esi and edx

     DONEROTATING:
     cmp edx, numOfKeyElements     ;if edx = 10, need to reset
     jne LOOPING                   ;if not, keep looping
     mov edx, 0

     LOOPING:
     pop ecx
     loop LOOP1

RET                             ;returns next memory location saved after call of procedure
Encryption ENDP                 ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Decryption PROC USES EDX ESI
;Procedure decrypts by way of rotation of the key
;Receives: newWord = what to be decrypted, newWordSize = SIZEOF newWord
;Returns: newWord = newWord that is decrypted by rotation  
;Requires: Nothing
 
 mov edx, 0
 mov esi,0
 mov ecx, newWordSize
 call Crlf

 LOOP1:
     push ecx                      ;ESP = ecx
     cmp key[edx],0                ;is key[edx] negative?
     jl LESSTHANZERO               ;if yes ...
     mov cL, key[edx]              ;rotation uses cL
     rol newWord[esi], cL          ;rotates right cL amount of bits
     inc esi                       ;increment both esi and edx
     inc edx
     jmp DONEROTATING

     LESSTHANZERO:
     neg key[edx]                  ;change sign of key[edx] to positive
     mov cL, key[edx]
     ror newWord[esi],cL           ;rotates left cL amount of bits
     neg key[edx]                  ;change sign of key[edx] back to negative
     inc esi
     inc edx                       ;increment both esi and edx

     DONEROTATING:
     cmp edx, numOfKeyElements     ;if edx = 10, need to reset
     jne LOOPING                   ;if not, keep looping
     mov edx, 0

     LOOPING:
     pop ecx
     loop LOOP1

     call Crlf
RET                             ;returns next memory location saved after call of procedure
Decryption ENDP                 ;end of procedure

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DisplaySentence PROC USES EDX
DisplaySentence PROC USES EDX
;Procedure displays out the newly encrypted string
;Receives: Nothing
;Returns: displays out the encrypted word, nothing returned in registers
;Requires: Nothing

mov edx, OFFSET promptEncrypted
call WriteString
mov edx, OFFSET newWord                 ;reads out prompt then newWord
call WriteString
call crlf

RET                             ;returns next memory location saved after call of procedure
DisplaySentence ENDP                 ;end of procedure
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplayDSentence PROC USES EDX
;Procedure displays out the newly decrypted string
;Receives: Nothing
;Returns: displays out the decrypted word, nothing returned in registers
;Requires: Nothing

mov edx, OFFSET promptDecrypted
call WriteString
mov edx, OFFSET newWord                 ;reads out prompt then newWord
call WriteString
call crlf

RET                             ;returns next memory location saved after call of procedure
DisplayDSentence ENDP                 ;end of procedure
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end main