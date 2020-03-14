import math

primes = []
for n in range(2, 2000000):
	print(n)
	prime = True
	for d in range(2, int(math.sqrt(n)) + 1):
		if n % d == 0:
			prime = False
			break
	if prime:
		primes.append(n)
sum = 0
for p in primes:
	sum += p
print(sum)