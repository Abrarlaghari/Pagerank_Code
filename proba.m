function proba

    p_1 = 0.5;
    p_2 = 0.5;
    
    m_1_p = 0.1;    s_1_p = 0.06;
    m_1_n = 0.5;    s_1_n = 0.06;
    
    m_2_p = 0.1;    s_2_p = 0.06;
    m_2_n = 0.5;    s_2_n = 0.06;
    
    D_1_p = gmdistribution( [m_1_p], [s_1_p^2] );
    D_1_n = gmdistribution( [m_1_n], [s_1_n^2] );

    D_2_p = gmdistribution( [m_2_p], [s_2_p^2] );
    D_2_n = gmdistribution( [m_2_n], [s_2_n^2] );

    dummy = zeros(1,1,2);
    
    dummy(1,1,1) = s_1_p^2;
    dummy(1,1,2) = s_2_p^2;
    D_p = gmdistribution( [m_1_p; m_2_p], dummy, [p_1; p_2] );
    dummy(1,1,1) = s_1_n^2;
    dummy(1,1,2) = s_2_n^2;
    D_n = gmdistribution( [m_1_n; m_2_n], dummy, [1-p_1; 1-p_2] );
    
    dummy(1,1,1) = s_1_p^2;
    dummy(1,1,2) = s_1_n^2;
    D_1 = gmdistribution( [m_1_p; m_1_n], dummy, [p_1; p_2] );
    
    dummy(1,1,1) = s_2_p^2;
    dummy(1,1,2) = s_2_n^2;
    D_2 = gmdistribution( [m_2_p; m_2_n], dummy, [1-p_1; 1-p_2] );

    dummy(1,1,1) = s_1_p^2;
    dummy(1,1,2) = s_1_n^2;
    dummy(1,1,3) = s_2_p^2;
    dummy(1,1,4) = s_2_n^2;
    D = gmdistribution( [m_1_p; m_1_n; m_2_p; m_2_n], dummy, [p_1; p_2; 1-p_1; 1-p_2] );
    
%     plot( (-1:0.01:3)', pdf( D, (-1:0.01:3)' ) );
    
    pi1 = 0.1;
    pi2 = 0.1;
    
    
%     P1 = pdf( D_1_p, pi1 ) * pdf( D_2_n, pi2 ) * p_1  /  ( pdf( D_1, pi1 ) * pdf( D_2, pi2 ) )
%     P2 = pdf( D_2_p, pi2 ) * pdf( D_1_n, pi1 ) * p_2  /  ( pdf( D_1, pi1 ) * pdf( D_2, pi2 ) )

%     pdf( D_p, pi1 ) 
%     pdf( D_n, pi2 )
    
    P1 = pdf( D_p, pi1 ) * pdf( D_n, pi2 ) * 0.5  /  ( (pdf( D_p, pi1 )*0.5+pdf( D_n, pi1 )*0.5) * (pdf( D_p, pi2 )*0.5+pdf( D_n, pi2 )*0.5) )
    P2 = pdf( D_p, pi2 ) * pdf( D_n, pi1 ) * 0.5  /  ( pdf( D, pi1 ) * pdf( D, pi2 ) )

    
%     
%     N = 100;
%     piList = zeros(2,N);
%     for i = 1:N
%         if rand <= p_1
%             piList(1,i) = m_1_p + randn * s_1_p;
%             piList(2,i) = m_2_n + randn * s_2_n;
%         else
%             piList(1,i) = m_1_n + randn * s_1_n;
%             piList(2,i) = m_2_p + randn * s_2_p;
%         end
%     end
%     
end

