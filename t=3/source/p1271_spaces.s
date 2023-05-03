.bss
.globl squares
.globl stack
.globl key
squares: .space 32000 
stack: .space 32000
key: .space 32000
.data
.globl mask63
.globl mask62
.globl mask56
.globl zero
.globl p0
.globl p1

.p2align 5
zero: .quad 0x0
p0	: .quad 0xFFFFFFFFFFFFFFFF
p1	: .quad 0x7FFFFFFFFFFFFFFF
mask63: .quad 0x7fffffffffffffff
mask62: .quad 0x3fffffffffffffff
mask56: .quad 0xffffffffffffff
