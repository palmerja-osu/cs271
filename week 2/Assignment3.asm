; Author:	James Palmer
; Date: 2/7/2016
; Programming Assignment #3
; Description: 
;1. Implementing data validation
;2. Implementation of an accumulator
;3. Integer arithmetic
;4. Defining variables (integer and string)
;5. Using library procedures for I/O
;6. Implementing control structures (decision, loop, procedure)


INCLUDE Irvine32.inc

upperLimit = 200; Upper limit defined as constant

.data


debugMsg BYTE "madeit"


greetingTitle BYTE "MASM Counter Practice",0
greetingCredit BYTE "by Sam Snyder",0
greetingGetName BYTE "Please enter your name: ",0
greetingName BYTE 21 DUP(0);0
greetingHello BYTE "Hello ",0
instructionsStart BYTE "For this program to work, one must input a number that is lower or equal to your previous number.", 0
instructionsNegative BYTE "At any time, enter a negative number to end.", 0 
instructionsInput BYTE "Enter your number: ",0
inputNumber DWORD ?
feedbackNumber BYTE "You entered the following number: ",0
feedbackError BYTE "Error!! Number was not less than 200. Please try again!",0
resultsMessageMax BYTE "The largest number entered was: ",0
resultsZeroCount BYTE "Nothing exists......",0
resultsMax DWORD 0;0
resultsMin DWORD 999;0 
resultsCount DWORD 0;0
resultsAverage DWORD 0;0 
resultsStdDev DWORD 0 ;0
resultsSum DWORD 0;0 
resultsMaxMessage BYTE "Largest number: ",0
resultsMinMessage BYTE "Smallest number: ",0
resultsCountMessage	BYTE "Number count: ",0
resultsAverageMessage BYTE "Average: ",0
resultsStdDevMessage BYTE "Standard Deviation: ",0
resultsSumMessage BYTE "Sum: ",0
goodbyeMessage BYTE "Goodbye ",0


;main code starts here starting with user greeting

.code
main PROC


mov edx, OFFSET greetingTitle
call WriteString
call Crlf
mov edx, OFFSET greetingCredit
call WriteString
call Crlf
mov edx, OFFSET greetingGetName
call WriteString
mov edx, OFFSET greetingName
mov ecx, SIZEOF greetingName
call ReadString
call Crlf
mov edx, OFFSET greetingHello
call WriteString
mov edx, OFFSET greetingName
call WriteString
call Crlf


mov edx, OFFSET instructionsStart
call WriteString
mov eax, upperLimit
call WriteDec
call Crlf
mov edx, OFFSET instructionsNegative
call WriteString
call Crlf


getInput:
	mov edx, OFFSET instructionsInput
	call WriteString
	call ReadInt
	call Crlf

	
	cmp eax, upperLimit ;0 
	jg badInput ;0
	cmp eax,0
	jl printResults ;0
	mov inputNumber, eax
	jmp calculateData ;0

badInput: 
	mov edx, OFFSET feedbackError
	call WriteString
	call Crlf
	jmp getInput
		

calculateData:
	mov eax, inputNumber
	cmp eax, resultsMax
	jg newMax
afterMax:
	mov eax, inputNumber
	cmp eax, resultsMin
	jl newMin
afterMin:
	inc resultsCount
	mov eax, resultsSum
	add eax, inputNumber
	mov resultsSum, eax
	mov edx, 0
	mov eax, resultsSum
	div resultsCount ;0
	mov resultsAverage, eax
	mov eax, 2
	mul edx
	cmp eax, resultsCount
	jge incAverage ;0

afterAverage:
	jmp getInput

incAverage:
	inc resultsAverage
	jmp afterAverage

newMax:
	mov resultsMax, eax
	jmp afterMax

newMin:
	mov resultsMin, eax
	jmp afterMin


printResults:

mov eax, resultsCount
cmp eax, 1
jl zeroCount ;0

mov edx, OFFSET resultsMaxMessage
mov eax, resultsMax
call WriteString
call WriteDec
call Crlf

mov edx, OFFSET resultsMinMessage
mov eax, resultsMin
call WriteString
call WriteDec
call Crlf

mov edx, OFFSET resultsCountMessage
mov eax, resultsCount
call WriteString
call WriteDec
call Crlf

mov edx, OFFSET resultsAverageMessage
mov eax, resultsAverage
call WriteString
call WriteDec
call Crlf

mov edx, OFFSET resultsSumMessage
mov eax, resultsSum
call WriteString
call WriteDec
call Crlf
jmp Goodbye

zeroCount:
mov edx, OFFSET resultsZeroCount
call WriteString
call Crlf


Goodbye:
mov edx, OFFSET goodbyeMessage
call WriteString
mov edx, OFFSET greetingName
call WriteString
call Crlf

	exit	;0
main ENDP

END main