%submodular basis function

%should be non decreasing and concave

function[w] = SubmodularW(n)
    
    j = 1:n;
    w = 5*log(j)+1;
end