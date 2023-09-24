################### Main Program Header ################################################################################################################################
# Program 2 : greyscale.asm 
# Programmer : Travimadox Webb
# Due Date : 29th September, 2023 Course: CSC2002S
# Last Modified : 20th September, 2023
####################################################################################################################################################################
# Overall Program Description:
# This program takes in a ppm file and converts it to a greyscale image.
####################################################################################################################################################################
# Register usage in main:
# later
####################################################################################################################################################################
# Pseudocode:
# Initialize variables (input_fd, output_fd, buffer, etc.)
#
# Open input file in read mode
#    -> Save the file descriptor to input_fd
#
# Open output file in write mode
#   -> Save the file descriptor to output_fd
#
# FOR each line in the header (1 to 4)
#   Read a line from input_fd into buffer
#   Write the line from buffer into output_fd
#
# Write "P2" to output_fd (to indicate greyscale)
#
# FOR each pixel (1 to 4096)
#   Read R from input_fd
#   Read G from input_fd
#   Read B from input_fd
#
#   Greyscale_value = floor((R + G + B) / 3)
#
#   Write Greyscale_value to output_fd
#
# Close input_fd
# Close output_fd
#
# Exit
####################################################################################################################################################################

.data
    filename_in: .asciiz "C:\Users\User\Downloads\sample_images\house_64_in_ascii_crlf.ppm"
    filename_out: .asciiz "C:\Users\User\Downloads\sample_images\house_64_outgreyscale_ascii_cr.ppm"
    input_buffer: .space 60000 #Whole size of input file
    output_buffer: .space 60000 #Whole size of output file
    reverse_buffer: .space 12 #size of string
    bye_msg: .asciiz "File processes succesfully\n"
    

    

.text
.globl main

################################################################
# Main function
# s0 = input file descriptor
# s1 = output file descriptor
# t0 = input buffer address pointer
# t1 = output buffer address pointer
################################################################
main:
    # Open the input file
    li $v0, 13 # system call for open file
    la $a0, filename_in # input filename
    li $a1, 0 # flag for reading
    li $a2, 0 # mode is ignored
    syscall # open a file (file descriptor returned in $v0)

    move $s0, $v0 # save the input file descriptor

    # Open the output file
    li $v0, 13 # system call for open file
    la $a0, filename_out # output filename
    li $a1, 1 # flag for writing
    li $a2, 0 # mode is ignored
    syscall # open a file (file descriptor returned in $v0)

    move $s1, $v0 # save the output file descriptor

     #Read the input file
    li $v0, 14 # system call for read file
    move $a0, $s0 # file descriptor to read
    la $a1, input_buffer # address of buffer from which to read
    li $a2, 60000 # hardcoded buffer length
    syscall # read from file

    # load pointers
    la $t0, input_buffer # load the address of the input buffer
    la $t1, output_buffer # load the address of the output buffer

    


####COpying the first 4 lines of the file##################################################
    #Test writing with the first for lines
    #Write the first 4 lines of the file
    li $t9, 10 #load the ASCII value of the new line character
    #line1(2bytes and EOL)
    lb $t2, 0($t0) # load the first byte of the input buffer
    sb $t2, 0($t1) # store the first byte of the input buffer to the output buffer
    lb $t2, 1($t0) # load the second byte of the input buffer
    sb $t2, 1($t1) # store the second byte of the input buffer to the output bufferr
    sb $t9, 2($t1) # null terminate the output buffer

    #line2(5bytes and EOL)
    lb $t2, 3($t0) # load the first byte of the input buffer
    sb $t2, 3($t1) # store the first byte of the input buffer to the output buffer
    lb $t2, 4($t0) # load the second byte of the input buffer
    sb $t2, 4($t1) # store the second byte of the input buffer to the output bufferr
    lb $t2, 5($t0) # load the third byte of the input buffer
    sb $t2, 5($t1) # store the third byte of the input buffer to the output bufferr
    lb $t2, 6($t0) # load the fourth byte of the input buffer
    sb $t2, 6($t1) # store the fourth byte of the input buffer to the output bufferr
    lb $t2, 7($t0) # load the fifth byte of the input buffer
    sb $t2, 7($t1) # store the fifth byte of the input buffer to the output bufferr
    sb $t9, 8($t1) # null terminate the output buffer

    #line3(5bytes and EOL)
    lb $t2, 9($t0) # load the first byte of the input buffer
    sb $t2, 9($t1) # store the first byte of the input buffer to the output buffer
    lb $t2, 10($t0) # load the second byte of the input buffer
    sb $t2, 10($t1) # store the second byte of the input buffer to the output bufferr
    lb $t2, 11($t0) # load the third byte of the input buffer
    sb $t2, 11($t1) # store the third byte of the input buffer to the output bufferr
    lb $t2, 12($t0) # load the fourth byte of the input buffer
    sb $t2, 12($t1) # store the fourth byte of the input buffer to the output bufferr
    lb $t2, 13($t0) # load the fifth byte of the input buffer
    sb $t2, 13($t1) # store the fifth byte of the input buffer to the output bufferr
    sb $t9, 14($t1) # null terminate the output buffer

    #line4(3bytes and EOL)
    lb $t2, 15($t0) # load the first byte of the input buffer
    sb $t2, 15($t1) # store the first byte of the input buffer to the output buffer
    lb $t2, 16($t0) # load the second byte of the input buffer
    sb $t2, 16($t1) # store the second byte of the input buffer to the output bufferr
    lb $t2, 17($t0) # load the third byte of the input buffer
    sb $t2, 17($t1) # store the third byte of the input buffer to the output bufferr
    sb $t9, 18($t1) # null terminate the output buffer
    
    addi $t0, $t0, 19
    addi $t1, $t1, 19



    #Looping to process the pixels
    li $s4, 4096 #Counter for the number of pixel values in the file

