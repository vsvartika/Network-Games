%Utility Design Computing the price of Anarchy Dual LP


%-------------------------------------------------------
function[xval,poa] = TwoClassComputingPoA(n,f1,f2,w, k, platform)

    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;

    f1_lp = [0, f1, 0]; %additional zero at the end and beginning to define f(0) and f(n+1)
    f2_lp = [0, f2, 0];
    w_lp = [0,w];  %additonal zero at the beginning defines w(0)

    IR = TwoClass_generateIR(n,k);
    numRowsIR = size(IR,1);

    B = zeros(numRowsIR +2,1)';
    A = zeros(numRowsIR +2,3);  %two extra rows for positivity constraint

    A(end-1,1)     = -1;  %for lambda1 and lambda 2 to be positive
    A(end-1,2)     = -1;
    B(end-1:end)   = 0;

    c = [0,0,1];

    for j =1:numRowsIR
        
        a1   = IR(j,1);        
        x1   = IR(j,2);
        b1   = IR(j,3);        
        a2   = IR(j,4);
        x2   = IR(j,5);        
        b2   = IR(j,6);
        

        B(j)   = - w_lp(b1+x1+b2+x2+1);      %because first component of w corresponds to case when b+x = 0

        A(j,1) =   a1*f1_lp(a1+x1+1) - b1*f1_lp(a1+x1+2);
        A(j,2) =   a2*f2_lp(a2+x2+1) - b2*f2_lp(a2+x2+2);
        A(j,3) = - w_lp(a1+x1+a2+x2+1);
    end
    
    options = platform.options;
    [xval, fval] = linprog(c,A,B, [], [], [], [], options); 
    poa = 1/fval;

end