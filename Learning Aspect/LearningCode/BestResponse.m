function[ai] = BestResponse(i,a_minus_i,V_r,A,F,N,C,Ni)
    utils = zeros(1,Ni);
    for act = 1:Ni
        utils(act) = Utility(i,act,a_minus_i,V_r,A,F,N,C);
    end

    [~,idx] = max(utils);

    l_idx = length(idx);
    i_idx = randi(l_idx,1,1);
    ai = idx(i_idx);  
    fprintf('\nThe utilties for player %d --',i)
    disp(utils)
end