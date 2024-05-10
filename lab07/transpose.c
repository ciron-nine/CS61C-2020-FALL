#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
        int time = n / blocksize + 1;
        for(int i = 0; i < time; i ++) {
            for(int j = 0; j < time; j ++) {
                for (int x = 0; x < blocksize; x++) {
                    for (int y = 0; y < blocksize; y++) {
                        if(!(i * blocksize + y >= n || j * blocksize + x >= n)) {
                            dst[i * blocksize + y + x * n + j * blocksize * n] = src[x + y * n + i * n * blocksize + j * blocksize];
                        }
                    }
                }
            }
        }
    
}
