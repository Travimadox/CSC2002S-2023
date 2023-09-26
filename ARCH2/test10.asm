################### Main Program Header ################################################################################################################################
# Program 1 : increase_brightness.asm 
# Programmer : Travimadox Webb
# Due Date : 29th September, 2023 Course: CSC2002S
# Last Modified : 25th September, 2023
####################################################################################################################################################################
# Overall Program Functional Description :
# This program reads in a PPM file and increases the each RGB value by 10
# After execution display the average of all RGB values of the original file, as well the average of all RGB values of the new file, as a double value on the console
# ####################################################################################################################################################################
# Register Usage in Main:
# s0 = input file descriptor
# s1 = output file descriptor
# t0 = input buffer address pointer
# t1 = output buffer address pointer
# s2 = Sum of all RGB values of the original file
# s3 = Sum of all RGB values of the new file
# s4 = Counter for the number of rgb values in the file
# t2 = Temporary register to hold the byte read from the file
# t3 = Temporary register to hold the integer value of the byte read from the file
# t4 = Temporary register to hold the value 255
# t5 = Temporary register to hold the value 10
# t6 = Temporary register to hold the value 10
# t7 = Temporary register to hold the reversed integer
# t8 = Temporary register to hold the loop counter
# t9 = Temporary register to hold the value 10
# f0 = Temporary register to hold the sum of all RGB values of the original file
# f1 = Temporary register to hold the value 12286 * 255
# f2 = Temporary register to hold the average of all RGB values of the original/new file
# f12 = Temporary register to hold the average of all RGB values of the original/new file
# ####################################################################################################################################################################
# Pseudocode:
# Initialize variables:
#   filename_in = "Absolute path to input file"
#   filename_out = "Absolute path to output file"
#   input_buffer = "Buffer to hold the input file"
#   output_buffer = "Buffer to hold the output file"
#   reverse_buffer = "Buffer to hold the reverse of the integer"
#   average_original_prompt = "The average of all RGB values of the original file is: \n"
#   average_new_prompt = "The average of all RGB values of the new file is: \n"
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
#   Add R, G, B to sum_original
#
#   New_R = min(R + 10, 255)
#   New_G = min(G + 10, 255)
#   New_B = min(B + 10, 255)
#
#   Add New_R, New_G, New_B to sum_new
#
#   Convert New_R to string and store in output_buffer
#   Convert New_G to string and store in output_buffer
#   Convert New_B to string and store in output_buffer
#
# Calculate average_original = sum_original / 12286*255
# Calculate average_new = sum_new / 12286*255
#
# Display average_original
# Display average_new
#
# Close file descriptors
#
# Exit
####################################################################################################################################################################


#### Data Segment ###################################################################################################################################################
.data
    filename_in: .asciiz "C:\Users\User\Downloads\sample_images\house_64_in_ascii_crlf.ppm"
    filename_out: .asciiz "C:\Users\User\Downloads\sample_images\house.ppm"
    input_buffer: .space 70000 #Whole size of input file
    output_buffer: .space 70000 #Whole size of output file
    reverse_buffer: .space 12 #size of string
    average_original_prompt: .asciiz "The average of all RGB values of the original file is: \n" # prompt for average_original
    average_new_prompt: .asciiz "\nThe average of all RGB values of the new file is: \n" # prompt for average_new

    

.text
.globl main


#### Main Program ###################################################################################################################################################
main:
#### File IO ########################################################################################################################################################
    # Open the input file in read mode and save the file descriptor to s0
    li $v0, 13 
    la $a0, filename_in 
    li $a1, 0 
    li $a2, 0 
    syscall 

    move $s0, $v0 

    # Open the output file in write mode and save the file descriptor to s1
    li $v0, 13 
    la $a0, filename_out 
    li $a1, 1 
    li $a2, 0 
    syscall 

    move $s1, $v0 

    # Read the input file into the input buffer
    li $v0, 14 
    move $a0, $s0 
    la $a1, input_buffer 
    li $a2, 60000 
    syscall 

    # Load pointers
    la $t0, input_buffer # load the address of the input buffer
    la $t1, output_buffer # load the address of the output buffer


#### Image Processing ##############################################################################################################################################


