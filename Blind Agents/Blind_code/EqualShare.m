%Equal share 

function[f] = EqualShare(n,k,w)

    f= zeros(1,n-k);
    if n-k>0
        for j = 1:n-k         
            f(j) = w(j)/j;
        end
    end  
    
end