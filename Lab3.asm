
TITLE Template of lab source code           (Lab4.asm)

; Program Description: calculates the difference between two military time
; Author: Poureya Sohbati
; Date:   10/14/2013

INCLUDE Irvine32.inc

.data

;;;;; use more descriptive variable names
	prompt1 BYTE "Enter start time: ",0
	prompt2 BYTE "Enter end time: ",0
	output1 BYTE "The time difference is ",0
	output2 BYTE " hr and ",0
	output3 BYTE " min",0
	
.code
main PROC
	
	mov  EDX, OFFSET prompt1
	call WriteString
	call ReadInt

	mov dx, 0								
	mov cx, 100
	div cx						; to divide mins from hrs
	mov cx, 60				
;;;;; it's a good idea to use one register for 100 and another register for 60
;;;;; so you don't have to keep loading cx with these 2 values
	
	mov di, dx
	mul cx						; to convert hrs to mins
	add di, ax					; stores total starting mins in di

	mov  EDX, OFFSET prompt2
	call WriteString
	call ReadInt

	mov dx, 0 
	mov cx, 100
	div cx						; to divide mins from hrs
	mov cx, 60
	mov bx, dx
	mul cx						; to convert hrs to mins
	add ax, bx					; stores total starting mins in di

	sub ax, di					; subtracts the starting time from the ending time
	mov cx, 60
	cwd
	idiv cx
	mov di, dx					; moves the difference in mins into di
	movsx eax, ax				; moves ax with sign extention into the eax, in case ax negative

	mov  EDX, OFFSET output1
	call WriteString
	call WriteInt
	mov  EDX, OFFSET output2
	call WriteString
	movsx eax, di				; moves the difference in mins into eax with sign extention
	call WriteInt
	mov  EDX, OFFSET output3
	call WriteString

;;;;; use crlf here so the output is on a line by itself
	
	exit
main ENDP
	
END main


COMMENT !

SCREEN OUTPUT:


Enter start time: 930
Enter end time: 1420
The time difference is +4 hr and +50 min



Enter start time: 1615
Enter end time: 1435
The time difference is -1 hr and -40 min

Enter start time: 1726
Enter end time: 1950
The time difference is +2 hr and +24 min

Enter start time: 1435
Enter end time: 1242
The time difference is -1 hr and -53 min
!
