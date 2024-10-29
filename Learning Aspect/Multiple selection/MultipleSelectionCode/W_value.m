%Program to calculate the system objective at a given strategy profile

function[W] = W_value(w,a,V_r,A)
    N_r = length(V_r);
    n = length(a);
    actual_a = zeros(1,n);


    for i=1:n
        actual_a(i)=A(i,a(i));
    end
    
    A_r = zeros(1,N_r);

    for r=1:N_r
        A_r(r) = sum(actual_a == r);
    end
    W = 0;
    for r = 1:N_r
        if A_r(r)>0
            W = W + V_r(r)*w(A_r(r));
        end
    end

end

