
function[] = GameDetails(N_r,V_r,k,n,C,N,w,F,A,indc)
fprintf('----------- <strong>Game Details</strong> (Multiple Resource Selection)------------------------------------------------------------------------')
fprintf('\nNumber of Resources = %d and corresponding value\n',N_r)
disp(V_r)
    if k == 3
        rowNames = {'f1', 'f2', 'f3'};
        classNames = {'C1','C2','C3'};
    else 
        rowNames = {'f1', 'f2'};
        classNames = {'C1','C2'};
    end
    r1 = string(1:n);
    colNames =  r1; 
if k == 3
    fprintf('Total classes = %d (total %d agents, %d in C1, %d in C2, %d in C3)',k,n, C(1), C(2), C(3))
else
    fprintf('Total classes = %d (total %d agents, %d in C1, %d in C2)',k,n, C(1), C(2))
end
fprintf('\nThe information graph for classes is\n')
tableN = array2table(N,'Rownames',classNames,'VariableNames',classNames);
disp(tableN)
fprintf('\nThe  basis function is \n')
r1 = string(1:n);
wNames   = append('w(',r1,')');
basis_w  = array2table(w,'VariableNames',wNames);
disp(basis_w)

fprintf('\n<strong>Chosen mechanism</strong> --  Rows for various classes, column for f(j)')
if indc ==1
    fprintf('-- Marginal Contribution\n')
elseif indc==2
    fprintf('-- Equal share\n')
else 
    fprintf(' -- either all 1 or optimal mechanism\n')
Tf = array2table(F,'Rownames',rowNames,'VariableNames',colNames);     
disp(Tf)

% action resource correpsondance
c = zeros(2^N_r,N_r);
for a=1:2^N_r
    c(a,:) = Resource(a,N_r);
end
fprintf('\nActions corresponding to resource selection (1 implies resource contained in the action)\n')
r1 = string(1:2^N_r);
rowNames =  r1; 
c1 = string(1:N_r);
colNames = append('r(',c1,')');
act_res = array2table(c,'Rownames',rowNames,'VariableNames',colNames);
disp(act_res)
fprintf('\nAction sets of players\n')
disp(A)
end