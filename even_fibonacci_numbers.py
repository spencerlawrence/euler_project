numbers = [1, 2, 3, ]
total = 0
while numbers[-1] <= 4000000:
	numbers.append(numbers[-1] + numbers[-2])
for n in numbers:
	if n % 2 == 0:
		total = n + total
print(total)