#### process the first 4 lines of the file##################################################
 
    li $t9, 10 #load the ASCII value of the new line character

    # Process line1(2bytes and EOL)
    lb $t2, 0($t0) # load the first byte of the line1
    sb $t2, 0($t1) # store the first byte of the line1 to the output buffer
    lb $t2, 1($t0) # load the second byte of the line1
    sb $t2, 1($t1) # store the second byte of the line1 to the output bufferr
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

    # Process line3(5bytes and EOL)
    lb $t2, 9($t0) # load the first byte of the line3
    sb $t2, 9($t1) # store the first byte of the line3 to the output buffer
    lb $t2, 10($t0) # load the second byte of the line3
    sb $t2, 10($t1) # store the second byte of the input buffer to the output bufferr
    lb $t2, 11($t0) # load the third byte of the line3
    sb $t2, 11($t1) # store the third byte of the line3 to the output bufferr
    lb $t2, 12($t0) # load the fourth byte of the line3
    sb $t2, 12($t1) # store the fourth byte of the line3 to the output bufferr
    lb $t2, 13($t0) # load the fifth byte of the line3
    sb $t2, 13($t1) # store the fifth byte of the line3 to the output bufferr
    sb $t9, 14($t1) # null terminate the output buffer

    # Process line4(3bytes and EOL)
    lb $t2, 15($t0) # load the first byte of the line4
    sb $t2, 15($t1) # store the first byte of the line4 to the output buffer
    lb $t2, 16($t0) # load the second byte of the line4
    sb $t2, 16($t1) # store the second byte of the line4 to the output bufferr
    lb $t2, 17($t0) # load the third byte of the line4
    sb $t2, 17($t1) # store the third byte of the line4 to the output bufferr
    sb $t9, 18($t1) # null terminate the output buffer


#### Process the pixels ################################################################################

    # Increment the pointers to the start of the pixel values  
    addi $t0, $t0, 19
    addi $t1, $t1, 19



    #Looping to process the pixels
    li $s2, 0 #Sum of all RGB values of the original file
    li $s3, 0 #Sum of all RGB values of the new file
    li $s4, 12286 #Counter for the number of RGB values in the file

loop:
    #Read R,g or b value and convert it to integer
    #Intialize the variable to hold the value
    beqz $s4, loop_end
    li $t3, 0

    read_loop:
        #Read the byte
        lb $t2, 0($t0)

        #Check if it is a new line character
        li $t4, 10
        beq $t2, $t4, read_loop_end

        #Convert the byte to integer
        sub $t2, $t2, 48

        #Multiply the current value by 10
        li $t5, 10
        mul $t3, $t3, $t5

        #Add the new value
        add $t3, $t3, $t2

        #Increment the pointer
        addi $t0, $t0, 1

        #Loop
        j read_loop

    read_loop_end:
        #Add the value to the sum of all RGB values of the original file
        add $s2, $s2, $t3

        #increase the brightness by 10
        addi $t3, $t3, 10

        #Check if the value is greater than 255 and set it to 255 if it is
        li $t4, 255
        bgt $t3, $t4, set_to_255
        j set_to_255_end

    set_to_255:
        li $t3, 255

    set_to_255_end:
        #Add the value to the sum of all RGB values of the new file
        add $s3, $s3, $t3
        

    # Convert the integer to a string
    # Initialize loop counter and buffer index
    li $t6, 10
    li $t8, 0  # Counter for total number of digits

    # Reverse the integer to convert from least significant digit to most
    li $t7, 0
    int2str_reverse_loop:
        beq $t3, $zero, int2str_conversion_loop
        div $t3, $t6
        mfhi $t9
        mul $t7, $t7, $t6
        add $t7, $t7, $t9
        divu $t3, $t3, $t6
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
    add $t0, $t0, 1 #increment the pointer to make sure we are at the next byte
    add $t1, $t1, 1 #increment the pointer to make sure we are at the next byte
    j loop


loop_end:
    # Calculate the average of all RGB values of the original file
    # Divide the sum by 12286*255
    li $t4, 3132930 #12286*255

    mtc1 $s2, $f0  # $f0 now has the sum
    mtc1 $t4, $f1  # $f1 now has 12286 * 255

    cvt.s.w $f0, $f0
    cvt.s.w $f1, $f1

    div.s $f2, $f0, $f1  # $f2 = $f0 / $f1

    # Display the average of all RGB values of the original file
    li $v0, 4 
    la $a0, average_original_prompt 
    syscall 

    # Print the average
    mov.s $f12, $f2 
    li $v0, 2 
    syscall 

    # Calculate the average of all RGB values of the new file   
    # Divide the sum by 12286 * 255
    li $t4, 3132930 #12286*255
    mtc1 $s3, $f0  # $f0 now has the sum
    mtc1 $t4, $f1  # $f1 now has 12286 * 255

    cvt.s.w $f0, $f0
    cvt.s.w $f1, $f1

    div.s $f2, $f0, $f1  # $f2 = $f0 / $f1

    # Display the average of all RGB values of the new file
    li $v0, 4 
    la $a0, average_new_prompt 
    syscall 

    #print the average
    mov.s $f12, $f2 
    li $v0, 2 
    syscall 





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

    # exit
    li $v0, 10 
    syscall 