#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    return (x >> n) & 1;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    // 1 0 = 0
    // 0 0 = 0
    // 1 1 = 1
    // 0 1 = 1
    if(v == 1) {
        if(get_bit(* x, n) == 1) {
            return;
        }
        else {
            *x = *x + (1 << n);
        }
    }
    else {
        if(get_bit(* x, n) == 1) {
            *x = *x - (1 << n);
        }
    }

}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    if(get_bit(*x, n) == 1) set_bit(x, n, 0);
    else set_bit(x, n, 1);
}

