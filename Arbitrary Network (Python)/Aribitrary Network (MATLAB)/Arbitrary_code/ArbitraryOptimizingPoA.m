%Utility Design Optimizing the price of Anarchy and resulting in Optimal Mechanism

%--------------------------------------------------------------------------
% Total Classes = k
% Nj -- no of observable agents by agents of class j
%
%  INPUTS:
%       Variable    Size        Description
%        C          1xk         Vector of no of agents in various classes
%       `N`         kxk         Adjecency matrix for the classes   
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------

%-------------LP Matrices details------------------------------------------  
% Default -- min c^Tx subject to Ax<=B
%  
%     total sum_Nj + 2*k + 1 variables 
%        1            variable for mu
%        Nj+2         Nj variables for fj(1),...,fj(Nj) and 2 variables for fj(0) and fj(Nj+1) for j=1,...,k
%
%     variables format --- [{fj(0),fj(1),....fj(Nj),fj(Nj+1)},mu]
%
%     total |I_R| + 4*k constraint                                
%        4*k   constraints     4 to accomodate that fj(0) = fj(Nj+1) = 0 for j=1,...,k
%        |I_R| constraints     for the LP
%
%--------------------------------------------------------------------------

function[fstar,poa] = ArbitraryOptimizingPoA(C,N,w, platform)

    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;
 
    w_lp = [0,w];                      %including w(0)

    IR = Arbitrary_IR(C);
    numRowsIR = size(IR,1);

    k = length(C);                     %no. of classes    
    Lj = zeros(1,k);                   %vector representing [N1+2,...Nk+2] 
    for j =1:k     
        Lj(j) = sum(N(j,:).*C)+2;      %length of fj including fj(0) and fj(Nj +1)
    end
    sum_Lj = sum(Lj);                  %equals N1+...+Nk + 2*k  

    %objective function  
    c = [0*(1:sum_Lj),1];

    %constraints
    A = zeros(numRowsIR + 4*k,sum_Lj+1);
    B = zeros(1,numRowsIR + 4*k);
    
    %----first 4*k constraints---------------------------------------------
    for j =1:k
        r_idx  = 4*j-3;                         
        c_idx1 = ge(j,2)*sum(Lj(1:j-1)) + 1;     %column corresponding to fj(0)
        c_idx2 = sum(Lj(1:j));                   %column corresponding to fj(Nj+1)

        A(r_idx  ,c_idx1) =  1;
        A(r_idx+1,c_idx1) = -1;
        A(r_idx+2,c_idx2) =  1;
        A(r_idx+3,c_idx2) = -1;

    end

    B(1:k*4) =0;
    
    %----LP constraints----------------------------------------------------
    for t = 1:numRowsIR
    
        a = zeros(1,k);
        x = zeros(1,k);
        b = zeros(1,k);
        
        for j = 1:k
            idx = 3*j-2;
            a(j) = IR(t,idx);
            x(j) = IR(t,idx+1);
            b(j) = IR(t,idx+2);            
        end


        At = sum(a+x)+1;   %because first component of w corresponds to case when a+x = 0
        Bt = sum(b+x)+1;   %because first component of w corresponds to case when b+x = 0
        
        Atj = zeros(1,k);
        for j=1:k
            Atj(j) =  sum (N(j,:).*(a+x)); 
        end

        for j =1:k
            c_idx = ge(j,2)*sum(Lj(1:j-1)) + Atj(j);
            A(t+k*4,c_idx+1) =   a(j);                        %coefficient of f1(Atj)
            A(t+k*4,c_idx+2) =  -b(j);                        %coefficient of f1(Atj+1)
        end
        A(t+k*4,end) = - w_lp(At);                            %coefficient of mu
        B(t+k*4)     = - w_lp(Bt);                            %right hand side
       
    end
    

    %solving the LP
    options = platform.options;
    [xval, fval] = linprog(c,A,B, [], [], [], [], options);

    %the PoA
    poa = 1/fval;
    
    %the optimal mechanism
    fstar = zeros(k,sum(C));
    fstar(:,:) = NaN;
    for j =1:k
        init_idx = ge(j,2)*sum(Lj(1:j-1)) + 2;             %index of fj(1)
        fin_idx  = sum(Lj(1:j)) - 1;                       %index of fj(Nj)
        fstar(j,1:Lj(j)-2) = xval(init_idx:fin_idx)';
    end
end