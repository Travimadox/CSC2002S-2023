.data
input: .asciiz "Enter two strings:\n"
output1: .asciiz "The strings are equal"
output2: .asciiz "The strings are not equal"
string1: .space 200
string2: .space 200

.text
.globl main

main:
    # Prompt user for strings
    li $v0, 4
    la $a0, input
    syscall
    
    # Read user string1
    li $v0, 8
    la $a0, string1
    li $a1, 200
    syscall

    # Read user string2
    li $v0, 8
    la $a0, string2
    li $a1, 200
    syscall

    # Initialize string pointers
    la $t0, string1  # $t0 = address of string1
    la $t1, string2  # $t1 = address of string2

    # Compare strings
    jal compare_strings
    beq $v0, 0, not_equal

    # Print "The strings are equal"
    li $v0, 4
    la $a0, output1
    syscall
    j exit_program

not_equal:
    # Print "The strings are not equal"
    li $v0, 4
    la $a0, output2
    syscall

exit_program:
    li $v0, 10
    syscall

# Function to compare two strings while ignoring spaces
compare_strings:
    li $v0, 1  # Assume strings are equal initially

compare_loop:
    lb $t2, 0($t0)  # Load a byte from string1
    lb $t3, 0($t1)  # Load a byte from string2

    # Skip spaces in string1
    beq $t2, 32, skip_space1

    # Skip spaces in string2
    beq $t3, 32, skip_space2

    # Check for end of string
    beq $t2, 10, end_of_string1
    beq $t3, 10, end_of_string2

    # Compare characters
    bne $t2, $t3, strings_not_equal

    # Move to next character in both strings
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j compare_loop

skip_space1:
    addi $t0, $t0, 1  # Skip the space in string1
    j compare_loop

skip_space2:
    addi $t1, $t1, 1  # Skip the space in string2
    j compare_loop

end_of_string1:
    beq $t3, 10, end_of_strings  # Both strings have ended
    li $v0, 0  # Strings are not equal
    j end_of_strings

end_of_string2:
    beq $t2, 10, end_of_strings  # Both strings have ended
    li $v0, 0  # Strings are not equal
    j end_of_strings

strings_not_equal:
    li $v0, 0  # Set $v0 to 0 to indicate strings are not equal

end_of_strings:
    jr $ra  # Return
