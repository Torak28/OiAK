#include <stdio.h>
 
extern int dodawanie(int l1, int l2);
 
int a = 5;
int b = 7;
 
int main(void)
{
	int c = 0;

    // Wywołanie funkcji Asemblerowej
    c = dodawanie(a, b);
 
    // Wyświetlenie wyniku
    printf("Wynik: %d\n", c);
 
    return 0;
}
