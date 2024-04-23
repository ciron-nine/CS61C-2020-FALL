#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t bigger = ((*reg >> 2) & 1) ^ (*reg & 1);
    bigger ^= ((*reg >> 3) & 1) ;
    bigger ^= ((*reg >> 5) & 1) ;
    *reg = (*reg >> 1) + (bigger << 15);
}

