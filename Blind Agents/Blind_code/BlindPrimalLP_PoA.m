%function for computing PoA using primal LP

function[poa] = BlindPrimalLP_PoA(f,w,n,k,platform)
    
    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;

    w_lp=[0,w];
    f_lp = [0,f,0];

    I = BlindgenerateI(n,k);
    
    numCols = size(I,1);
    
    %------------------Details of LP
    % 3 constraints + numCols for positivity
    c= zeros(1,numCols);
    
    for j = 1: numCols
        a    = I(j,1);
        t_a  = I(j,2);
        x    = I(j,3);
        t_x  = I(j,4);
        b    = I(j,5);
        t_b  = I(j,6);

        c(j)   =  -  w_lp(b+x+t_b+t_x+1);

        A(1,j) = - (t_a-t_b);
        A(2,j) =  - (a*f_lp(a+t_a+t_x+x+1) - b*f_lp(a+t_a+t_x+x+2));
        
        A(3,j) =  - w_lp(a+t_a+t_x+x+1);
        A(4,j) =    w_lp(a+t_a+t_x+x+1);
       

    end
    B(1:2)           = 0;
    B(3:4)           = 1;

    A(5:numCols+4,1:numCols) = -eye(numCols,numCols);
    B(5:numCols+4) = 0;
    
    options = platform.options;
    [xval,fval] = linprog(c,A,B, [], [], [], [], options);

    poa = - (1/fval);


end