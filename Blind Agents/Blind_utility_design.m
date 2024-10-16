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


addpath('Blind_code')
%% 

n = 7;
k = 1;
%% $x^2+e^{\pi i}$ 
% 
% 
% 
d = 0.5;
w = (1:n).^d;


f = MarginalContribution(n,0,w);

f= ones(1,n);

%--------------------------------------------------------------------------

[poa,fstar,optPoa] = BlindUtility_design_function(n,k,f,w,1);
