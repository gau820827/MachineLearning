require "time"

def sign(num)
	if num>0
		return 1
	else
		return -1
	end
end

def flip(num)
	srand Random.new_seed
	if rand() <= 0.2
		return -num
	else
		return num
	end
end

def hypothesis(theta,s,x)
	return s*sign(x-theta)
end

count=5000.to_f
size=20
AllEin=0.to_f
AllEout=0.to_f
for i in 1..count
	bestEin = 1
	x = []
	y = []
	for j in 1..size
		srand Random.new_seed
		r = rand()*2-1
		x << r
		y << flip(sign(r))
	end
	#print x, "\n", y, "\n"
	#Find out the lowest Ein
	for range in 0..size-2
		theta = (x[range]+x[range+1])/2
		#print "Try theta: ", theta, "\n"
		for s in [1,-1]
			err = 0.to_f
			for test in 0..size-1
				if hypothesis(theta,s,x[test]) != y[test]
					err = err+1
				end
			end
			Ein = err/test.to_f
			#print Ein, "\n"
			if Ein < bestEin
				bestEin = Ein
				besttheta = theta
				bests = s
			end
		end
	end
	print bestEin, "\n"
	Eout = 0.5+0.3*bests*(besttheta.abs-1)
	#print Eout, "\n"
	AllEin = AllEin + bestEin
	AllEout = AllEout + Eout
	#Find Eout
end
print "Avg Ein= ", AllEin/count, "\n"
print "Avg Eout= ", AllEout/count, "\n"