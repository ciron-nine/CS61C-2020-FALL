#include <stdio.h>
#include <omp.h>

int main() {
	#pragma omp parallel
	{
		int thread_ID = omp_get_thread_num();
		for(int i = 0; i < 10; i ++)
			printf("%d:hell\n", thread_ID);
		printf(" hello world %d\n", thread_ID);
	}
}
