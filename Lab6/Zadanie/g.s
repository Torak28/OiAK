.bss
.comm result, 4
.comm input, 4

.data
jeden: .long 1

.text
.global g
.type g, @function
g:
        movss %xmm0, input

        flds input      #zaladowanie argumentu do ST0
        
	/*
	Operacje matematyczne
	*/

	fmul input		#^2
	fiadd jeden		#Dodanie 1 do ST0
	fsqrt			#pierwiastek z ST0
	fisub jeden		#Odjecie 1	
	

        fstps result    	#pobranie wyniku do pamieci
        movss result, %xmm0     #przeniesienie arg doo zwrocenia

        ret
