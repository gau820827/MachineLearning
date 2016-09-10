require 'matrix'

srand Random.new_seed
def sign(num)
	if num>0
		return 1
	else
		return -1
	end
end

def flip(num)
	if rand() <= 0.1
		return -num
	else
		return num
	end
end

count=1000.to_f
size=1000.to_f
Eout=[]
SIM=[]
for i in 1..count
	#Generate data
	x = []
	y = []
	for j in 1..size
		r = [1,rand()*2-1,rand()*2-1]
		x << r
		y << flip(sign(r[1]*r[1]+r[2]*r[2]-0.6))
	end
	#Transform
	z = []
	for data in x
		rr = [data[0],data[1],data[2],data[1]*data[2],data[1]*data[1],data[2]*data[2]]
		z << rr
	end
	#Linear Regression
	X = Matrix.rows(z)
	Y = Matrix.column_vector(y)
	XT = X.transpose
	XPI = (XT*X).inverse*XT
	w = XPI*Y
	print w,"\n"
	#Test with other hypothesis
	sim=0.to_f
	g = Vector[-1,-0.05,0.08,0.13,1.5,1.5]
	for j in 0..size-1
		if sign((w.column_vectors)[0].inner_product X.row(j)) == sign(g.inner_product X.row(j))
			sim = sim+1
		end
	end
	print sim/size, "\n"
	SIM << sim/size
	####################
	###Calculate Eout###
	####################
	#Generate new data
	newx = []
	newy = []
	for j in 1..size
		srand Random.new_seed
		newr = [1,rand()*2-1,rand()*2-1]
		newx << newr
		newy << flip(sign(newr[1]*newr[1]+newr[2]*newr[2]-0.6))
	end
	#Transform new data
	newz = []
	for data in newx
		newrr = [data[0],data[1],data[2],data[1]*data[2],data[1]*data[1],data[2]*data[2]]
		newz << newrr
	end
	#Eout
	error = 0
	newX = Matrix.rows(newz)
	for j in 0..size-1
		if sign((w.column_vectors)[0].inner_product newX.row(j)) != newy[j]
			error = error + 1
		end
	end
	Eout << error/size
	###########################
	###End of Calculate Eout###
	###########################
end
SIM = SIM.inject { |sum, v| sum + v }
print SIM/count, "\n"
AllEout = Eout.inject { |sum, v| sum + v }
print "AVG Eout= ", AllEout/count, "\n"