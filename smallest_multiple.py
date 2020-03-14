# 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
# What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?


def main():
    n = 2520
    while True:
        for d in range(19, 1, -1):
            if n % d != 0:
                break
            if d == 2:
                return n
        n += 20


print(main())
