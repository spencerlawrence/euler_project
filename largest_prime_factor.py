import math

largest = 0
n = 600851475143
for d in range(2, int(math.sqrt(n)) + 1):
	if n % d == 0:
		prime = True
		for x in range(2, int(math.sqrt(d)) + 1):
			if d % x == 0:
				prime = False
		if prime:
			largest = d
print(largest)
