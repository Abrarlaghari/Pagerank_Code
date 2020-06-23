function proba_magassagok_2d

    p_v = 2/3;
    p_s = 1/3;
    
    m_v = [160 180];    s_v = [ 50, 0; 0 50];
    m_s = [180 160];    s_s = [ 50, 0; 0 50];
    
    D_v = gmdistribution( m_v, s_v );
    D_s = gmdistribution( m_s, s_s );
    

    D_1 = gmdistribution( [m_v; m_s], cat(3, s_v, s_s), [p_v, p_s] );
%     D_2 = gmdistribution( [m_v; m_s], cat(3, s_v, s_s), [1-p_v, 1-p_s] );

    pi1 = [150 140];
    pi2 = [140 150];

    pdf(D_v, pi1) * p_v  /  ( pdf(D_1, pi1) )
    pdf(D_s, pi1) * p_s  /  ( pdf(D_1, pi1) )
    
    
    
end

