################### Main Program Header ################################################################################################################################
# Program 2 : greyscale.asm 
# Programmer : Travimadox Webb
# Due Date : 29th September, 2023 Course: CSC2002S
# Last Modified : 30th September, 2023
####################################################################################################################################################################
# Overall Program Description:
# This program takes in a ppm file and converts it to a greyscale image.
####################################################################################################################################################################
# Register usage in main:
# s0 = input file descriptor
# s1 = output file descriptor
# t0 = input buffer address pointer
# t1 = output buffer address pointer
# s2 = variable to hold the greyscale value
# s4 = counter for the number of pixel values in the file
# s5 = variable to hold R value
# s6 = variable to hold G value
# s7 = variable to hold B value
# t2 = temporary register to hold the byte read from the input buffer
####################################################################################################################################################################
# Pseudocode:
# Initialize variables:
#   filename_in = "Absolute path to input file"
#   filename_out = "Absolute path to output file"
#   input_buffer = "Buffer to hold the input file"
#   output_buffer = "Buffer to hold the output file"
#   reverse_buffer = "Buffer to hold the reverse of the integer"
#   bye_msg = "Message to print when the program is done"
#
# Open input file in read mode
#    -> Save the file descriptor to s0
#    -> Read the file into input_buffer
#
# Open output file in write mode
#   -> Save the file descriptor to s1
#
# Process the first 4 lines of the file
#   -> Write the first 4 lines of the file to the output buffer with P2 as the first line
#
# FOR each pixel (1 to 4096)
#   Read R from input_buffer
#   Convert R to integer
#   Read G from input_buffer
#   Convert G to integer
#   Read B from input_buffer
#   Convert B to integer
#
#   Greyscale_value = floor((R + G + B) / 3)
#
#   Write Greyscale_value to output_buffer
#
# Close file descriptors
#
# Exit
####################################################################################################################################################################



#### Data Segment ###############################################################################################################
.data
    filename_in: .asciiz "C:\Users\User\OneDrive - University of Cape Town\Desktop\CSC2002S\CSC2002S-2023\ARCH2\Images\Input\house_64_in_ascii_crlf.ppm"
    filename_out: .asciiz "C:\Users\User\OneDrive - University of Cape Town\Desktop\CSC2002S\CSC2002S-2023\ARCH2\Images\Output\House_Greyscale.ppm"
    input_buffer: .space 60000 #Whole size of input file
    output_buffer: .space 60000 #Whole size of output file
    reverse_buffer: .space 12 #size of string
    bye_msg: .asciiz "File processed succesfully\n"
    

    

.text
.globl main


#### Main Program ###############################################################################################################

main:
    # Open the input file in read mode and save the file descriptor
    li $v0, 13 
    la $a0, filename_in 
    li $a1, 0 
    li $a2, 0 
    syscall 

    move $s0, $v0 

    # Open the output file in write mode and save the file descriptor
    li $v0, 13 
    la $a0, filename_out 
    li $a1, 1
    li $a2, 0 
    syscall 

    move $s1, $v0 

    #Read the input file into the input buffer
    li $v0, 14 
    move $a0, $s0 
    la $a1, input_buffer 
    li $a2, 60000 
    syscall 

    # Load pointers to the input and output buffers
    la $t0, input_buffer 
    la $t1, output_buffer

    


