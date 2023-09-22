    .data
string_buffer:  .asciiz "123"

    .text
    .globl main

main:
    # Initialize stack frame for main
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Load the address of string_buffer into $a1
    la $a1, string_buffer

    # Call str2int function
    jal str2int

    # Store the result (in $v0) for future use or debugging
    move $t2, $v0

    # Output the converted integer (optional, but useful for testing)
    # We're assuming that you have a print_int function to print the integer
    move $a0, $v0
    jal print_int

    # Restore $ra and remove the main's stack frame
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    # Exit program
    li $v0, 10
    syscall


print_int:
    # Store return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # print integer using syscall
    move $a0, $t2
    li $v0, 1
    syscall

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra




# Your str2int function goes here
str2int:
    # Convert pixel to integer
    li $t7, 0 # initialize integer to 0
    li $t8, 0 # initialize loop counter to 0

    str2int_loop:
        # Check if character is a digit
        lb $t9, 0($a1) # load character into $t9
        li $t0, 48 # load 48 into $t0
        li $t1, 57 # load 57 into $t1
        blt $t9, $t0, str2int_end # if character is less than 48, exit loop
        bgt $t9, $t1, str2int_end # if character is greater than 57, exit loop

        # Convert character to integer
        sub $t9, $t9, $t0 # subtract 48 from character
        mul $t7, $t7, 10 # multiply integer by 10
        add $t7, $t7, $t9 # add character to integer

        # Increment loop counter
        addi $t8, $t8, 1 # increment loop counter

        # Increment buffer pointer
        addi $a1, $a1, 1 # increment buffer pointer

        # Check if loop counter is 3
        bne $t8, 3, str2int_loop # if loop counter is not 3, repeat loop

    str2int_end:
        # Exit
        move $v0, $t7 # save integer in $v0
        jr $ra # return to main

