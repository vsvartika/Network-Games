%Generates the IR set in the paper -- but for isolated agents
%
%----------------Inputs----------------------------------------------------
%     `n`               1x1                  Number of total agents
%     `kappa`           1x1                  Number of isolated agents
%
%---------------Output-----------------------------------------------------
%     `matrix` of feasible points to generate LP constraints
%
%--------------------------------------------------------------------------

function matrix = VS_Isolated_generateIR(n,kappa)

    nm_ag = n-kappa;

    idx=1;

    for i = 0:kappa
        for j = 0:kappa
            for k = 0:kappa

                if i+j+k <= kappa

                    for a=0:n-kappa
                        for x = 0:n-kappa
                            for b = 0:n-kappa

                                if a+x+b+i+j+k >=1 & a+x+b+i+j+k<=n
                                    if a+x+b <= n-kappa
                                        if a+x+b== n-kappa || a*x*b ==0
                                            matrix(idx,:)=[a, i, x, j, b, k];
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

