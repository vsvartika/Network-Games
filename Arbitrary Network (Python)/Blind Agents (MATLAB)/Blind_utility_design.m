%Utility Design for distributed Optimization


%-------------------------INPUTS-------------------------------------------
%       Variable    Size        Description
%       `n`         1x1 int     Number of players
%       `k`         1x1 int     Number of blind players
%       `f`         1x(n-k)     Utility design chosen f(1)>0 just to calculate PoA
%       `w'         1xn         Basis function -- all the components>0
%
%
%--------------------------------------------------------------------------
%clear all
close all;


addpath('Blind_code')
%% 

n = 3;
k = 1;
%% $x^2+e^{\pi i}$ 
% 
% 
% 
d = 0.5;
w = (1:n).^d;


f = MarginalContribution(n,0,w);

f(1:(n-k)) =  [ 1     rand];
f(n-k+1:n) =f(n-k);



%--------------------------------------------------------------------------

[poa,fstar,optPoa] = BlindUtility_design_function(n,k,f,w,1);
