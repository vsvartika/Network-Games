%Utility Design for distributed Optimization


%-------------------------INPUTS-------------------------------------------
%       Variable    Size        Description
%       `n`         1x1 int     Number of players
%       `k`         1x1 int     Number of isolated players
%       `f`         1x(n-k)     Utility design chosen f(1)>0 just to calculate PoA
%       `w'         1xn         Basis function -- all the components>0
%
%
%--------------------------------------------------------------------------
%clear all
close all;


addpath('Isolated_code')

n = 3;
k = 1;
d = 0.5;
w = (1:n).^d;


f = EqualShare(n,k,w);

%f = MarginalContribution(n,k,w);




%------------The counter example to monotonicity for blind and isolate
%agents for any mechanism------------------
% n = 3; 
% k = 1;
% f = [1      0.15425];





%--------------------------------------------------------------------------

[poa,f_star,optPoa] = IsolatedUtility_design_function(n,k,f,w,1);
