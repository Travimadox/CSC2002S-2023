################### Main Program Header ################################################################################################################################
# Program 1 : increase_brightness.asm 
# Programmer : Travimadox Webb
# Due Date : 29th September, 2023 Course: CSC2002S
# Last Modified : 20th September, 2023
####################################################################################################################################################################
# Overall Program Functional Description :
# This program reads in a PPM file and increases the each RGB value by 10
# After execution display the average of all RGB values of the original file, as well the average of all RGB values of the new file, as a double value on the console
# ####################################################################################################################################################################
# Register Usage in Main
# $s0 - input file descriptor
# $s1 - output file descriptor
# $s2 - buffer
# ####################################################################################################################################################################
# Pseudo Code:
#
# Initialize variables (input_fd, output_fd, buffer, sum_original, sum_new, etc.)
#
# Open input file in read mode
#   -> Save the file descriptor to input_fd
#
# Open output file in write mode
#    -> Save the file descriptor to output_fd
#
# FOR each line in the header (1 to 4)
#    Read a line from input_fd into buffer
#    Write the line from buffer into output_fd
#
# FOR each pixel (1 to 4096)
#    Read R from input_fd
#    Read G from input_fd
#    Read B from input_fd
#
#   Add R, G, B to sum_original
#
#   New_R = min(R + 10, 255)
#   New_G = min(G + 10, 255)
#   New_B = min(B + 10, 255)
#
#   Add New_R, New_G, New_B to sum_new
#
#   Write New_R to output_fd
#    Write New_G to output_fd
#   Write New_B to output_fd
#
# Calculate average_original = sum_original / (4096 * 3)
# Calculate average_new = sum_new / (4096 * 3)
#
# Display average_original
# Display average_new
#
# Close input_fd
# Close output_fd
#
# Exit
####################################################################################################################################################################

.data
    input_fd: .space 100 # input file descriptor
    output_fd: .space 100 # output file descriptor
    buffer: .space 100 # buffer to read lines from file
    input_prompt: .asciiz "Enter the name of the input file:\n " # prompt for input file name
    output_prompt: .asciiz "Enter the name of the output file:\n " # prompt for output file name
    average_original_prompt: .asciiz "The average of all RGB values of the original file is: \n" # prompt for average_original
    average_new_prompt: .asciiz "The average of all RGB values of the new file is: \n" # prompt for average_new

.globl main

.text

main:
################################################### Input file handling ##########################################################################################
    #Prompt user for input file name
    li $v0, 4 # system call for print_str
    la $a0, input_prompt # load input_prompt into $a0
    syscall # print input_prompt

    #Read input file name
    li $v0, 8 # system call for read_str
    la $a0, buffer # load buffer into $a0
    li $a1, 100 # buffer size
    syscall # read input file name

    #Open input file
    li $v0, 13 # system call for open
    la $a0, buffer # load buffer into $a0
    li $a1, 0 # flag for reading
    li $a2, 0 # mode is ignored
    syscall # open input file

    #Save input file descriptor
    move $s0, $v0 # save input file descriptor

################################################### Output file handling #######################################################################################
    #Prompt user for output file name
    li $v0, 4 # system call for print_str
    la $a0, output_prompt # load output_prompt into $a0
    syscall # print output_prompt

    #Read output file name
    li $v0, 8 # system call for read_str
    la $a0, buffer # load buffer into $a0
    li $a1, 100 # buffer size
    syscall # read output file name

    #Open output file
    li $v0, 13 # system call for open
    la $a0, buffer # load buffer into $a0
    li $a1, 1 # flag for writing
    li $a2, 0 # mode is ignored
    syscall # open output file

    #Save output file descriptor
    move $s1, $v0 # save output file descriptor


################################################### Copy header ################################################################################################
    jal copy_header # jump to copy_header

################################################## Increase brightness ########################################################################################
    jal increase_brightness # jump to increase_brightness

################################################### Calculate average_original ###############################################################################
    # Calculate average_original = sum_original / 4096
    li $t0, 4096 # load 4096 into $t0

    # Move integer to floating point registers for average_original
    mtc1 $s4, $f0
    mtc1 $t0, $f2

    # Convert integers to floats
    cvt.s.w $f0, $f0
    cvt.s.w $f2, $f2

    # Divide the floats
    div.s $f12, $f0, $f2

