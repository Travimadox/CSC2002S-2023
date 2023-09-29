################################################################
# Description to be added
################################################################

.data
    filename_in: .asciiz "C:\Users\User\Downloads\sample_images\house_64_in_ascii_crlf.ppm"
    filename_out: .asciiz "C:\Users\User\Downloads\sample_images\house_64_out_ascii_cr.ppm"
    input_buffer: .space 60000 #Whole size of input file
    output_buffer: .space 60000 #Whole size of output file
    average_original_prompt: .asciiz "The average of all RGB values of the original file is: \n" # prompt for average_original
    average_new_prompt: .asciiz "The average of all RGB values of the new file is: \n" # prompt for average_new

    

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

    addi $t0, $t0, 19 # increment the input buffer pointer by 19 bytes
    addi $t1, $t1, 19 # increment the output buffer pointer by 19 bytes
    
   
    #read the5th line(dynamic)
    line5:
    #do it dyanmixally
    lb $t2, 0($t0) # load the first byte of the input buffer
    #check if it is a new line
    li $t3, 10 #load the ASCII value of the new line character
    beq $t2, $t3, line5_end #if it is a new line, end the loop
    sb $t2, 0($t1) # store the first byte of the input buffer to the output buffer
    addi $t0, $t0, 1 # increment the input buffer pointer by 1 byte
    addi $t1, $t1, 1 # increment the output buffer pointer by 1 byte
    j line5 #jump to the beginning of the loop

    line5_end:
    sb $t9, 0($t1) # null terminate the output buffer
   

    # Write the output buffer to the output file
    li $v0, 15 # system call for write file
    move $a0, $s1 # file descriptor to write
    la $a1, output_buffer # address of buffer from which to read
    li $a2, 60000 # hardcoded buffer length
    syscall # write to file\

    # Close the input file
    li $v0, 16 # system call for close file
    move $a0, $s0 # file descriptor to close
    syscall # close input file

    # Close the output file
    li $v0, 16 # system call for close file
    move $a0, $s1 # file descriptor to close
    syscall # close output file

    # Exit program
    li $v0, 10 # system call for exit
    syscall # exit