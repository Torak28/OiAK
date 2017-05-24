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
 	call funkcja     	 	 # Wywołanie funkcjinie funkcji

	mov %rax, %rsi
	mov $0, %rax        # Przesyłamy 0 parametrów zmiennoprzecinkowych
	mov $format_d, %rdi # Pierwszy parametr całkowity dla scanf
	call printf

	mov $0, %rax 		# Przesyłamy 0 parametrów zmiennoprzecinkowych
	mov $nowa_linia, %rdi 	# Pierwszy parametr typu całkowitego
	call printf		# Wywołanie funkcji printf


mov $0, %rax
call exit
