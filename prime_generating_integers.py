import math


def is_prime(n):
    if n in prime:
        return True
    for d in range(2, int(math.sqrt(n)) + 1):
        if n % d == 0:
            return False
    prime.add(n)
    return True


def get_divisors(n):
    divisors = set()
    for d in range(2, int(math.sqrt(n)) + 1):
        if n % d == 0:
            if d in sum:
                continue
            elif is_prime(d) and is_prime(int(n / d)):
                divisors.add(d)
            else:
                return set()
    return divisors


sum = set()
prime = set()
for n in range(100000000, 1, -1):
    sum = sum | get_divisors(n)
total = 0
for n in sum:
    total = n + total
print(total)
