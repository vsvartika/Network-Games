%Utility Design for distributed Optimization


%       INPUTS:
%       Variable    Size        Description
%       `n`         1x1 int     Number of players
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------
clear all
addpath('Blind_code')

n=15;
kvals = 0:n;


%--------------------------Basis Function----------------------------------
d = 0.8;
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

%Utility design 1-- equal share, 2-- marginal contribution, 3-- fixed mechanism    
f_mech = 2;

if f_mech == 1
    f = EqualShare(n,0,w);
elseif f_mech == 2
    f = MarginalContribution(n,0,w);
else 
    f=1:n;
    [poa,fstar,opt_poa]   = BlindUtility_design_function(n,0,f,w,0); 
    f  = fstar;
end


for k= kvals              
    [poa,fstar,opt_poa]   = BlindUtility_design_function(n,k,f,w,0); 

    M_poa(idx)          = poa;
    M_opt_poa(idx)      = opt_poa;
    M_f_star(idx,1:n)   = fstar;
    Fix_f(idx,1:n)      = f;

    idx=idx+1;
end


%% Displaying and plotting

if f_mech ==1
    fprintf('\n Chosen mechanism -- Equla share -- Rows for no of Blind agents\n')
elseif f_mech ==2
    fprintf('\n Chosen mechanism -- Marginal Contribution -- Rows for no of Blind agents\n')
elseif f_mech ==3 
    fprintf('\n Chosen mechanism --  Repeating optimal for no Blind -- Rows for no of Blind agents\n')
else 
    fprintf('\n Chosen mechanism --  Some mechanism -- Rows for no of Blind agents\n')
end

rowNames = string(kvals);
r1 = string(1:n);
colNames = append('f(',r1,')');
T1 = array2table(Fix_f,'Rownames',rowNames,'VariableNames',colNames);
%disp(T1)


fprintf('\n <strong>Optimal mechanism</strong> -- type T1 to see fixed mechanism\n')

r2 = append('f*(',r1,')');
colNames = [r2,'Poa(f)','Opt PoA'];
M_f_star = [M_f_star M_poa' M_opt_poa' ];
T = array2table(M_f_star,'Rownames',rowNames,'VariableNames',colNames);
disp(T)

%Plotting------------------------------------------------------------------
figure(11)
plot(kvals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('Blind agents')
ylabel('PoA')
hold on
plot(kvals,M_opt_poa,'d--','LineWidth',1,'Color','r')



if f_mech ==1
    legend('Equal Share', 'Optimal PoA')
elseif f_mech ==2
    legend('Marginal Contribution', 'Optimal PoA')
else 
    legend('Fixed mechanism', 'Optimal PoA')
end

title('PoA vs Blind Agents')



figure(12)
subplot(2,1,1)
plot(1:n,w,'d--','LineWidth',1)
title('Basis function')
xlabel('No of agents')


subplot(2,1,2)
plot(kvals,M_poa,'o--','LineWidth',1,'Color','b')
xlabel('Blind agents')
ylabel('PoA')
hold on
plot(kvals,M_opt_poa,'d--','LineWidth',1,'Color','r')


if f_mech ==1
    legend('Equal Share', 'Optimal PoA')
elseif f_mech ==2
    legend('Marginal Contribution', 'Optimal PoA')
else 
    legend('Fixed mechanism', 'Optimal PoA')
end

title('PoA vs Blind Agents')
hold off

fprintf('\n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n')
