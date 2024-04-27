.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    li t0, 1
    blt a1, t0, error
    # Prologue
    addi sp, sp, -16
    sw s3, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    addi s0, zero, 4
    mul s2, a1, s0
    mv s0, a0
    mv s1, zero
loop_start:
    lw s3, 0(s0)
    bge s3, zero, loop_continue 
    mv s3, zero
    sw s3, 0(s0)
loop_continue:
    addi s1, s1, 4
    addi s0, s0, 4
    blt s1, s2, loop_start
loop_end:
    # Epilogue
    lw s3, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    
	ret
error:
    li a1, 78
    j exit2
