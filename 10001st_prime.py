import math

n = 1
primes = []
while len(primes) <= 10002:
	prime = True
	for d in range(2, int(math.sqrt(n)) + 1):
		if n % d == 0:
			prime = False
			break
	if prime:
		primes.append(n)
	n += 1

print(primes[10001])
