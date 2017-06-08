# Zadania do wykonania:

 * Wypisanie wartości funckji Fibonacciego
 * Napisanie w C wywołania funkcji rdsc i rdtsc

### Uruchamianie Fib

```
	make Fib
```

I dla 200 otrzymuje:
```
./Fib 
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000338864a5c1caeb07d0ef067cb83df17e395
```

Do kodu już wcześniej napisanego należało tylko wywołać printfa. Dużo mi zabrało określenie jakie powinno być słowo formatujące. Próbowałem z '%p" ale koniec końców zostałem przy '%llx'.

### Uruchamianie Rdtsc

```
	make Rdtsc
```

Wywołanie:
```
./rdtsc 
Podaj char dla my_rdtsc: 1
Wynik: 1685803351275
./rdtsc 
Podaj char dla my_rdtsc: 0
Wynik: 1775419689679

```

Idea pracy jest taka że po pobraniu od uzytkownika liczby sprawdza czy jest Ona równa 0 czy 1. Dla 0 wywoła rdtsc, a dla 1 rdtscp

Oba rozkazy pokazyja czas pracy procesora w cyklach, wiec jest to bardzo dokładna wartości i dzieki niej można sprawdzać efektywność danego kawałka kodu.

W obu przypadkach zaczynamy od zerowania wartości w %rax, nastepnie wywołujemy cpuid do zakończenia wszystkich dotychczas trwających procesów, tak żeby nasz procesor był zainteresowany tylko naszym badanym kawałkiem kodu. Dalej jest wywoływana komenda rdtsc lub rdtscp, o których więcej poniżej, a jej wynik zapisywany jest w %rdx i %rax. Do każdego z rejestrów trafia inna 32-bitowa część liczby.
I tak w %edx zapisywane są bity wyższe a w %eax mniej znaczące. By cały wynik uzyskać w %rax musimy pierw %rdx przesunąć o 32 w lewo, a następnie wykonać OR na obu liczbach.

Różnicą w komendach rdtsc i rdtscp, jest 'out of order execution' w przypadku rdtsc. Oznacza to że nie wykona się ona w miejscu w którym zapisaliśmy je w kodzie, rdtscp wydaje sie więc lepszym pomysłem, ale nie jest on niestety wspierany przez wszystkie Procesory. W moich wynikach wartość rdtscp jst zawsze troszkę większa od rdtsc.




