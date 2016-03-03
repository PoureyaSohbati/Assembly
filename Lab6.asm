TITLE Program Template			(Lab6.asm)

; Program Description:
; Author: Poureya Sohbati
; Date: 11/18/2013


INCLUDE Irvine32.inc


;---------------------------------------------------------------
outputString MACRO promptStr
; prints an array of strings on the screen
;Receives: a string
;Returns: nothing
;Requires: nothing
;---------------------------------------------------------------
	push edx
	mov edx, promptStr
	call WriteString
	pop edx
ENDM

;---------------------------------------------------------------
inputString MACRO inputStr, stringSize
;gets data from the user and strores it in an array
;Receives: a string and size of that string
;Returns: nothing
;Requires: nothing
;---------------------------------------------------------------
	push edx
	push ecx
	mov edx, inputStr
	mov ecx, stringSize - 1
	call ReadString
	pop ecx
	pop edx
ENDM

;---------------------------------------------------------------
outputNum MACRO myNum
;prints an integer on the screen
;Receives: a variable or a registery
;Returns: nothing
;Requires: nothing
;---------------------------------------------------------------
	push eax
	mov eax, myNum
	call WriteInt
	call crlf
	pop eax

ENDM

	strSize = 30

.data

	myStr BYTE "Enter a non-negative number: ",0
	invalid BYTE "Not a valid number",0
	number BYTE "Number: ",0
	triple BYTE "Tripled: ",0
	myStr2 BYTE strSize DUP(?)
	   ;;;; 30 is too large for an input string, a 32 bit value
	   ;;;; is 10 characters long
	   ;;;; -1pt

	num DWORD 0

.code
main PROC

	outputString  OFFSET myStr
	inputString   OFFSET myStr2, strSize
	sub esp,4  
	push OFFSET mystr2 
	push num
		;;;; num needs to be passed by address so atoi can change the value
		;;;; -1pt

	call atoi  
	mov al, 0
	cmp [esp+8], al  
	    ;;;; pop the return data to a register then compare it
		;;;; this is main where esp should be at the bottom of the stack
		;;;; so  there should be no esp+8
		;;;; -1pt

	je FINAL
	outputString OFFSET number
	pop num
	    ;;;; num should not be on the stack because atoi clears out
		;;;; all its input parameters
		;;;; see comment at end of atoi

	outputNum  num
	mov eax, 3
	mul num
	outputString OFFSET triple
	outputNum  eax
	jmp ENDPROGRAM

	FINAL:
		outputString  OFFSET invalid

	ENDPROGRAM: 

	exit		
main ENDP
;---------------------------------------------------------------
isASpace PROC
;checks whether the character is a space character
;Receives: nothing
;Returns: 1 for space, 0 for non-space in a register
;Requires: an input character in al
;---------------------------------------------------------------
	mov edx, 0
	cmp al, 20h
	jne done
	mov edx, 1
	
	done:
		ret	

isASpace ENDP

;---------------------------------------------------------------
isADigit PROC
;checks whether the character is a digit character between '0' and '9'
;Receives: nothing
;Returns: 1 for digit, 0 for non-digit in a register
;Requires: accepts the input character in al
;---------------------------------------------------------------

	mov edx, 0
	cmp al, 39h
	ja done2
	cmp al, 30     ;;;; should be 30h, 
	               ;;;; program doesn't catch non-digit characters
				   ;;;; -1pt
	jb done2
	mov edx, 1
	
	done2:
		ret	

isADigit ENDP


;---------------------------------------------------------------
atoi PROC
;converts the string to a number, if it's a string with valid characters
;Receives: the address of the numeric string and the address of the output integer variable through the stack
;Returns: if the number is valid, passes it back through its address on the stack and returns 1
; if the number is not valid, returns 0 
;Requires: nothing
;---------------------------------------------------------------

	
	push ebp
	mov ebp, esp
	pushad							; push all registers into the stack
	mov ecx, 1						; leading sapce
	mov ebx, 0						; string walker starts at begin of string
	mov esi, [ebp+12]				; esi = address of the user input array 
	
	CHECK:
		mov al, [esi+ebx]			; al = a character from our array 
		cmp al, 0h					; if at the end of the string
		je FINISH
		call isASpace				
		cmp edx, 0
		je NotASpace
		cmp ecx, 1
		jne FINISH
		inc ebx						; increments the walker
		jmp CHECK

	NotASpace:
		call isADigit	
		cmp edx, 0
		je notADigit				; if the character is not a digit
		sub al, 30h					; coverts the charcter into an integer
		movzx eax, al
		push ebx
		mov ebx, [ebp+8]
		mov ecx, ebx
		shl ecx, 3
		shl ebx, 1
		add ebx, ecx
		add ebx, eax
		mov [ebp+8], ebx
		  ;;;; it's more efficient to use a register like ebx to store
		  ;;;; the number inside the loop
		  ;;;; THis way you don't have to keep moving data from ebx to
		  ;;;; the stack and move it back from the stack to ebx every
		  ;;;; time through the loop. 
		  ;;;; -1pt

		pop ebx
		mov ecx, 0
		inc ebx						; increments the walker
		jmp CHECK

	
	notADigit:
		mov ecx, 0					; ecx = 0 if there is a non-digit character in the string
		jmp DONE3

	FINISH:
		mov ecx, 1					; ecx = 1 if the string is valid
		
	DONE3:	
		mov [ebp+16], ecx			; returns the ecx by pushing the integer into the stack
		popad
		pop ebp
		ret 
		   ;;;; need to return and clear out parameters
		   ;;;; -1pt

atoi ENDP
END main


COMMENT!
Screen output:

Enter a non-negative number: 1234
Number: +1234
Tripled: +3702


Enter a non-negative number: 654 3
Number: +654
Tripled: +1962

Enter a non-negative number: asd
Not a valid number


Enter a non-negative number:      1456
Number: +1456
Tripled: +4368

Enter a non-negative number: 123as
Not a valid number

!