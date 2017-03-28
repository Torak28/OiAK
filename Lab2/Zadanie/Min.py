def myMin(Lista):
	min = Lista[0]
	for i in Lista:
		if i < min:
			 min = i
	return min

print myMin([1,2,3])
print myMin([3,2,1])