#### Processing the first 4 lines of the file##################################################
    
    li $t9, 10 #load the ASCII value of the new line character

    # Process line1(2bytes and EOL)
    lb $t2, 0($t0) # load the first byte of line1
    li $t2, 80 #load the ASCII value of the P character
    sb $t2, 0($t1) # store the P character to the output buffer

    lb $t2, 1($t0) # load the second byte of the line1
    li $t2, 50 #load the ASCII value of the 2 character
    sb $t2, 1($t1) # store the 2 character to the output bufferr
    sb $t9, 2($t1) # null terminate the output buffer

    # Process line2(5bytes and EOL)
    lb $t2, 3($t0) # load the first byte of the line2
    sb $t2, 3($t1) # store the first byte of the line2 to the output buffer
    lb $t2, 4($t0) # load the second byte of the line2
    sb $t2, 4($t1) # store the second byte of the line2 to the output bufferr
    lb $t2, 5($t0) # load the third byte of the line2
    sb $t2, 5($t1) # store the third byte of the line2 to the output bufferr
    lb $t2, 6($t0) # load the fourth byte of the line2
    sb $t2, 6($t1) # store the fourth byte of the line2 to the output bufferr
    lb $t2, 7($t0) # load the fifth byte of the line2
    sb $t2, 7($t1) # store the fifth byte of the line2 to the output bufferr
    sb $t9, 8($t1) # null terminate the output buffer

    #line3(5bytes and EOL)
    lb $t2, 9($t0) # load the first byte of the line3
    sb $t2, 9($t1) # store the first byte of the line3 to the output buffer
    lb $t2, 10($t0) # load the second byte of the line3
    sb $t2, 10($t1) # store the second byte of the line3 to the output bufferr
    lb $t2, 11($t0) # load the third byte of the line3
    sb $t2, 11($t1) # store the third byte of the line3 to the output bufferr
    lb $t2, 12($t0) # load the fourth byte of the line3
    sb $t2, 12($t1) # store the fourth byte of the line3 to the output bufferr
    lb $t2, 13($t0) # load the fifth byte of the line3
    sb $t2, 13($t1) # store the fifth byte of the line3 to the output bufferr
    sb $t9, 14($t1) # null terminate the output buffer

    #line4(3bytes and EOL)
    lb $t2, 15($t0) # load the first byte of the line4
    sb $t2, 15($t1) # store the first byte of the line4 to the output buffer
    lb $t2, 16($t0) # load the second byte of the line4
    sb $t2, 16($t1) # store the second byte of the line4 to the output bufferr
    lb $t2, 17($t0) # load the third byte of the line4
    sb $t2, 17($t1) # store the third byte of the line4 to the output bufferr
    sb $t9, 18($t1) # null terminate the output buffer
    
    # Increment the pointers to the start of the pixel values
    addi $t0, $t0, 19
    addi $t1, $t1, 19



#### Processing the pixel values of the file ##################################################

    #Looping to process the pixels
    li $s4, 4096 #Counter for the number of pixel values in the file

loop:
    
    #Read R,G and B values of a pixel and convert it to integer
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

    # Convert the integer to a string
    # Initialize loop counter and buffer index
    li $t6, 10
    li $t8, 0  # Counter for total number of digits

    # Reverse the integer to convert from least significant digit to most
    li $t7, 0

    int2str_reverse_loop:
        beq $s2, $zero, int2str_conversion_loop
        div $s2, $t6
        mfhi $t9
        mul $t7, $t7, $t6
        add $t7, $t7, $t9
        divu $s2, $s2, $t6
        addi $t8, $t8, 1  # Count the digit
        j int2str_reverse_loop

    # Convert reversed integer to ASCII character
    int2str_conversion_loop:
        beq $t8, $zero, int2str_end
        div $t7, $t6
        mfhi $t9
        addiu $t9, $t9, 48
        sb $t9, 0($t1)
        addi $t1, $t1, 1
        divu $t7, $t7, $t6
        addi $t8, $t8, -1  # Decrement digit counter
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
    li $v0, 15 
    move $a0, $s1 
    la $a1, output_buffer 
    li $a2, 60000 
    syscall



    # Close the input file
    li $v0, 16 
    move $a0, $s0 
    syscall

    # Close the output file
    li $v0, 16 
    move $a0, $s1 
    syscall


    # Print a message and exit
    li $v0, 4 
    la $a0, bye_msg 
    syscall 

    # Exit
    li $v0, 10 
    syscall 


