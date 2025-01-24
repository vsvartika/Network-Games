%Utility Design for distributed Optimization


%       INPUTS:
%       Variable    Size        Description
%       `n`         1x1 int     Number of players
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------
clear all
addpath('Isolated_code')

n=15;
kvals = 3;
k=kvals;
%--------------------------Basis Function----------------------------------
d_vals = 0:0.05:1;



%--------------------------------------------------------------------------

idx=1;
M_f_star = zeros(size(d_vals,2),n);
M_f_star(:,:) =NaN;
Fix_f = M_f_star;
for d= d_vals   

    w = (1:n).^d; 
           
    %Utility design 1-- equal share, 2-- marginal contribution, 3-- fixed mechanism    
    f_mech = 2;

    if f_mech == 1
        f = EqualShare(n,k,w);
    elseif f_mech == 2
        f = MarginalContribution(n,k,w);
    elseif f_mech == 3
        f_init = 1:n;
        if idx==1
            [poatemp,f_fix,opt_poatemp] = IsolatedUtility_design_function(n,0,f_init,w,0);
        end
        f  = f_fix(1:n-k);
    else 
        f  = 1:n-k;
    end
    
    [poa,fstar,opt_poa]   = IsolatedUtility_design_function(n,k,f,w,0); 

    M_poa(idx)          = poa;
    M_opt_poa(idx)      = opt_poa;
    M_f_star(idx,1:n-k) = fstar;
    Fix_f(idx,1:n-k)    = f;

    idx=idx+1;
end


%min f----------------------------------------------------------
min_f = min(M_f_star(:,1:n-k),[],2);

%% Displaying and plotting

if f_mech ==1
    fprintf('\n Chosen mechanism -- Equla share -- Rows for no of isolated agents\n')
elseif f_mech ==2
    fprintf('\n Chosen mechanism -- Marginal Contribution -- Rows for no of isolated agents\n')
elseif f_mech ==3 
    fprintf('\n Chosen mechanism --  Repeating optimal for no isolated -- Rows for no of isolated agents\n')
else 
    fprintf('\n Chosen mechanism --  Some mechanism -- Rows for no of isolated agents\n')
end

rowNames = string(d_vals);
r1 = string(1:n);
colNames = append('f(',r1,')');
T1 = array2table(Fix_f,'Rownames',rowNames,'VariableNames',colNames);
%disp(T1)


fprintf('\n <strong>Optimal mechanism</strong> -- type T1 to see fixed mechanism\n')

r2 = append('f*(',r1,')');
colNames = [r2,'Poa(f)','Opt PoA', 'Min f'];
M_f_star = [M_f_star M_poa' M_opt_poa' min_f];
T = array2table(M_f_star,'Rownames',rowNames,'VariableNames',colNames);
disp(T)

%Plotting------------------------------------------------------------------
figure(2)

plot(d_vals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('Submodularity Parameter')
ylabel('PoA')
hold on
plot(d_vals,M_opt_poa,'s--','LineWidth',1,'Color','r')


if f_mech ==1
    legend('ES', 'Isolated Agents -- Optimal PoA')
elseif f_mech ==2
    legend('MC PoA', 'Isolated Agents -- Optimal PoA')
else 
    legend('Fixed mechanism', 'Isolated Agents -- Optimal PoA')
end

title(['PoA with ', num2str(kvals), ' out of ', num2str(n), ' Isolated Agents'])
hold off



fprintf('\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')
