
TITLE Template of lab source code           (Lab4.asm)

; Program Description: finds the greatest common divisor(GCD) of two unsigned 
;						integers by using the Euclidean algorithm
; Author: Poureya Sohbati
; Date:   10/28/2013

INCLUDE Irvine32.inc

.data
	prompt1  BYTE "Enter first integer: ",0
	prompt2  BYTE "Enter second integer: ",0
	message1 BYTE "The number must be positive",0
	message2 BYTE "The number must be non-zero",0
	output1  BYTE "The GCD is: ",0
	output2  BYTE "The only common divisor is 1",0
	again    BYTE "Another GCD? [y/n]: ",0


	
.code
main PROC
	
	begin:
		mov cl, 0						; its a flag for the first integer
		mov  EDX, OFFSET prompt1
		call WriteString
		call ReadInt
		cmp eax, 0
		jz errorZero					; if the integer entered is 0
		jl errorNeg						; if the integer entered is negative
		mov ebx, eax
		jmp num2

	errorZero: 
		mov  EDX, OFFSET message2
		call WriteString
		call crlf
		cmp cl, 1						; if cl == 1 goes jumps to instructions that get the second integer (num2)
										; else jumps to instuctions that get the first integer
		je num2							; jumps to intructions for second integer
		jmp begin						; jumps to intructions for first integer

	errorNeg: 
		mov  EDX, OFFSET message1
		call WriteString
		call crlf
		cmp cl, 1						; if cl == 1 goes jumps to instructions that get the second integer (num2)
										; else jumps to instuctions that get the first integer
		je num2							; jumps to intructions for second integer
		jmp begin						; jumps to intructions for first integer

	num2: 
		mov cl, 1						; its a flag for second integer
		mov  EDX, OFFSET prompt2
		call WriteString
		call ReadInt
		cmp eax, 0
		jz errorZero					; if the integer entered is 0
		jl errorNeg						; if the integer entered is negative
		jmp compare   ;;;;; don't need this line
		              ;;;;; execution naturally falls through to the next instruction.   -1/2pt

	
	compare:							; compares the two integers and stores the largest one in eax and the smallest in ebx
		cmp eax, ebx
		jb exchange	   ;;;; use: jne calc
		               ;;;; then code the xchg here
					   ;;;; and let execution falls through to calc    -1/2pt

	calc:								; claculation of the GCD
		mov edx, 0
		div ebx
		mov eax, ebx
		mov ebx, edx
		cmp edx, 0
		jnz calc
		jmp result     ;;;;; don't need this
		               ;;;;; if you move the xchg instruction as outlined above

	exchange:							; swaps the two integers
		xchg eax, ebx
		jmp calc
		

	result:		
		cmp  eax, 1
		je   print1
		mov  EDX, OFFSET output1 		; output if GCD > 1
		call WriteString
		call WriteInt
		call crlf
		jmp  ask
			
	print1:								; output if the GCD == 1
		mov  EDX, OFFSET output2
		call WriteString
		call crlf

	ask:								; if the user wants to try again
		mov  EDX, OFFSET again
		call WriteString
		call ReadChar
		call WriteChar
		call crlf
		cmp al, 'y'						; jumps to the begining if y
		je begin
		cmp al, 'Y'
		je begin
		cmp al, 'n'						
		je endProgram					; jumps to the end if n
		cmp al, 'N'
		jne ask	
		
		

	endProgram:

	exit
main ENDP
	
END main


COMMENT !

SCREEN OUTPUT:

Enter first integer: 136
Enter second integer: 24
The GCD is: +8
Another GCD? [y/n]: y
Enter first integer: 786
Enter second integer: 62
The GCD is: +2
Another GCD? [y/n]: k
Another GCD? [y/n]: y
Enter first integer: 85
Enter second integer: 5
The GCD is: +5
Another GCD? [y/n]: Y
Enter first integer: 146
Enter second integer: 956
The GCD is: +2
Another GCD? [y/n]: l
Another GCD? [y/n]: n
Press any key to continue . . .


Enter first integer: 86
Enter second integer: 36
The GCD is: +2
Another GCD? [y/n]: s
Another GCD? [y/n]: Y
Enter first integer: 863
Enter second integer: 9
The only common divisor is 1
Another GCD? [y/n]: y
Enter first integer: 21
Enter second integer: 9
The GCD is: +3
Another GCD? [y/n]: N
Press any key to continue . . .
!
