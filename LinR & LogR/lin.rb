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

count, size = 1000.0, 1000.0
Ein=[]
for i in 1..count
	#Generate data
	x = []
	y = []
	for j in 1..size
		r = [1,rand()*2-1,rand()*2-1]
		x << r
		y << flip(sign(r[1]*r[1]+r[2]*r[2]-0.6))
	end
	#Linear Regression
	X = Matrix.rows(x)
	Y = Matrix.column_vector(y)
	XT = X.transpose
	XPI = (XT*X).inverse*XT
	w = XPI*Y
	puts w
	#Calculate Ein
	error=0.to_f
	for j in 0..size-1
		if sign((w.column_vectors)[0].inner_product X.row(j)) != y[j]
			error = error+1
		end
	end
	Ein << error/size
end
AllEin = Ein.inject { |sum, v| sum + v }
puts AllEin/count