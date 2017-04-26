#Heks na Bin


#Sekacja zmiennych sterujących pracą. Takie stałe procesorowe
.data
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm textin, 512
.comm textout, 64
.comm test, 64

.text
tekst: .ascii "\n"
tekst_len = .-tekst
calosc: .ascii "Caly bufor znakow: "
calosc_len = .-calosc
calosc2: .ascii "Dodanie: "
calosc2_len = .-calosc

.globl _start

_start:
	/*Wczytanie znakow z kalwiatury do bufora textin*/
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $textin, %ecx
	movl $BUFLEN, %edx
	int $0x80

	/*W %eax znajduje sie dlugosc naszego tekstu dlatego przenosimy ją
	do rejestru %r9d, by była tam pamiętana
	Operacja pomniejszania %eax usuwa nam znak nowej linii przez co liczba
	1234 ma dlugosc 4*/
	decl %eax
	movl %eax, %r9d
	movl $0, %r11d
	/*Pomniejszamy jeszcze o jeden wejscie r9d jako że poslugujemy sie tutaj nomenklatura
	 tablicowa, tj. numerujemy od 0 a nie od 1*/
	dec %r9d
	/*Do %ebx wrzucam 4 jako dlugosc reprezentacji binarnej po przeksztalceniu jednej
	liczby w hexie.
	Dlugosc maksymalnego wyniku przechowuje w r8d*/
	movl $4, %ebx
	mull %ebx
	movl %eax, %r8d
	/*Ustawienie wszystkoch licznikow*/
	movl $0, %edi
	movl $0, %esi
	movl $0, %r10d
	movl $4, %r12d
	/*PODUMOWANIE
	  r11d - dlugosc poprawnie wpisanych znakow
	  r9d - maksymalna dlugosc wejscia, bedzie zmiejszana przy wylawianiu poszczegolnych liczb
	  r8d - maksymalna dlugosc wyniku, bedzie zmiejszana przy wylawianiu posczegolnych liczb
	  edi - reset na 0, ot takie przygotowanie
	  esi - reset na 0, ot takie przygotowanie
	  r10d - Aktualnie badana cyfra w ciągu wejsciowym, dla Nas na poczatek to oczywiscie 0
	  r12d - Stala porzebna do odwracania binarki*/
jmp sprawdzanie_czy_Hex

sprawdzanie_czy_Hex:
	/*Ustawiamy licznik edi na odpowiednia wartosc*/
	movl %r10d, %edi
	/*ecx jako nasz licznik petli dla pojedynczego znaku*/
	movl $4, %ecx
	/*Wrzucamy do al nasza cyfre z wejscia*/
	movb textin(,%edi,1), %al
	#movb $0x30, %bl
	movb $'0' %bl
	cmp %bl, %al
	jge liczba_lub_litera
	jmp nic
liczba_lub_litera:
	#movb $0x39, %bl
	movb $'9', %bl
	cmp %bl, %al
	jle pre_int
	#movb $0x41, %bl
	movb $'A', %bl
	cmp %bl, %al
	jge moze_litera
	jmp nic
moze_litera:
	#movb $0x46, %bl
	movb $'F', %bl
	cmp %bl, %al
	jle pre_chr
	jmp nic
	
nic:
	/*Nic co nas interesuje wiec zmiejszamy dlugosc wyniku o 4*/
	subl $4, %r8d
	#subl $1, %r9d Nie wiem czy potrzebne bo w sumie po co nam ilosc przetworzonych
	jmp zamiana

pre_chr:
	subb $55, %al
	movl $0, %ebx
	inc %r11d 
	jmp bin
pre_int:
	subb $48, %al
	movl $0, %ebx
	inc %r11d
	jmp bin

bin:
	cmp %ebx, %ecx
	je zamiana
	shrb $1, %al
	jc jedynka
	jmp zero
	
jedynka:
	movb $'1', textout(,%esi,1)
	inc %esi
	inc %ebx
	jmp bin
zero:
	movb $'0', textout(,%esi,1)
	inc %esi
	inc %ebx
	jmp bin

zamiana:
	/*Funkcja ustawiające liczniki na odpowiednich miejscach przed odwracaniem*/	
	movl %r11d, %eax
	dec %eax
	mull %r12d
	movl %eax, %edi
	addl $3, %eax
	movl %eax, %edx				
	jmp odwracanie

odwracanie:
	movb textout(,%edi,1), %al
	movb textout(,%edx,1), %ah
	movb %al, textout(,%edx,1)
	movb %ah, textout(,%edi,1)
	inc %edi
	dec %edx
	cmp %edx, %edi	
	jge kolejny_znak
	jmp odwracanie

kolejny_znak:
	/*Sprawdzamy czy przejechalismy po calym wejsciu,
	 W r10d trzymamy ilosc aktualnie przerobionych w 
	 r9d trzymamy maks do zrobienia*/
	cmp %r9d, %r10d
	je wypisanieWszystkiego
	inc %r10d
	jmp sprawdzanie_czy_Hex

wypisanieWszystkiego:	
	movq $1, %rax
	movq $1, %rdi
	movq $calosc, %rsi
	movq $calosc_len, %rdx
	syscall

	movq $textout, %r15

	/*Wypisanie calosci*/
	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq %r8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*EKSPERYMENT*/
	movq $1, %rax
	movq $1, %rdi
	movq $calosc, %rsi
	movq $calosc_len, %rdx
	syscall
eksp:
	movq $1010, %r10
	movq $1, %r11
	addq %r11, %r10
eksp2:
	movl $0, %edx
	movb $1, %al
	movb %al, test(,%edx,1)
	inc %edx
	movb $0, %al
        movb %al, test(,%edx,1)
        inc %edx
	movb $1, %al
        movb %al, test(,%edx,1)
        inc %edx
	movb $0, %al
        movb %al, test(,%edx,1)
        inc %edx
	movl $0, %edx
        movb $1, %al
        movb %al, test(,%edx,1)
        inc %edx
        movb $0, %al
        movb %al, test(,%edx,1)
        inc %edx
        movb $1, %al
        movb %al, test(,%edx,1)
        inc %edx
        movb $0, %al
        movb %al, test(,%edx,1)
        inc %edx
eksp3:
	mov test, %al
eksp4:
	mov $test, %al
eksp5:
	movq $0, %edi
	movl test(, %edi, 8), %al


	/*Wypisanie calosci*/
	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $2, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	jmp dodanie

dodanie:
	movq $textout, %rax
	movq $textout, %rbx
	addq %rax, %rbx
	jmp koniec
	
koniec:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80
