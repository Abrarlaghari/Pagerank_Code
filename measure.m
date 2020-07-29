function [betError ourError btError money betCount] = measure( leagueData, S, startGameDay, lastGameDay, params, BT )
    teamList = leagueData.teamList;
    gameDays = leagueData.gameDays;
    allResults = leagueData.allResults;
    
    
    nTeams = length(teamList);
    
    betThreshold = params.betThreshold;
    
    if params.dupl
        %team2IxOffset = nTeams;
         team2IxOffset = 0;
    else
        team2IxOffset = 0;
    end
    
    money = 0;
    betCount = 0;
    
    betErrors = [];
    btErrors = [];
    ourErrors = [];
    
    deltaList = [];
    hits = [];

%     [D1 D2 negDists] = learnDeltaDistributions( leagueData, S, startGameDay-params.learnGameDays, startGameDay-1, params );
%     D1.lambda
%     D2.lambda
    
    for gameDay = startGameDay:lastGameDay

      
        pi = PageRank( S{gameDay-1}, teamList );
%         pi = PageRank( W{gameDay-1} + params.drawWeight * D{gameDay-1} );

        if params.print
           datee= gameDays{gameDay};
        end
        
        fid = fopen('data_peter.txt', 'at');
        %fprintf(fid, '%d %d %d\n', v);
        fprintf(fid, '%s\n', datee);
        fclose(fid); 
               
%         resChances = calcResultChances( leagueData, gameDay-1 );
    
%         normFactor = calcNormFactor( S{gameDay-1} );

        [D1 D2 negDists] = learnDeltaDistributions( leagueData, S, gameDay-params.learnGameDays, gameDay-1, params );

        for gameIx = 1:size(allResults,1)
            if allResults(gameIx,1) ~= gameDay
                continue;
            end

            team1Ix = allResults(gameIx, 2);        
%           team2Ix = allResults(gameIx, 3) + team2IxOffset;
            team2Ix = allResults(gameIx, 3);
            goals1 = allResults(gameIx, 4);       
            goals2 = allResults(gameIx, 5);
            result =  allResults(gameIx, 6);
            

%             if params.maxGoals > 1
%                 S2 = registerResult( S{gameDay-1}, team1Ix, team2Ix, params.maxGoals+2, params.maxGoals+2, 1, params );
%                 pi2 = PageRank( S2 );
%                 normFactor = computeDelta( pi, pi2 );
%             else
                normFactor = 1;
%             end

            
            odds1 = allResults(gameIx, 7);
            odds2 = allResults(gameIx, 8);       
            odds3 = allResults(gameIx, 9);
            betPerc1 = 1/odds1;        
            betPerc2 = 1/odds2;        
            betPerc3 = 1/odds3;
            sumPerc = betPerc1+betPerc2+betPerc3;
            betPerc1 = betPerc1 / sumPerc;        
            betPerc2 = betPerc2 / sumPerc;        
            betPerc3 = betPerc3 / sumPerc;

            if result == 1
                realPerc1 = 1; realPerc2 = 0; realPerc3 = 0;
            elseif result == 2
                realPerc1 = 0; realPerc2 = 1; realPerc3 = 0;
            else
                realPerc1 = 0; realPerc2 = 0; realPerc3 = 1;
            end


            for g2 = 0:params.maxGoals
                for g1 = 0:params.maxGoals
%                     if params.maxGoals<=1 &&  g1==1 && g2==1
%                         distance(g1+1, g2+1) = 0.1 / normFactor;
%                         continue
%                     end
                        
                    S2 = registerResult( S{gameDay-1}, team1Ix, team2Ix, g1, g2, 1, params );
                    
                    pi2 = PageRank( S2,teamList );
                    
                    delta = computeDelta(pi, pi2) / normFactor;
                    
                    deltaList = [deltaList; delta];
                    if goals1 == g1 && goals2 == g2;
                        hit = 1;
                    else
                        hit = 0;
                    end  
                    hits = [hits; hit];
                    
                    distances(g1+1, g2+1) = delta;
                end
            end
            

            distances = distances / sum(distances(:));
            
            
%             P1 = D1.lambda * exp(-D1.lambda*distance);
%             P2 = D2.lambda * exp(-D2.lambda*distance);
           P1 = gampdf( distances, D1.G(1), D1.G(2) );
           P2 = gampdf( distances, D2.G(1), D2.G(2) );

            O = 0;
            for i = 1:params.maxGoals+1
                for j = 1:params.maxGoals+1
                    O = O + P1(i,j) * prod(P2(:))/P2(i,j);
                end
            end
            
            for i = 1:params.maxGoals+1
                for j = 1:params.maxGoals+1
                    P(i,j) = P1(i,j) * (prod(P2(:))/P2(i,j)) / O;
                end
            end
            
%             distances
%            P
            
%             sum(P(:))
%             pause

            ourPerc1 = 0;
            ourPerc2 = 0;
            ourPerc3 = 0;
            for g1 = 0:params.maxGoals
                for g2 = 0:params.maxGoals
                    if g1 > g2
                        ourPerc1 = ourPerc1 + P(g1+1, g2+1);
                    elseif g1 < g2
                        ourPerc3 = ourPerc3 + P(g1+1, g2+1);
                    else
                        ourPerc2 = ourPerc2 + P(g1+1, g2+1);
                    end
                end
            end

            % Bradley-Terry
            pi1 = BT.pi{gameDay-1}(allResults(gameIx, 2));
            pi2 = BT.pi{gameDay-1}(allResults(gameIx, 3));
            theta = BT.theta{gameDay-1};
            alpha = BT.alpha{gameDay-1};
            btPerc1 = (alpha*pi1) / ((alpha*pi1) + theta*pi2);
            btPerc2 = (theta^2-1)*(alpha*pi1)*pi2 / (((alpha*pi1) + theta*pi2)*(theta*(alpha*pi1) + pi2));            
            btPerc3 = (pi2) / ((alpha*theta*pi1) + pi2);
            
            if btPerc3 < 0 || abs(btPerc1+btPerc2+btPerc3-1)>0.0001; 'PARA'; end
            
