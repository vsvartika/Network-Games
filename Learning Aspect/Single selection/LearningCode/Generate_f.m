%Generates f for any class
%
%   INPUTS
%   Nj        1x1     no. of players that can be observed
%   w         1xn     basis function
%   indc      1x1     1 for marginal contribution, 2 for equal share, 3 for all f being 1
%--------------------------------------------------------------------------

function[f] = Generate_f(Nj,w,indc)
    f= zeros(1,Nj);
    for j = 1:Nj
        if indc ==1
            val =0;
            if j>=2
                val = w(j-1);   
            end
            f(j) = w(j)-val;
        elseif indc ==2       
                f(j) = w(j)/j;           
        else
            f= ones(1,Nj);
        end
    end   

end
