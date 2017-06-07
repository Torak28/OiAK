#include <stdio.h>

// Deklaracja zmiennej przechowującej ciąg znaków do konwersji
char str[] = "AbCdEfGh";
// Stała przechowująca długość tego ciągu
const int len = 8;

int main(void)
{
    asm(
    "mov $0, %%rbx \n" 	// Zerowanie rejestru RBX - licznika do pętli.
    			// Każdy mnemonik rejestru należy poprzedzić znakami %%.

    "petla: \n" // Etykieta powrotu do pętli

    "mov (%0, %%rbx, 1), %%al \n" // Skopiowanie n-tej komórki stringu
    				  // do rejestru al. %0 to alias rejestru w którym 
				  //kompilator C umieści
   				  // pierwszy parametr wejściowy 
			          //(wskaźnik na pierwszą komórkę stringa).

    "and $223, %%al \n" // Wyzerowanie 5 bity kodu znaku ASCII
                        // (zamiana na duża literę)
    "add $32, %%al \n"  // Dodanie do kodu litery wartości 2^5
                        // (zamiana na małą literę)

    "mov %%al, (%0, %%rbx, 1) \n" // Zapisanie zmienionej wartości do stringa

    "inc %%rbx \n"      // Zwiększenie licznika pętli
    "cmp len, %%ebx \n" // Porównanie licznika pętli ze stałą "len"
                        // zadeklarowaną w kodzie C
    "jl petla \n" // Powrót na początek pętli aż do wykonania operacji
                  // dla każdego znaku ze stringa

    : // Nie mamy żadnych parametrów wyjściowych. Jeśli by takie były
    // należało by je zadeklarować podobnie jak w lini poniżej, jednak
    // zamiast "r" należało by użyć "r=". Spowodowało by to przeniesienie
    // wartości z rejestru oznaczonego w kodzie jako %0, %1 itp. do zmiennej
    // po wykonaniu wstawki.

    :"r"(&str) // Lista parametrów wejściowych - zmiennych które zostaną
    // zapisane do rejestrów i będzie możliwy ich odczyt w kodzie Asemblerowym.
    // Podobnie jak wyżej - są one dostępne jako aliasy na rejestry - %0, %1 itp.

    :"%rax", "%rbx" // Rejestry których będziemy używać w kodzie Asemblerowym.
    );

    //
    // Wyświetlenie wyniku
    //
    printf("Wynik: %s\n", str);
    return 0;
}
