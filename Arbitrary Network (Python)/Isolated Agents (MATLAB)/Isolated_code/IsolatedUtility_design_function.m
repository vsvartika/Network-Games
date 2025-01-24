%% -----Function that calls the computing and optimizing poa functions-----
%
%--------------------------------Inputs------------------------------------
%   `n`             1x1             Number of agents
%   `k`             1x1             Number of isolated agents
%   `f`             1x(n-k)         A chosen mechanism for agents utility
%   `w`             1xn             Basis function
%   `printing`                      Solver options
%
%-------------------------------Outputs------------------------------------
%   `poa`           1x1             Price of anarchy of chosen mechanism
%   `fstar`         1x(n-k)         Optimal mechanism for agents utility
%   `optPoa`        1x1             Optimal price of anarchy
%
%--------------------------------------------------------------------------


function[poa,fstar,optPoa] = IsolatedUtility_design_function(n,k,f,w,printing)

    platform.matlabOptions = optimoptions('linprog','Algorithm', ...
                                           'dual-simplex', 'Display','off',...
                                           'ConstraintTolerance', 1e-8,...
                                           'OptimalityTolerance', 1e-8);

    %% Verifying the inputs are correct
    if k>n
        error('Isolated agents more than total agents')
    end
    
    % Verifying the validity of chosen basis function and mechanism
    if size(f)>0
        if f(1)<= 0  
            error('PoA is zero because f(1) is less than zero')
        end
    end
    
    for j=1:n
        if w(j) <=0
            error('Invalid basis function -- w(%d) <= 0 -- w(j) should be > 0 for all j',j)
        end
    end
    
    if size(f,2) ~= n-k
            error('The dimension of chosen mechanism is wrong')
    elseif size(w,2) ~= n
            error('The dimension of basis function is wrong')
    end
    %----------------------------------------------------------------------
    if printing ==1
        fprintf('\n--------------------------------------------------------\n')
        fprintf('Total agents = %d (%d normal, %d isolated)',n, n-k, k)
        fprintf('\n--------------------------------------------------------')
        fprintf('\n The  basis function is \n')
        r1       = string(1:n);
        wNames   = append('w(',r1,')');
        basis_w  = array2table(w,'VariableNames',wNames);
        disp(basis_w)
        
    end
    %----------------------------------------------------------------------

    %% Dual Linear program to Compute Price of Anarchy
    [xval,poa]=  IsolatedComputingPoA(n,f,w, k, platform);
    
    if printing ==1
        r2          = string(1:n-k);
        fNames      = append('f(',r2,')');
        fNames      = [fNames,'PoA(f)'];
        mechanism_f = array2table([f,poa],'VariableNames',fNames); 
        fprintf('\n The chosen mechanism and PoA is\n')
        disp(mechanism_f)
    end
    
    %% Primal Linear program to Compute Price of Anarchy -- for verification purpose -- default value = 0 
    pr_vf = 0;
    if pr_vf == 1
        [ppoa] = IsolatedPrimalLP_PoA(f,w,n,k,platform);
        fprintf('\n The price of anarchy for chosen mechanism is (primal) = %f',ppoa)
        fprintf('\n--------------------------------------------------------')
    end
    
    %% Linear program to *Optimize* price of anarchy
 
       
    [fval,optPoa] =  IsolatedOptimizingPoA(n,w,k,platform);
    fstar = fval(2:n-k+1)';

    if printing ==1
        if n-k>0
            fNames      = append('f*(',r2,')');
            fNames      = [fNames,'opt PoA'];
            mechanism_f = array2table([fstar,optPoa],'VariableNames',fNames); 
            fprintf('\n The <strong>Optimal mechanism and Optimal PoA</strong>  is\n')
            disp(mechanism_f)
        else
            fprintf('\n--------------------------------------------------------')
            fprintf('\n All Isolated -- nothing to optimize')
            fprintf('\n The *optimal* price of anarchy is = %f',optPoa)
        end
        
        fprintf('\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')

    end
end
