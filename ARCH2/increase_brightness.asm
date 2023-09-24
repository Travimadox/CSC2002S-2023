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
# Calculate average_original = sum_original / (4096*3)
# average_original = average_original / 255
#
# Calculate average_new = sum_new / (4096*3)
# average_new = average_new / 255
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
    input_fd: .asciiz "C:\Users\User\OneDrive - University of Cape Town\Desktop\CSC2002S\CSC2002S-2023\ARCH2\Images\Input\jet_64_in_ascii_cr.ppm"# input file descriptor
    output_fd: .asciiz "C:\Users\User\OneDrive - University of Cape Town\Desktop\CSC2002S\CSC2002S-2023\ARCH2\Images\Output\Jet.ppm"# output file descriptor
    buffer: .space 5 # buffer to read lines from file
    line1: .space 3 # buffer to read lines from file
    line2: .space 6 # buffer to read lines from file
    line3: .space 6 # buffer to read lines from file
    line4: .space 4 # buffer to read lines from file
    average_original_prompt: .asciiz "The average of all RGB values of the original file is: \n" # prompt for average_original
    average_new_prompt: .asciiz "The average of all RGB values of the new file is: \n" # prompt for average_new

.globl main

.text

main:
################################################### Input file handling ##########################################################################################
    # Initialize stack frame for main
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    #Open input file
    li $v0, 13 # system call for open
    la $a0, input_fd # load buffer into $a0
    li $a1, 0 # flag for reading
    li $a2, 0 # mode is ignored
    syscall # open input file

    #Save input file descriptor
    move $s0, $v0 # save input file descriptor

################################################### Output file handling #######################################################################################
    

    #Open output file
    li $v0, 13 # system call for open
    la $a0, output_fd # load buffer into $a0
    li $a1, 1 # flag for writing
    li $a2, 0 # mode is ignored
    syscall # open output file

    #Save output file descriptor
    move $s1, $v0 # save output file descriptor


################################################### Copy header ################################################################################################
    #jal copy_header # jump to copy_header
    # Do it manually instead
    # Read line 1 from input_fd into buffer
    li $v0, 14 # system call for read
    move $a0, $s0 # load input file descriptor into $a0
    la $a1, line1 # load buffer into $a1
    li $a2, 3 # buffer size
    syscall # read a line from input_fd into buffer

    # Write line 1 from buffer into output_fd
    li $v0, 15 # system call for write
    move $a0, $s1 # load output file descriptor into $a0
    la $a1, line1 # load buffer into $a1
    move $a2, $v0 # amount read from input
    syscall # write a line to output_fd from buffer

    # Read line 2 from input_fd into buffer
    li $v0, 14 # system call for read
    move $a0, $s0 # load input file descriptor into $a0
    la $a1, line2 # load buffer into $a1
    li $a2, 6 # buffer size
    syscall # read a line from input_fd into buffer

    # Write line 2 from buffer into output_fd
    li $v0, 15 # system call for write
    move $a0, $s1 # load output file descriptor into $a0
    la $a1, line2 # load buffer into $a1
    move $a2, $v0 # amount read from input
    syscall # write a line to output_fd from buffer

    # Read line 3 from input_fd into buffer
    li $v0, 14 # system call for read
    move $a0, $s0 # load input file descriptor into $a0
    la $a1, line3 # load buffer into $a1
    li $a2, 6 # buffer size
    syscall # read a line from input_fd into buffer
    
    # Write line 3 from buffer into output_fd
    li $v0, 15 # system call for write
    move $a0, $s1 # load output file descriptor into $a0
    la $a1, line3 # load buffer into $a1
    move $a2, $v0 # amount read from input
    syscall # write a line to output_fd from buffer

    # Read line 4 from input_fd into buffer
    li $v0, 14 # system call for read
    move $a0, $s0 # load input file descriptor into $a0
    la $a1, line4 # load buffer into $a1
    li $a2, 4 # buffer size
    syscall # read a line from input_fd into buffer


