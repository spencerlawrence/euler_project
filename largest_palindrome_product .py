def is_palindrome(n):
    x = 1
    for char in n:
        if char != n[-x]:
            return False
        x += 1
    return True


def is_product(n):
    d = 999
    while len(str(int(n / d))) == 3 and d > 99:
        if n % d == 0:
            return True
        d -= 1
    return False


for n in range(998001, 9999, -1):
    if is_palindrome(list(str(n))):
        if is_product(n):
            print(n)
            break
