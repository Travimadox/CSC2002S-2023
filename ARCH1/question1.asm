.data   
    input: .asciiz "Enter a number:\n"
    output: .asciiz "The result is:\n"

.text
.globl main

main:
    #Prompt user for the string
    li $v0, 4
    la $a0, input
    syscall

    #read in integer
    li $v0,5
    syscall

    #Nor it to flip the bits
    nor $t0,$v0,$v0

    #print out answer
    li $v0, 4
    la $a0, output
    syscall

    li $v0,1
    move $a0, $t0
    syscall

    #exit the system
    li $v0,10
    syscall