################################################## Increase brightness ########################################################################################
    jal increase_brightness # jump to increase_brightness

################################################### Calculate average_original ###############################################################################
    # Calculate average_original = sum_original / (4096*3)
    # average_original = average_original / 255
    li $t0, 4096 # initialize 4096 to $t0
    li $t1, 3 # initialize 3 to $t1
    mul $t0, $t0, $t1 # multiply 4096 by 3
    div $s4, $s4, $t0 # divide sum_original by 4096*3
    li $t2, 255 # initialize 255 to $t2
    div $s4, $s4, $t2 # divide sum_original by 255
    

####################################################### Display average_original ##############################################################################
   # Display average_original_prompt
    li $v0, 4 # system call for print_str
    la $a0, average_original_prompt
    syscall 
    # Display average_original
    li $v0, 2 
    move $a0, $s4 
    syscall 

################################################### Calculate average_new ####################################################################################
   # Calculate average_new = sum_new / (4096*3)
    # average_new = average_new / 255
     li $t0, 4096 # initialize 4096 to $t0
     li $t1, 3 # initialize 3 to $t1
     mul $t0, $t0, $t1 # multiply 4096 by 3
     div $s5, $s5, $t0 # divide sum_new by 4096*3
     li $t2, 255 # initialize 255 to $t2
     div $s5, $s5, $t2 # divide sum_new by 255

########################################################## Display average_new ###############################################################################
    # Display average_new_prompt
    li $v0, 4 # system call for print_str
    la $a0, average_new_prompt # load average_new_prompt into $a0
    syscall # print average_new_prompt

    # Display average_new as float
    li $v0, 2 # system call for print_int
    move $a0, $s5 # load average_new into $a0
    syscall # print average_new




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



    # Restore $ra and remove the main's stack frame
    lw $ra, 0($sp)
    addi $sp, $sp, 4

######################################################################## Exit ########################################################################
    # Exit
    li $v0, 10 # system call for exit
    syscall # exit





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
# $s3 - loop counter
# $s4 - sum_original
# $s5 - sum_new
# $t0 - R, G, B integer
# $t1 - New_R, New_G, New_B integer
# $t2 - 255
# $t3 - brightness factor
# $t8 - loop counter
# $t9 - loop counter
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
    # Save $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # FOR each pixel (1 to 4096)
    li $s3, 4096 # initialize loop counter to 4096
    li $s4, 0 # initialize sum_original to 0
    li $s5, 0 # initialize sum_new to 0
    li $t3, 10 # initialize brightness factor to 10
    li $t2, 255 # initialize max value to 255

    increase_brightness_loop:
        li $t9, 3 # Loop counter to read R, G, B

    read_rgb_loop:
        # Read value into buffer
        li $v0, 14 # system call for read
        move $a0, $s0 # load input file descriptor into $a0
        la $a1, buffer # load buffer into $a1
        li $a2, 4 # buffer size
        syscall # read a line from input_fd into buffer

        # Convert string to integer
        move $a1, $a1 # buffer pointer
        jal str2int # jump to str2int
        move $t0, $v0 # Now $t0 contains the integer value

        # Add to sum_original
        add $s4, $s4, $t0 

        # Increase brightness
        add $t1, $t0, $t3

        # Check if the new value exceeds maximum
        bgt $t1, $t2, set_max_value
        j continue_after_set_max
       
    set_max_value:
        li $t1, 255

    continue_after_set_max:
        add $s5, $s5, $t1 # Add to sum_new

        # Convert integer to string
        move $t7, $t1 
        la $a1, buffer 
        jal int2str 
        
        

        # Write the value to the output file
        li $v0, 15
        move $a0, $s1
        la $a1, buffer
        li $a2, 5
        syscall

        addi $t9, $t9, -1
        bnez $t9, read_rgb_loop

        addi $s3, $s3, -1
        bnez $s3, increase_brightness_loop

    # Return to caller
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra




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
    # Save $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)

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
        lw $ra, 0($sp)
        addi $sp, $sp, 4
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
    # Save $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)

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
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