%            sumPerc = btPerc1+btPerc2+btPerc3;
%            btPerc1 = btPerc1 / sumPerc;        
%            btPerc2 = btPerc2 / sumPerc;        
%            btPerc3 = btPerc3 / sumPerc;
            
            betError = ( (betPerc1-realPerc1)^2 + (betPerc2-realPerc2)^2 + (betPerc3-realPerc3)^2 );
            btError = ( (btPerc1-realPerc1)^2 + (btPerc2-realPerc2)^2 + (btPerc3-realPerc3)^2 );
            ourError = ( (ourPerc1-realPerc1)^2 + (ourPerc2-realPerc2)^2 + (ourPerc3-realPerc3)^2 );

            betErrors = [betErrors; betError];
            btErrors = [btErrors; btError];
            ourErrors = [ourErrors; ourError];

            win1 = (odds1-1) * ourPerc1 + (-1) * (1-ourPerc1);
            win2 = (odds2-1) * ourPerc2 + (-1) * (1-ourPerc2);
            win3 = (odds3-1) * ourPerc3 + (-1) * (1-ourPerc3);
            
            
            
                        
            if params.print
                fprintf( 1, '%d %11s - %11s  %d-%d  %.2f %.2f %.2f   %.2f %.2f %.2f E:%.2f   %.2f %.2f %.2f E: %.2f   %.2f %.2f %.2f\n', gameDay, teamList{team1Ix}, teamList{team2Ix-team2IxOffset}, goals1, goals2, odds1, odds2, odds3, btPerc1, btPerc2, btPerc3, btError, ourPerc1, ourPerc2, ourPerc3, ourError, win1, win2, win3 );
            end
%              fflush(stdout);
             drawnow('limitrate');
           
            maxWin = max( [win1, win2, win3] );
            if ourPerc1>=params.minChance && betPerc1 >=params.minChance && win1 >= betThreshold && win1 == maxWin
                betCount = 1 + betCount;
                stake = 1;%win1;
                if result == 1
                    money = money + (odds1-1)* stake;
                else
                    money = money-stake;
                end
            elseif  ourPerc2>=params.minChance && betPerc2 >=params.minChance && win2 >= betThreshold && win2 == maxWin
                betCount = 1 + betCount;
                stake = 1;%win2;
                if result == 2
                    money = money + (odds2-1)* stake;
                else
                    money = money-stake;
                end
            elseif  ourPerc3>=params.minChance && betPerc3 >=params.minChance && win3 >= betThreshold && win3 == maxWin
                betCount = 1 + betCount;
                stake = 1;%win3;
                if result == 3
                    money = money + (odds3-1)* stake;
                else
                    money = money-stake;
                end
            end
            
            
    fid = fopen('data_peter.txt', 'at');
    %fprintf(fid, '%d %d %d\n', v);
%    fprintf(fid, '%d %11s - %11s  %d-%d  %.2f %.2f %.2f   %.2f %.2f %.2f E:%.2f   %.2f %.2f %.2f E: %.2f   %.2f %.2f %.2f\n', gameDay, teamList{team1Ix}, teamList{team2Ix-team2IxOffset}, goals1, goals2, odds1, odds2, odds3, btPerc1, btPerc2, btPerc3, btError, ourPerc1, ourPerc2, ourPerc3, ourError, win1, win2, win3 );
    
     fprintf(fid, '%d %11s - %11s  %d-%d \n', gameDay, teamList{team1Ix}, teamList{team2Ix-team2IxOffset},goals1, goals2 );
    fclose(fid);
            
%             pause
        end
        
      
    end
    
%     [deltaList, IX] = sort(deltaList);
%     hits = hits(IX);
%     figure; plot( deltaList, cumsum(hits) /sum(hits) ); hold on;
%     
%     lambda1 = 1 / mean( deltaList(hits==1) )
%     Y = 1 - exp(-lambda1* deltaList );
%     plot( deltaList, Y) ;
%     
% 
%     hits = 1-hits;
%     figure; plot( deltaList, cumsum(hits) /sum(hits) ); hold on;
%     
%     lambda2 = 1 / mean( deltaList(hits==1) )
%     Y = 1 - exp(-lambda2* deltaList );
%     plot( deltaList, Y) ;
%     
%     hits(:) = 1;
%     figure; plot( deltaList, cumsum(hits) /sum(hits) ); hold on;
%     lambda3 = 1 / (mean( deltaList ))
%     Y = 1 - exp(-lambda3* deltaList );
%     plot( deltaList, Y) ;
    

%     figure;
%     Y = (1 - exp(-lambda* (deltaList-offset) )) ./ (1 - exp(-lambda2* (deltaList-offset) ));
%     plot( deltaList, Y) ;
    
    
    betError = mean(betErrors);
    ourError = mean(ourErrors);
    btError = mean(btErrors);
    


end