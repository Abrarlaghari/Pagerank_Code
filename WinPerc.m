function pi = WinPerc( W, D )
    N = size(W,1);
    
    t = (W+W'+D) * ones(N,1);
    
    Tinv = diag(1./t);
    
    w = W * ones(N,1);
    d = D * ones(N,1);
    
    kappa = 1/3;
    
    pi = Tinv * ( w + kappa * d );
    
    pi = pi / sum(pi);
end