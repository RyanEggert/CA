strout= ''
for i in range(31):
    strout += 'reg{n}out, '.format(n=31-i)

print strout