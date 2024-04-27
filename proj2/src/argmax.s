.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    li t1, 1
    blt a1, t1, error
    addi sp, sp, -16
    sw s3, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    # Prologue
    mv s0, a0
    mv s1, zero
    mv s3, zero
    mv s2, zero
loop_start:
    li t1, 4
    mul t2, s1, t1
    add t2, t2, s0
    lw t0, 0(t2)
    li t3, 4
    mul t1, s3, t3
    add t1, t1, s0
    lw t2, 0(t1)
    bge t0, t2, loop_continue
    mv s1, s3
loop_continue:
    addi s3, s3, 1
    blt s3, a1, loop_start
loop_end:
    mv a0, s1
    # Epilogue
    lw s3, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    ret
error:
    li a1, 77
    j exit2