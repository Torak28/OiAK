.bss
.comm result, 4
.comm input, 4

.data
jeden: .long 1

.text
.global f
.type f, @function
f:
        movss %xmm0, input

        flds input      #zaladowanie argumentu do ST0
        
	/*
	Operacje matematyczne
	*/

	fmul input		#Mnozymy ST0 razy wejscie ^2
	flds input 		#Teraz w ST0 jest x, a w ST1 x^2	
	
	fmul input		#^2
	fiadd jeden		#Dodanie 1 do ST0
	fsqrt			#pierwiastek z ST0
	fiadd jeden		#Dodanie 1 do ST0

	fdivr %st(1), %st(0)	
	

        fstps result    #pobranie wyniku do pamieci
        movss result, %xmm0     #przeniesienie arg doo zwrocenia

        ret
