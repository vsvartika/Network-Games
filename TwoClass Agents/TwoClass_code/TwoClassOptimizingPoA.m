function[fstar,poa] = TwoClassOptimizingPoA(n,w, kappa, platform)

    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;
 
    w_lp = [0,w];


    IR = TwoClass_generateIR(n,kappa);
    numRowsIR = size(IR,1);
    
    %-------------LP Matrices details---------------------  
    %  
    %     total n + 5 variables 
    %        1              variable for f1(0)
    %        kappa          variables -- for f1(1),...,f1(kappa)
    %        1              variable  -- for f1(kappa+1)
    %        1              variable for f2(0)
    %        n-kappa        variables -- for f2(1),...,f2(n-kappa)
    %        1              variable  -- for f2(n-kappa+1)
    %        1              variable  -- for mu
    %
    %     8 extra constraint                                
    %        4 to accomodate that f1(0) = f1(kappa+1)   = 0 
    %        4 to accomodate that f2(0) = f2(n-kappa+1) = 0 
    %        |I_R| constraints for the LP
    %
    %----------------------------------------------------- 

    % variables----------- [f1(0),....f1(k),f1(k+1),f2(0),....f2(n-k),f2(n-k+1),mu] --------------- 
    c = [0*(1:n+4),1];
    A = zeros(numRowsIR + 8,n+5);
    B = zeros(1,numRowsIR + 8);

     

    %---- ensure f1(0)=f1(k+1)=0 ---  %first variable and (k+2)-th variable 
    A(1,1)        =  1;
    A(2,1)        = -1;   
    A(3,kappa+2)  =  1;
    A(4,kappa+2)  = -1; 

    %---- ensure f2(0)=f2(k+1)=0 ---  %(k+3)-th variable and (n+4)-th variable 
    A(5,kappa+3)  =  1;
    A(6,kappa+3)  = -1;   
    A(7,n+4)      =  1;
    A(8,n+4)      = -1; 

    B(1:8) =0;
    


    for j = 1:numRowsIR

        a1   = IR(j,1);        
        x1   = IR(j,2);
        b1   = IR(j,3);        
        a2   = IR(j,4);
        x2   = IR(j,5);        
        b2   = IR(j,6);

        B(j+8)                   = -w_lp(b1 + x1 + b2 + x2 + 1);    
        A(j+8,a1+x1+1)           =  a1;                                  %coefficient of f1(a1+x1)
        A(j+8,a1+x1+2)           = -b1;                                  %coefficient of f1(a1+x1+1)  

        A(j+8,kappa+2+a2+x2+1)   =  a2;                                  %coefficient of f2(a2+x2)
        A(j+8,kappa+2+a2+x2+2)   = -b2;                                  %coefficient of f2(a2+x2+1)

        A(j+8,end)               = -w_lp(a1 + x1 + a2 + x2 + 1);         %coefficient of mu

    end
    
    options = platform.options;
    [xval, fval] = linprog(c,A,B, [], [], [], [], options);

    if size(xval) == 0
        error('Linear program is infeasible')
    end

    poa = 1/fval;

    fstar = zeros(2,n);
    fstar(:,:) = NaN;
    fstar(1,1:kappa)   = xval(2:kappa+1)';
    fstar(2,1:n-kappa) = xval(kappa+4:n+3)';


end