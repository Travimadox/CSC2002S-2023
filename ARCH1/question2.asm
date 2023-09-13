.data
    input: .asciiz "Enter a number:\n"
    output: .asciiz "The factorial is:\n"

.text

.globl main

main:
    #Prompt user for integer
    li $v0,4
    la $a0,input
    syscall

    #read in integer
    li $v0,5
    syscall

    #check if N = 1 or N =0
    li $t1,1
    beq $v0,$t1,print
    beq $v0,$zero,print

    #calculate factorial
    li $t0,1 #multiplying factorial
    li $t2,1 #Loop variable
    li $t3,1

loop:
    bgt $t2,$v0,factorial
    mul $t3,$t3,$t2
    addi $t2,$t2,1
    j loop


factorial:
    li $v0,4
    la $a0,output
    syscall

    li $v0,1
    move $a0, $t3
    syscall

    #exit
    li $v0,10
    syscall

print:
    li $v0,4
    la $a0,output
    syscall

    li $v0,1
    move $a0, $v0
    syscall

    #exit
    li $v0,10
    syscall
