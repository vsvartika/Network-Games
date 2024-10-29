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
%        tol                   1x1             The tolerance for convergence criteria
%--------------------OUTPUTS-----------------------------------------------
%        a_ne                  1xn             Pure strategy NE
%        W                     1x1             System objective value at a_ne
%        W_arr                                 Transient W

%% Input -- classes and information graph

addpath('LearningCode')
rng("default")


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
    c1 = 4;
    c2 = 4;
    c3 = 4;
    C = [c1,  c2, c3];
    N = [1    1   0;
         1    1   1;
         1    1   1];
    n = sum(C);                      %no of players
    %no of agents observed by agents in various classes
    N1 = sum(N(1,:).*C);
    N2 = sum(N(2,:).*C);
    N3 = sum(N(3,:).*C);
else
     error('Can not accomodate this network -- only two and three classes can be accomodated')
end

%%  Input -- basis function and utility design mechanism

d = 0.5;
w = (1:n).^d;

F = ones(k,n);
F(:,:) = NaN;

% last entry  --  1 for marginal contribution, 2 for equal share, 3 for all f being 1
idc =1;
F(1,1:N1) = Generate_f(N1,w,idc);
F(2,1:N2) = Generate_f(N2,w,idc);
if k ==3
    F(3,1:N3) = Generate_f(N3,w,idc);
end
%% A random game instance
[A,V_r,N_a] = GenerateGame(n);

%% Best Response Dynamics

a = zeros(1,n);
for i = 1:n
    a(i) = randi(N_a(i),1,1);
end
fprintf('\n Initial action profile')
disp(a)
tol =0.01;
tot_iter = 10;
W_arr = zeros(1,tot_iter*n);
idx =1;
for iter =1:tot_iter
    a_old = a;
    for i=1:n
        a_minus_i =  [a(1:i-1),a(i+1:end)];
        a(i) = BestResponse(i,a_minus_i,V_r,A,F,N,C,N_a(i));
        fprintf('\n iter = %d, player = %d, best response = %d',iter,i,a(i))
        fprintf('\n action profile')
        disp(a)
        W_arr(idx) =  W_value(w,a,V_r,A);
        idx = idx+1;
    end

    if abs(max(max(a_old-a)))<=tol %converegence criteria
        fprintf('\n Best response dynamics converged (%d iterations taken) -- The NE is:',iter)
        disp(a)
        break
    end
end

W_arr_fin = W_arr(1:idx-1);
W = W_value(w,a,V_r,A);

fprintf('\n The system objective equals =%f',W)
figure(1)
plot(1:idx-1,W_arr_fin,'r--o','LineWidth',1)
