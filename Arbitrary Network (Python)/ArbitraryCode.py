import numpy as np
import pulp as lp

#-------------------------------------------------------------------------------------------------------------
def Generate_f(Nj,w,indc):
  #creates 1xNj dimensional utility generanting mechanism
  #indc =1 -- Marginal contribution(w), indc =2 -- Equal share(w), indc =3 for all 1
  f= np.zeros((Nj,1))
  for j in range (Nj):
      if indc == 1:
          val =0
          if j>=1:
              val = w[j-1]
          f[j] = w[j]-val;
      elif indc ==2:
              f[j] = w[j]/(j+1)
      else:
          f=np.ones((Nj,1))
  return np.transpose(f)

#-------------------------------------------------------------------------------------------------------------
def LinearProgram(A,b,c):
  #solves Linear program min c^T x subject to Ax<=b

  m = A.shape[0]     # no. of constraints
  n = A.shape[1]     # no. of variables

  if c.shape[0] != n or c.shape[1]!=1:
    raise Exception('c must be a column vector of length',n,'Current dimenstions are',c.shape,'should be', (n,1))

  if b.shape[0] != m or b.shape[1]!=1:
    raise Exception('b must be a column vector of length',m,'Current dimenstions are',b.shape,'should be', (m,1))

  set_m = range(0,m )
  set_n = range(0,n)
  x = lp.LpVariable.dicts("x", set_n, cat='Continuous')
  prob = lp.LpProblem("numpy_constraints", lp.LpMinimize)
  prob += lp.lpSum([c[i]*x[i] for i in set_n])

  for i in set_m:
    prob += lp.lpSum([A[i][j]*x[j] for j in set_n]) <= b[i]
  prob.solve()
  x_soln = np.array([x[i].varValue for i in set_n]) 
  z = prob.objective.value()
  return z,x_soln

#-------------------------------------------------------------------------------------------------------------
def GenerateIR(kappa):
    idx =1
    kk = kappa+1
    for a in range(kk):
        for x in range(kk-a):
            for b in range(kk-a-x):
                if a+x+b == kappa or a*x*b ==0:
                    n_row = np.array([a,x,b])
                    if idx ==1:
                        matrix = n_row
                        idx = idx+1
                    else:
                        matrix = np.vstack((matrix,n_row))
    return matrix

def concatenate(matrix1,matrix2):
    r1,c1 = matrix1.shape[0], matrix1.shape[1] 
    r2,c2 = matrix2.shape[0], matrix2.shape[1] 
    new_mat = np.zeros((r1*r2,c1+c2))
    rval =0
    for l1 in range(r1):
        for l2 in range(r2):
            new_mat[rval + l2,0:c1]       = matrix1[l1,:]
            new_mat[rval + l2,c1:c1+c2]   = matrix2[l2,:]
        rval = rval+r2
    return new_mat

def ArbtitraryIR(C):
    k = C.shape[0]  
    for j in range(k):
        mat0 = GenerateIR(C[0])
        mat1 = GenerateIR(C[1])
        tempIR = concatenate(mat0,mat1)
        if k==3:
            mat2 = GenerateIR(C[2])
            tempIR = concatenate(tempIR,mat2)
    IR = tempIR[1:,:]
    return IR

