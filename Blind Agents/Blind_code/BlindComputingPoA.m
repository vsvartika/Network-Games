%Utility Design Computing the price of Anarchy Dual LP


%-------------------------------------------------------
function[xval,poa] = BlindComputingPoA(n,f,w, k, platform)

    platform.name = 'matlab-built-in'; 
    platform.options = platform.matlabOptions;

    f_lp = [0,f,0];    %additional zero at the end and beginning to define f(0) and f(n+1)
    w_lp = [0,w];      %additonal zero at the beginning defines w(0)

    IR = VS_Isolated_generateIR(n,k);
    numRowsIR = size(IR,1);

    B = zeros(numRowsIR +2,1)';
    A = zeros(numRowsIR +2,3);  %two extra rows for positivity constraint

    A(end-1:end,1) = -1;
    B(end-1:end)   = 0;
    c = [0,0,1];

    for j =1:numRowsIR
        a   = IR(j,1);
        t_a = IR(j,2);
        x   = IR(j,3);
        t_x = IR(j,4);
        b   = IR(j,5);
        t_b = IR(j,6);
        

        B(j)   = - w_lp(b + x + t_b + t_x + 1);      %because first component of w corresponds to case when b+x = 0
        A(j,1) =   t_a - t_b;
        A(j,2) =   a*f_lp(a+x+t_a+t_x+1) - b*f_lp(a+x+t_a+t_x+2);
        A(j,3) = - w_lp(a+x+t_a+t_x+1);
    end
    
    options = platform.options;
    [xval, fval] = linprog(c,A,B, [], [], [], [], options); 
    poa = 1/fval;

end