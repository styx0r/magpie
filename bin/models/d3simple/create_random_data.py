import random

def randnum(upper=10):
    return random.randint(1, 10)

with open('example1.barplot', 'w') as f:
    for i in range(randnum(upper=20)):
        f.write("%s\n" % randnum())

with open('example2.barplot', 'w') as f:
    for i in range(randnum(upper=20)):
        f.write("%s\n" % randnum())
