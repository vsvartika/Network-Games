function[U] = Utility(i,ai,a_minus_i,V_r,A,F,N,C)
    %ai is the index of action of player i
    %a_minus_i is 1x(n-1) array of indices of actions of others
    
    n = sum(C);
    a = zeros(1,n);
    a(1:i-1) = a_minus_i(1:i-1);
    a(i) = ai;
    a(i+1:n) = a_minus_i(i:end);

    k = length(C);

    ki = 1*le(i,C(1)) + 2*ge(i,C(1)+1);
    if k==3 && i>= C(1)+C(2)+1
        ki = 3;
    end
    
    f = F(ki,:);


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
   
    ni = length(idx);
    actual_a = zeros(1,ni);
    
    temp = 1;
    for j = idx
        actual_a(temp) = A(j,a(j));
        temp = temp + 1;
    end
    A_r = sum(actual_a == A(i,ai));  %number of players selecting resource selected by player of interest
    U = V_r(A(i,ai))*f(A_r);
end