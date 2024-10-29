function[W] = W_val(a,V_r,A,C,w)
    
    n = sum(C);
    N_r = length(V_r);
    actual_a = zeros(1,n);
    for j = 1:n
        actual_a(j) = A(j,a(j));
    end

    %players selecting various resources
    r_sel = zeros(n,N_r);
    for j=1:n
        r_sel(j,:) = Resource(actual_a(j),N_r);
    end
    W=0;
    for r=1:N_r        
        a_r =  sum(r_sel(:,r))  ;
        if a_r>0
            W = W + V_r(r)*w(a_r); 
        end
    end
end