%Generates set IR that dicatates the constraints in Linear programs
% --------------------------------------------------------------------------
%       INPUTS:
%       Variable    Size        Description
%        C          1x1         Vector of no of agents in various classes
%
%--------------------------------------------------------------------------

function[IR]=Arbitrary_IR(C)

    k = length(C);
    n = sum(C);

    for j = 1:k
        mat1   = generateIR(C(1));
        mat2   = generateIR(C(2));
        tempIR = concatenate(mat1,mat2);

        if k == 3        
            mat3   = generateIR(C(3));
            tempIR = concatenate(tempIR,mat3);
        end
    end
    IR = tempIR(2:end,:);   %removed the entry with all zeros
    
    %% ensuring all the constraints are satisfied
    
    %each row should sum between 1 to n
    if min(sum(IR,2))<=0 || max(sum(IR,2))> n    
        error('IR generation is incorrect -- sum of all is zero or more than n')
    end

   numRows = size(IR,1);

   for t =1:numRows
       for j = 1:k
           idx = 3*j-2;
           %To ensure aj+bj+xj = kj or aj*bj*xj = 0
           if sum(IR(t,idx:idx+2),2) ~= C(j) && IR(t,idx)*IR(t,idx+1)*IR(t,idx+2)~=0     
               error('IR generation is incorrect -- sum is not k%d and product is not zero',j)
           end
       end
   end
     
   th_sz=1;    
   for j=1:k 
        th_sz = th_sz*(2*C(j)^2+2);
   end    
   th_sz = th_sz-1;
   fprintf('\nNumber of elements in IR = %d (th %d)',numRows,th_sz)

end


function [matrix] = generateIR(kappa)
    idx=1;
    rows = 2*kappa^2 +2;
    cols = 3;
    matrix = zeros(rows,cols);

    for a = 0:kappa
        for x = 0:kappa-a
            for b = 0:kappa-a-x
                if a+x+b == kappa || a*x*b ==0    
                    matrix(idx,:)=[a,x,b];
                    idx=idx+1;      
                end
            end
        end
    end

end

function[matrix] = concatenate(matrix1,matrix2)   %concatenates any two given matrices

    r1 = size(matrix1,1);
    r2 = size(matrix2,1);
    c1 = size(matrix1,2);
    c2 = size(matrix2,2);
    new_mat = zeros(r1*r2,c1+c2);
    rval =0;

    for l1 = 1:r1
        for l2 = 1:r2
            new_mat(rval + l2,1:c1)       = matrix1(l1,:);
            new_mat(rval + l2,c1+1:c1+c2) = matrix2(l2,:);
        end
        rval = rval+r2;
    end

    matrix = new_mat;

end