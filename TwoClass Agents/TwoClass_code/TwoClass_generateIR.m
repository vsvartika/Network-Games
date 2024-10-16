%Variant to generate IR with Isolated

function matrix = TwoClass_generateIR(n,kappa)
    
    ag_1 = kappa;
    ag_2 = n-kappa;

    idx=1;

    for i = 0:kappa
        for j = 0:kappa
            for k = 0:kappa

                if i+j+k <= kappa 
                         if i+j+k == kappa || i*j*k ==0

                            for a=0:n-kappa
                                for x = 0:n-kappa
                                    for b = 0:n-kappa
        
                                        if a+x+b+i+j+k >=1 & a+x+b+i+j+k<=n
                                            if a+x+b <= n-kappa
                                                if a+x+b== n-kappa || a*x*b ==0
                                                    matrix(idx,:)=[i, j, k, a, x,b];
                                                    idx=idx+1;
                                                end
                                            end
                                        end
        
                                    end
                                end
                            end                  
                    
                         end
                 end

            end
        end
    end





end

