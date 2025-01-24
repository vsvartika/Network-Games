from pulp import *
import numpy as np
import ArbitraryCode as ac


# Number of classes, players in various classes, Information Graph
k = 2;   #k should take vlaue in {2,3}
if k==2:
  c1 = 2
  c2 = 2
  C = np.array([c1,c2])
  N_mat = np.array([[1,  0],[1, 1]])
  n = np.sum(C)
  N = np.zeros((1,k))
elif k ==3:
  c1 = 5
  c2 = 5
  c3 = 5
  C = np.array([c1,c2,c3])
  N_mat = np.array([[1, 0, 0],[1, 1,0],[1, 1,1]])
  n = np.sum(C)
  N = np.zeros((1,k))
else:
  raise Exception('choose k from {2,3}')

if np.trace(N_mat) !=k:
  raise Exception('Invalid information graph -- any class must be able to observe the agents in the same class')

for j in range(k):
    N[0,j] = np.sum(N_mat[j]*C)

# The basis function and utility design function
d = 0
w = np.arange(n+1)
w = np.power(w,d)

F = np.ones((k,n))
F[:,:] = np.nan

#last entry -- 1 for marginal contribution, 2 for equal share, 3 for all f being 1
for j in range(k):
  n = int(N[0,j])
  F[j,0:n] = ac.Generate_f(n,w,2)


poa = ac.ArbitraryComputingPoA(C,N_mat,F,w)
print('PoA is', poa,'\nChosen mechanism is \n')
print(F)

opt_poa,fstar= ac.ArbitraryOptimizingPoA(C,N_mat,w)
print('Optimal PoA is',opt_poa,'\nOptimal mechanism is \n')
print(fstar)