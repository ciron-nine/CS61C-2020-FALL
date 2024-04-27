.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    
    li t0, 5
    bne a0, t0, incargs
    #prologue
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



	# =====================================
    # LOAD MATRICES
    # =====================================
    mv s0, a1 # argv
    mv s1, a2 # classify sign
    
    # Load pretrained m0
    li a0, 8
    jal ra, malloc
    beq a0, zero, mallocerror
    mv s2, a0 # m0 row col pointer
    mv a1, s2
    lw a0, 4(s0)
    addi a2, s2, 4
    jal ra, read_matrix
    mv s3, a0 # m0 matrix pointer

    # Load pretrained m1
    li a0, 8
    jal ra, malloc
    beq a0, zero, mallocerror
    mv s4, a0 # m1 rowpointer
    mv a1, s4
    lw a0, 8(s0)
    addi a2, s4, 4
    jal ra, read_matrix
    mv s5, a0 # m1 matrix pointer
 



    # Load input matrix
    li a0, 8
    jal ra, malloc
    beq a0, zero, mallocerror
    mv s6, a0 # input rowpointer
    mv a1, s6
    lw a0, 12(s0)
    addi a2, s6, 4
    jal ra, read_matrix
    mv s7, a0 # input matrix pointer





    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    li t0, 4
    lw t1, 0(s2)
    lw t2, 4(s6)
    mul t1, t0, t1
    mul t0, t1, t2
    mv a0, t0
    jal ra, malloc
    beq a0, zero, mallocerror
    mv a6, a0
    mv s8, a0
    lw a1, 0(s2)
    lw a2, 4(s2)
    mv a0, s3
    mv a3, s7
    lw a4, 0(s6)
    lw a5, 4(s6)
    jal ra, matmul
    lw t1, 0(s2)
    lw t2, 4(s6)
    mul t0, t1, t2
    mv a0, s8
    mv a1, t0
    jal ra, relu
    mv a0, s3
    jal ra, free
    mv a0, s7
    jal ra, free
    
    lw t0, 0(s4)
    lw t1, 4(s6)
    mul t0, t0, t1
    li t1, 4
    mul t0, t0, t1
    mv a0, t0
    jal ra, malloc
    beq a0, zero ,mallocerror
    mv s3, a0
    mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s8
    lw a4, 0(s2)
    lw a5, 4(s6)
    mv a6, s3
    jal ra, matmul
    
    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0)
    lw a2, 0(s4)
    lw a3, 4(s6)
    mv a1, s3
    jal ra, write_matrix
    
    bne s1, zero, exitt
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s3
    lw t0, 0(s4)
    lw t1, 4(s6)
    mul a1, t0, t1
    jal ra, argmax

    # Print classification
    mv a1, a0
    jal ra, print_int



    # Print newline afterwards for clarity
    li a1, 10
    jal ra, print_char
exitt:
    mv a0, s1
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
incargs:
    li a1, 89
    j exit2
mallocerror:
    li a1, 88
    j exit2
