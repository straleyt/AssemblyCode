TITLE Fibonacci.asm
; **********************************************************
; Program Description: CSCI 2525, second program of Assignment 3  
; Author: Tegan Straley
; Creation Date: September 11, 2015
; **********************************************************


INCLUDE Irvine32.inc     ;//Includes the Irvine32 library of functions

.data
     fibonacciArray BYTE 0h,1h,0h,0h,0h,0h,0h           ;only known f(0) = 0 && f(1) = 1
   

.code
main proc

     MOV eax, 0          				;eax register is zeroed out
     MOV ebx, 0          				;ebx register is zeroed out
     
     MOV al, fibonacciArray             ;al = 0
     ADD al, [fibonacciArray + 1]       ;al = 1

     XCHG [fibonacciArray + 2], al      ;fibonacciArray now 0,1,1,0,0,0,0
     MOV eax, 0                         ;eax register is zeroed out
     ADD al, [fibonacciArray + 1]       ;al = 1
     ADD al,[fibonacciArray + 2]        ;al = 2

     XCHG [fibonacciArray + 3], al      ;fibonacciArray now 0,1,1,2,0,0,0
     MOV eax, 0                         ;eax register is zeroed out
     ADD al,[fibonacciArray + 2]        ;al = 1
     ADD al,[fibonacciArray + 3]        ;al = 3

     XCHG [fibonacciArray + 4], al      ;fibonacciArray now 0,1,1,2,3,0,0
     MOV eax, 0                         ;eax register is zeroed out
     ADD al,[fibonacciArray + 3]        ;al = 2
     ADD al,[fibonacciArray + 4]        ;al = 5

     XCHG [fibonacciArray + 5], al      ;fibonacciArray now 0,1,1,2,3,5,0
     MOV eax, 0                         ;eax register is zeroed out
     ADD al,[fibonacciArray + 4]        ;al = 3
     ADD al,[fibonacciArray + 5]        ;al = 8

     XCHG [fibonacciArray + 6], al      ;fibonacciArray now 0,1,1,2,3,5,8


     MOV bl,[fibonacciArray + 3]
     call DumpRegs       				;prints the register information to the screen

     MOV bh,[fibonacciArray + 4]
     call DumpRegs       				;prints the register information to the screen

     MOV bx,WORD PTR [fibonacciArray + 5]

     call DumpRegs       				;prints the register information to the screen


exit  
main endp
end main