####################################################### Display average_original ##############################################################################
    # Display average_original_prompt
    li $v0, 4
    la $a0, average_original_prompt
    syscall

    # Display average_original
    li $v0, 2
    syscall

################################################### Calculate average_new ####################################################################################
    # Calculate average_new = sum_new / 4096
    li $t0, 4096 # load 4096 into $t0

    # Move integer to floating point registers for average_new
    mtc1 $s5, $f4
    mtc1 $t0, $f6

    # Convert integers to floats
    cvt.s.w $f4, $f4
    cvt.s.w $f6, $f6

    # Divide the floats
    div.s $f12, $f4, $f6

########################################################## Display average_new ###############################################################################
    # Display average_new_prompt
    li $v0, 4
    la $a0, average_new_prompt
    syscall

    # Display average_new
    li $v0, 2
    syscall





############################################################### Close input_fd ################################################################################
    # Close input_fd
    li $v0, 16 # system call for close
    move $a0, $s0 # load input file descriptor into $a0
    syscall # close input_fd

############################################################### Close output_fd ###############################################################################
    # Close output_fd
    li $v0, 16 # system call for close
    move $a0, $s1 # load output file descriptor into $a0
    syscall # close output_fd

######################################################################## Exit ########################################################################
    # Exit
    li $v0, 10 # system call for exit
    syscall # exit




###################### Copy Header ###############################################################
# Function : copy_header
# Last modified : 20th September, 2023
##################################################################################################
# Functional Description :
# This function copies the header of the input file to the output file
##################################################################################################
# Register Usage in copy_header
# $s0 - input file descriptor
# $s1 - output file descriptor
# $s2 - buffer
# $s3 - loop counter
##################################################################################################
# Pseudo Code:
# FOR each line in the header (1 to 4)
#    Read a line from input_fd into buffer
#    Write the line from buffer into output_fd
##################################################################################################

copy_header:
    # FOR each line in the header (1 to 4)
    li $s3, 4 # initialize loop counter to 4

    copy_header_loop:
        # Read a line from input_fd into buffer
        li $v0, 14 # system call for read
        move $a0, $s0 # load input file descriptor into $a0
        la $a1, buffer # load buffer into $a1
        li $a2, 100 # buffer size
        syscall # read a line from input_fd into buffer

        # Write the line from buffer into output_fd
        li $v0, 15 # system call for write
        move $a0, $s1 # load output file descriptor into $a0
        la $a1, buffer # load buffer into $a1
        syscall # write the line from buffer into output_fd

        # Decrement loop counter
        addi $s3, $s3, -1 # decrement loop counter

        # Check if loop counter is 0
        bne $s3, $zero, copy_header_loop # if loop counter is not 0, repeat loop

    # Exit
    jr $ra # return to main


###################### Increase Brightness #######################################################
# Function : increase_brightness
# Last modified : 20th September, 2023
##################################################################################################
# Functional Description :
# This function increases the brightness of the input file and writes the result to the output file
##################################################################################################
# Register Usage in increase_brightness
# $s0 - input file descriptor
# $s1 - output file descriptor
# $s2 - buffer
# $s3 - loop counter
# $s4 - sum_original
# $s5 - sum_new
# $t0 - Old_Pixel
# $t1 - New_Pixel
# $t2 - Max Pixel value
# $t3 - Brightness factor
# $t4 - New Pixel ASCII character
##################################################################################################
# Pseudo Code:
# FOR each pixel (1 to 4096)
#    Read R from input_fd and convert to integer
#    Read G from input_fd and convert to integer
#    Read B from input_fd and convert to integer
#    Add R, G, B to sum_original
#    New_R = min(R + 10, 255)
#    Check if R + 10 > 255
#        New_R = 255
#    New_G = min(G + 10, 255)
#    Check if G + 10 > 255
#        New_G = 255
#    New_B = min(B + 10, 255)
#    Check if B + 10 > 255
#        New_B = 255
#    Add New_R, New_G, New_B to sum_new
#    Convert New_R to ASCII character
#    Write New_R to output_fd as ASCII character
#    Convert New_G to ASCII character
#    Write New_G to output_fd
#    Convert New_B to ASCII character
#    Write New_B to output_fd
##################################################################################################

