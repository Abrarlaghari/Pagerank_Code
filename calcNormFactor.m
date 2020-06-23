
function f = calcNormFactor(M)
    N = size(M,1);

%     f = 1;
%     return

%     N = size(M,1);
%     U = sum( M, 1 );
%     lambda = 0.98;
%     f = det( eye(N) - (lambda)* (M * diag(1./U)) );
%     return

%     f = sum( M(:) );
%     return
   
    
    pi = PageRank( M );
    
    M2 = M;
    
    f = 0;
    C = 0;
    for  i = 1:N
        for j = 1:N
            if i==j; continue; end
                
            if M(i,j) ~= 0; continue; end
            
            M2(i,j) = M2(i,j) + 1;
            M2(j,i) = M2(j,i) + 1;
            pi2 = PageRank(M2);
            M2(i,j) = M2(i,j) - 1;
            M2(j,i) = M2(j,i) - 1;
            
            f = f + computeDelta( pi, pi2 );
            C = C+1;
        end
    end
    f = f / C * N*N;
end