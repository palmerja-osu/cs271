;Author: James Palmer
;Email: palmerja@oregonstate.edu
;Class: CS_271_400_W2016   
;Assignment: Program #5   
;Due: 2/28/2016

NCLUDE Irvine32.inc

.data

welcome					   BYTE	  "Project 5: sorting random integers By James Palmer.", 0
instructions_1			   BYTE	  "Please enter a number between [10, 200] to see all presorted numbers. ",0
instructions_2			   BYTE   "Finally, show the sorted list in descending order", 0
instructions_3			   BYTE   "Please enter a number between 10 and 200.", 0
belowError				   BYTE   "The number you entered was too small. ", 0
aboveError				   BYTE   "The number you entered was too big. ", 0
medianString			   BYTE	  "The median is: ",0
spaces					   BYTE	  "   ", 0
goodbye					   BYTE	  "End of program!", 0
beforeSort				   BYTE	  "The array before sorting: ", 0
afterSort				   BYTE	  "The array after sorting: ", 0
number					   DWORD  ?
request					   DWORD  ?
requestTemp			       DWORD  ?
;constants
MIN				=		 10
MAX				=		 200
LO				=		 100
HI				=		 999
MAX_SIZE		=		 200
;Array
list					   DWORD MAX_SIZE DUP(?)  ;

val1 DWORD 11
val2 DWORD 16
.code
 main PROC
	push val1
	push val2
	
	call introduction
	push OFFSET request
	call getData
	call Randomize			
	push OFFSET list
	push request
	call fillArray
	mov  edx, OFFSET beforeSort
	call WriteString
	call CrLf
	push OFFSET list
	push request
	call displayList
	push OFFSET list
	push request
	call sortList
	call CrLf
	push OFFSET list
	push request
	call displayMedian
	call CrLf
	mov  edx, OFFSET afterSort
	call WriteString
	call CrLf
	push OFFSET list
	push request
	call displayList
	call farewell
	exit
main ENDP

introduction PROC
	; Intro proc to user
	call	 CrLf
	mov		 edx, OFFSET welcome
	call	 WriteString
	call	 CrLf
	; What  is the user  seeing in this assingment?
	mov		edx, OFFSET instructions_1
	call	WriteString
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	ret
introduction ENDP

getData PROC

	
		push ebp
		mov	 ebp, esp
		mov	 ebx, [ebp + 8] 


	userNumberLoop:
					mov		edx, OFFSET instructions_3
					call	WriteString
					call	CrLf
					call    ReadInt
					mov     [ebx], eax		
					cmp		eax, MIN
					jb		errorBelow
					cmp		eax, MAX
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
			pop ebp
	ret 4 
getData ENDP

;fill array 

fillArray PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]  
	mov	 ecx, [ebp + 8]   

	fillArrLoop:
		mov		eax, HI
		sub		eax, LO
		inc		eax
		call	RandomRange
		add		eax, LO
		mov		[esi], eax  ; random number in array
		add		esi, 4		; next element
		loop	fillArrLoop

	pop  ebp
	ret  8
fillArray ENDP

;list out min values per row

displayList PROC
	push ebp
	mov  ebp, esp
	mov	 ebx, 0			  
	mov  esi, [ebp + 12]  
	mov	 ecx, [ebp + 8]   
	displayLoop:
		mov		eax, [esi]  ;current element
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		ebx
		cmp		ebx, MIN
		jl		skipCarry
		call	CrLf
		mov		ebx,0
		skipCarry:
		add		esi, 4		;next element in sequence
		loop	displayLoop
	endDisplayLoop:
		pop		ebp
		ret		8
displayList ENDP

;print out values of our created list

sortList PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]			
	mov	 ecx, [ebp + 8]				
	dec	 ecx
	outerLoop:
		mov		eax, [esi]			; get current element
		mov		edx, esi
		push	ecx					; save outer loop 
		innerLoop:
			mov		ebx, [esi+4]
			mov		eax, [edx]
			cmp		eax, ebx
			jge		skipSwitch
			add		esi, 4
			push	esi
			push	edx
			push	ecx
			call	exchange
			sub		esi, 4
			skipSwitch:
			add		esi,4

			loop	innerLoop
			skippit:
		pop		ecx 			; restore outer loop counter
		mov		esi, edx		

		add		esi, 4			; next element
		loop	outerLoop
	endDisplayLoop:
		pop		ebp
		ret		8
sortList ENDP

;print out values start here
exchange PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, [ebp + 16]	 ;first number			
	mov		ebx, [ebp + 12]	 ;second number			
	mov		edx, eax
	sub		edx, ebx					

	; somehow we got to switch these two up.
	mov		esi, ebx
	mov		ecx, [ebx]
	mov		eax, [eax]
	mov		[esi], eax  ; put eax in array
	add		esi, edx
	mov		[esi], ecx

	popad
	pop		ebp
	ret		12
exchange ENDP


;display proc starts here
displayMedian PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]  
	mov	 eax, [ebp + 8]   
	mov  edx, 0
	mov	 ebx, 2
	div	 ebx
	mov	 ecx, eax


	medianLoop:
		add		esi, 4
		loop	medianLoop

	; check for zero
	cmp		edx, 0
	jnz     itsOdd
	; its even
	mov		eax, [esi-4]
	add		eax, [esi]
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	mov		edx, OFFSET medianString
	call	WriteString
	call	WriteDec
	call	CrLf
	jmp		endDisplayMedian

	itsOdd:
	mov		eax, [esi]
	mov		edx, OFFSET medianString
	call	WriteString
	call	WriteDec
	call	CrLf

	endDisplayMedian:

	pop  ebp
	ret  8
displayMedian ENDP

; say goodbye
farewell PROC

	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	call	CrLf
	exit
farewell ENDP
END main