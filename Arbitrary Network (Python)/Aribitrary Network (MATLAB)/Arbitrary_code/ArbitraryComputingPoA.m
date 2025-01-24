%Utility Design Computing the price of Anarchy Dual LP

%--------------------------------------------------------------------------
%       INPUTS:
%       Variable    Size        Description
%        C          1xk         Vector of no of agents in various classes
%       `N`         kxk         Adjecency matrix for the classes   
%       `F`         kxn         Chosen utility design -- F(:,1)>0
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%  LP Matrices details
%  Default -- min c^Tx subject to Ax<=B
%
%     total 1+k variables 
%        1              variable for mu
%        k              variables  -- lambda_1,..lambda_k
%
%
%     total k + |IR| constraint                              
%        k     constraints       to ensure lambda_j >= 0 for each j = 1,...,k
%       |IR|   constraints       for the LP    
%--------------------------------------------------------------------------

function[poa] = ArbitraryComputingPoA(C,N,F,w, platform)

    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;

    %-------- Formatting f and w --------------------------------------------------------------------------------
    k = length(C);

    N1 = sum(N(1,:).*C);
    N2 = sum(N(2,:).*C);

    f1 = F(1,1:N1);
    f2 = F(2,1:N2);

    if k==3
        N3 = sum(N(3,:).*C);
        f3 = F(3,1:N3);
    end

    if k==2
        mm = max([length(f1),length(f2)]);
    elseif k==3
        mm = max([length(f1),length(f2),length(f3)]);       
    end

    f_lp = zeros(k,mm+2);
    
    %fj(0) and fj(Nj+1) set to zero
    f_lp(1,1:N1+2) = [0, f1, 0];       
    f_lp(2,1:N2+2) = [0, f2, 0];
    if k ==3
        f_lp(3,1:N3+2) = [0, f3, 0];
    end

    w_lp = [0,w];  %additonal zero at the beginning defines w(0)
 %% ----------------------------------------------------------------------------------------------------------------------------------
    %the objective function  
    c = [zeros(1,k),1];    


    %the constraints
    IR = Arbitrary_IR(C);
    numRowsIR = size(IR,1);

    B = zeros(numRowsIR + k,1)';
    A = zeros(numRowsIR + k,k+1);   %'k' extra rows for positivity constraint on lambda_j
    
    %k constraints for lambda_j to be positive   (Default Format Ax<=B)
    for j = 1:k
         A(end-k+j,1)     = -1;    
         B(end-k+j)       =  0;
    end
    
    %|IR| constraints of the LP
    for t =1:numRowsIR
        a = zeros(1,k);
        x = zeros(1,k);
        b = zeros(1,k);
        
        for j = 1:k
            idx  = 3*j-2;
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
            A(t,j) =   a(j)*f_lp(j, Atj(j)+1) - b(j)*f_lp(j, Atj(j)+2);    %coefficient of lambda_j
        end

        B(t)     = - w_lp(Bt);                                             %right hand side
        A(t,k+1) = - w_lp(At);                                             %coefficient of mu
    end
    
    %Solving the LP
    options = platform.options;
    [xval, fval] = linprog(c,A,B, [], [], [], [], options); 
    poa = 1/fval;

end