@ Start of file Arithmetic1.s
@
@ Copyright 2022 University of Dublin. All Rights Reserved.
@
@ Write an arm program to evaluate 4 * x * x + 3 * x
@ assume x is in r1 and store result in r0
@ 

        MOV     r1, #0x8 


@ Upload the code that goes between the dashed lines.
@ -------------- start cut ------------------------
        MUL     r2, r1, r1     @r2 = x * x
        MOV     r3, #4         @load 4 into r3
        MUL     r2, r2, r3     @r2 = 4 * x * x

        MOV     r3, #3         @load 3 into r3
        MUL     r3, r1, r3     @r3 = 3 * x

        ADD     r0, r2, r3     @r0 = 4 * x * x + 3 * x

@ -------------- end cut --------------------------

stop:   B	stop
@
@ End of file Arithmetic1.s
