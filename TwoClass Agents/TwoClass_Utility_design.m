%Utility Design for distributed Optimization


%       INPUTS:
%       Variable    Size        Description
%       `n`         1x1 int     Number of players
%       `k`         1x1 int     Number of isolated players
%       `f`         1x(n-k)     Utility design chosen f(1)>0 just to calculate PoA
%       `w'         1xn         Basis function -- all the components>0


%--------------------------------------------------------------------------

%Default value for verifying should be 0  -- verifying the previous optimal
clear all
close all;
%clear all;
addpath('TwoClass_code')

%% Input of number or players and isolated agents
n = 10;
k = 5;

%%  Input of design mechanism and basis function

d = 0.5;
w = (1:n).^d;


%w = ones(1,n);
f1 = MarginalContribution(k,w);
f2 = MarginalContribution(n-k,w);

f1 = rand(1,5);
f2 = f1;
%--------------------------------------------------------------------------
printing=1;

[poa,fstar,optPoa] = TwoClassUtility_design_function(n,k,f1,f2,w,printing);
