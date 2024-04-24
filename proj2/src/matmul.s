.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    li t0, 1
    blt a1, t0, error1
    blt a2, t0, error1
    blt a4, t0, error2
    blt a5, t0, error2
    bne a2, a4, error3
    # Error checks
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
    mv s0, zero
    mv s1, zero
    mv s8, a0 # Pointer to A
    mv s7, a3 # Pointer to B
    mv s6, a2 # length
    mv s5, a6
    mv s2, a1
    mv s3, a5
outer_loop_start:
    mv s4, s7
    mv s0, zero


inner_loop_start:
    mv a0, s8
    mv a1, s4
    mv a2, s6
    li a3, 1
    mv a4, s3
    jal ra, dot
    sw a0, 0(s5)
    addi s5, s5, 4
    addi s4, s4, 4
    addi s0, s0, 1
    blt s0, s3, inner_loop_start
    add s8, s8, s6
    add s8, s8, s6
    add s8, s8, s6
    add s8, s8, s6
    addi s1, s1, 1
    blt s1, s2, outer_loop_start
inner_loop_end:




outer_loop_end:

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
    # Epilogue
    
    
    ret
error1:
    li a1, 72
    j exit2
error2:
    li a1, 73
    j exit2
error3:
    li a1, 74
    j exit2