#include <stdio.h>

void set_fpu(int a, int b);
int get_fpu();

int main(){
	/*
	a = 0	->	bez zmian w precyzji
	a = 1	->	pojedyncza precyzja
	a = 2	->	podwojna precyzja
	a = 3	->	rozszerzona precyzja

	b = 0	->	njblizsze zaokraglenia
	b = 1	->	w dol
	b = 2	->	w gore
	b = 3	->	do zera
	b = 4	->	bez zmian w zaokraglaniu
	*/
	printf("Control Word: %x\n", get_fpu());
	set_fpu(2,2);
	printf("Control Word: %x\n", get_fpu());
	return 0;
}
