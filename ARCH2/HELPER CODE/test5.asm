#MIPS program read file line by line and proint out each line

.data
    filename_in: .asciiz "C:\Users\User\Downloads\sample_images\house_64_in_ascii_crlf.ppm"
    filename_out: .asciiz "C:\Users\User\Downloads\sample_images\house_64_out_ascii_cr.ppm"
    buffer: .space 5 # buffer to read lines from file
    line1: .space 4 # buffer to read lines from file
    line2: .space 7 # buffer to read lines from file
    line3: .space 7 # buffer to read lines from file
    line4: .space 5 # buffer to read lines from file

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

    #read first four lines first
    #line1
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line1 # address of buffer from which to read
    li $a2, 4 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, line1 # address of string to print
    syscall

   


    #line2
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line2 # address of buffer from which to read
    li $a2, 7 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, line2 # address of string to print
    syscall

   


    #line3
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line3 # address of buffer from which to read
    li $a2, 7 # hardcoded buffer length
    syscall # read from file

    #print
    li $v0, 4 # system call for print string
    la $a0, line3 # address of string to print
    syscall

    

    #line4
    li $v0, 14 # system call for read from file
    move $a0, $s0 # file descriptor
    la $a1, line4 # address of buffer from which to read
    li $a2, 5 # hardcoded buffer length
    syscall # read from file

    

    #print
    li $v0, 4 # system call for print string
    la $a0, line4 # address of string to print
    syscall

    #close file
    li $v0, 16 # system call for close file
    move $a0, $s0 # file descriptor to close
    syscall # close file

    # exit
    li $v0, 10 # system call for exit
    syscall # exit