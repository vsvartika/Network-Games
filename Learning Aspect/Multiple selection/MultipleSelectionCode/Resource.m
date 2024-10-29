%given an actual action, this program returns a 1xN_r array that has value 1 if r is contained and zero else

function[y] = Resource(a,N_r)
    y = zeros(1,N_r);
    x = dec2bin(a-1);

    l_x = length(x);

    for j = l_x:-1:1
       if x(j) == '1'
           y(end-l_x+j) =1;
       end
    end

end