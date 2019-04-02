# Co program robi?

Program wylicza liczbę w ciągu Fibonacciego o indeksie podanym przez użytkownika(przez "podanie" rozumiem umieszczenie w kodzie programu). Następnie wypisuję ją na ekran w dwóch konwencjach zapisu, tj. Little Endian i Big Endian.

```asm
.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 1
EXIT_SUCCESS = 0
BUFF = 16
N_INDEX = 200
```

# Jak go uruchomić?

Wykonać komendę: make Fib, a następnie uruchomić sam program poprzez: ./Fib

# Jak odczytać wynik?

Należy się posłużyć hexdumpem z -C

# Przykład użycia

```
torak28@jarek-VirtualBox:~/Pulpit/OiAK/Lab4$ make Fib
as -o Fib.o -gstabs Fib.s
ld -o Fib Fib.o

torak28@jarek-VirtualBox:~/Pulpit/OiAK/Lab4$ ./Fib
8}��\J���߃�g�8�J\��}�g˃���

torak28@jarek-VirtualBox:~/Pulpit/OiAK/Lab4$ ./Fib | hexdump -C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000003e0  00 00 00 00 00 00 00 00  38 03 00 00 00 00 00 00  |........8.......|
000003f0  0e 7d b0 ae 1c 5c 4a 86  95 e3 17 df 83 cb 67 f0  |.}...\J.......g.|
00000400  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000007e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 03 38  |...............8|
000007f0  86 4a 5c 1c ae b0 7d 0e  f0 67 cb 83 df 17 e3 95  |.J\...}..g......|

torak28@jarek-VirtualBox:~/Pulpit/OiAK/Lab4$./Fib > out.txt
torak28@jarek-VirtualBox:~/Pulpit/OiAK/Lab4$ls -l out.txt
-rw-rw-r-- 1 torak28 torak28 2048 maj 25 08:58 out.txt
```

Jak widać oba zapisy przedstawiają tą samą liczbę. Dodatkowo można sprawdzić że plik do którego przesłaliśmy wynik programu ma wielkość 2048, czyli po 1024 na jedną liczbe


# Jak to jest zrobione?

Zgodnie z założeniamy program operuje na 4 głównych buforach o wielkości 1024. Dwóch oznaczające liczby w ciągu, i po jednym na wynik w każdej konwencji. 

```asm
.bss
.comm pierwsza, 1024
.comm druga, 1024
.comm wynik, 1024
.comm BE, 1024
```

Adresy poszczególnych liczb zamieszczam sobie w rejestrze przy pomocy mnemonika lea, a następnie przechodząc po całym buforze dodaje poszczególne 64bitowe segmenty z przeniesieniem. Z uwagi na parę porównań w trakcie trwania pracy programu dla bezpieczeństwa pcham rejestr flag na sto i zdejmuje go tuż przed samym dodawaniem.

```asm
	movq (%r13), %rax
	movq (%r14), %rbx
	popf
	adcq %rbx, %rax
	pushf
	movq %rax, (%r13)
	movq %rbx, (%r14)	
	jmp zapisz_wynik
```

Sam wynik zapisuje pierw bezpośrednio pod tymi samymi adresami co akurat przerabiane liczby ale oczywiście w osobnym rejetrze. Tym samym mam z głowy zapis w LE jako że tak jest ułożona pamięć.

```asm
zapisz_wynik:
	movq %rax, wynik(,%edi,1)
	jmp zapisz_BE

```

Co do zapisu w BE to stosuje szereg przesunięć bitowych i dodawań na pomniejszych rejestrach tak by koniec końców otrzymać dobry zapis.

```asm
zapisz_BE:	
	movq $0, %rcx
	
	movb %al, %cl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 XXXXXXXX
	shlq $56, %rcx	#XXXXXXXX 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 YYYYYYYY
	shlq $56, %rbx	#YYYYYYYY 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rbx	#00000000 YYYYYYYY 00000000 00000000 00000000 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 ZZZZZZZZ
	shlq $56, %rbx	#ZZZZZZZZ 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $16, %rbx	#00000000 00000000 ZZZZZZZZ 00000000 00000000 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ 00000000 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 CCCCCCCC
	shlq $56, %rbx	#CCCCCCCC 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $24, %rbx	#00000000 00000000 00000000 CCCCCCCC 00000000 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC 00000000 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 VVVVVVVV
	shlq $56, %rbx	#VVVVVVVV 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $32, %rbx	#00000000 00000000 00000000 00000000 VVVVVVVV 00000000 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV 00000000 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 BBBBBBBB
	shlq $56, %rbx	#BBBBBBBB 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $40, %rbx	#00000000 00000000 00000000 00000000 00000000 BBBBBBBB 00000000 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV BBBBBBBB 00000000 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 NNNNNNNN
	shlq $56, %rbx	#NNNNNNNN 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $48, %rbx	#00000000 00000000 00000000 00000000 00000000 00000000 NNNNNNNN 00000000
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV BBBBBBBB NNNNNNNN 00000000
	shrq $8, %rax
	movb %al, %bl	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 MMMMMMMM
	shlq $56, %rbx	#MMMMMMMM 00000000 00000000 00000000 00000000 00000000 00000000 00000000
	shrq $56, %rbx	#00000000 00000000 00000000 00000000 00000000 00000000 00000000 MMMMMMMM
	addq %rbx, %rcx #XXXXXXXX YYYYYYYY ZZZZZZZZ CCCCCCCC VVVVVVVV BBBBBBBB NNNNNNNN MMMMMMMM
	
	movq $0, %rbx
	movq %rcx, %rbx	
	movq %rbx, BE(,%edi,1)
	jmp ciag_fib_dalej
```

Gdy oba segmenty są już odpowiednio zapisane to przechodze na kolejny "odcinek" liczby i wykonuje wszystko od nowa aż nie przejdę całości. Z ciekawszych elementów tego etapu należy podkreślić zamiane rejestrów przechowujących adresy poszczególnych buforów liczb. Wykonuje tą operacje żeby zawsze liczba pod buforem "pierwsza" była liczbą mniejszą z pary "pierzwsza", "druga". Wynika to z samego dodawania z przeniesienie, opisanym wcześniej.

```asm
nastepna:
	movq $0, %r8
	movq $1016, %r12
	inc %r10d
	/*Zamiana*/
	movq %r13, %r15
	movq %r14, %r13
	movq %r15, %r14
	movq $0, %r15
	cmp %r10d, %r11d
	jle wypisz	
	jmp dalej
```


Gdy obie liczby są gotowe to wypisuje je na ekran w odpowiednich pętlach.

```asm
wypisz:
	lea wynik, %r12
	movq $0, %r13
	movq $63, %r14
	jmp petla_wypisujaca

petla_wypisujaca:
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq %r12, %rsi
	movq $BUFF, %rdx
	syscall
	
	inc %r13
	addq $16, %r12
	cmp %r13, %r14
	jge petla_wypisujaca
	jmp wypiszBE
	
wypiszBE:
	lea BE, %r12
	movq $0, %r13
	movq $63, %r14
	jmp petla_wypisujacaBE

petla_wypisujacaBE:
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq %r12, %rsi
	movq $BUFF, %rdx
	syscall
	
	inc %r13
	addq $16, %r12
	cmp %r13, %r14
	jge petla_wypisujacaBE
	jmp koniec
```


