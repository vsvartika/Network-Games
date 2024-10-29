%provides actual selected resources by various playeres given an action profile index

function[] = resources_selected(a,V_r,A)
    n = length(a);
    N_r = length(V_r);
    act_a = zeros(1,n);
    res_sel = zeros(n,N_r);
    for i = 1:n
        act_a(i) = A(i,a(i));
        res_sel(i,:) = Resource(act_a(i),N_r);
    end
    fprintf('\nActual actions')
    disp(act_a)
    fprintf('Resource selection\n')
    disp(res_sel)
end