;Author: James Palmer
;Email: palmerja@oregonstate.edu
;Class: CS_271_400_W2016   
;Assignment: Program #6A   
;Due: 3/13/2016

INCLUDE c:/Irvine/Irvine32.inc

.data

welcome					   BYTE	  "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures By James Palmer.", 0
instructions_1			   BYTE	  "Please provide 10 unsigned decimal integers.",0 
instructions_2			   BYTE   "Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 0
instructions_3			   BYTE   "Please enter your desired unsigned integer: ", 0
aveString				   BYTE	  "The average is: ",0
errString				   BYTE	  "ERROR: You did not enter an unsigned number or your number was too big!", 0
spaces					   BYTE	  ", ", 0
goodbye					   BYTE	  "Thank you for playing!", 0
enteredString			   BYTE   "You entered the following numbers: ", 0
sumString				   BYTE   "The sum of these numbers is: ", 0
request					   DWORD  10 DUP(0)
requestCount			   DWORD  ? 
;constants
MIN				=		 0
LO				=		 30h
HI				=		 39h
MAX_SIZE		=		 10
;Array
list					   DWORD MAX_SIZE DUP(?)  
strResult				   db 16 dup (0)		  



getString MACRO	instruction, request, requestCount
	;aquiring string macro here
	push	edx
	push	ecx
	push	eax
	push	ebx
	mov			edx, OFFSET instructions_3
	call	WriteString
	mov			edx, OFFSET request
	mov			ecx, SIZEOF	request
	call	ReadString
	mov			requestCount, 00000000h
	mov			requestCount, eax	
	pop     ebx
	pop			eax
	pop			ecx
	pop			edx
ENDM


displayString MACRO  strResult

	push	edx
	mov			edx, strResult
	call	WriteString
	pop			edx

ENDM


.code
 main PROC

	call	introduction

	push	OFFSET list
	push	OFFSET request
	push	OFFSET requestCount
	call	readVal

	call	CrLf

	push	OFFSET aveString
	push	OFFSET sumString
	push	OFFSET list
	call	displayAve

	call	CrLf

	push	edx
	mov		edx, OFFSET enteredString
	call	WriteString
	pop		edx

	push	OFFSET strResult
	push	OFFSET list
	call	writeVal

	call	CrLf
	
	push	OFFSET goodbye
	call	farewell
	
	exit
main ENDP




introduction PROC

	call	 CrLf
	mov		 edx, OFFSET welcome
	call	 WriteString
	call	 CrLf
	call	 CrLf
	
	mov		edx, OFFSET instructions_1
	call	WriteString
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	ret

introduction ENDP



readVal PROC

		push  ebp
		mov	  ebp, esp
		mov	  ecx, 10								 
		mov	  edi, [ebp+16]							

	userNumberLoop: 	
					
					getString instructions_3, request, requestCount    

					push	ecx
					mov		esi, [ebp+12]			
					mov		ecx, [ebp+8]			
					mov		ecx, [ecx]				
					cld								
					mov		eax, 00000000			
					mov		ebx, 00000000			
					
						str2int:
							lodsb					
							
							cmp		eax, LO			
							jb		errMessage		
							cmp		eax, HI			
							ja		errMessage		
							
							sub		eax, LO			
							push	eax
							mov		eax, ebx
							mov		ebx, MAX_SIZE
							mul		ebx
							mov		ebx, eax
							pop		eax
							add		ebx, eax
							mov		eax, ebx
							
							continn:
							mov		eax, 00000000
							loop	str2int

					mov		eax,ebx 
					stosd				;this should put eax into the listed array			
					
					add		esi, 4					
					pop		ecx						
					loop	userNumberLoop
					jmp		readValEnd
		
		errMessage:
				pop		ecx
				mov		edx, OFFSET  errString
				call	WriteString
				call	CrLf
				jmp		userNumberLoop

	readValEnd:
	pop ebp			
	ret 12													
readVal ENDP


;this section is intended to convert given string to the ascii
writeVal PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 8]				
	mov		ecx, 10
	L1:	
				push	ecx
				mov		eax, [edi]
			    mov		ecx, 10         
				xor		bx, bx         

			divide:
				xor		edx, edx				
				div		ecx						  
				push	dx						 
				inc		bx						  
				test	eax, eax				 
				jnz		divide					  

												  
				mov		cx, bx					 
				lea		esi, strResult			  
			next_digit:
				pop		ax
				add		ax, '0'					  
				mov		[esi], ax				  
				
				displayString OFFSET strResult

				loop	next_digit
			
		pop		ecx 
		mov		edx,	OFFSET spaces
		call	WriteString
		mov		edx, 0
		mov		ebx, 0
		add		edi, 4
		loop L1
	
	pop		ebp			
	ret		8											
writeVal ENDP


displayAve PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 8]  
	mov	 eax, 10										
	mov  edx, 0
	mov	 ebx, 0
	mov	 ecx, eax

	medianLoop:
		mov		eax, [esi]
		add		ebx, eax
		add		esi, 4
		loop	medianLoop
	
	endMedianLoop:
	
	mov		edx, 0
	mov		eax, ebx
	mov		edx, [ebp+12]
	call	WriteString
	call	WriteDec
	call	CrLf
	mov		edx, 0
	mov		ebx, 10
	div		ebx
	mov		edx, [ebp+16]
	call	WriteString
	call	WriteDec
	call	CrLf

	endDisplayMedian:

	pop		ebp
	ret		12
displayAve ENDP


farewell PROC
	
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]							

	call	CrLf	
	call	WriteString
	call	CrLf
	pop		ebp
	ret		4
	
farewell ENDP


exit
END main

