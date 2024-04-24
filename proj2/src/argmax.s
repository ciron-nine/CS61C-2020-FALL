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
    lw s1, 0(s0)
    mv s3, zero
loop_start:
    lw s2 0(s0)
    bge s1, s2, loop_continue
    mv s1, s2
loop_continue:
    addi s0, s0, 4
    addi s3, s3, 1
    blt s3, a1, loop_start
loop_end:
    mv a0, s1
    # Epilogue
    addi sp, sp, 16
    lw s3, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)

    ret
error:
    li a1, 77
    j exit2