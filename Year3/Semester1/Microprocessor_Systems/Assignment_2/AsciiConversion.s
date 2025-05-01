@ Start of file AsciiConversion.s
@
@ Copyright 2022 University of Dublin. All Rights Reserved.
@
@ A sequence of seven ASCII symbols, each in the range '0' . . . '9', can 
@ represent an unsigned value in the range 0 . . . 9,999,999 in text form. 
@ 
@ Design and write an ARM assembly language program that will convert such 
@ a sequence to the value represented by the symbols. 
@ 
@ Assume that the seven byte-size ASCII symbols will be stored in R1 to R7, 
@ with the most significant digit stored in R7. 
@ 
@ Store the result of the conversion in R0.
@ 
@ For example, given the following sequence of ASCII symbols
@         '1', '0', '3', '4', '2', '7', '9'
@ your program should store the value 1,034,279 (0x000FC827) in R0.
@ 
LDR	R7, ='1'
	LDR	R6, ='0'
	LDR	R5, ='3'
	LDR	R4, ='4'
	LDR	R3, ='2'
	LDR	R2, ='7'
	LDR	R1, ='9'
@ Upload the code that goes between the dashed lines.
@ -------------- start cut ------------------------
        SUB	R7, R7, #0x30  @ Convert ASCII '1' to integer (R7 = 1)
	SUB	R6, R6, #0x30  @ Convert ASCII '0' to integer (R6 = 0)
	SUB	R5, R5, #0x30  @ Convert ASCII '3' to integer (R5 = 3)
	SUB	R4, R4, #0x30  @ Convert ASCII '4' to integer (R4 = 4)
	SUB	R3, R3, #0x30  @ Convert ASCII '2' to integer (R3 = 2)
	SUB	R2, R2, #0x30  @ Convert ASCII '7' to integer (R2 = 7)
	SUB	R1, R1, #0x30  @ Convert ASCII '9' to integer (R1 = 9)


	LDR R8, =1000000      @ Load 1,000,000 into R8
	MUL	R0, R7, R8    @ Multiply R7 (1) by 1,000,000

	LDR R8, =100000       @ Load 100,000 into R8
	MUL	R9, R6, R8    @ Multiply R6 (0) by 100,000

           LDR R8, =10000         @ Load 10,000 into R8
	MUL	R10, R5, R8    @ Multiply R5 (3) by 10,000

           LDR R8, =1000          @ Load 1,000 into R0
	MUL	R11, R4, R8    @ Multiply R4 (4) by 1,000

	LDR R8, =100           @ Load 100 into R0
	MUL	R12, R3, R8    @ Multiply R3 (2) by 100

	LDR R8, =10            @ Load 10 into R0
	MUL	R13, R2, R8    @ Multiply R2 (7) by 10

	ADD	R0, R0, R9    
	ADD	R0, R0, R10
           ADD     R0, R0, R11
           ADD     R0, R0, R12
           ADD     R0, R0, R13
           ADD     R0, R0, R1
@ -------------- end cut --------------------------
stop:   B	stop
@
@ End of file AsciiConversion.s
