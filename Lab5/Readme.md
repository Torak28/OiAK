# Podstawy:

Aby wywołać funkcję napisaną w C z kodu Asemblerowego należy umieścić jej argumenty całkowite (liczby lub wskaźniki na adresy w pamięci) kolejno w rejestrach RDI, RSI, RDX, RCX, R8, R9, argumenty zmiennoprzecinkowe w rejestrach XMM0-XMM7 i wywołać tą funkcję korzystając z rozkazu call. Jeśli przekazujemy argumenty zmiennoprzecinkowe, wtedy do rejestru RAX musimy również wpisać ich ilość.

# Wywołanie funkcji w C w Assemblerze:

Ot takie tam.

### Funkcja w C:

```C
float funkcja(int a, int b){
	return a*a+b+b;	
}
```

### Kod Assemblera:

```asm
.data
format_d: .asciz "%d",
nowa_linia: .asciz "\n"

.bss
.comm liczba1, 4 
.comm liczba2, 4

.text
.global main

main:
	/*1 liczba
	Odpowiednik poniższego kodu w C: scanf(&liczba1, "%d");*/
        mov $0, %rax        # Przesyłamy 0 parametrów zmiennoprzecinkowych
        mov $format_d, %rdi # Pierwszy parametr całkowity dla scanf
        mov $liczba1, %rsi  # Drugi parametr całkowity dla scanf
        call scanf          # Wywołanie funkcji scanf z biblioteki stdio.h

	/*2 liczba 
	Odpowiednik poniższego kodu w C: scanf(&liczba2, "%d");*/
	mov $0, %rax        # Przesyłamy 0 parametrów zmiennoprzecinkowych
	mov $format_d, %rdi # Pierwszy parametr całkowity dla scanf
	mov $liczba2, %rsi  # Drugi parametr całkowity dla scanf
	call scanf          # Wywołanie funkcji scanf z biblioteki stdio.h
 
	mov $0, %rcx
	mov $0, %rax    	 	 # Przesyłamy 0 parametrów zmiennoprzecinkowych
 	mov liczba1(, %rcx, 4), %rdi  	 # Pierwszy parametr - typu całkowitego
	mov liczba2(, %rcx, 4), %rsi 	 # Drugi parametr - typu całkowitego
 	call funkcja     	 	 # Wywołanie funkcjinie funkcji, wynik jest w rax

	mov %rax, %rsi
	mov $0, %rax        # Przesyłamy 0 parametrów zmiennoprzecinkowych
	mov $format_d, %rdi # Pierwszy parametr całkowity dla scanf
	call printf

	mov $0, %rax 		# Przesyłamy 0 parametrów zmiennoprzecinkowych
	mov $nowa_linia, %rdi 	# Pierwszy parametr typu całkowitego
	call printf		# Wywołanie funkcji printf


mov $0, %rax
call exit
```

### Wywołanie:

```
gcc f.s f.c -o F -g
```

### Wynik:

```
./F 
5		#Pierwsza liczba podana
75		#Druga liczba podana
175		#Wynik
```

# Wstawka Assemblerowa w C:

```C
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
```

### Wywołanie wstawki:

```
gcc c.c -o C -g
```

### Wynik:

```
 ./C 
Wynik: abcdefgh
```

# Funkcja Assemblerowa wywołana w C

Ot takie tam.

### Funkcja Assemblerowa

Pamiętać o wskąźnikach stosu i powrocie!

```asm
.data
 
.text
.global dodawanie
.type dodawanie, @function

dodawanie:
	push %rbp		
    	mov %rsp, %rbp
	
	/* W rejestrze RDI 1 int
    	   W rejestrze RSI znajdzie się 2 int
	   W rejestrze RDX znajduje się 3 int*/

	addq %rdi, %rsi
	movq %rsi, %rax

	mov %rbp, %rsp
   	pop %rbp
ret
	
```

### Kod w C:

```C
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
```

### Wywołanie:

```
gcc a.c a.s -o A -g
```

### Wynik:

```
./A 
Wynik: 12
```











