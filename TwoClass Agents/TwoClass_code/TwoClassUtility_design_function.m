function[poa,fstar,optPoa] = TwoClassUtility_design_function(n,k,f1,f2,w,printing)

platform.matlabOptions = optimoptions('linprog','Algorithm', ...
                                       'dual-simplex', 'Display','off',...
                                       'ConstraintTolerance', 1e-8,...
                                       'OptimalityTolerance', 1e-8);
%% Verifying the inputs are correct
if k>n
    error('More agents in Partition 1 than total agents')
end

%% Verifying the validity of chosen basis function and mechanism
    if size(f1)>0
        if f1(1)<= 0  
            error('PoA is zero because f1(1) is less than zero')
        end
    end

    if size(f2)>0
        if f2(1)<= 0  
            error('PoA is zero because f2(1) is less than zero')
        end
    end
    
    for j=1:n
        if w(j) <=0
            error('Invalid basis function -- w(%d) <= 0 -- w(j) should be > 0 for all j',j)
        end
    end
    
    if size(f1,2) ~= k
            error('The dimension of chosen mechanism is wrong')
    end

    if size(f2,2) ~= n-k
            error('The dimension of chosen mechanism is wrong')
    end

    if size(w,2) ~= n
            error('The dimension of basis function is wrong')
    end
    %--------------------------------------------------------------------------
    
    
    %---------------------------------VS: Printing----------------------------%
    if printing ==1
        fprintf('\n--------------------------------------------------------\n')
        fprintf('Total agents = %d (%d in P1, %d in P2)',n, k, n-k)
        fprintf('\n--------------------------------------------------------')
        fprintf('\n The  basis function is \n')
        r1       = string(1:n);
        wNames   = append('w(',r1,')');
        basis_w  = array2table(w,'VariableNames',wNames);
        disp(basis_w)
    end
    %-------------------------------------------------------------------------%
    
    
    
    %% Dual Linear program to Compute Price of Anarchy
    [xval,poa]=  TwoClassComputingPoA(n,f1,f2,w, k, platform);

    if printing ==1
        fprintf('\n--------------------------------------------------------')
        fprintf('\n <strong>Chosen mechanism</strong> --  Rows for different partition, column for f(j) -- <strong> PoA(f) </strong>= %f\n',poa)
        f = zeros(2,n);
        f(:,:) = NaN;
        f(1,1:k) =f1;
        f(2,1:n-k) = f2;
        rowNames = {'P1', 'P2'};
        r1 = string(1:n);
        colNames =  r1;  
        Tf = array2table(f,'Rownames',rowNames,'VariableNames',colNames);
        
        disp(Tf)
        %---------------------------------VS: Printing----------------------------%
        fprintf('------------------------------------------------------------------------------------------------------------------------------------------')
    end
    %-------------------------------------------------------------------------%

   %% Linear program to *Optimize* price of anarchy     
        
    [fstar,optPoa] =  TwoClassOptimizingPoA(n,w,k,platform);

    if printing ==1
        fprintf('\n <strong>Optimal mechanism</strong> --  Rows for different partition, column for f(j) --<strong> Optimal PoA </strong>= %f\n',optPoa')
    
    
        rowNames = {'P1', 'P2'};
        r1 = string(1:n);
        colNames =  r1;  
        T = array2table(fstar,'Rownames',rowNames,'VariableNames',colNames);
    
        disp(T)
    
        %---------------------------------VS: Printing----------------------------%
        fprintf('------------------------------------------------------------------------------------------------------------------------------------------')
         %---------------------------------VS: Printing----------------------------%
    
    
        %% ---------------------------------VS: Printing----------------------------%
        fprintf('\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')
    end
    %-------------------------------------------------------------------------%
end
