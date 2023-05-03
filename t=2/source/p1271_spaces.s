.bss
.globl squares
.globl stack
.globl key
.globl p0
.globl p1

squares: .space 32000 
stack: .space 32000
key: .space 32000
.data
.globl mask63
.globl mask62
.globl mask56
.globl zero
.p2align 5
p0	: .quad 0xFFFFFFFFFFFFFFFF
p1	: .quad 0x7FFFFFFFFFFFFFFF
zero    : .quad 0x0
mask63: .quad 0x7fffffffffffffff
mask62: .quad 0x3fffffffffffffff
mask56: .quad 0xffffffffffffff
