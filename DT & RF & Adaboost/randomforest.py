import math
import random
global count
count = 0
def readdata(file):
	y = []
	x = []
	u = []
	for line in f.readlines():
		x1, x2, yy = line.split()
		x.append([float(x1),float(x2)])
		y.append(float(yy))
	return y, x

def TreeError(y, x, tree):
	error = 0
	for i in xrange(0, len(y)):
		if x[i][tree["2"][0]] > tree["2"][2]:
			k = TraverseTree(x[i], tree["1"])
		else:
			k = TraverseTree(x[i], tree["0"])
		if k != y[i]:
			error = error + 1
	return error/float(len(y))

def TraverseTree(x, tree):
	if tree["0"] == None and tree["1"] == None:
		return tree["2"]
	elif x[tree["2"][0]] > tree["2"][2]:
		return TraverseTree(x, tree["1"])
	else:
		return TraverseTree(x, tree["0"])

def terminal(data):
	y = []
	x = []
	for i in xrange(len(data)):
		y.append(data[i][0])
		x.append(data[i][1])
	xsame = True
	ysame = True
	for i in xrange(0, len(y)-1):
		if x[i] != x[i+1]:
			xsame = False
	for i in xrange(0, len(y)-1):
		if (y[i] < 0) != (y[i+1] < 0):
			ysame = False
	if xsame or ysame:
		#print "Leaf!"
		#print y,x
		return True
	else:
		return False

def gini(data):
	G = 0.0
	for k in [-1.0,1.0]:
		right = 0.0
		for i in xrange(len(data)):
			# print data[i][0]
			if (data[i][0]<0) == (k < 0):
				right = right + 1
		G = G + ((right/len(data)) ** 2)
	return 1.0-G

def decision_tree(data):
	#print "branch!"
	global count
	count = count + 1
	if terminal(data):
		#print data[0][0]
		count = count - 1
		t = {"0":None, "1":None, "2":data[0][0]}
		return t
	else:
		#learn
		bestb = 100000000000
		tmp = data
		for i in xrange(0,2):
			tmp = sorted(tmp, key=lambda temp: temp[1][i])
			for j in xrange(0,len(tmp)-1):
				theta = (tmp[j][1][i] + tmp[j+1][1][i])/2
				b = len(tmp[:j+1])*gini(tmp[:j+1]) + len(tmp[j+1:])*gini(tmp[j+1:])
				if b < bestb:
					bestb = b
					besth = [i, j, theta]
		#Split
		tmp = sorted(tmp, key=lambda temp: temp[1][besth[0]])
		#print "Weight = ", len(tmp[:besth[1]+1]), len(tmp[besth[1]+1:])
		#print "hypothesis = ", besth
		t = {"0":None, "1":None, "2":besth}
		t["0"] = decision_tree(tmp[:besth[1]+1])
		t["1"] = decision_tree(tmp[besth[1]+1:])
		#Return G
		return t

def boosting(y, x):
	dataforest = []
	for time in xrange(0, 300):
		ydata = []
		xdata = []
		while len(ydata) != len(y):
			random.seed()
			r = random.randint(0,len(y)-1)
			ydata.append(y[r])
			xdata.append(x[r])
		dataforest.append([ydata, xdata])
	return dataforest

def ForestError(y, x, Forest):
	error = 0
	for i in xrange(0, len(y)):
		kall = 0
		for tree in Forest:
			if x[i][tree["2"][0]] > tree["2"][2]:
				k = TraverseTree(x[i], tree["1"])
			else:
				k = TraverseTree(x[i], tree["0"])
			kall = kall + k
		if math.copysign(1, kall) != y[i]:
			error = error + 1
	return error/float(len(y))

f = open("./hw6_train.dat", "r")
y, x = readdata(f)
f = open("./hw6_test.dat", "r")
yt, xt = readdata(f)

AllEout = []
time = 100
for t in xrange(0, time):
	dataforest = boosting(y, x)
	Forest = []
	EachEin = []
	EachEout = []
	for i in xrange(0, len(dataforest)):
		data = zip(dataforest[i][0], dataforest[i][1])
		Tree = decision_tree(data)
		Forest.append(Tree)
		#EachEin.append(TreeError(y, x, Tree))
		#EachEout.append(TreeError(yt, xt, Tree))
	e = ForestError(yt, xt, Forest)	
	AllEout.append(e)
	print "Eout = ", e
print "AVG Eout = ", sum(AllEout)/float(time)