function[U] = Utility(i,ai,a_minus_i,V_r,A,F,N,C)
    %ai is the index of action of player i
    %a_minus_i is 1x(n-1) array of indices of actions of others

    n = sum(C);
    N_r = length(V_r);

    %the action profile
    a = zeros(1,n);
    a(1:i-1) = a_minus_i(1:i-1);
    a(i) = ai;
    a(i+1:n) = a_minus_i(i:end);
    
    %class of agent i -- required for correct utility generating mechanism
    k = length(C);
    ki = 1*le(i,C(1)) + 2*ge(i,C(1)+1);
    if k==3 && i>= C(1)+C(2)+1
        ki = 3;
    end    
    f = F(ki,:);
    
    %agents whose actions agent i can observe
    idx = zeros(1,sum(N(ki,:).*C));
    temp = 1;
    for j=1:k
        if N(ki,j) == 1            
            init_idx = sum(C(1:j-1))+1;  
            fin_idx = sum(C(1:j));            
            idx(temp:temp+C(j)-1) = init_idx:fin_idx;
            temp = temp+C(j);
        end
    end

    %actual actions that agnet i can observe
    ni = length(idx);
    actual_a = zeros(1,ni);
    
    temp = 1;
    for j = idx
        actual_a(temp) = A(j,a(j));
        temp = temp + 1;
    end

    %number of players selecting resources selected by player i
    r_sel = zeros(ni,N_r);
    for j=1:ni
        r_sel(j,:) = Resource(actual_a(j),N_r);
    end

    ri = Resource(A(i,ai),N_r);
    U=0;
    for r=1:N_r
        if ri(r)==1
            a_r =  sum(r_sel(:,r))  ;  
            U = U+V_r(r)*f(a_r);
        end        
    end
end