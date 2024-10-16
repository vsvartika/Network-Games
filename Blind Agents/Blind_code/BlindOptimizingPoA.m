%Linear program to Optimize the PoA given a basis function

%------------------------------Inputs--------------------------------------
%   `n`            1x1               Number of agents
%   `w`            1xn               Basis function
%   `kappa`        1x1               Number of isolated agents
%   `platform`                       Solver option
%
%
%------------------------------Outputs--------------------------------------
%   `poa`            1x1             Optimal price of anarchy
%   `xval`           1x(n-kappa+4)   [f(0),f(1),...,f(n-kappa),f(n-kappa+1),lambda,mu]      
%            
%
% -------The optimal mechanism is [f(1),f(2),...,f(n-kappa)]---------------            
%--------------------------------------------------------------------------

function[xval,poa] = BlindOptimizingPoA(n,w, kappa, platform)

    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;
     
    %-------------LP Matrices details--------------------------------------
    %  
    %     total (n + 4) variables 
    %        1              variable for f(0)
    %        n              variables -- for f(1),...,f(n)
    %        1              variable  -- for f(n+1)
    %        1              variable  -- for mu
    %        1              variable  -- for lambda
    %
    %     5 extra constraint                                 first 5 constraints
    %        4 to accomodate that f(0) = f(n+1) = 0 
    %        1 constraint to ensure lambda >= 0
    %        |I_R| constraints for the LP    
    %        
    %---------------------------------------------------------------------- 

    w_lp = [0,w];
    IR = VS_Isolated_generateIR(n,kappa);
    numRowsIR = size(IR,1);

    c = [0*(1:n+3),1];
    A = zeros(numRowsIR + 5,n + 4);
    B = zeros(1,numRowsIR + 5);
    
    %---- ensure f(0)=f(n+1)=0 ---  %first variable and third last variable -- [f(0),....f(n),f(n+1),lambda,mu]
    A(1,1)         =  1;
    A(2,1)         = -1;   
    A(3,end-2)     =  1;
    A(4,end-2)     = -1; 

   % ---- ensure lamdba >=0 ------------ second last variable--------------   
    A(5,end-1)     = -1; 
    B(1:5)         =  0;
    

   %-------------The constraints for Linear Program------------------------
    for j = 1:numRowsIR

        a             = IR(j,1);
        t_a           = IR(j,2);
        x             = IR(j,3);
        t_x           = IR(j,4);
        b             = IR(j,5);
        t_b           = IR(j,6);

        B(j+5)                      = -w_lp(b + x + t_b + t_x + 1);        %the right hand side  
        A(j+5,a + x + t_a + t_x+1)  =  a;                                  %coefficient of f(a+x)
        A(j+5,a + x + t_a + t_x+2)  = -b;                                  %coefficient of f(a+x+1)
        A(j+5,end-1)                =  t_a - t_b;                          %coefficient of lambda
        A(j+5,end)                  = -w_lp(a + x + t_a + t_x + 1);        %coefficient of mu

    end
    %----------------------------------------------------------------------
    
    options = platform.options;
    [xval, fval] = linprog(c,A,B, [], [], [], [], options);

    if size(xval) == 0
        error('Linear program to Optimize price of anarchy is infeasible')
    end

    poa = 1/fval;
end