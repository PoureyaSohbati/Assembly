
TITLE Template of lab source code           (Lab5.asm)

; Program Description: finds the greatest common divisor(GCD) of two unsigned 
;						integers by using the Euclidean algorithm
; Author: Poureya Sohbati
; Date:   11/6/2013

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
		test eax, -1					; if the integer entered is 0
		jz errorZero					
		test eax, 80000000h				; if the integer entered is negative
		jnz errorNeg					
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
		test eax, -1					; if the integer entered is 0
		jz errorZero					
		test eax, 80000000h				; if the integer entered is negative
		jnz errorNeg


		mov edx, 1

	calc:								; calculation of the GCD
		test eax, 1						; test for EAX (even)
		jnz calc2						; jump if EAX is odd
		test ebx, 1						; test for EBX (even)
		jnz calc2						; jump if EBX is odd
		shr eax, 1						; EAX / 2
		shr ebx, 1						; EBX / 2
		shl edx, 1						; EDX * 2
		jmp calc

	calc2:
		cmp eax, 0						
		je result						; jump if EAX <= 0
		test eax, 1						; test for EAX (even)
		jz eax_even						; jump if EAX is even
		test ebx, 1						; test for EBX (even)
		jz ebx_even						; jump if EBX is even
		mov ecx, eax					
		sub ecx, ebx					; ecx = eax - ebx
		test ecx, 80000000h				
		jz calc3						; jump if ecx is not negative
		neg ecx

	calc3:
		cmp eax, ebx					; jump if eax < ebx
		jb B_Equal_C
		mov eax, ecx					; else eax = ecx
		jmp calc2

	eax_even:							; if EAX is even
		shr eax, 1
		jmp calc2

	ebx_even:							; if EBX is even
		shr ebx, 1
		jmp calc2

	B_Equal_C:							; ebx = ecx
		mov ebx, ecx
		jmp calc2


	result:		
		mov  eax, ebx
		mul  edx
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

Enter first integer: 66
Enter second integer: 36
The GCD is: +6
Another GCD? [y/n]: y
Enter first integer:
The number must be non-zero
Enter first integer: 86
Enter second integer: 33
The only common divisor is 1
Another GCD? [y/n]: y
Enter first integer: 956
Enter second integer: 462
The GCD is: +2
Another GCD? [y/n]: y
Enter first integer:
The number must be non-zero
Enter first integer: 30
Enter second integer: 40
The GCD is: +10
Another GCD? [y/n]:



Enter first integer: -545
The number must be positive
Enter first integer: 95
Enter second integer: 15
The GCD is: +5
Another GCD? [y/n]: 0
Another GCD? [y/n]: y
Enter first integer: 0
The number must be non-zero
Enter first integer: 365
Enter second integer: 180
The GCD is: +5
Another GCD? [y/n]: y
Enter first integer: 360
Enter second integer: 180
The GCD is: +180
Another GCD? [y/n]:

Enter first integer: 24
Enter second integer: 6
The GCD is: +6
Another GCD? [y/n]: y
Enter first integer: 152
Enter second integer: 36
The GCD is: +4
Another GCD? [y/n]: y
Enter first integer: 1756
Enter second integer: 35
The only common divisor is 1
Another GCD? [y/n]: 4
Another GCD? [y/n]: 5
Another GCD? [y/n]: y
Enter first integer: 1236
Enter second integer: 87
The GCD is: +3
Another GCD? [y/n]:

!
