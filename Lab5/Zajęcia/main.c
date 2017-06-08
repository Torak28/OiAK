#include <stdio.h>

extern unsigned long long int my_rdtsc(char a);

int main(void){
	unsigned long long int wynik = 0;

	char a;

	printf("Podaj char dla my_rdtsc: ");
	scanf("%c", &a);

	wynik = my_rdtsc(a);

	printf("Wynik: %llu\n", wynik);

	return 0;
}
