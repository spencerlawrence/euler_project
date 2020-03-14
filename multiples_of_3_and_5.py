sum = []
total = 0
for n in range(999,2,-1):
	if n % 3 == 0:
		sum.append(n)
	elif n % 5 == 0:
		sum.append(n)
for n in sum:
	total = total + n
print(total)
