history = {}
count = 0

for start in range(2, 1000000):
    n = start
    chain = []
    while n != 1:
        if n in history:
            chain.extend(history[n])
            break
        else:
        	chain.append(n)
        if n % 2 == 0:
            n = int(n / 2)
        else:
            n = int(3 * n + 1)
    history[start] = chain

# longest = 0
# answer = 0
# for h in history:
#     if len(history[h]) > longest:
#     	longest = len(history)
#     	answer = h
# print(answer)

for h in history:
    print(h, len(history[h]))