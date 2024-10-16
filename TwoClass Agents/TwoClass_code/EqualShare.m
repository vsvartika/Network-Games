%Equal share 

function[f] = EqualShare(n,w)

    f= zeros(1,n);
    if n>0
        for j = 1:n        
            f(j) = w(j)/j;
        end
    end  
    
end