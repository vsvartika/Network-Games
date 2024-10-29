%Generate a game that allows for multiselections given the maximum number
%of resources and no. of players
function[A,V_r,N_a] = GenerateGameMS(n,M_r)
    N_r = M_r;
    V_r = rand(1,N_r);
    P_a = 2^N_r;
    N_a = randi(P_a,1,n);
    m_N_a = max(N_a);

    A = zeros(n,m_N_a);
    A(:,:) = NaN;
    for i = 1:n
        % idx = randperm(P_a);
        % A(i,1:N_a(i)) = idx(1:N_a(i));
        A(i,1:N_a(i)) = randsample(P_a,N_a(i))';
    end
end