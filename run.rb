load 'method.rb'
# all numbers should be float
smoothing = 0.5
f = 10.0
c = 200.0
big_d = 700.0
big_c = 100000.0
puts retrieve(f,c,big_d,big_c,smoothing)
f += 1
puts retrieve(f,c,big_d,big_c,smoothing)
c += 1
puts retrieve(f,c,big_d,big_c,smoothing)
