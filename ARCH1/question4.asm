.data
    input: .asciiz "Enter an equation:\n"
    output: .asciiz "The result is: "
    equation: .space 200

.text
.globl main

main:
    # Prompt the user for the equation
    li $v0, 4
    la $a0, input
    syscall

    # Read the equation from the user
    li $v0, 8
    la $a0, equation
    li $a1, 200
    syscall
    
    move $t0, $a0 # $t0 points to the start of the equation
    li $t1, 0     # $t1 will store the first operand
    li $t2, 0     # $t2 will store the second operand
    li $t5, 1     # $t5 will store the sign of operand1 (1 for positive, -1 for negative)
    li $t6, 1     # $t6 will store the sign of operand2 (1 for positive, -1 for negative)

    # Check for '-' before operand1
    lb $t3, 0($t0)
    beq $t3, 45, negate_operand1
    j parse_operand1

negate_operand1:
    li $t5, -1
    addi $t0, $t0, 1  # Skip the '-' sign

parse_operand1:
    lb $t3, 0($t0)  # Load the next character
    beq $t3, 43, parse_operand2  # If it's '+', proceed to parsing operand2
    sub $t3, $t3, 48  # Convert ASCII to integer
    mul $t1, $t1, 10
    add $t1, $t1, $t3  # Update the operand
    addi $t0, $t0, 1   # Move to the next character
    j parse_operand1

parse_operand2:
    addi $t0, $t0, 1   # Skip the '+' sign

    # Check for '-' before operand2
    lb $t3, 0($t0)
    beq $t3, 45, negate_operand2
    j parse_operand2_loop

negate_operand2:
    li $t6, -1
    addi $t0, $t0, 1  # Skip the '-' sign

parse_operand2_loop:
    lb $t3, 0($t0)  # Load the next character
    beq $t3, 0, compute  # If it's the end of the string, compute the sum
    sub $t3, $t3, 48  # Convert ASCII to integer
    mul $t2, $t2, 10
    add $t2, $t2, $t3  # Update the operand
    addi $t0, $t0, 1   # Move to the next character
    j parse_operand2_loop

compute:
    mul $t1, $t1, $t5  # Apply the sign to operand1
    mul $t2, $t2, $t6  # Apply the sign to operand2
    add $t4, $t1, $t2  # Compute the sum

    # Print the result
    li $v0, 4
    la $a0, output
    syscall

    # Print the computed sum
    move $a0, $t4
    li $v0, 1
    syscall

exit:
    # Exit the program
    li $v0, 10
    syscall
