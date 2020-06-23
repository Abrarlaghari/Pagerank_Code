function proba_magassagok

    p_v = 2/3;
    p_s = 1/3;
    
    m_v = 160;    s_v = sqrt(50);
    m_s = 180;    s_s = sqrt(50);
    
    D_v = gmdistribution( [m_v], [s_v^2] );
    D_s = gmdistribution( [m_s], [s_s^2] );

    dummy(1,1,1) = s_v^2;
    dummy(1,1,2) = s_s^2;
    D_1 = gmdistribution( [m_v; m_s], dummy, [p_v; p_s] );

    dummy(1,1,1) = s_v^2;
    dummy(1,1,2) = s_s^2;
    D_2 = gmdistribution( [m_v; m_s], dummy, [1-p_v; 1-p_s] );

    
    pi1 = 150;
    pi2 = 140;
    
    
    
    figure; plot( 0:1:240, pdf(D_1, (0:1:240)' ) );
    figure; plot( 0:1:240, pdf(D_2, (0:1:240)' ) );

%     pdf(D_v, pi1)*pdf(D_s, pi2) * p_v  /  ( pdf(D_1, pi1) * pdf(D_2, pi2) )    
%     pdf(D_v, pi2)*pdf(D_s, pi1) * p_v  /  ( pdf(D_1, pi1) * pdf(D_2, pi2) )

    pdf(D_v, pi1)*pdf(D_s, pi2) * p_v  /  ( p_v*(pdf(D_v, pi1)*pdf(D_s, pi2)) + p_s*(pdf(D_v, pi2)*pdf(D_s, pi1)) )
    pdf(D_s, pi1)*pdf(D_v, pi2) * p_s  /  ( p_s*(pdf(D_s, pi1)*pdf(D_v, pi2)) + p_v*(pdf(D_s, pi2)*pdf(D_v, pi1)) )
    
    
%     pdf(D_v, pi1) * p_v  /  ( pdf(D_1, pi1) )
%     pdf(D_s, pi1) * p_s  /  ( pdf(D_1, pi1) )
    
    
    
end

