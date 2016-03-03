TITLE Lab 7				(lab7.asm)

; Description: Calculate scores with nested procedure calls
; Author:Poureya Sohbati
; Date: 11/30/13

INCLUDE Irvine32.inc

AGrade = 414		;minimum score for an A
BGrade = 368		;minimum score for a B
CGrade = 322		;minimum score for a C

; Does a calculation and prints a number onto the screen
print MACRO var
; Recieves a the scrore through eax and the minimum score required 

	push eax
	push ebx
	mov ebx, var	; ebx = Minimum Grade
	sub ebx, eax	; ebx = minimum - Student's score
	mov eax, ebx	; eax =  points needed
	call WriteInt
	mov eax, 2ch	; eax = ','
	call WriteChar
	mov eax, 20h	; eax = ' '
	call WriteChar
	pop ebx
	pop eax
ENDM

.data
menu BYTE   "1. Print assignment scores", 0ah, 0dh,
			"2. Print quiz scores", 0ah, 0dh,
			"3. Print midterm scores", 0ah, 0dh,
			"4. Print extra credit scores", 0ah, 0dh,
			"5. Quit", 0ah, 0dh,
			"Choice: ", 0

scores BYTE 14,18,19,19,19,14,20,100,  ; assignments, 7 scores
            10,10,8,9,9,10,100,		; quizzes, 6 scores (lowest score dropped)
            73,62,100,                 ; midterms, 2 scores
            5,0,2,2,0,100              ; extra credit, 4 scores (Check quiz and modules 1,3,5,6)

outStr BYTE "Scores: ",0
finalStr BYTE "Final exam score for A, B, C are: ",0

.code
; main: call oneRow, then call final
	
main PROC

	push OFFSET scores
	push LENGTHOF scores
	push OFFSET menu
	push OFFSET outStr
	call oneRow
	push OFFSET finalStr
	call final
	exit
main ENDP

; oneRow: store row addresses
;         loop to print menu and call display until choice is 5
oneRow PROC


	push ebp
	mov ebp, esp
	sub esp, 16					; creating 4 local variables
	pushad
	mov edi, [ebp+20]			; edi = address array of scores
	mov ebx, ebp				; ebx = frame of the procedure
	sub ebx, 4
	mov [ebx], edi				; var1 = address of the firs score 
	mov ecx, [ebp+16]			; ecx = length of the array
	mov al, 64h					; the number that we're looking for in our array (100)
	cld							; incrementing edi

	L1:
		repne scasb
		jnz L2					; go to L2 if ecx == 0 (end of the array)
		sub ebx, 4
		mov [ebx], edi
	jmp L1
		
	L2: 
		mov edx, [ebp+12]		; edx = address of the menu
		call WriteString
		call readDec
		cmp eax, 5
		je done					; finish procedere if user choose 5
		mov ebx, 4
		mul ebx
		mov ebx, ebp
		sub ebx, eax
		push [ebx]				; push the address of the chosen par of the array
		push [ebp+8]			; push the address of the OutStr
		call display
		jmp L2
	
	done:
		popad
		add esp, 16				; deleting the local variables by making the esp to point to ebp
		pop ebp
		ret 12

oneRow ENDP

; display: print text explanation and print all elements of one row
display PROC

	push ebp
	mov ebp, esp
	pushad
	mov edx, [ebp+8]					; edx = address of the OutStr
	call WriteString
	mov esi, [ebp+12]					; esi = chosen part of the score array
	xor eax, eax


	L:
		mov al, BYTE ptr [esi]			; al = score
		call WriteDec
		mov al, 20h						; al = ' '
		call writeChar
		inc esi
		cmp byte ptr [esi], 64h
		jne L							; while (esi != 100)

	call crlf
	call crlf

	popad
	pop ebp
	ret 8

display ENDP

; final: calculate and print final exam scores with text explanation
final PROC
	
	push ebp
	mov ebp, esp
	pushad
	xor ecx, ecx
	mov esi, [ebp+12]				; esi = address of the score array
	xor eax, eax
	xor ebx, ebx


	L1:
		inc ecx
		cmp ecx, 5
		je done	

	L2:
		mov bl, BYTE ptr [esi]		; bl = esi (score)
		inc esi
		cmp bl, 64h
		je L1			
		add eax, ebx				; eax += score
		jmp L2

	done:
		mov edx, [ebp+8]			; edx = address the finalStr array
		call WriteString			
		print AGrade
		print BGrade
		print CGrade
		popad
		pop ebp
		ret 8

final ENDP


END main

COMMENT !
Screen Output:

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 1
Scores: 14 18 19 19 19 14 20

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 2
Scores: 10 10 8 9 9 10

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 3
Scores: 73 62

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 4
Scores: 5 0 2 2 0

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 3
Scores: 73 62

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 5
Final exam score for A, B, C are: +91, +45, -1,

Screen Output2:
1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 1
Scores: 20 20 20 20 20 20 20

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 2
Scores: 10 10 10 10 10 10

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 3
Scores: 80 80

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 4
Scores: 5 2 2 2 2

1. Print assignment scores
2. Print quiz scores
3. Print midterm scores
4. Print extra credit scores
5. Quit
Choice: 5
Final exam score for A, B, C are: +41, -5, -51,
!