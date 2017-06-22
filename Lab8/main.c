#include <stdio.h>

#define size 512 

long long unsigned int my_rdtsc(char p);

void mnozenie(int A[size][size]) {
	int B[size][size];	
	
	for(int i=0; i<size; i++) {
		for(int j=0; j<size; j++) {
			B[i][j] = 0;
			for(int k = 0; k < size; k++) {
				B[i][j] = B[i][j] + A[i][k] * A[k][j];	
			}
		}
	}

}

void mnozenie_po_t(int A[size][size], int AT[size][size]) {
	int B[size][size];	
	
	for(int i=0; i<size; i++) {
		for(int j=0; j<size; j++) {
			B[i][j] = 0;
			for(int k = 0; k < size; k++) {
				B[i][j] = B[i][j] + A[i][k] * AT[j][k];	
			}
		}
	}

}

void mnozenie_transponowane(int A[size][size]) {
	int B[size][size];

	for(int i=0; i<size; i++) {
		for(int j=0; j<size; j++) {
			B[i][j] = 0;
			for(int k = 0; k < size; k++) {
				B[i][j] = B[i][j] + A[i][k] * A[j][k];	
			}
		}
	}
}
int main() {
	int A[size][size];
	int AT[size][size];
	int B[size];

	for(int i = 0; i < size; i++) {
		B[i] = i;
		for(int j = 0; j < size; j++) {
			A[i][j] = i*j;
		}
	}
	my_rdtsc(1);
	my_rdtsc(1);
	long long unsigned int start = my_rdtsc(1);
	mnozenie(A);
	long long unsigned int end = my_rdtsc(1);

	printf("CZAS A*A:\t%llu", end-start);
	
	my_rdtsc(1);
	my_rdtsc(1);
	start = my_rdtsc(1);
	mnozenie_transponowane(A);
	end = my_rdtsc(1);

	printf("\nCZAS A*A^T:\t%llu\n", end-start);

	my_rdtsc(1);
	my_rdtsc(1);
	start = my_rdtsc(1);
	
	for(int i = 0; i<size; i++) {
		for(int j = 0; j < size; j++) {
			AT[j][i] = A[i][j];
		}
	}	
	mnozenie_po_t(A, AT);
	end = my_rdtsc(1);

	printf("CZAS AT, A*AT:\t%llu\n\n\n", end-start);

	int tmp = 0;
	my_rdtsc(1);
	my_rdtsc(1);
	for(int i = 0; i < size; i++) {
		start = my_rdtsc(1);
		tmp = B[i];
		end = my_rdtsc(1);
		if( i % 17 == 0) {
			printf("\n");
		} else {
			printf("%llu ", end-start);
		}
	}	
	printf("\n");	
	return 0;
}

