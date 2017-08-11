; Author:	James Palmer
; Date: 2/7/2016
; Program #4
; Description: 
; 1. Designing and implementing  procedures
; 2. Designing and implementing loops
; 3. Writing nested loops
; 4. Understanding data validation
; Description: This Program is to calculate composite numbers. First, the user is instructed to enter the number of composites to be displayed,
;				and is prompted to enter an integer in the range [1 .. 400].  
;				The user enters a number, n, and the program verifies that 1 ≤ n ≤ 400.  If n is out of range, the user is re-prompted until s/he enters a value in the specified range.  
;				The program then calculates and displays all of the composite numbers up to and including the nth composite.  
;				The results should be displayed 10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

.data

welcome					   BYTE	  "We are going to calculate composite numbers so you do not have to.", 0
instructions_1			   BYTE	  "Please enter a number between 1 - 400 ",0
belowError				   BYTE   "The number you entered was too small. ", 0
aboveError				   BYTE   "The number you entered was too big. ", 0
spaces					   BYTE	  "   ", 0
goodbye					   BYTE	  "Run the Zerglings are coming! Save yourself! ARRRRHHHHHH! ", 0 ;joke from this weeks assignment in 261
number					   DWORD  ?
count					   DWORD  1

userNumber				   DWORD  ?
userNumberTemp			   DWORD  ?
innerLoopCount			   DWORD  ?
outerLoopCount			   DWORD  ?
underScore				   BYTE	  " _ ", 0
barr					   BYTE	  " | ", 0
outerCompare			   DWORD  ?
innerCompare			   DWORD  ?
writeCount				   DWORD  0
tenn				       DWORD  10



;constants
LOWERLIMIT		=		 1
UPPERLIMIT		=		 400



.code
 main PROC

	
	call introduction
	call getUserData
		;validate
	call showComposites
		;validate is composite
	call farewell

	exit
main ENDP

introduction PROC

	; Programmer name and title of assignment
	call	 CrLf
	mov		 edx, OFFSET welcome
	call	 WriteString
	call	 CrLf

	; assignment instructions
	mov		edx, OFFSET instructions_1
	call	WriteString
	call	CrLf
	mov		ecx, 0
	ret

introduction ENDP

getUserData PROC

; loop to allow user to continue entering negative numbers
userNumberLoop:
			mov		eax, count
			add		eax, 1
			mov		count, eax
			call	WriteString
			call	CrLf
			call    ReadInt
			mov     userNumber, eax
			cmp		eax,LOWERLIMIT
			jb		errorBelow
			cmp		eax, UPPERLIMIT
			jg		errorAbove
			jmp		continue

errorBelow:
			mov		edx, OFFSET belowError
			call	WriteString
			call	CrLf
			jmp		userNumberLoop
errorAbove:
			mov		edx, OFFSET aboveError
			call	WriteString
			call	CrLf
			jmp		userNumberLoop
continue:
			mov		ecx, 4
			mov		userNumberTemp, ecx
			cmp		ecx, userNumber
			ja		farewell

ret
getUserData ENDP


showComposites PROC

;inner loop
			mov		eax, userNumber
			sub		eax, 2
			mov		innerLoopCount, eax

;outer loop
			mov		eax, userNumber
			sub		eax, 3
			mov		outerLoopCount, eax
			mov		ecx, outerLoopCount
			mov		eax, 4
			mov		outerCompare, eax

; reset inner loop after each complete inner loop cycle
			mov		eax, 2
			mov		innerCompare, eax
			call	CrLf

outerLoop:
		skipCarry:
			mov		eax, 2
			mov		innerCompare, eax
			mov		eax, outerCompare
			push	ecx
			push	eax
			mov		ecx, innerLoopCount

		isComposite:
			mov		eax, outerCompare
			mov		edx, 0
			div		innerCompare
			cmp		edx, 0
			jne		skipPrint

			mov		eax, outerCompare
			call	WriteDec
			mov		edx, OFFSET spaces
			call	WriteString
			mov		ebx, writeCount
			inc		ebx
			mov		writeCount, ebx
			cmp		ebx, 10
			jne		exitInnerLoop
			call	CrLf
			mov		writeCount,esi
			jmp		exitInnerLoop

		skipPrint:
		mov		ebx, innerCompare

		sub		eax, 1
		cmp		eax, ebx
		jae		skipIncrement
		add		eax, 1
		mov		innerCompare, eax
		skipIncrement:
		loop isComposite
		exitInnerLoop:

	pop		eax
	pop		ecx
	inc		eax
	mov		outerCompare, eax
	loop	outerLoop

	ret
showComposites ENDP

farewell PROC

		call	CrLf
		mov		edx, OFFSET goodbye
		call	WriteString
		call	CrLf
		call	CrLf
		exit
farewell ENDP
END main