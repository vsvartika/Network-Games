%--------------------------------------------------------------------------
%       INPUTS:
%       Variable    Size        Description
%        C          1xk         Vector of no of agents in various classes
%       `N`         kxk         Adjecency matrix for the classes   
%       `F`         kxn         Chosen utility design -- F(:,1)>0
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------

function[fstar,optPoa,poa] = Arbitrary_design_function(C,N,F,w,printing)

pf.matlabOptions = optimoptions('linprog','Algorithm', ...
                                       'dual-simplex', 'Display','off',...
                                       'ConstraintTolerance', 1e-8,...
                                       'OptimalityTolerance', 1e-8);

n = sum(C);               %no. of players
k = length(C);            %no. of classes

%% Verifying the validity of chosen basis function and mechanism
    for i=1:n
        if w(i) <=0
            error('Invalid basis function -- w(%d) <= 0 -- w(j) should be > 0 for all j',i)
        end
    end

    if size(w,2) ~= n
        error('The dimension of basis function is wrong')
    end

    if min([F(:,1)])<=0
        error('the chosen mechanism is unacceptable as first component is less than zero')
    end

%% Printing
    if k == 3
        rowNames = {'f1', 'f2', 'f3'};
        classNames = {'C1','C2','C3'};
    else 
        rowNames = {'f1', 'f2'};
        classNames = {'C1','C2'};
    end
    r1 = string(1:n);
    colNames =  r1; 

    if printing ==1
        fprintf('\n------------------------------------------------------------------------------------------------------------------------------------------\n')
        if k == 3
            fprintf('Total agents = %d (%d in C1, %d in C2, %d in C3)',n, C(1), C(2), C(3))
        else
            fprintf('Total agents = %d (%d in C1, %d in C2)',n, C(1), C(2))
        end

        fprintf('\nThe information graph for classes is\n')
        tableN = array2table(N,'Rownames',classNames,'VariableNames',classNames);
        disp(tableN)
        fprintf('\n------------------------------------------------------------------------------------------------------------------------------------------')
        fprintf('\nThe  basis function is \n')
        wNames   = append('w(',r1,')');
        basis_w  = array2table(w,'VariableNames',wNames);
        disp(basis_w)
    end

        
%% Dual Linear program to Compute Price of Anarchy
    poa =  ArbitraryComputingPoA(C,N,F,w, pf);

    if printing ==1
        fprintf('\n------------------------------------------------------------------------------------------------------------------------------------------')
        fprintf('\n<strong>Chosen mechanism</strong> --  Rows for various classes, column for f(j) -- <strong> PoA(f) </strong>= %f\n',poa)
        Tf = array2table(F,'Rownames',rowNames,'VariableNames',colNames);     
        disp(Tf)
   end
   

%% Linear program to *Optimize* price of anarchy     

    [fstar,optPoa] =  ArbitraryOptimizingPoA(C,N,w, pf);

    if printing ==1
        fprintf('\n------------------------------------------------------------------------------------------------------------------------------------------')
        fprintf('\n<strong>Optimal mechanism</strong> --  Rows for various classes, column for f(j) --<strong> Optimal PoA </strong>= %f\n',optPoa')
        T = array2table(fstar,'Rownames',rowNames,'VariableNames',colNames);
        disp(T)
        fprintf('------------------------------------------------------------------------------------------------------------------------------------------')
        fprintf('\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')
    end
end
