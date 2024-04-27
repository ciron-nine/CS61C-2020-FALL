.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    addi sp, sp, -40
    sw s3, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw ra, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    # Prologue
	mv s0, a1 #pointer rows
    mv s1, a2 #pointer cols
    mv a1, a0
    li a2, 0
    jal ra, fopen
    li t0, -1
    beq a0, t0, openerror
    mv s2, a0 #file pointer
    li a0, 8
    jal ra, malloc
    beq a0, zero, mallocerror
    mv s4, a0 #eight pointer
    li a3, 8
    mv a2, a0
    mv a1, s2
    jal ra, fread
    li t0, 8
    bne a0, t0, readerror
    lw t0, 0(s4)
    sw t0, 0(s0)
    lw t0, 4(s4)
    sw t0, 0(s1)
    mv a0, s4
    jal ra, free
    lw t0, 0(s0)
    lw t1, 0(s1)
    mul s3, t0, t1 #size of mat
    li t0, 4
    mul s3, s3, t0
    mv a0, s3
    jal ra, malloc
    beq a0, zero, mallocerror
    mv s4, a0 #res pointer
    mv a2, a0
    mv a3, s3
    mv a1, s2
    jal ra, fread
    bne a0, s3, readerror
    mv a1, s2
    jal ra, fclose
    li t0, -1
    beq a0, t0, closeerror
    mv a0, s4
    
    # Epilogue
    lw s3, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw ra, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    ret

openerror:
    li a1, 90
    j exit2
mallocerror:
    li a1, 88
    j exit2
readerror:
    li a1, 91
    j exit2
closeerror:
    li a1, 92
    j exit2