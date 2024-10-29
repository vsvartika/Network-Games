%Utility Design for distributed Optimization
%--------------------------------------------------------------------------
%       INPUTS:
%       Variable    Size        Description
%        k          1x1         No of classes
%        cj         1x1         No of agents in class j
%       `N`         kxk         Adjecency matrix for the classes   
%       `F`         kxn         Chosen utility design -- F(:,1)>0
%       `w'         1xn         Basis function -- all the components>0
%--------------------------------------------------------------------------
clear 
addpath('Arbitrary_code')

%% Input -- classes and information graph

k = 3;  %k \in {2,3}

if k ==2
    c1 = 2;
    c2 = 2;

    C = [c1,  c2];

    N = [1    0;
         1    1];

    n = sum(C);                      %no of players

    %no of agents observed by agents in various classes
    N1 = sum(N(1,:).*C);            
    N2 = sum(N(2,:).*C);
elseif k==3
    c1 = 1;
    c2 = 1;
    c3 = 1;

    C = [c1,  c2, c3];

    N = [1    0   0;
         0    1   1;
         0    1   1];
    n = sum(C);                      %no of players

    %no of agents observed by agents in various classes
    N1 = sum(N(1,:).*C);
    N2 = sum(N(2,:).*C);
    N3 = sum(N(3,:).*C);
else
     error('can not accomodate this network -- only two and three classes can be accomodated')
end

%verifying the validity of information graph
if sum(diag(N)) ~= k
    error('invalid N -- all the agents must be able to observe their own class')
end

%%  Input -- basis function and utility design mechanism

d = 0.5;
w = (1:n).^d;

F = ones(k,n);
F(:,:) = NaN;

% last entry  --  1 for marginal contribution, 2 for equal share, 3 for all f being 1
F(1,1:N1) = Generate_f(N1,w,2);
F(2,1:N2) = Generate_f(N2,w,2);
if k ==3
    F(3,1:N3) = Generate_f(N3,w,2);
end

%% --------------------------------------------------------------------------
printing=1;
[fstar,optPoa,poa] = Arbitrary_design_function(C,N,F,w,printing);
