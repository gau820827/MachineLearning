require 'matrix'

def sign(num)
	if num>0
		return 1
	else
		return -1
	end
end

def error(w,x,y)
	size = y.row_count.to_f
	error = 0.to_f
	for i in 0..size-1
		if sign((w.column_vectors)[0].inner_product x.row(i)) != y.row(i)[0]
			error = error+1
		end
	end
	return error/size
end

def read(filename)
	rx = []
	ry = []
	File.foreach(filename) { |lines|
		data = lines.split(" ")
		rx << [1.to_f, data[0].to_f, data[1].to_f]
		ry << [data[2].to_f]
	}
	x = Matrix.rows(rx)
	y = Matrix.rows(ry)
	return x,y
end

def read_valid(filename)
	count = 0
	rx = []
	ry = []
	rx1 = []
	ry1 = []
	File.foreach(filename) do |lines|
		data = lines.split(" ")
		if count < 120
			rx << [1.to_f, data[0].to_f, data[1].to_f]
			ry << [data[2].to_f]
		else
			rx1 << [1.to_f, data[0].to_f, data[1].to_f]
			ry1 << [data[2].to_f]
		end
		count = count + 1
	end
	x = Matrix.rows(rx)
	y = Matrix.rows(ry)
	x1 = Matrix.rows(rx1)
	y1 = Matrix.rows(ry1)
	#print x,y,x1,y1
	return x,y,x1,y1
end

def readfold(filename)
	xfold = []; yfold = []
	xother = []; yother = []
	for i in 0..4
		rfx = []; rfy = []
		rox = []; roy = []
		st = 40*i; ed = 40*(i+1)-1
		count = 0
		print count," ", st, " ", ed, "\n"
		File.foreach(filename) do |lines|
			data = lines.split(" ")
			if count >= st && count <= ed
				rfx << [1.to_f, data[0].to_f, data[1].to_f]
				rfy << [data[2].to_f]
			else
				rox << [1.to_f, data[0].to_f, data[1].to_f]
				roy << [data[2].to_f]
			end
			count = count + 1
		end
		fx = Matrix.rows(rfx); fy = Matrix.rows(rfy)
		ox = Matrix.rows(rox); oy = Matrix.rows(roy)
		xfold << fx; yfold << fy
		xother << ox; yother << oy
	end
	return xfold, yfold, xother, yother
end

def compute_w(x,y,lamda)
	return ((x.transpose)*x + lamda*Matrix.identity(x.column_count)).inverse*x.transpose*y
end

#Readfile
x,y = read("./hw4_train.dat")
x2,y2 = read("./hw4_test.dat")
xtrain, ytrain, xvalid, yvalid = read_valid("./hw4_train.dat")
xfold, yfold, xother, yother = readfold("./hw4_train.dat")
#print xfold, yfold, "\n"
for power in -10..2
	#Compute w
	lamda = 10**power
	wv = compute_w(xtrain,ytrain,lamda)
	w = compute_w(x,y,lamda)
	#Compute Ecv
	ecv = 0
	for i in 0..4
		#print compute_w(xfold[i],yfold[i],lamda), "\n"
		ecv = ecv + error(compute_w(xother[i],yother[i],lamda), xfold[i], yfold[i])
	end
	ecv = ecv/5
	#Compute error
	print "Power of Lamda= ", power, " Ein= ", error(w,x,y), " Eout= ", error(w,x2,y2), "\n"
	print "Power of Lamda= ", power, " Etrain= ", error(wv,xtrain,ytrain), " Evalid= ", error(wv,xvalid,yvalid), " Eout= ", error(wv,x2,y2), "\n"
	print "Power of Lamda= ", power, " Ecv= ", ecv, " Ein= ", error(w,x,y), " Eout= ", error(w,x2,y2), "\n"
	print "\n"
end