extern io_print_dec
section .rodata
    one:dq 1.0
    three: dq 3.0
section .data
    a: dq 1.0
    b:dq 1.0
    c: dq 1
section .text

global f1
global f2
global f3
f1:
    push ebp 
    mov ebp, esp
    fld qword[one]
    fld qword[ebp+8]
    fscale
    fld qword[one]
    faddp
    pop ebp
    ret
f2:
    push ebp 
    mov ebp, esp
    fld qword[ebp+8]
    fld qword[ebp+8]
    fmulp
    fld qword[ebp+8]
    fmulp
    fld qword[ebp+8]
    fmulp
    fld qword[ebp+8]
    fmulp
    pop ebp
    ret
f3:
    push ebp 
    mov ebp, esp
    fld qword[one]
    fld qword[ebp+8]
    fsubp
    fld qword[three]
    fdivp
    pop ebp
    ret
