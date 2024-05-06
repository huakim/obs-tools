from time import process_time
def dummy(i):
  i = i + i
def f(i):
  i = i * i * i
start = process_time()
n=99990900
for i in range(n): dummy(i)
for i in range(n): f(i)
time = process_time() - start

print(time)
