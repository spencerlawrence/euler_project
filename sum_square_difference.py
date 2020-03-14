total_1 = 0
total_2 = 0
for x in range(1, 101):
    total_1 = total_1 + (x * x)
    total_2 = total_2 + x
total_2 = total_2 * total_2
print(total_2 - total_1)
