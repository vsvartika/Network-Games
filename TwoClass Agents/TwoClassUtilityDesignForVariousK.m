%Two classes of agents --
%
% INPUTS:
%       Variable     Size        Description
%        `n`         1x1 int     Number of players
%        `w'         1xn         Basis function -- all the components>0
%
%       Description:
%        `kvals`     1x(n+1)    Range for number of players in P1
%        `k`         1x1        Number of agents in partition 1
%        `n-k`       1x1        Number of agents in partition 2
%        `f1`        1xk        Utility design chosen f1(1)>0
%        `f2`        1x(n-k)    Utility design chosen f2(1)>0
%
%
%  OUTPUTS 
%       The price of anarchy for any given mechanisms and number of agents in the partitions
%       Optimal price of anarchy and optimal mechanism%
%
%--------------------------------------------------------------------------

clear all

addpath('TwoClass_code')
n = 15;
kvals = 0:n;

%--------------------------Basis Function----------------------------------
d = 0.5;
w = (1:n).^d;
fprintf('\n The  basis function is w(j) = j^d with d = %f\n',d)
r1       = string(1:n);
wNames   = append('w(',r1,')');
basis_w  = array2table(w,'VariableNames',wNames);
disp(basis_w)
%-----------------------------------------------------------

idx=1;

M_f1_star = zeros(size(kvals,2),n);
M_f1_star(:,:) = NaN;
M_f2_star = M_f1_star;
Fix_f1 = M_f1_star;
Fix_f2 = M_f2_star;



for k= kvals   
       
    %Utility design 1-- equal share, 2-- marginal contribution, 
    %3 -- fixed optimal mechanism  -- Repeating the optimal for the case when there is only one class   
    f_mech =2;

    if f_mech == 1
        f1 = EqualShare(k,w);
        f2 = EqualShare(n-k,w);
    elseif f_mech == 2
        f1 = MarginalContribution(k,w);
        f2 = MarginalContribution(n-k,w);
    elseif f_mech ==3 
        f1_init = 1:n;
        f2_init = [];
        if idx==1
            [poatemp,f_fix,opt_poatemp] = TwoClassUtility_design_function(n,n,f1_init,f2_init,w,0);
        end
        f1     = f_fix(1,1:k);
        f2     = f_fix(1,1:n-k);
    else
        f1 = 1:k;
        f2 = 1:n-k ;
    end
    
    [poa,fstar,optPoa]   = TwoClassUtility_design_function(n,k,f1,f2,w,0); 

    M_poa(idx)                  = poa;
    M_opt_poa(idx)              = optPoa;
    M_f1_star(idx,:)            = fstar(1,:);
    M_f2_star(idx,:)            = fstar(2,:);
    Fix_f1(idx,1:k)             = f1;
    Fix_f2(idx,1:n-k)           = f2;

    idx=idx+1;
end

%percentage error----------------------------------------------------------
perc_error = (M_opt_poa-M_poa)./M_poa;
perc_error = perc_error*100;
max_perc_error = max(abs(perc_error));

%% Displaying and plotting

fprintf('\n')
if f_mech ==1
    fprintf('<strong>Chosen Mechanism</strong> -- Equalshare')
elseif f_mech ==2
    fprintf('<strong>Chosen Mechanism</strong> -- Marginal Contribution')
elseif f_mech ==3
    fprintf('<strong>Chosen Mechanism</strong> -- repeating optimal mechanism from one class case')
else
    fprintf('<strong>Chosen Mechanism</strong> -- Some random -- type `Fix_f1`and `Fix_f2` to see')
end
fprintf('\n')

fprintf('\n<strong>Optimal mechanism</strong> --  Rows for no agents in the partition, column for f(j), Total Agents =%d\n',n)
r1 = append('P1--',string(kvals));
r2 = append('P2--',string(kvals(end):-1:kvals(1)));


colNames = string(1:n);
colNames = append('f(',colNames,')');
colNames = [colNames, 'PoA(f)', 'Optimal PoA', '% error'];
M_f1 = [M_f1_star M_poa' M_opt_poa' perc_error'];
T1 = array2table(M_f1,'Rownames',r1, 'VariableNames',colNames);
disp(T1)
M_f2 = [M_f2_star M_poa' M_opt_poa' perc_error'];
T2 = array2table(M_f2,'Rownames',r2, 'VariableNames',colNames);
disp(T2)

%Comparing the mechanisms
C_f1 = M_f1_star;
C_f2 = flip(M_f2_star);
max_diff =max(max(abs(C_f1-C_f2)));

tol = 10^(-8);
if max_diff >=tol
    fprintf('Optimal mechanisms for different partitions <strong>do not match</strong> when same no. of players are contained, maximum difference is %f', max_diff)
    fprintf('\nPossibly because the LP solution for Optimizing LP is not unique')
else 
    fprintf('Optimal mechanisms for different partitions <strong>match</strong> when same no. of players are contained')
end

fprintf('\nMaximum percentage error between chosen and optimal mechanism = %f, when d = %f',max_perc_error,d)
fprintf('\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')



%Plotting-----------------------------------------------------------------

figure(1)
plot(kvals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('No of agents in partition 1')
ylabel('PoA')
title('Price of Anarchy -- Two class of agents')
hold on
plot(kvals,M_opt_poa,'*--','LineWidth',1,'Color','r')
if f_mech ==1
    legend('ES PoA', 'TC -- Optimal PoA')
elseif f_mech ==2
    legend('MC', 'TC -- Optimal PoA')
else 
    legend('Fixed mechanism', 'TC -- Optimal PoA')
end
hold off


figure(22)
subplot(3,1,1)
plot(1:n,w,'d--','LineWidth',1)
title('Basis function')
xlabel('No of agents')

subplot(3,1,2)
plot(kvals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('No of agents in partition 1')
ylabel('PoA')
title('Price of Anarchy -- Two class of agents')
hold on
plot(kvals,M_opt_poa,'*--','LineWidth',1,'Color','r')
if f_mech ==1
    legend('ES PoA', 'TC -- Optimal PoA')
elseif f_mech ==2
    legend('MC', 'TC -- Optimal PoA')
else 
    legend('Fixed mechanism', 'TC -- Optimal PoA')
end
hold off

subplot(3,1,3)
plot(kvals,perc_error,'d--')
xlabel('No of agents in partition 1')
ylabel('Percentage error')
title('Percentage error when repeating the fixed policy')

