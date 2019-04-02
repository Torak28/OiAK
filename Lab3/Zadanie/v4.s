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
.comm binarka, 64
.comm sklejenie, 8
.comm wynik, 65

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
	movb $'0', %bl
	cmp %bl, %al
	jge liczba_lub_litera
	jmp nic
liczba_lub_litera:
	movb $'9', %bl
	cmp %bl, %al
	jle pre_int
	movb $'A', %bl
	cmp %bl, %al
	jge moze_litera
	jmp nic
moze_litera:
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

	jmp pre_odejmowanie_z_bufora

pre_odejmowanie_z_bufora:
	/*r8d - dlugosc binarki*/
	movl %r8d, %r13d
	dec %r13d
	movl $0, %r14d
	movl $0, %edi
	movl $0, %esi
	jmp odejmowanie_z_bufora

odejmowanie_z_bufora:
	/*r13d - ilosc do przelecenia
	  r14d - aktalnie badany*/
	movb textout(,%edi,1), %al
	subb $48, %al
	movb %al, binarka(,%esi,1)
	inc %r14d
	inc %edi
	cmp %r13d, %r14d
	jle dalsze_odejmowanie
	jmp pre_sklejanie

dalsze_odejmowanie:
	inc %esi
	jmp odejmowanie_z_bufora

pre_sklejanie:
	/*r13d - ilosc do przelecenia
	  r14d - aktalnie badany
	  esi jest od 7 jako ze kopiowanie z pamieci jest little endianem
	  r15d - dlugosc wyniku
	*/
	movl $64, %r13d
	movl $0, %r14d
	movl $0, %r15d
	movl $0, %edx
	movb $0, %al
	movb $0, %ah
	movl $7, %esi
	jmp sklejanie

sklejanie:
	/*textout przechowuje 1 0 1 0 0 1 0 0
	*/
	movb binarka(,%edx,1), %al	#al 0000 0001	0x1
	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0000	0x0
	shlb $1, %al			#al 0000 0010	0x2
	addb %ah, %al			#al 0000 0010	0x2
	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0001	0x1
	shlb $1, %al			#al 0000 0100	0x4
	addb %ah, %al			#al 0000 0101	0x5
	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0000	0x0
	shlb $1, %al			#al 0000 1010	0xa
	addb %ah, %al			#al 0000 1010	0xa

	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0000	0x0
	shlb $1, %al			#al 0001 0100	0x14
	addb %ah, %al			#al 0001 0101	0x15
	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0001	0x1
	shlb $1, %al			#al 0010 1000	0x28
	addb %ah, %al			#al 0010 1001	0x29
	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0000	0x0
	shlb $1, %al			#al 0101 0010	0x52
	addb %ah, %al			#al 0101 0010	0x52
	inc %edx
	movb binarka(,%edx,1), %ah	#ah 0000 0000	0x0
	shlb $1, %al			#al 1010 0100	0xa4
	addb %ah, %al			#al 1010 0010	0xa4
	inc %edx
	
	cmp %eax, %r14d
	je dalej
	movb %al, sklejenie(,%esi,1) 	
	inc %r15d
	inc %r15d

dalej:
	subl $8, %r13d
	cmp %r13d, %r14d
	jl dalsze_sklejanie
	jmp dodawanie

dalsze_sklejanie:
	dec %esi
	jmp sklejanie
	
dodawanie:
	movl $0, %edi
	movq sklejenie(, %edi, 8), %rbx
	movq sklejenie(, %edi, 8), %rax
	/*Usuwanie 0*/
	shr $12, %rax
	shr $12, %rbx
	addq %rax, %rbx
	jc przeniesienie
	jmp bez_przeniesienia

przeniesienie:
	jmp koniec

bez_przeniesienia:
	movl $0, %esi
	movq %rbx, wynik(,%esi,1)
	jmp koniec

koniec:	
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80
