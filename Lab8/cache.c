#include <stdio.h>


#define size 1000

long long unsigned int my_rdtsc(char p);
int wynikAA[size][size];
int wynikAAT[size][size];

void printM(int A[size][size])
{
	for (int i = 0; i < size; ++i){
		for (int j = 0; j < size; ++j){
			printf("%d ", A[i][j]);
		}
	printf("\n");
	}
}

void printA(int A[size]){
    for (int i = 0; i < size; ++i){
		printf("%d", A[i]);
	}
	printf("\n");    
}

void mnozenieA(int A[size][size]) {	
	for(int i=0; i<size; i++) {
		for(int j=0; j<size; j++) {
			wynikAA[i][j] = 0;
			for(int k = 0; k < size; k++) {
				wynikAA[i][j] = wynikAA[i][j] + A[i][k] * A[k][j];	
			}
		}
	}
}

void mnozenieAT(int A[size][size], int AT[size][size]) {
	for(int i=0; i<size; i++) {
		for(int j=0; j<size; j++) {
			wynikAAT[i][j] = 0;
			for(int k = 0; k < size; k++) {
				wynikAAT[i][j] = wynikAAT[i][j] + A[i][k] * AT[k][j];	
			}
		}
	}

}


int main() {
	int A[size][size];
	int AT[size][size];

	
	
	//wypelnienie A
	for(int i = 0; i < size; i++) {
		for(int j = 0; j < size; j++) {
			A[i][j] = i + j;
			if(i % 2 == 0){
				A[i][j] += 1;			
			}
		}
	}
	
	//wypelnie AT
	for(int i = 0; i<size; i++) {
		for(int j = 0; j < size; j++) {
			AT[j][i] = A[i][j];
		}
	} 
	

	unsigned long long int czas_przed = my_rdtsc(1);
	mnozenieA(A);
	unsigned long long int czas_srodek = my_rdtsc(1);
	mnozenieAT(A,AT);
	unsigned long long int czas_koniec = my_rdtsc(1);

	unsigned long long int czasAA = czas_srodek - czas_przed;
	printf("Czas A*A: %llu\n", czasAA);
	unsigned long long int czasAT = czas_koniec - czas_srodek;
	printf("Czas A*AT: %llu\n", czasAT);

	unsigned long long int roznica = czasAA - czasAT;
	printf("Roznica: %llu\n", roznica);

	return 0;
}

