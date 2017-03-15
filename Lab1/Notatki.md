# Notatki

### Kompilacja:

Plika Makefile o strukturze:

```
plik: plik.o
	ld -o plik plik.o
plik.o: plik.s
	as -o plik.o plik.o
```

Idea jest taka że żeby skompilować program wystarczy wpisać polecenie make plik. W Naszym przypadku obsługuje *make HelloWorld32* i *HelloWorld64*.

### Sekcje Programu

W programie Assemblerowym możemy wyróżnić 3 główne sekcje:
* **.data** - do przechowywania zmiennych, w Naszym przypadku były to zazwyczaj zmienne służące do kontaktu z procesorem
* **.text** - do przechowywania zmiennych typu tesktoweg, jak np. komunikatów
* **start** - czyli Nasz program

### Struktura Kodu

Ważne chyba żeby załapać ideę kodu Assemblerowego. Takie np. Wypisanie wymaga ustawienia konkretnych rejestrów w konkretny sposób. Można to przyrównać trochę jako fazę przygotowania która się kńczy wywołaniem **syscall** albo **int 0x80**

W HelloWorldach jakie przygotowałem można wyróżnić dwa takie "ustawienia". Pierwsze które wykonuje wypisanie i można je rozumieć jako **printf** z *ANSI-C* i drugie iealnie odzwierciedlające **return 0**

### Różnice między 32 a 64 bitami

Jak na razie widoczne są 4:
* Inne rejestry, co jest dość oczywiste
* Inne przerwanie systemowe, 64 bitowe **syscall** vs 32 bitowe **int 0x80**
* Inne numery zmiennych systemowych
* No i w końcu wymaganie do uzywanie innego mov-a

### MOV

```asm
movq $RESET, %rax               #rax            0xffffffffffffffff
et1: movq $ZMIENNA, %rax        #rax            0x0
movq $RESET, %rax               #rax            0xffffffffffffffff
et2: movl $ZMIENNA, %eax        #rax            0x0
movq $RESET, %rax               #rax            0xffffffffffffffff
et3: movw $ZMIENNA, %ax         #rax            0xffffffffffff0000
movq $RESET, %rax               #rax            0xffffffffffffffff
et4: movb $ZMIENNA, %al         #rax            0xffffffffffffff00
movq $RESET, %rax               #rax            0xffffffffffffffff
```

Ergo: dla 64bit movq i movl to jedno i to samo chyba

### GDB - debugger

```
gdb NazwaPlikuWykonywalnego	#Program do debugowania
gdb b _start 			#Ustawia breakpointa na danej etykiecie
gdb r				#Stratujr Nasz program do tej etykiety
gdb info registers rax 		#Wyświetla informacje o zawartości rejestru rax
gdb stepi			#Przechodzi o jedna instrukcje maszynową dalej
```

### Konstrukcje

`offset(%base, %index, multiplier` - pozwala odczytać lub zapisać ilość bajtów równą `multiplier` pod adresem w pamięci `(offset + zawartość resjestru base + zawartość rejestru index) * multiplier`

My wykorzystujemy to do odczytywania pojedynczych znaków.

### Uwagi

Do zrobienia jest Cezar i Odwracanie tekstu
