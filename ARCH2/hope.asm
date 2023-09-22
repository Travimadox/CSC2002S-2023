.data
    input_fd: .asciiz "C:\Users\User\OneDrive - University of Cape Town\Desktop\CSC2002S\CSC2002S-2023\ARCH2\Images\Input\house_64_in_ascii_crlf.ppm" # input file descriptor
    output_fd: .asciiz "C:\Users\User\OneDrive - University of Cape Town\Desktop\CSC2002S\CSC2002S-2023\ARCH2\Images\Output\testout.txt"# output file descriptor
    buffer: .space 128 # buffer to read lines from file
   

.globl main

.text

main:
    #open input file
    li $v0, 13 # system call for open file
    la $a0, input_fd # input file name
    li $a1, 0 # flag for reading
    li $a2, 0 # mode is ignored
    syscall # open a file (file descriptor returned in $v0)

    move $s6, $v0 # save the input file descriptor

    #open output file
    li $v0, 13 # system call for open file
    la $a0, output_fd # output file name
    li $a1, 1 # flag for writing
    li $a2, 0 # mode is ignored
    syscall # open a file (file descriptor returned in $v0)

    move $s7, $v0 # save the output file descriptor

    #read from input file
    li $v0, 14 # system call for read from file
    move $a0, $s6 # file descriptor
    la $a1, buffer # address of buffer from which to read
    li $a2, 128 # hardcoded buffer length
    syscall

    #write to output file
    li $v0, 15 # system call for write to file
    move $a0, $s7 # file descriptor
    la $a1, buffer # address of buffer from which to read
    li $a2, 128 # hardcoded buffer length
    syscall

    #Close input file
    li $v0, 16 # system call for close file
    move $a0, $s6 # file descriptor to close
    syscall

    #Close output file
    li $v0, 16 # system call for close file
    move $a0, $s7 # file descriptor to close
    syscall

    #exit
    li $v0, 10 # system call for exit
    syscall # exit