#-------------------------------------------------------------------------------------------------------------
def ArbitraryComputingPoA(C,N_mat,F,w):
  k = C.shape[0] 
  n = np.sum(C)
  N = np.zeros((1,k))
  for j in range(k):
    N[0,j] = np.sum(N_mat[j,:]*C)

  f0 = F[0,0:int(N[0,0])]
  f0 = np.append(0,f0)
  f0 = np.append(f0,0)
  f1 = F[1,0:int(N[0,1])]
  f1 = np.append(0,f1)
  f1 = np.append(f1,0)

  if k==3:
    f2 = F[2,0:int(N[0,2])]
    f2 = np.append(0,f2)
    f2 = np.append(f2,0)

  mm = int(np.max(N))
  f_lp = np.zeros((k,mm+2))

  f_lp[0,0:(int(N[0,0])+2)] = f0
  f_lp[1,0:(int(N[0,1])+2)] = f1
  if k==3:
   f_lp[2,0:(int(N[0,2])+2)] = f2

  w_lp = np.append(0,w)

  #the objective function
  c = np.zeros((1,k))
  c = np.append(c,[[1]], axis =1)

  #the constraints
  IR = ArbtitraryIR(C)
  numRowsIR = IR.shape[0]

  B= np.zeros((numRowsIR+k,1))
  A= np.zeros((numRowsIR+k,k+1))

  for j in range(k):   #to ensure lambda_j is >=0
    A[-1-k+j+1,0] = -1
    B[-1-k+j+1]   = 0
  
  for t in range(numRowsIR):
    a = np.zeros((1,k))
    x = np.zeros((1,k))
    b = np.zeros((1,k))

    for j in range(k):
      idx = 3*(j+1)-3
      a[0,j] = IR[t,idx]
      x[0,j] = IR[t,idx+1]
      b[0,j] = IR[t,idx+2]
    
    At = np.sum(np.add(a,x))
    At = int(At)
    Bt = np.sum(np.add(b,x))
    Bt = int(Bt)

    Atj = np.zeros((1,k))
    for j in range(k):
      Atj[0,j] = np.sum(N_mat[j,:]*np.add(a,x))

    for j in range(k):
      temp_idx = int(Atj[0,j])
      A[t,j] = a[0,j]*f_lp[j,temp_idx] - b[0,j]*f_lp[j,temp_idx+1]  

    B[t] = - w_lp[Bt]
    A[t,k] = -w_lp[At] 
  val = LinearProgram(A,B,np.transpose(c))

  poa_val = val[0]
  poa = 1/poa_val
  return poa


def ArbitraryOptimizingPoA(C,N_mat,w):
  
  w_lp = np.append(0,w)

  IR = ArbtitraryIR(C)
  numRowsIR = IR.shape[0]

  k = C.shape[0] 

  N = np.zeros((1,k))
  for j in range(k):
    N[0,j] = np.sum(N_mat[j,:]*C)
  
  Lj = np.zeros((1,k))
  for j in range(k):
    Lj[0,j] = N[0,j] + 2

  sum_Lj = int(np.sum(Lj))

  #the objective function
  c = np.zeros((1,sum_Lj))
  c = np.append(c,[[1]], axis =1)

  #the constraints
  B= np.zeros((numRowsIR+4*k,1))
  A= np.zeros((numRowsIR+4*k,sum_Lj+1))

  #first 4*k constraints
  for j in range(k):
    r_idx = int(4*j)
    c_idx1 =0
    if j>=1:
      c_idx1 = int(np.sum(Lj[0,0:j]))
    c_idx2 = int(np.sum(Lj[0,0:j+1])-1)

    A[r_idx,c_idx1]     =  1
    A[r_idx+1,c_idx1]   = -1
    A[r_idx+2,c_idx2]   =  1
    A[r_idx+3,c_idx2]   = -1

  B[0:4*k] = 0

  #LP constraints
  for t in range(numRowsIR):
    a = np.zeros((1,k))
    x = np.zeros((1,k))
    b = np.zeros((1,k))

    for j in range(k):
      idx = 3*(j+1)-3
      a[0,j] = IR[t,idx]
      x[0,j] = IR[t,idx+1]
      b[0,j] = IR[t,idx+2]
    
    At = np.sum(np.add(a,x))
    At = int(At)
    Bt = np.sum(np.add(b,x))
    Bt = int(Bt)

    Atj = np.zeros((1,k))
    for j in range(k):
      Atj[0,j] = np.sum(N_mat[j,:]*np.add(a,x))

    for j in range(k):
      c_idx = int(Atj[0,j])
      if j>=1:
        c_idx = int(np.sum(Lj[0,0:j]) + Atj[0,j])

      A[t+4*k,c_idx ] = a[0,j] 
      A[t+4*k,c_idx + 1] = -b[0,j]

    B[t+4*k] = - w_lp[Bt]
    A[t+4*k,-1] = -w_lp[At] 
  poa_val,f = LinearProgram(A,B,np.transpose(c))

  opt_poa = 1/poa_val
  xval = f.shape

  #the optimal mechanism
  fstar = np.zeros((k,int(np.sum(C))))
  fstar[:,:] = np.nan
  for j in range(k):
    init_idx = 1
    if j>=1:
      init_idx = int(np.sum(Lj[0,0:j])) + 1
    fin_idx = int(np.sum(Lj[0,0:j+1])-1) 
    # print(init_idx,fin_idx)
    fstar[j,0:int(N[0,j])] = f[init_idx:fin_idx]
       

  return opt_poa,fstar






  




  