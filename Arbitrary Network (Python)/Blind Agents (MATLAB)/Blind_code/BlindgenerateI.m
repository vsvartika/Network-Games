%generate I

function[matrix] = IsolatedgenerateI(n,kp)
    idx=1;
    for a=0:n - kp
        for x=0:n - kp
            for b=0:n - kp

                for i =0:kp
                    for j=0:kp
                        for k =0:kp

                            if a+x+b+i+j+k >=1 & a+x+b+i+j+k <=n & a+x+b<=n-kp & i+j+k<=kp

                                matrix(idx,:) = [a,i,x,j,b,k];
                                idx           = idx+1;

                            end

                        end
                    end
                end

            end
        end
    end
end