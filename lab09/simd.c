#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
	clock_t start = clock();

	long long int sum = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS; i++) {
			if(vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	long long int sum = 0;

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			if(vals[i] >= 128) sum += vals[i];
			if(vals[i + 1] >= 128) sum += vals[i + 1];
			if(vals[i + 2] >= 128) sum += vals[i + 2];
			if(vals[i + 3] >= 128) sum += vals[i + 3];
		}

		//This is what we call the TAIL CASE
		//For when NUM_ELEMS isn't a multiple of 4
		//NONTRIVIAL FACT: NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);		// This is a vector with 127s in it... Why might you need this?
	long long int result = 0;				   // This is where you should put your final result!
	/* DO NOT DO NOT DO NOT DO NOT WRITE ANYTHING ABOVE THIS LINE. */
	
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		/* YOUR CODE GOES HERE */
		__m128i *p = (__m128i *) vals;
		__m128i inital = _mm_setzero_si128();
		for(unsigned int i = 0; i < NUM_ELEMS / 4 ; i ++) {
			__m128i b = _mm_loadu_si128(p + i);
			__m128i mask = _mm_cmpgt_epi32(b, _127);
			b = _mm_and_si128(b, mask);
			inital = _mm_add_epi32(inital, b);
		}
		
		/* You'll need a tail case. */
		int tail_count = NUM_ELEMS % 4;
		__m128i b = _mm_loadu_si128(p + NUM_ELEMS / 4);
		p = &b;
		int* int_p = (int *) p;
		for(int i = 0; i < tail_count; i ++) {
			if(int_p[i] >= 128) {
				result += int_p[i];
			}
		}
		p = &inital;
		int_p = (int *) p;
		for(int i = 0; i < 4; i ++) {
			result += int_p[i];
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);
	long long int result = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		/* COPY AND PASTE YOUR sum_simd() HERE */
		/* MODIFY IT BY UNROLLING IT */
		__m128i *p = (__m128i *) vals;
		__m128i inital = _mm_setzero_si128();
		for(unsigned int i = 0; i < NUM_ELEMS / 4 / 4 * 4; i += 4) {
			__m128i b = _mm_loadu_si128(p + i);
			__m128i mask = _mm_cmpgt_epi32(b, _127);
			b = _mm_and_si128(b, mask);
			inital = _mm_add_epi32(inital, b);

			b = _mm_loadu_si128(p + i + 1);
			mask = _mm_cmpgt_epi32(b, _127);
			b = _mm_and_si128(b, mask);
			inital = _mm_add_epi32(inital, b);
			
			b = _mm_loadu_si128(p + i + 2);
			mask = _mm_cmpgt_epi32(b, _127);
			b = _mm_and_si128(b, mask);
			inital = _mm_add_epi32(inital, b);

			b = _mm_loadu_si128(p + i + 3);
			mask = _mm_cmpgt_epi32(b, _127);
			b = _mm_and_si128(b, mask);
			inital = _mm_add_epi32(inital, b);
		}
		/* You'll need 1 or maybe 2 tail cases here. */
		int *int_p;
		int tail_count = NUM_ELEMS % 4;
		for(int i = NUM_ELEMS / 4 / 4 * 4; i < NUM_ELEMS / 4; i ++) {
			__m128i b = _mm_loadu_si128(p + i);
			__m128i mask = _mm_cmpgt_epi32(b, _127);
			b = _mm_and_si128(b, mask);
			inital = _mm_add_epi32(inital, b);
		}
		__m128i b = _mm_loadu_si128(p + NUM_ELEMS / 4);
		p = &b;
		int_p = (int *) p;
		for(int i = 0; i < tail_count; i ++) {
			if(int_p[i] >= 128) {
				result += int_p[i];
			}
		}
		p = &inital;
		int_p = (int *) p;
		for(int i = 0; i < 4; i ++) {
			result += int_p[i];
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}