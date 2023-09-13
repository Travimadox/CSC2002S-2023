.data
input: .asciiz "Enter two strings:\n"
output1: .asciiz "The strings are equal"
output2: .asciiz "The strings are not equal"
string1: .space 200
string2: .space 200

.text
.globl main

main:
    #Prompt user for the string
    li $v0, 4
    la $a0, input
    syscall

    #Read user string1
	li $v0,8
	la $a0,string1
	li $a1,200
	syscall 
    la $t0, string1 #t0 = string1[i]

    #Read user string2
	li $v0,8
	la $a0,string2
	li $a1,200
	syscall 
    la $t1, string2 #t1 = string2[i]


    #findlength
    li $t8,0 #length of string 1
    li $t9,0 #length of string 2
    j findlength

findlength:
    lb $t2,0($t0)
    beq $t2, 10, findlength2
    addi $t8,$t8,1
    addi $t0,$t0,1
    j findlength

findlength2:
    lb $t2,0($t1)
    beq $t2, 10, equalbefore
    addi $t9,$t9,1
    addi $t1,$t1,1
    j findlength2

equalbefore:
    #RESET THE pointers
    la $t0, string1
    la $t1, string2
    li $t3,0 # loop1 variable
    li $t4,0 # loop2 variable

    #select the length to iterate with through the strings
    #string1 greater
    bgt $t8,$t9, loop1
    bgt $t9,$t8, loop2
    b loop1 #if equal

loop1:
    bgt $t3,$t8, equal
    lb $t2,0($t0) #String 1 character
    lb $t7,0($t1) #string 2 character
    beq $t2,32, update1
    beq $t7,32, update2
    bne $t2,$t7, notequal
    addi $t0,$t0,1
    addi $t1,$t1,1
    addi $t3,$t3,1
    j loop1


loop2:
    bgt $t4,$t9, equal
    lb $t2,0($t0) #String 1 character
    lb $t7,0($t1) #string 2 character

    beq $t2,32, update3
    beq $t7,32, update4

    bne $t2,$t7, notequal
    addi $t0,$t0,1
    addi $t1,$t1,1
    addi $t4,$t4,1
    j loop2

update1:
    addi $t0,$t0,1
    j loop1

update2:
    addi $t1,$t1,1
    j loop1


update3:
    addi $t0,$t0,1
    j loop2

update4:
    addi $t1,$t1,1
    j loop2

equal:
# Print out output2 message
    li $v0, 4
    la $a0, output1
    syscall
    j exit

notequal:
    # Print out output2 message
    li $v0, 4
    la $a0, output2
    syscall
    j exit


exit:
    li $v0,10
    syscall