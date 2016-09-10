require 'matrix'

def sign(num)
	if num>0
		return 1
	else
		return -1
	end
end

dimension=20
size=1000.to_f
rx=Array.new(dimension) { Array.new() }
ry=[]
rw = Array.new(dimension,0.to_f)
#Read File
File.foreach("./hw3_train.dat") do |line|
	data = line.split(" ")
	for i in 0..dimension-1
		rx[i] << data[i].to_f
	end
	ry << data[dimension].to_f
end
#Compute the gradient
x = Matrix.columns(rx)
y = Matrix.column_vector(ry)
w = Matrix.column_vector(rw)
time=2000
tau=0.001
n=0
sum = Matrix.column_vector(rw)
for i in 0..time
	if n==size
		n=0
	end
	sum = (y[n,0]*x.row(n))/(1+Math.exp(y[n,0]*(w.column(0).inner_product x.row(n))))
	g = sum
	wnew = w + tau*g
	w = wnew
	n += 1
end
print wnew,"\n"
#Test Eout
count=0.to_f
error=0.to_f
File.foreach("./hw3_test.dat") do |line|
	wt=0
	count += 1
	data = line.split(" ")
	#print data[dimension], "\n"
	for i in 0..dimension-1
		aa=[wnew[i,0],data[i].to_f]
		#print aa, "\n"
		wt += wnew[i,0]*data[i].to_f
		#print wt, "\n"
	end
	#print sign(wt).to_f, "\n"
	if sign(wt).to_f != data[dimension].to_f
		error += 1
		#print count, "\n"
	end
end
print "Eout= ", error/count, "\n"