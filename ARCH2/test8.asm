.data
buffer: .space 12         # Reserve space for buffer (max 10 digits + null terminator)
int_msg: .asciiz "The integer was "
str_msg: .asciiz "\nThe string is "

.text
.globl main
main:
    # Initialize $t3 with an integer value (12345)
    li  $t3, 12345

    # Initialize $t1 with the address of the buffer
    la  $t1, buffer

    # Print "The integer was "
    la   $a0, int_msg
    li   $v0, 4
    syscall

    # Print the integer
    move $a0, $t3
    li   $v0, 1
    syscall

    # Initialize some registers for the loop
    li   $t0, 10       # Store 10 in $t0 for division and modulo operations
    li   $t2, 0        # Counter to keep track of the number of digits

    convert_loop:
        div  $t3, $t0
        mflo $t3
        mfhi $t4

        addi $t4, $t4, 48
        sb   $t4, 0($t1)

        addi $t1, $t1, 1
        addi $t2, $t2, 1

        bnez $t3, convert_loop

    # Reverse the string (use $t2 for the number of iterations)
    srl  $t2, $t2, 1
    la   $t4, buffer

    reverse_loop:
        lb   $t5, 0($t1)
        lb   $t6, 0($t4)

        sb   $t5, 0($t4)
        sb   $t6, 0($t1)

        addi $t1, $t1, -1
        addi $t4, $t4, 1
        addi $t2, $t2, -1

        bnez $t2, reverse_loop

    # Null-terminate the string
    addi $t4, $t4, -1
    li   $t5, 0
    sb   $t5, 0($t4)

    # Print "The string is "
    la   $a0, str_msg
    li   $v0, 4
    syscall

    # Print the string
    la   $a0, buffer
    li   $v0, 4
    syscall

    # Exit
    li   $v0, 10
    syscall