loop:
    
    #Read R,g or b value and convert it to integer
    #Intialize the variable to hold the value
    beqz $s4, loop_end
    li $s5, 0 #variable to hold R value
    li $s6, 0 #variable to hold G value
    li $s7, 0 #variable to hold B value
    li $s2, 0 #variable to hold the greyscale value

    #Read R value
    read_loopR:
        #Read the byte
        lb $t2, 0($t0)

        #Check if it is a new line character
        li $t4, 10
        beq $t2, $t4, read_loopGbefore

        #Convert the byte to integer
        sub $t2, $t2, 48

        #Multiply the current value by 10
        li $t5, 10
        mul $s5, $s5, $t5

        #Add the new value
        add $s5, $s5, $t2

        #Increment the pointer
        addi $t0, $t0, 1

        #Loop back
        j read_loopR

    read_loopGbefore:
        #Increment the pointer
        addi $t0, $t0, 1

    #Read G value
    read_loopG:
        #Read the byte
        lb $t2, 0($t0)

        #Check if it is a new line character
        li $t4, 10
        beq $t2, $t4, read_loopBbefore

        #Convert the byte to integer
        sub $t2, $t2, 48

        #Multiply the current value by 10
        li $t5, 10
        mul $s6, $s6, $t5

        #Add the new value
        add $s6, $s6, $t2

        #Increment the pointer
        addi $t0, $t0, 1

        #Loop back
        j read_loopG


    read_loopBbefore:
        #Increment the pointer
        addi $t0, $t0, 1

    #Read B value
    read_loopB:
        #Read the byte
        lb $t2, 0($t0)

        #Check if it is a new line character
        li $t4, 10
        beq $t2, $t4, greyscale

        #Convert the byte to integer
        sub $t2, $t2, 48

        #Multiply the current value by 10
        li $t5, 10
        mul $s7, $s7, $t5

        #Add the new value
        add $s7, $s7, $t2

        #Increment the pointer
        addi $t0, $t0, 1

        #Loop back
        j read_loopB

    #Calculate the greyscale value
    greyscale:
        #Add the values
        add $s2, $s5, $s6
        add $s2, $s2, $s7

        #Divide by 3
        li $t2, 3
        div $s2, $s2, $t2

        #Convert to ASCII
        # Initialize loop counter and buffer index
        li $t8, 0
        li $t6, 10

         # Reverse the integer to convert from least significant digit to most
        li $t7, 0

        int2str_reverse_loop:
        beq $s2, $zero, int2str_conversion_loop
        div $s2, $t6
        mfhi $t9
        mul $t7, $t7, $t6
        add $t7, $t7, $t9
        divu $s2, $s2, $t6
        j int2str_reverse_loop

        # Convert reversed integer to ASCII character
        int2str_conversion_loop:
        beq $t7, $zero, int2str_end
        div $t7, $t6
        mfhi $t9
        addiu $t9, $t9, 48
        sb $t9, 0($t1)
        addi $t1, $t1, 1
        divu $t7, $t7, $t6
        j int2str_conversion_loop

        int2str_end:
        # Null-terminate the string
        li $t9, 10
        sb $t9, 0($t1)


    # decrement the counter
    addi $s4, $s4, -1
    add $t0, $t0, 1 #increment the pointer tom amke sure we are at the next byte
    add $t1, $t1, 1 #increment the pointer tom amke sure we are at the next byte
    j loop


loop_end:
    # Write to file now using the output buffer
    li $v0, 15 # system call for write to file
    move $a0, $s1 # file descriptor
    la $a1, output_buffer # address of buffer from which to write
    li $a2, 60000 # hardcoded buffer length
    syscall



    # Close the input file
    li $v0, 16 # system call for close file
    move $a0, $s0 # file descriptor to close
    syscall

    # Close the output file
    li $v0, 16 # system call for close file
    move $a0, $s1 # file descriptor to close
    syscall


    # Print a message and exit
    li $v0, 4 # system call for print string
    la $a0, bye_msg # address of string to print
    syscall # print the string

    # exit
    li $v0, 10 # system call for exit
    syscall # exit


