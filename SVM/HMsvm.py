import sys
import math
import numpy as np
from cvxopt import matrix, solvers
def ztransform (x1,x2):
	return [x2*x2-2*x1+3, x1*x1-2*x2-3]

def transform(x1,x2):
	return [1, 1.414*x1, 1.414*x2, x1*x1, x1*x2, x2*x1, x2*x2]

def kernel(x1,x2):
	return (1+x1[0]*x2[0]+x1[1]*x2[1])*(1+x1[0]*x2[0]+x1[1]*x2[1])

x = [[1.0,0.0],[0.0,1.0],[0.0,-1.0],[-1.0,0.0],[0.0,2.0],[0.0,-2.0],[-2.0,0.0]]
y = [-1.0,-1.0,-1.0,1.0,1.0,1.0,1.0]

#Problem 2
for i in range(0,7):
	print ztransform(*x[i])

#Problem 3
k = np.zeros((7,7))
for i in range(0,7):
	for j in range(0,7):
		k[i,j] = kernel(x[i],x[j])
P = matrix(np.outer(y,y) * k)
q = matrix(np.ones(7) * -1)
A = matrix(y, (1,7))
b = matrix(0.0)
G = matrix(np.diag(np.ones(7) * -1))
h = matrix(np.zeros(7))
print P,q,G,h,A,b
 
# Solve QP problem0
solution = solvers.qp(P, q, G, h, A, b)
 
# Lagrange multipliers
a = np.ravel(solution['x'])
print a
print sum(a)

#Problem 4
#SV = 1~5
s = 1
svsum = 0.0
for i in range(1,6):
	svsum = svsum + a[i]*y[i]*kernel(x[i], x[s])
b = y[s] - svsum
print b
w = [0,0,0,0,0,0,0]
for i in range(1,6):
	t = transform(*x[i])
	for j in range(1,7):
		w[j] = w[j] + a[i]*y[i]*t[j]
print w