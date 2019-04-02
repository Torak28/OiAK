tab = [1,1,0,0,0,1]

a=[]
b=[]
c=[]
d=[]

iterator = 0
dlugosc = 5

for i in tab:
	if(iterator <2):
		a.append(tab[iterator])
		iterator +=1
	if(iterator >=2 and iterator <4):
		b.append(tab[iterator])
		iterator +=1
	if(iterator >=4 and iterator <6):
		c.append(tab[iterator])
		iterator +=1
	if(iterator >=6 and iterator <8):
		d.append(tab[iterator])
		iterator +=1

print a
print b
print c
print d
