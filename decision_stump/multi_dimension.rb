require "time"
require "matrix"


def sign(num)
	if num>0
		return 1
	else
		return -1
	end
end

def hypothesis(theta,s,x)
	return s*sign(x-theta)
end

size = 0
dimension = 9
x = [[],[],[],[],[],[],[],[],[]]
y = []
data = Array.new(dimension+1)
File.foreach("./hw2_train.dat") do |line|
	size = size+1
	data = line.split(' ')
	for number in 0..dimension-1
		x[number] << data[number].to_f
	end
	y << data[number+1].to_f
end
#print size
#First calculate
goods = Array.new(dimension)
goodtheta = Array.new(dimension)
goodEin = [1,1,1,1,1,1,1,1,1]
for number in 0..dimension-1
	for range in 0..size-2
		theta = (x[number][range]+x[number][range+1])/2
		#print "Try theta: ", theta, "\n"
		for s in [1,-1]
			err = 0.to_f
			for test in 0..size-1
				if hypothesis(theta,s,x[number][test]).to_f != y[test]
					err = err+1
				end
			end
			#print err, "\n", test, "\n"
			Ein = err/test.to_f
			#print Ein, "\n"
			if Ein < goodEin[number]
				goodEin[number] = Ein
				goodtheta[number] = theta
				goods[number] = s
			end
		end
	end
end
#Try the best
bestEin = goodEin.min
chosen = goodEin.index(bestEin) 
besttheta = goodtheta[chosen]
bests = goods[chosen]
test_data = []
test=0.to_f
out_err=0.to_f
#print chosen, "\n"
File.foreach("./hw2_test.dat") do |lines|
	test = test+1
	test_data = lines.split(' ')
	#print test_data, "\n"
	if hypothesis(besttheta,bests,test_data[chosen].to_f).to_f != test_data[dimension].to_f
		out_err = out_err+1
	end
end
Eout = out_err.to_f/test
print "BestEin= ", bestEin, "\nEout= ", Eout, "\n"