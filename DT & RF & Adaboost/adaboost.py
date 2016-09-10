import math
N = 100
Time = [300]
def readdata(file):
	y = []
	x = []
	u = []
	for line in f.readlines():
		x1, x2, yy = line.split()
		x.append([float(x1),float(x2)])
		y.append(float(yy))
		u.append(1)
	return y, x, u

def gError(y, x, u, theta, s, direction):
	error = 0
	for i in xrange(0, N):
		if decision_stump(theta, s, x[i][direction]) != y[i]:
			error = error + u[i]
	return error/float(N)

def GError(y, x, alpha, g):
	error = 0
	for i in xrange(0, len(y)):
		G = 0
		for t in xrange(0, Time[0]):
			G = G + alpha[t]*decision_stump(g[t][0], g[t][1], x[i][g[t][2]])
		#print x[i], G, y[i]
		if math.copysign(1, G) != y[i]:
			error = error + 1
	return error/float(len(y))

def decision_stump(theta, s, x):
	return s*math.copysign(1, x-theta)

for time in Time:
	f = open("./hw6_train.dat", "r")
	y, x, u = readdata(f)
	f = open("./hw6_test.dat", "r")
	yt, xt, ut = readdata(f)
	besttheta = 1.0
	bests = 1.0
	bestd = 1.0
	alpha = []
	g = []
	for t in xrange(0, time):
		bestEin = 1.0
		#Find best g(x)
		for s in [-1,1]:
			for direction in [0,1]:
				for i in xrange(0, N-1):
					theta = (x[i][direction]+x[i+1][direction])/2
					Ein = gError(y,x,u,theta,s,direction)
					if Ein < bestEin:
						bestEin = Ein
						besttheta = theta
						bests = s
						bestd = direction
		g.append([besttheta, bests, bestd])
		print "bestEin = ", bestEin
		#Update u(t) to u(t+1)
		wu = 0
		for i in xrange(0, N):
			if decision_stump(besttheta, bests, x[i][bestd]) != y[i]:
				wu = wu + u[i]
		e = wu/float(sum(u))
		p = math.sqrt((1-e)/e)
		print "e = ", e, " p = ", p, " wrong u = ", wu
		for i in xrange(0, N):
			if decision_stump(besttheta, bests, x[i][bestd]) != y[i]:
				u[i] = u[i] * p
			else:
				u[i] = u[i] / p
		print "=================Finish Update ", t
		#Compute alpha(t)
		alpha.append(math.log(p))
	#END OF ITERATION
	#Return G(x)
	GEin = GError(y, x, alpha, g)
	GEout = GError(yt, xt, alpha, g)
	print "Alpha = ", alpha
	print "G = ", g
	print "GEin = ", GEin
	print "GEout = ", GEout
	print "U = ", sum(u)/float(N)