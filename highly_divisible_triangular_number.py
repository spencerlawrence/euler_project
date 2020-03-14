import math


def count_divisors(n):
    count = 2
    for d in range(2, int(math.sqrt(n)) + 1):
        if n % d == 0:
            count += 2
    return count


triangle_number = 0
divisors = 0
i = 1
while True:
    triangle_number += i
    divisors = count_divisors(triangle_number)
    if divisors > 500:
        print(triangle_number)
        break
    i += 1
