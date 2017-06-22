/*
 * Funkcja liczaca calke z funckji:
 * g = sqrt(x^2 + 1) -1
 * metoda prostokatow, z wykorzystaniem
 * wektorow (rownolegle obliczanie)
 * Funkcja wylicza sume wysokosci
 * prostokatow dla czterech punktow
 * jednoczesnie co skutkuje szybszym 
 * uzyskaniem wyniku.                
 */

.bss
.comm   begin,  4       # poczatek przedzialu calkowania
.comm   end,    4       # koniec przedzialu calkowania
.comm   dx,     16      # wektor [dx, dx, dx, dx]
.comm   begins  16      # wektor [begin, begin, begin, begin]
.comm   result  16      # wektor [suma, suma, suma, suma]

.data
init_x: .float  1, 2, 3, 4      # wektor startowy dla wyznaczania wysokosci
jedynki: .float 1, 1, 1, 1	# wektor [1, 1, 1, 1]
fours:  .float  4, 4, 4, 4      # wektor [4, 4, 4, 4]
zeros:  .float  0, 0, 0, 0      # wektor [0, 0, 0, 0]
sevens: .float  7, 7, 7, 7      # wektor [7, 7, 7, 7]
twos:   .float  2, 2, 2, 2      # wektor [2, 2, 2, 2]

.text
.global calka_simd
.type calka_simd, @function
.type g, @function

calka_simd:

        pushq %rbp
        movq %rsp, %rbp         #ramka stosu

	/*
	 * 3 parametry: 
	 * int prec      - dokladnosc obliczen
	 * float beg     - dolna granica
	 * float end     - gorna granica
	 *
	 * Znajdują sie w rejestrze %rdi, %xmm0 i %xmm1
	 */

        movss %xmm0, begin      # pobranie 1 argumetnu
        movss %xmm1, end        # pobranie 2 argumentu
        cvtsi2ss %rdi, %xmm0    # pobranie 3 argumentu (rzutowanie int na float)

        /*
	 * Liczenie szerokosci prostokatow
	 */
        subss begin, %xmm1      # wyznaczam dlugosc obszaru calkowania
        divss %xmm0, %xmm1      # wyliczam szerokosc prostokatu wynik zachowuje w %xmm1


        /*
  	 * dx zapisana na 4 pozycjach dla przyszłego przyspieszenia
	 */

        movq $0, %rsi          			 # iterator po wektorze dx
        KopiowanieDX:
                movss %xmm1, dx(,%rsi,4)         # kopiowanie dx na kolejne pozycje
                inc %rsi
                cmp $4, %rsi
                je Dalej
                jmp KopiowanieDX

        Dalej:
                movups dx, %xmm1        	 # wektor dx w rejestrze


        /*
	 * Tworzę wektory bgins i iters potrzebne do dlaszego wyznaczenia wysokosci
	 */

        movq $0, %rsi           		# iterator po wektorach
        movss begin, %xmm2      		# potrzebne do stworzenia wektoru begins
        Wektory:
                movss %xmm2, begins(,%rsi,4)    # kopiowanie begin na kolejne pozycje

                inc %rsi
                cmp $4, %rsi
                je Dalej2
                jmp Wektory


        Dalej2: 
		/*
		 * Od razu bez cyrtolenia, przechodze do liczenia
		 */
                movups begins, %xmm2
                movups init_x, %xmm3

	/*	
         * Majac juz wektory [dx,...,dx], [begin,...,begin] i [1,...,4] 
         * Moge zaczac wyliczac wysokosci prostokatow za pomoaca f(vec) 
         * W petli 4 razy mniejszej niz precyzja (%rdi) nalezy powtarzac
         * nastepujace kroki:                                           
         * wyznaczyc wektor punktow (make_x(vec_t-1))                   
         * wyznaczyc wartosci f w tych punktach f(vec_t)                
	 */	

        shrq $2, %rdi           	# dzielenie na 4 bo bedzie 4 razy mniej operacji
        movups zeros, %xmm0     	# zerow do xmm0, gdzie przechowuje sumy wysokosci
        Petla:
                call make_x     	# wyznacz wektor punktow
                call g          	# wyznaczanie wysokosci punktow

                movups fours, %xmm6     # wczytanie wektoru czworek
                addps %xmm6, %xmm3      # kolejne iteratory

                addps %xmm5, %xmm0      # dodanie wyniku f(vec_t) do sum

                dec %rdi
                cmp $0, %rdi
                je Koniec
                jmp Petla

        Koniec:
		/*
                 * w xmm0 mam 4 sumy, ktore pomnoze przez wektor dx i
                 * zsumuje w jedna calosc co da ostateczny wynik
		 */

                mulps %xmm1, %xmm0      # teraz to sumy pol
                movq $0, %rsi   	# iterator po wektorze
                movups %xmm0, result    # wczytanie wynikow do pamieci
                movups zeros, %xmm0     # wyzerowanie
                Sumowanie:
                        addss result(,%rsi,4), %xmm0    # jedna duza suma = calka
                        inc %rsi
                        cmp $4, %rsi
                        je Wynik
                        jmp Sumowanie

        Wynik:
                /*
 		 * W xmm0 jest wynik!
		 */


                leave
                ret


/*
 * Funkcja make_x wyznacza wektor
 * kolejnych punktow, ktorych wysokosci
 * trzeba wyznczyc, jako parametr
 * przyjmuje wektor iteratorow, ktore
 * przemnozone przez wektor dx dadza
 * w wyniku wektor kolejnych punktow
 * wynik zwraca w xmm4
 */
make_x:
        pushq %rbp
        movq %rsp, %rbp

        movups zeros, %xmm4     # wyzerowanie rejestru %xmm4
        addps %xmm3, %xmm4      # %xmm4 = [i, i+1, i+2, i+3]
        mulps %xmm1, %xmm4      # %xmm4 = [dx,...,dx]*[i,i+1,...,i+3]
        addps %xmm2, %xmm4      # %xmm4 = [xp + i*dx]

        leave
        ret


/*
 * Sama funkcja g
 * wychodzi xmm4 wynik zwraca w xmm5
 */
g:
        pushq %rbp
        movq %rsp, %rbp

        movups zeros, %xmm5     # wyzerowanie rejestru %xmm5
        addps %xmm4, %xmm5      # dodanie do xmm5 wektoru punktow
        mulps %xmm5, %xmm5      # [x,...,x]^2
        movups jedynki, %xmm6   # wyjedynkowanie rejestru %xmm6
	addps %xmm6, %xmm5	# [x,...,x]^2 + [1,...,1]

	movups zeros, %xmm6     # wyzerowanie rejestru %xmm6
	addps %xmm1, %xmm6	# xmm1 w xmm6
	movups zeros, %xmm1     # wyzerowanie rejestru %xmm1
	sqrtps %xmm5, %xmm1	# sqrt() z wynikiem w xmmm1
	movups zeros, %xmm5	# zerowanie xmm5
	addps %xmm1, %xmm5	# wynik w xmm5
	movups zeros, %xmm1	# zerowanie xmm1
	addps %xmm6, %xmm1	# xmm1 wraca na swoje miejsce	
	
	movups jedynki, %xmm6   # wyjedynkowanie rejestru %xmm6
        subps %xmm6, %xmm5      # sqrt() - 1


        leave
        ret

