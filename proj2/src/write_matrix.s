.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
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
	mv s0, a2 # rows
    mv s1, a3 # cols
    mv s2, a1 # pointer martix
    mv a1, a0
    li a2, 1
    jal ra, fopen
    li t0, -1
    beq a0, t0, openerror
    mv s3 a0 #file pointer
    li a0, 8
    jal ra, malloc
    mv s4, a0 #eight pointer
    sw s0, 0(s4)
    sw s1, 4(s4)
    mv a1, s3
    mv a2, s4
    li a3, 2
    li a4, 4
    jal ra, fwrite
    li a3, 2
    bne a0, a3, writeerror
    mv a0, s4
    jal ra, free
    mul a3, s0, s1
    mul s0, s1, s0
    li a4, 4
    mv a2, s2
    mv a1, s3
    jal ra, fwrite
    bne a0, s0, writeerror
    mv a0, s2
    jal ra, free
    mv a1, s3
    jal ra, fclose
    li t0, -1
    beq a0, t0, closeerror

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
    li a1, 93
    j exit2
writeerror:
    li a1, 94
    j exit2
closeerror:
    li a1, 95
    j exit2