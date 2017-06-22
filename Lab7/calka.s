.bss
/* zmienne funkcji calkujacej */
.comm precyzja, 4
.comm begin, 4
.comm end, 4
.comm suma, 4
.comm _dx, 4


/* zmienne funkcji g*/
.comm x, 4

/* zmienne funkcji liczacej make_x */
.comm xp, 4
.comm i, 4
.comm dx, 4

/*zmienna do przetransportowania wyniku*/
.comm result, 4
.comm temp, 4

.data
jeden: .long 1

.text
.global calka

.type calka, @function
.type g, @function
.type wysokosc, @function

calka:
        pushq %rbp
        movq %rsp, %rbp
	/*
	* 3 parametry
	* Pierwszy arg to dokladnosc w %rsi
	* Drugi to poczatek przedzialu calkowania %xmm0
	* Trzeci to koniec przedzialu calkowania %xmm1
	*/



	/*Liczymy szerokosc prostokata
	 *szerokosci prostokata dx:
	 *dx = (xk - xp)/n
	 */

        movq $0, %rsi
        movq %rdi, precyzja(,%rsi,4)		#pobranie precyzjayzji
        movss %xmm0, begin      		#pobranie dolnej granicy
        movss %xmm1, end        		#pobranie gornej granicy

        flds end        			#xk
        fsub begin      			#(xk - xp)
        fidiv precyzja      			#((xk - xp)/n

        fstps _dx       			#pobranie wyliczonego przedzialu do _dx

	/*
	 * kolejnym krokiem algorytmu jest wyliczenie
	 * sumy wysokosci wszystkich prostokatow
	 * dla i = 1, 2,...,precyzja
	 *  suma += g(make_x(xp, i, dx))
	 */

        fldz    				#0 do st(0) - suma wszystkich wysokosci

        petla:
                movss begin, %xmm0     	 	#pierwszy argument dla make_x
                        			#drugi argument jest w %rdi
                movss _dx, %xmm1        	#trzeci argument

                call make_x

                /*
		 * w %xmm0 jest wynik make_x i jest od razu pierwszym
                 * argumentem g(x)
		 */

                call g


		/*
		 * w %xmm0 jest teraz wysokosc jednego z prostokatow
                 * teraz wystarczy dodac %xmm0 do sumy wszystkiego co jest w st(0)
		 */

                movss %xmm0, result

                fadd result     		#dodanie na szczyt stosu wysokosci prostokata

                dec %rdi        		#dekrementuje licznik
                cmp $0, %rdi    		#jesli 0 to konczymy prace
                je koniec
                jmp petla

        koniec:    
		/*
		 * w st(0) jest wysokosc wszystkich prostokatow
                 * pomnoze teraz to wszystko przez szerokosc
		 */

                fmul _dx
                fstps result    		#wynik calkowania
                movss result, %xmm0

                movq %rbp, %rsp
                popq %rbp
                ret

	/*
	 * wylicza wysokosc danego prostokata    
	 * potrzebne argumenty pobiera z         
	 * rejestrow %xmm(0-1) oraz %rdi        
	 * %xmm0 - dolna granica calkowania      
	 * %rdi  - numer prostokata              
	 * %xmm1 - szerokosc prostokata          
	 * wynik zwraca w %xmm0                  
	 */
make_x:
        pushq %rbp     			 #ramka stosu
        movq %rsp, %rbp

        /*pobranie argumentow*/
        movq %rdi, precyzja(,%rsi,4)
        movss %xmm0, xp
        movss %xmm1, dx

        fild precyzja       		# i
        fmul dx 			# i*dx
        fadd xp 			# xp + i*dx

        fstps result
        movss result, %xmm0     	#pobranie wyniku

        movq %rbp, %rsp         	#porzadkowanie stosu
        popq %rbp
        ret



	/*
	 * wylicza wartosc funkcji w danym punkcie
	 * wynik zwraca w %xmm0 
	 * argument przyjmuje z %xmm0
	 */

g:
        pushq %rbp
        movq %rsp, %rbp

        movss %xmm0, x  # pobranie argumentu

        flds x
        fmul x  		#x^2
	fiadd jeden		#x^2+1
	fsqrt			#sqrt(x^2+1)
        fld1

        /*w st(1) mam sqrt(x^2+1) a w st(0) mam 1
        od st(0) odejmuje st(1)*/

        fxch    		#zamieniam st(0) z st(1)
        fsub %st(1)     	#odejmuje od st(0) st(1)

        fstps result   		#pobranie wyniku
        fstps temp      	#czyszcze stos ze smieci pozostawionych przez funkcje

        movss result, %xmm0     #wynik do %xmm0

        movq %rbp, %rsp
        popq %rbp
        ret
