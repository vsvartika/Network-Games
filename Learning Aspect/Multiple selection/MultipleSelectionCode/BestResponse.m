function[ai] = BestResponse(iter,i,a,V_r,A,F,N,C,Ni)
    a_minus_i =  [a(1:i-1),a(i+1:end)];
    utils = zeros(1,Ni);
    for act = 1:Ni
        utils(act) = Utility(i,act,a_minus_i,V_r,A,F,N,C);
    end

    mm = max(utils);
    idx = find(utils == mm);

    l_idx = length(idx);
    i_idx = randi(l_idx,1,1);
    if sum(a(i)==idx)>=1
        ai = a(i);
    else
        ai = idx(i_idx);  
    end

    if l_idx > 1
        a_str = append(' a(',string(idx),') ');
        fprintf('\nIteration =%d, Player %d -- Best repsonse not unique, best response = ',iter, i)
        fprintf('%s',a_str)
        fprintf(' Chosen action -- a(%d)',ai)
    else
        fprintf('\nIteration =%d,Player %d -- Best response = a(%d)',iter,i,ai)
    end
    fprintf('\nThe utilties for player %d --',i)
    disp(utils)
end