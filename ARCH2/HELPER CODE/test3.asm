#MIPS program read file line by line and proint out each line

.data
    filename_in: .asciiz "C:\Users\User\Downloads\sample_images\house_64_in_ascii_cr.ppm"
    filename_out: .asciiz "C:\Users\User\Downloads\sample_images\house_64_out_ascii_cr.ppm"
    buffer: .space 5 # buffer to read lines from file
    line1: .space 3 # buffer to read lines from file
    line2: .space 6 # buffer to read lines from file
    line3: .space 6 # buffer to read lines from file
    line4: .space 4 # buffer to read lines from file

.text
.globl main

main:
    # open file
    li $v0, 13 # system call for open file
    la $a0, filename_in # input filename
    li $a1, 0 # flag for reading
    li $a2, 0 # mode is ignored
    syscall # open a file (file descriptor returned in $v0)
    move $s0, $v0  # Save the file descriptor for later

    #open file to write
    li $v0, 13 # system call for open file
    la $a0, filename_out # input filename
    li $a1, 1 # flag for writing
    li $a2, 0 # mode is ignored
    syscall # open a file (file descriptor returned in $v0)
    move $s1, $v0  # Save the file descriptor for later

   jal copy_header

   li $t0, 4096 #counter for loop

   jal loop

    # close file\
    li $v0, 16 # system call for close file
    move $a0, $s0 # file descriptor to close
    syscall # close file

    # close file\
    li $v0, 16 # system call for close file
    move $a0, $s1 # file descriptor to close
    syscall # close file

    # exit
    li $v0, 10 # system call for exit
    syscall # exit

#########################################################################################################
copy_header:
    #read first four lines first
    #line1
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line1 # address of buffer from which to read
    li $a2, 3 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, line1 # address of string to print
    syscall

    #Write to file
    li $v0, 15 # system call for write to file
    move $a0, $s1 # file descriptor
    la $a1, line1 # address of buffer from which to read
    li $a2, 3 # hardcoded buffer length
    syscall # write to file


    #line2
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line2 # address of buffer from which to read
    li $a2, 6 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, line2 # address of string to print
    syscall

    #Write to file
    li $v0, 15 # system call for write to file
    move $a0, $s1 # file descriptor
    la $a1, line2 # address of buffer from which to read
    li $a2, 6 # hardcoded buffer length
    syscall # write to file


    #line3
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line3 # address of buffer from which to read
    li $a2, 6 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, line3 # address of string to print
    syscall

    #Write to file
    li $v0, 15 # system call for write to file
    move $a0, $s1 # file descriptor
    la $a1, line3 # address of buffer from which to read
    li $a2, 6 # hardcoded buffer length
    syscall # write to file

    #line4
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line4 # address of buffer from which to read
    li $a2, 4 # hardcoded buffer length
    syscall # read from file

    

    #print
    li $v0, 4 # system call for print string
    la $a0, line4 # address of string to print
    syscall

    #Write to file
    li $v0, 15 # system call for write to file
    move $a0, $s1 # file descriptor
    la $a1, line4 # address of buffer from which to read
    li $a2, 4 # hardcoded buffer length
    syscall # write to file

    jr $ra


#########################################################################################################
loop:

    #read R VALUE
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, buffer # address of buffer from which to read
    li $a2, 4 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, buffer # address of string to print
    syscall

    #read G VALUE
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, buffer # address of buffer from which to read
    li $a2, 4 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, buffer # address of string to print
    syscall

    #read B VALUE
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, buffer # address of buffer from which to read
    li $a2, 4 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, buffer # address of string to print
    syscall

    #decrement counter
    addi $t0, $t0, -1

    #check if counter is 0
    bnez $t0, loop

    jr $ra