.bss
.comm   poczatekCalkowania,  4  # poczatek przedzialu calkowania
.comm   koniecCalkowania,    4  # koniec przedzialu calkowania
.comm   dx,     16      	# wektor [dx, dx, dx, dx]
.comm   poczatekV  16      	# wektor [poczatekCalkowania, poczatekCalkowania, poczatekCalkowania, poczatekCalkowania]
.comm   wynikV  16      	# wektor [suma, suma, suma, suma]

.data
wysokosciStart: .float  1, 2, 3, 4      # wektor startowy dla wyznaczania wysokosci
jedynki: .float 1, 1, 1, 1		# wektor [1, 1, 1, 1]
zera:  .float  0, 0, 0, 0      		# wektor [0, 0, 0, 0]
czworki: .float 4, 4, 4, 4		# wektor [4, 4, 4, 4]

.text
.global calka_simd
.type calka_simd, @function
.type g, @function

calka_simd:

        pushq %rbp
        movq %rsp, %rbp         #ramka stosu

	/* 
	 * int prec      - dokladnosc obliczen, ilosc prostokatow w %rdi
	 * float beg     - dolna granica calkowania w xmm0
	 * float koniecCalkowania     - gorna granica calkowania w xmm1
	 */

        movss %xmm0, poczatekCalkowania      # pobranie 1 argumetnu
        movss %xmm1, koniecCalkowania        # pobranie 2 argumentu
        cvtsi2ss %rdi, %xmm0    	     # pobranie 3 argumentu (rzutowanie int na float)

        /*
	 * Liczenie szerokosci prostokatow
	 */
        subss poczatekCalkowania, %xmm1      # wyznaczam dlugosc obszaru calkowania
        divss %xmm0, %xmm1      	     # wyliczam szerokosc prostokatu wynik zachowuje w %xmm1


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
                movups dx, %xmm1        	 # wektor dx w rejestrze xmm1


        /*
	 * Tworzę wektory poczatkowych
	 */

        movq $0, %rsi           		  # iterator po wektorach
        movss poczatekCalkowania, %xmm2 
        Wektory:
                movss %xmm2, poczatekV(,%rsi,4)   # kopiowanie poczatekCalkowania na kolejne pozycje

                inc %rsi
                cmp $4, %rsi
                je Dalej2
                jmp Wektory


        Dalej2: 
		/*
		 * Od razu bez cyrtolenia, przechodze do liczenia
		 */
                movups poczatekV, %xmm2
                movups wysokosciStart, %xmm3

	/*	
         * Majac juz wektory [dx,...,dx], [poczatekCalkowania,...,poczatekCalkowania] i [1,...,4] 
         * Moge zaczac wyliczac wysokosci prostokatow za pomoaca g(vec) 
         * W petli 4 razy mniejszej niz precyzja (%rdi) nalezy powtarzac
         * nastepujace kroki:                                           
         * wyznaczyc wektor punktow (generujX(vec_t-1))                   
         * wyznaczyc wartosci f w tych punktach f(vec_t)                
	 */	

        shrq $2, %rdi           	# dzielenie na 4 bo bedzie 4 razy mniej operacji
        movups zera, %xmm0     		# zer do xmm0, gdzie przechowuje sumy wysokosci
        Petla:
                call generujX     	# wyznacz wektor punktow
                call g          	# wyznaczanie wysokosci punktow

                movups czworki, %xmm6   # wczytanie wektoru czworek
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
                movups %xmm0, wynikV    # wczytanie wynikow do pamieci
                movups zera, %xmm0      # wyzerowanie
                Sumowanie:
                        addss wynikV(,%rsi,4), %xmm0    # jedna duza suma = calka
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
 * Funkcja generujX wyznacza wektor
 * kolejnych punktow, ktorych wysokosci
 * trzeba wyznczyc, jako parametr
 * przyjmuje wektor iteratorow, ktore
 * przemnozone przez wektor dx dadza
 * w wyniku wektor kolejnych punktow
 * wynik zwraca w xmm4
 */
generujX:
        pushq %rbp
        movq %rsp, %rbp

        movups zera, %xmm4      # wyzerowanie rejestru %xmm4
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

        movups zera, %xmm5      # wyzerowanie rejestru %xmm5
        addps %xmm4, %xmm5      # dodanie do xmm5 wektoru punktow
        mulps %xmm5, %xmm5      # [x,...,x]^2
        movups jedynki, %xmm6   # wyjedynkowanie rejestru %xmm6
	addps %xmm6, %xmm5	# [x,...,x]^2 + [1,...,1]

	movups zera, %xmm6      # wyzerowanie rejestru %xmm6
	addps %xmm1, %xmm6	# xmm1 w xmm6
	movups zera, %xmm1      # wyzerowanie rejestru %xmm1
	sqrtps %xmm5, %xmm1	# sqrt() z wynikiem w xmmm1
	movups zera, %xmm5	# zerowanie xmm5
	addps %xmm1, %xmm5	# wynik w xmm5
	movups zera, %xmm1	# zerowanie xmm1
	addps %xmm6, %xmm1	# xmm1 wraca na swoje miejsce	
	
	movups jedynki, %xmm6   # wyjedynkowanie rejestru %xmm6
        subps %xmm6, %xmm5      # sqrt() - 1


        leave
        ret

