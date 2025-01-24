%Marginal Contribution Utility

function[f] = MarginalContribution(n,k,w)

    f= zeros(1,n-k);
    if n-k>0
        for j = 1:n-k
            if j==1
                val =0;
            else
                val = w(j-1);
            end
            f(j) = w(j)-val;
        end
    end  
    
end