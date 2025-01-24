%Utility Design for distributed Optimization


%       INPUTS:
%       Variable    Size        Description
%       `n`         1x1 int     Number of players
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------
clear all
addpath('Isolated_code')

n=15;
kvals = 0:n;


%--------------------------Basis Function----------------------------------
d = 0;
w = (1:n).^d; 

fprintf('\n The  basis function is w(j) = j^d with d = %f\n',d)
r1       = string(1:n);
wNames   = append('w(',r1,')');
basis_w  = array2table(w,'VariableNames',wNames);
disp(basis_w)

%--------------------------------------------------------------------------

idx=1;
M_f_star = zeros(size(kvals,2),n);
M_f_star(:,:) =NaN;
Fix_f = M_f_star;
for k= kvals   
           
    %Utility design 1-- equal share, 2-- marginal contribution, 3-- optimal for normal fixed mechanism    
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


%percentage error----------------------------------------------------------
perc_error = (M_opt_poa-M_poa)./M_poa;
perc_error = perc_error*100;


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

rowNames = string(kvals);
r1 = string(1:n);
colNames = append('f(',r1,')');
T1 = array2table(Fix_f,'Rownames',rowNames,'VariableNames',colNames);
%disp(T1)


fprintf('\n <strong>Optimal mechanism</strong> -- type T1 to see fixed polity\n')

r2 = append('f*(',r1,')');
colNames = [r2,'Poa(f)','Opt PoA', '% error'];
M_f_star = [M_f_star M_poa' M_opt_poa' perc_error'];
T = array2table(M_f_star,'Rownames',rowNames,'VariableNames',colNames);
disp(T)

%Plotting------------------------------------------------------------------
figure(31)
plot(kvals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('Isolated agents')
ylabel('PoA')
hold on
plot(kvals,M_opt_poa,'s--','LineWidth',1,'Color','r')


if f_mech ==1
    legend('Equal Share', 'Optimal PoA')
elseif f_mech ==2
    legend('Marginal Contribution', 'Optimal PoA')
else 
    legend('Fixed mechanism', 'IS -- Optimal PoA')
end

title('PoA vs Isolated Agents')
hold off


%---------------------------------------------------


hold off


figure(12)
subplot(3,1,1)
plot(1:n,w,'d--','LineWidth',1)
title('Basis function')
xlabel('No of agents')


subplot(3,1,2)
plot(kvals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('Isolated agents')
ylabel('PoA')
hold on
plot(kvals,M_opt_poa,'s--','LineWidth',1,'Color','r')


if f_mech ==1
    legend('Equal Share', 'Optimal PoA')
elseif f_mech ==2
    legend('Marginal Contribution', 'Optimal PoA')
else 
    legend('Fixed mechanism', 'IS -- Optimal PoA')
end

title('PoA vs Isolated Agents')
hold off


subplot(3,1,3)
plot(kvals,perc_error,'d--')
xlabel('Isolated agents')
ylabel('Percentage error')
title('Percentage error when repeating the fixed policy')
fprintf('\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')
