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
.comm textout, 512

.comm b1, 8
.comm b2, 8
.comm b3, 8
.comm b4, 8
.comm b5, 8
.comm b6, 8
.comm b7, 8
.comm b8, 8

.text
tekst: .ascii "\n"
tekst_len = .-tekst
calosc: .ascii "Caly bufor znakow: "
calosc_len = .-calosc

b1_tekst: .ascii "B1: "
b1_len = .-b1_tekst
b2_tekst: .ascii "B2: "
b2_len = .-b2_tekst
b3_tekst: .ascii "B3: "
b3_len = .-b3_tekst
b4_tekst: .ascii "B4: "
b4_len = .-b4_tekst
b5_tekst: .ascii "B5: "
b5_len = .-b5_tekst
b6_tekst: .ascii "B6: "
b6_len = .-b6_tekst
b7_tekst: .ascii "B7: "
b7_len = .-b7_tekst
b8_tekst: .ascii "B8: "
b8_len = .-b8_tekst


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
	movb $0x30, %bl
	cmp %bl, %al
	jge liczba_lub_litera
	jmp nic
liczba_lub_litera:
	movb $0x39, %bl
	cmp %bl, %al
	jle pre_int
	movb $0x41, %bl
	cmp %bl, %al
	jge moze_litera
	jmp nic
moze_litera:
	movb $0x46, %bl
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
	je zera
	inc %r10d
	jmp sprawdzanie_czy_Hex

zera:
	/*Wypełnianie zerami jak nie ma do 64*/
	jmp pre_sklejanie

pre_sklejanie:
	movl $0, %edi
	movl $0, %esi
	movl $7, %edx
	movl %r8d, %r13d
	dec %r13d
	jmp sklejanieB1

sklejanieB1:
	movb textout(,%edi,1), %al
	movb %al, b1(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB1		
	jmp spr_sklejania1

spr_sklejania1:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB2
	jmp wypisanieWszystkiego

sklejanieB2:
	movb textout(,%edi,1), %al
	movb %al, b2(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB2	
	jmp spr_sklejania2

spr_sklejania2:	
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB3
	jmp wypisanieWszystkiego

sklejanieB3:
	movb textout(,%edi,1), %al
	movb %al, b3(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB3	
	jmp spr_sklejania3

spr_sklejania3:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB4
	jmp wypisanieWszystkiego

sklejanieB4:
	movb textout(,%edi,1), %al
	movb %al, b4(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB4
	jmp spr_sklejania4

spr_sklejania4:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB5
	jmp wypisanieWszystkiego

sklejanieB5:
	movb textout(,%edi,1), %al
	movb %al, b5(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB5		
	jmp spr_sklejania5

spr_sklejania5:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB6
	jmp wypisanieWszystkiego

sklejanieB6:
	movb textout(,%edi,1), %al
	movb %al, b6(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB6		
	jmp spr_sklejania6

spr_sklejania6:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB7
	jmp wypisanieWszystkiego

sklejanieB7:
	movb textout(,%edi,1), %al
	movb %al, b7(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB7		
	jmp spr_sklejania7

spr_sklejania7:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jge sklejanieB8
	jmp wypisanieWszystkiego

sklejanieB8:
	movb textout(,%edi,1), %al
	movb %al, b8(,%esi,1)
	inc %edi
	inc %esi
	cmp %edi, %edx
	jge sklejanieB8		
	jmp spr_sklejania8

spr_sklejania8:
	cmp %edi, %r13d
	addl $8, %edx
	movl $0, %esi
	jmp wypisanieWszystkiego

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
	
	/*B1*/
	movq $1, %rax
	movq $1, %rdi
	movq $b1_tekst, %rsi
	movq $b1_len, %rdx
	syscall

	movq $b1, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B2*/
	movq $1, %rax
	movq $1, %rdi
	movq $b2_tekst, %rsi
	movq $b2_len, %rdx
	syscall

	movq $b2, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B3*/
	movq $1, %rax
	movq $1, %rdi
	movq $b3_tekst, %rsi
	movq $b3_len, %rdx
	syscall

	movq $b3, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B4*/
	movq $1, %rax
	movq $1, %rdi
	movq $b4_tekst, %rsi
	movq $b4_len, %rdx
	syscall

	movq $b4, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B5*/
	movq $1, %rax
	movq $1, %rdi
	movq $b5_tekst, %rsi
	movq $b5_len, %rdx
	syscall

	movq $b5, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B6*/
	movq $1, %rax
	movq $1, %rdi
	movq $b6_tekst, %rsi
	movq $b6_len, %rdx
	syscall

	movq $b6, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B7*/
	movq $1, %rax
	movq $1, %rdi
	movq $b7_tekst, %rsi
	movq $b7_len, %rdx
	syscall

	movq $b7, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	/*B8*/
	movq $1, %rax
	movq $1, %rdi
	movq $b8_tekst, %rsi
	movq $b8_len, %rdx
	syscall

	movq $b8, %r15

	movq $1, %rax
	movq $1, %rdi
	movq %r15, %rsi 
	movq $8, %rdx
	syscall

	movq $1, %rax
	movq $1, %rdi
	movq $tekst, %rsi
	movq $tekst_len, %rdx
	syscall

	



	jmp koniec
	
koniec:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $0x80



/*10100100
11000001
10110101
11010010
11000110
11100011
11010111
11110100*/
