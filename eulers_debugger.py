product = [2,]

insert = False
for n in range(len(product)):
	if n == 0 and product[n] > 4:
		product[n] = int(str(product[n] * 2)[1])
		insert = True
	elif product[n] > 4:
		product[n] = int(str(product[n]*2)[1])
		product[n-1] = product[n-1] + 1
	else:
		product[n] = product[n]*2
if insert:
	product.insert(0,1)
print(product)
