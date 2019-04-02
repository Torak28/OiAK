#include <stdio.h>

int set_mode(int a);
int set_round(int b);

float f(float x);
float g(float x);

//Tutaj będzie deklaracja tych funkcji f i g

int main(){
	/*
	a = 1	->	pojedyncza precyzja
	a = 2	->	podwojna precyzja
	
	b = 1	->	w dol
	b = 2	->	w gore
	b = 3	->	do zera
	b = 4	->	njblizsze zaokraglenia
	*/

	int pojedyncza = set_mode(1);
	int podwojna = set_mode(2);
	int bez_zmian = set_mode(0);
	printf("Precyzja:\n%x\n%x\n%x\n", pojedyncza, podwojna, bez_zmian);

	/*dla podwojnej precyzji wszystko!*/
	int w_dol = set_round(1);
	int w_gore = set_round(2);
	int do_zera = set_round(3);
	int najblizsze = set_round(4);
	printf("Zaokraglanie:\n%x\n%x\n%x\n%x\n", w_dol, w_gore, do_zera, najblizsze);

	/*Sprawdzenie f i g*/

	set_mode(1);
	set_round(1);
	printf("Pojedyncza precyzja z zaokrągleniem w dół:\n \t%.15f\n\t%.15f\n", f(0.0002), g(0.0002));

	set_mode(2);
	set_round(1);
	printf("Podwojna precyzja z zaokrągleniem w dół:\n \t%.15f\n\t%.15f\n", f(0.0002), g(0.0002));

	set_mode(1);
	set_round(2);
	printf("Pojedyncza precyzja z zaokrągleniem w górę:\n \t%.7f\n\t%.7f\n", f(0.0002), g(0.0002));
	
	set_mode(2);
	set_round(2);
	printf("Podwojna precyzja z zaokrągleniem w górę:\n \t%.15f\n\t%.15f\n", f(0.0002), g(0.0002));


	return 0;
}

