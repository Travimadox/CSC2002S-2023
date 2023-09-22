    .data
output_buffer:  .space 20  # Allocate space for output string

    .text
    .globl main

main:
    # Initialize stack frame for main
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize integer in $a0
    li $a0, 1234

    # Load the address of output_buffer into $a1
    la $a1, output_buffer

    # Call int2str function
    jal int2str

    # Output the converted string (optional, but useful for testing)
    # We're assuming that you have a print_string function
    la $a0, output_buffer
    jal print_string

    # Restore $ra and remove the main's stack frame
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    # Exit program
    li $v0, 10
    syscall

# Your int2str function goes here
int2str:
    # Initialize loop counter and buffer index
    li $t8, 0
    li $t6, 10

    # Reverse the integer to convert from least significant digit to most
    li $t7, 0
    int2str_reverse_loop:
        beq $a0, $zero, int2str_conversion_loop
        div $a0, $t6
        mfhi $t9
        mul $t7, $t7, $t6
        add $t7, $t7, $t9
        divu $a0, $a0, $t6
        j int2str_reverse_loop

    # Convert reversed integer to ASCII character
    int2str_conversion_loop:
        beq $t7, $zero, int2str_end
        div $t7, $t6
        mfhi $t9
        addiu $t9, $t9, 48
        sb $t9, 0($a1)
        addi $a1, $a1, 1
        divu $t7, $t7, $t6
        j int2str_conversion_loop

    int2str_end:
    # Null-terminate the string
    sb $zero, 0($a1)

    # Exit
    jr $ra

# Utility function to print a string
print_string:
    # Store return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Print string using syscall
    li $v0, 4
    syscall

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
