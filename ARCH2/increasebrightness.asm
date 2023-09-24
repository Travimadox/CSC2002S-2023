################################################################
# Description to be added
################################################################

.data
    filename_in: .asciiz "C:\Users\User\Downloads\sample_images\house_64_in_ascii_crlf.ppm"
    filename_out: .asciiz "C:\Users\User\Downloads\sample_images\house_64_out_ascii_cr.ppm"
    input_buffer: .space 60000 #Whole size of input file
    output_buffer: .space 60000 #Whole size of output file
    average_original_prompt: .asciiz "The average of all RGB values of the original file is: \n" # prompt for average_original
    average_new_prompt: .asciiz "\nThe average of all RGB values of the new file is: \n" # prompt for average_new

    

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
    li $s2, 0 #Sum of all RGB values of the original file
    li $s3, 0 #Sum of all RGB values of the new file
    li $s4, 12286 #Counter for the number of rgb values in the file

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
        #integr value is now in $t3
        # print the integer value
        #move $a0, $t3 # load the integer value
        #li $v0, 1 # system call for print_int
        #syscall # print the integer value

        # print a new line
        #li $v0, 11 # system call for print character
        #li $a0, 10 # ASCII code for new line
        #syscall # print the new line character

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
        

        #Convert the integer to a string
        #coming later in the code

    # decrement the counter
    addi $s4, $s4, -1
    add $t0, $t0, 1 #increment the pointer tom amke sure we are at the next byte
    j loop


loop_end:
    #Calculate the average of all RGB values of the original file
    #Divide the sum by 12286
    li $t4, 3132930 #12286*255

    mtc1 $s2, $f0  # $f0 now has the sum
    mtc1 $t4, $f1  # $f1 now has 12286 * 255

    cvt.s.w $f0, $f0
    cvt.s.w $f1, $f1

    div.s $f2, $f0, $f1  # $f2 = $f0 / $f1

    # display the average of all RGB values of the original file
    li $v0, 4 # system call for print_str
    la $a0, average_original_prompt # load the address of the prompt string
    syscall # print the prompt string

    #print the average
    mov.s $f12, $f2 # load the average of all RGB values of the original file
    li $v0, 2 # system call for print_int
    syscall # print the average of all RGB values of the original file

    # Calculate the average of all RGB values of the new file   
    #Divide the sum by 12286
    li $t4, 3132930 #12286*255
    mtc1 $s3, $f0  # $f0 now has the sum
    mtc1 $t4, $f1  # $f1 now has 12286 * 255

    cvt.s.w $f0, $f0
    cvt.s.w $f1, $f1

    div.s $f2, $f0, $f1  # $f2 = $f0 / $f1

    # display the average of all RGB values of the new file
    li $v0, 4 # system call for print_str
    la $a0, average_new_prompt # load the address of the prompt string
    syscall # print the prompt string

    #print the average
    mov.s $f12, $f2 # load the average of all RGB values of the original file
    li $v0, 2 # system call for print_int
    syscall # print the average of all RGB values of the original file





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

    # exit
    li $v0, 10 # system call for exit
    syscall # exit