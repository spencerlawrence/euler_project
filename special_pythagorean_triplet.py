def main():
	for c in range(997, 1, -1):
		a = 1
		while c + a < 1000:
			b = 1000 - c - a
			if a >= b:
				break
			if a**2 + b**2 == c**2:
				return a * b * c
			a += 1

print(main())