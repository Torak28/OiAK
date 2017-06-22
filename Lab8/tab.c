#include <stdio.h>


#define size 4100

long long unsigned int my_rdtsc(char p);

int main() {
	int A[size];

	
	
	//wypelnienie A
	for(int i = 0; i < size; i++) {
		A[i] = i;
	}
	
	unsigned long long int czas_przed;
	unsigned long long int czas_po;
	for(int i = 0; i < size; i++) {
		czas_przed = my_rdtsc(1);
		A[i];
		czas_po = my_rdtsc(1);

		printf("Roznica %d: %llu\n", i, czas_po - czas_przed);
	}

	return 0;
}

