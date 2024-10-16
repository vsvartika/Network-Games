%Marginal Contribution Utility

function[f] = MarginalContribution(n,w)

    f= zeros(1,n);
    if n>0
        for j = 1:n
            if j==1
                val =0;
            else
                val = w(j-1);
            end
            f(j) = w(j)-val;
        end
    end  
    
end