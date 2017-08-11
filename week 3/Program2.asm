;Author: James Palmer
;Email: palmerja@oregonstate.edu
;Class: CS_271_400_S2016   
;Assignment: Program #2
;Due: 4/17/2016


INCLUDE Irvine32.inc

.data
 

programTitle        BYTE "Programming Assignment #2",0
firstMessage		BYTE "Fibonacci Numbers	 ",0						
secondMessage		BYTE "Programmed by Leonardo Pisano. ",0
thirdMessage		BYTE "What is your name? ",0
str1				BYTE "Please enter your name: ",0									;ask for user name 
buffer				BYTE 80 DUP(0)
fourthMessage		BYTE "Enter the number of Fibonacci terms to be displayed",0dh,0ah,0;
promptMessage1		BYTE " Give the number as an integer in the range [1 .. 46].",0dh,0ah,0;
promptMessage2		BYTE "How many Fibonacci terms do you want?",0							
endMessage			BYTE "Certified results from Leonardo Pisano.  Goodbye.",0				
askQuit				BYTE "To close this window hit ENTER.",0								
prev2Numbers		DWORD 0																;temporary integer	
spaces				BYTE "  ",0															;whitespace between numbers for grid
counter				BYTE 0																;5 numbers per line 
.code

main PROC;
	MOV edx, OFFSET firstMessage					;Display instructions line 1
	CALL	WriteString;
	MOV edx, OFFSET  secondMessage					;Display instructions line 2
	CALL	WriteString;
	MOV edx, OFFSET  thirdMessage					;Display instructions line 3
	CALL	WriteString;
	
	mov	edx, OFFSET str1							;Display inputed name
	call WriteString
	mov eax, OFFSET buffer
	mov ebx, SIZEOF buffer
	call ReadString

	MOV edx, OFFSET  fourthMessage					;Display instructions line 3
	CALL	WriteString;

;code for looping the Fibonacci Program
doThis:								
		
	MOV	edx,OFFSET promptMessage1		;Display instructions line 3
	CALL	WriteString;
	MOV	edx,OFFSET promptMessage2		;Display instructions line 1
	CALL	WriteString;
	CALL	ReadInt						;read the users input (integer)
	CMP	eax, 46							;check condition using CMP
	JA	doThis							;if above 46 jump loop again
	CMP	eax, 1							;check condition using CMP
	JB	doThis							;if below 1 jump loop again

;Ending the loop here

	mov ecx, eax						; set the counter register
	MOV	ebx, 0;						
	MOV	edx, 1;
	MOV al, 0;
fibLoop:
	ADD prev2Numbers, edx;				;prev2Numbers will be assigned to ebx					
	ADD eax, prev2Numbers				;store the 2 previous numbers into eax
	MOV ebx, edx						
	MOV edx, eax						
	CALL WriteInt						;show number(s)
	MOV edx, OFFSET spaces				;whitespace
	setNewLine: CALL resetLine			;write on a new line the next 5 numbers
	CALL	WriteString;
	INC counter							; five counter
	CMP counter, 5					
	JE setNewLine						;if counter == 5 go to add a new line
		
LOOP fibLoop;


	CALL Crlf							;end of line
	MOV edx,OFFSET endMessage			;Display instructions line 1
	CALL	WriteString;
	MOV edx, OFFSET  askQuit			;Display instructions line 2
	CALL	WriteString					;ask for a 0 to quit	
	CALL	ReadInt						;keeps the window open for viewing
	exit; 

main ENDP;

resetLine PROC
	MOV	counter, 0;
	CALL Crlf;
resetLine endP;


END main