increase_brightness:
    # FOR each pixel (1 to 4096)
    li $s3, 4096 # initialize loop counter to 4096
    li $s4, 0 # initialize sum_original to 0
    li $s5, 0 # initialize sum_new to 0
    li $t3, 10 # initialize brightness factor to 10
    li $t2, 255 # initialize max value to 255

    #Skip the first 4 lines of the file
    li $t8, 4 # initialize loop counter to 4

    skip_first_4_lines:
        # Read a line from input_fd into buffer
        li $v0, 14 # system call for read
        move $a0, $s0 # load input file descriptor into $a0
        la $a1, buffer # load buffer into $a1
        li $a2, 100 # buffer size
        syscall # read a line from input_fd into buffer

        # Decrement loop counter
        addi $t8, $t8, -1 # decrement loop counter

        # Check if loop counter is 0
        bne $t8, $zero, skip_first_4_lines # if loop counter is not 0, repeat loop`

    increase_brightness_loop:
        # Read Pixel from input_fd and convert to integer
        li $v0, 14 # system call for read
        move $a0, $s0 # load input file descriptor into $a0
        la $a1, buffer # load buffer into $a1
        li $a2, 100 # buffer size
        syscall # read pixel from input_fd into buffer

        # Convert ASCII pixel to integer
        jal str2int 
        move $t0, $v0 # save R in $t0

       
        # Add pixel to sum_original
        add $s4, $s4, $t0 # add R to sum_original
       

        # Increase brightness
        add $t1, $t0, $t3 # add 10 to pixel

        # Check if pixel + 10 > 255
        bgt $t1, $t2, set_brightness_max # if pixel + 10 > 255, set pixel to 255

        # Set pixel >255 to 255
        set_brightness_max:
            li $t1, 255 # load 255 into $t1
        
        # Add pixel to sum_new
        add $s5, $s5, $t1 # add pixel to sum_new

        # Convert pixel to ASCII character
        jal int2str
        move $t4, $v0 # save pixel in $t4

        # Write pixel to output_fd
        li $v0, 15 # system call for write
        move $a0, $s1 # load output file descriptor into $a0
        move $a1, $t4 # load new pixel into $a1
        syscall # write pixel to output_fd

        # Increment loop counter
        addi $s3, $s3, -1 # decrement loop counter


        # Check if loop counter is 0
        bne $s3, $zero, increase_brightness_loop # if loop counter is not 0, repeat loop

    # Exit
    jr $ra # return to main





###################### str2int ###################################################################
# Function : str2int
# Last modified : 20th September, 2023
##################################################################################################
# Functional Description :
# This function converts a string to an integer
##################################################################################################
# Register Usage in str2int
# $a0 - buffer
# $a1 - buffer pointer
# $t7 - integer
# $t8 - loop counter
# $t9 - character
# $t0 - 48 ASCII FOR 0
# $t1 - 57 ASCII FOR 9
##################################################################################################
# Pseudo Code:
# FOR each character in the string (1 to 3)
#    Check if character is a digit
#    Convert character to integer
#    Increment loop counter
#    Increment buffer pointer
#    Check if loop counter is 3
##################################################################################################


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
        jr $ra # return to increase_brightness


###################### int2str ###################################################################`
# Function : int2str
# Last modified : 20th September, 2023
##################################################################################################
# Functional Description :
# This function converts an integer to a string
##################################################################################################
# Register Usage in int2str
# $a0 - integer
# $a1 - buffer pointer
# $t7 - integer
# $t8 - loop counter
# $t9 - remainder
# $t0 - 48
##################################################################################################
# Pseudo Code:
# Coming later
##################################################################################################

int2str:
    # Convert pixel to ASCII character
    li $t8, 0 # initialize loop counter to 0
    li $t9, 0 # initialize loop counter to 0

    int2str_loop:
        # Check if integer is 0
        beq $t7, $zero, int2str_end # if integer is 0, exit loop

        # Convert integer to ASCII character
        div $t7, $t0 # divide integer by 10
        mflo $t9 # save remainder in $t9
        add $t9, $t9, $t0 # add 48 to remainder
        sb $t9, 0($a1) # save remainder in buffer

        # Increment loop counter
        addi $t8, $t8, 1 # increment loop counter

        # Increment buffer pointer
        addi $a1, $a1, 1 # increment buffer pointer

        # Check if loop counter is 3
        bne $t8, 3, int2str_loop # if loop counter is not 3, repeat loop

    int2str_end:
        # Exit
        jr $ra # return to increase_brightness
