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
    input_filename: .asciiz "color.ppm"
    output_filename: .asciiz "greyscale.ppm"
    buffer: .space 4 #buffer to read RGB Values
    header: .space 4 #buffer to read header

.text

.globl main

main:



