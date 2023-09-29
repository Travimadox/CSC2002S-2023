    .data
buffer:      .space 5          # Space for reading a line of max 5 characters (3 digits + CR + LF)
outbuffer:   .space 6          # Space for writing the output line (3 digits + CR + LF)
input_file:  .asciiz "C:\Users\User\Downloads\test\input.txt"
output_file: .asciiz "C:\Users\User\Downloads\test\output.txt"

    .text
    .globl main

main:

    #Constants
    li   $t9, 10
    # Open input file
    li   $v0, 13
    la   $a0, input_file
    li   $a1, 0
    syscall
    move $s0, $v0      # Save the file descriptor to $s0

    # Open output file
    li   $v0, 13
    la   $a0, output_file
    li   $a1, 1
    syscall
    move $s1, $v0      # Save the file descriptor to $s1

    # Initialize running sum
    li   $s2, 0

read_line:
    # Read a line from the input file
    li   $v0, 14
    move $a0, $s0
    la   $a1, buffer
    li   $a2, 5
    syscall

    # Check for EOF
    beq  $v0, $zero, close_files

    # Convert ASCII to integer (Assuming up to 3 digits)
    li   $t0, 0                   # Initialize to zero
    li   $t3, 0                   # Counter for loop
convert_loop:
    lb   $t1, buffer($t3)         # Load a byte
    beq  $t1, 13, end_convert     # If CR, end conversion
    sub  $t1, $t1, 48             # Convert ASCII to integer
    mul  $t0, $t0, 10             # Shift existing number left
    add  $t0, $t0, $t1            # Add new digit
    addi $t3, $t3, 1              # Increment loop counter
    j    convert_loop
end_convert:
    # Add to running sum
    add  $s2, $s2, $t0

    # Add 10 to the number
    addi $t0, $t0, 10

    # Cap at 255 if number > 255
    li   $t4, 255
    bgt  $t0, $t4, cap_value
    j    continue_conversion
cap_value:
    li   $t0, 255
continue_conversion:

    # Convert integer to ASCII (Assuming 1 to 3 digits)
    la   $t2, outbuffer
    li   $t3, 100                 # Start with hundreds place
convert_back:
    div  $t0, $t3
    mflo $t1                      # Quotient in $t1
    mfhi $t0                      # Remainder back in $t0
    addi $t1, $t1, 48             # Convert to ASCII
    sb   $t1, 0($t2)              # Store ASCII
    addi $t2, $t2, 1              # Increment buffer position
    li   $t4, 10                  # Next divisor is 10
    beq  $t3, $t4, write_output   # Exit loop after 1's place
    div  $t3, $t9                 # Next divisor
    j    convert_back

write_output:
    # Add CR and LF to outbuffer
    li   $t1, 13                  # ASCII for CR
    sb   $t1, 0($t2)
    addi $t2, $t2, 1
    li   $t1, 10                  # ASCII for LF
    sb   $t1, 0($t2)

    # Write the line to output file
    li   $v0, 15
    move $a0, $s1
    la   $a1, outbuffer
    li   $a2, 5
    syscall

    j read_line

close_files:
    # Close input file
    li   $v0, 16
    move $a0, $s0
    syscall

    # Close output file
    li   $v0, 16
    move $a0, $s1
    syscall

    # Exit
    li   $v0, 10
    syscall
