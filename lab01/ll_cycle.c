#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *f = head;
    node *n = head;
    while(f != NULL) {
      f = f->next;
      if(f == NULL) break;
      f = f->next;
      n = n->next;
      if(f == n) return 1;
    }
    return 0;
}
