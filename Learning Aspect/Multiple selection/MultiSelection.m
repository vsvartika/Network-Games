%This program calculates time average of the system objective as agents
%perform best response dynamics as per their utility design function

% Single selection

%------------------------INPUTS--------------------------------------------
%        Variables             Size            Description
%        k                     1x1             No of classes
%        cj                    1x1             No of agents in class j
%        N                     kxk             Adjecency matrix for the classes
%        n                     1x1             No. of players
%        F                     kxn             Chosen utility design -- F(:,1)>0
%        w                     1xn             Basis function -- all the components>0
%        M_r                   1x1             Maximum number of resources
%        N_r                   1x1             Random variable representing no. of resources in the current game instance 
%        V_r                   1xN_r           Array representing values of resources
%        A                     matrix          Various rows represent action sets of various players    
%        N_a                   1xn             Array representing no. of actions of players          
%--------------------Other Variables---------------------------------------
%        a                     1xn             Array of action profiles of players
%--------------------OUTPUTS-----------------------------------------------
%        a_ne                  1xn             Pure strategy NE
%        W                     1x1             System objective value at a_ne

%% Input -- classes and information graph
clear
rng(1, "Twister")
addpath('MultipleSelectionCode\')
addpath('SavedGamesMS\')
fprintf('\n@@@@@@@@@@@@@@@@@@@@@@@@@@\n')
k = 3;  %k \in {2,3}

if k == 2
    c1 = 2;
    c2 = 2;
    C = [c1,  c2];
    N = [1    0;
         1    1];
    n = sum(C);                      %no of players
    %no of agents observed by agents in various classes
    N1 = sum(N(1,:).*C);            
    N2 = sum(N(2,:).*C);
elseif k == 3
    c1 = 2;
    c2 = 2;
    c3 = 2;
    C = [c1,  c2, c3];
    N = [1    0   0;
         0    1   0;
         0    0   1];
    n = sum(C);                      %no of players
    %no of agents observed by agents in various classes
    N1 = sum(N(1,:).*C);
    N2 = sum(N(2,:).*C);
    N3 = sum(N(3,:).*C);
else
    error('Can not accomodate this network -- only two and three classes can be accomodated')
end

%%  Input -- basis function and utility design mechanism

d = 0;
w = (1:n).^d;

F = ones(k,n);
F(:,:) = NaN;

% last entry  --  1 for marginal contribution, 2 for equal share, 3 for all f being 1
idc =3;
F(1,1:N1) = Generate_f(N1,w,idc);
F(2,1:N2) = Generate_f(N2,w,idc);
if k ==3
    F(3,1:N3) = Generate_f(N3,w,idc);
end
%% A random game instance
M_r =5;
[A,V_r,N_a] = GenerateGameMS(n,M_r);
%Game1;
N_r = length(V_r);

%printing
GameDetails(N_r,V_r,k,n,C,N,w,F,A,idc)
%% Best Response Dynamics
fprintf('----------- <strong>Best Response Dynamics</strong> ----------------------------------------------------------------------------------------------------')

a = zeros(1,n);
for i = 1:n
    a(i) = randi(N_a(i),1,1);
end
fprintf('\nInitial action profile')
a_str = append('a(',string(a),')');
disp(a_str)
resources_selected(a,V_r,A)
W =W_val(a,V_r,A,C,w);
fprintf('\nThe system objective value is %f',W)
tol =0.01;
iter =1;
while 1
    a_old = a;
    fprintf('\n--------------------------------BR - Iteration = %d------------------------------------------------------------------------------------',iter)
    for i=1:n
        a(i) = BestResponse(iter, i,a,V_r,A,F,N,C,N_a(i));
        fprintf('\nAction profile')
        a_str = append(' a(',string(a),') ');
        fprintf('%s',a_str)
        resources_selected(a,V_r,A)
        W =W_val(a,V_r,A,C,w);
        fprintf('\nThe system objective value is %f',W)
        fprintf('\n-------------------------')
    end
    if max(max(abs(a_old-a)))<=tol %converegence criteria
        fprintf('\nBest response dynamics converged (%d iterations taken) -- The NE is:',iter)
        fprintf('%s',a_str)
        fprintf('\nResources selected at NE are')
        resources_selected(a,V_r,A)
        %fprintf('\nType GameDetails(N_r,V_r,k,n,C,N,w,F,A) to get the details of the game')
        break
    end
    iter = iter+1;
    
end

W= W_val(a,V_r,A,C,w);
fprintf('\nThe system objective is %f',W)

