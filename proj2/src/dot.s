.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t6, 1
    blt a2, t6, error1
    blt a3, t6, error2
    blt a4, t6, error2
    addi sp, sp, -20
    sw s3, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s4, 16(sp)
    # Prologue
    li s0, 4
    mul a3, a3, s0
    mul a4, a4, s0
    mv s0, a0
    mv s1, a1
    mv s2, zero
    mv a0, zero
loop_start:
    lw s3, 0(s0)
    lw s4, 0(s1)
    mul s3, s3, s4
    add a0, s3, a0
    add s0, s0, a3
    add s1, s1, a4
    addi s2, s2, 1
    blt s2, a2, loop_start
loop_end:


    # Epilogue
    lw s3, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    ret
error1:
    li a1, 75
    j exit2
error2:
    li a1, 76
    j exit2