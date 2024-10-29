function[A,V_r,N_a] = GenerateGame(n)
%generates a random game instance with single selection
    M_r = 20;
    N_r = randi(M_r,1,1);
    V_r = rand(1,N_r);

    N_a = randi(N_r,1,n);
    m_N_a = max(N_a);

    A = zeros(n,m_N_a);
    A(:,:) =NaN;
    for i = 1:n
        % idx = randperm(N_r);
        % A(i,1:N_a(i)) = idx(1:N_a(i));
        A(i,1:N_a(i)) = randsample(N_r,N_a(i));
    end
end