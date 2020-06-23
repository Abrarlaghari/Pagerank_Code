function [D1 D2 negDists] = learnDeltaDistributions( leagueData, S, startGameDay, lastGameDay, params )

    teamList = leagueData.teamList;
    gameDays = leagueData.gameDays;
    allResults = leagueData.allResults;
    
    
    nTeams = length(teamList);
    
    if params.dupl
        team2IxOffset = nTeams;
    else
        team2IxOffset = 0;
    end

    
    deltaList = [];
    hits = [];
    
    negDeltaTable = cell( params.maxGoals+1, params.maxGoals+1 );
    
    distanceList = [];
    hitList = [];
    
    for gameDay = startGameDay:lastGameDay

      
        pi = PageRank( S{gameDay-1} );
    
%         normFactor = calcNormFactor( S{gameDay-1} );

        for i = 1:size(allResults,1)
            if allResults(i,1) ~= gameDay
                continue;
            end

            team1Ix = allResults(i, 2);        
           % team2Ix = allResults(i, 3) + team2IxOffset;
            team2Ix = allResults(i, 3);
            goals1 = allResults(i, 4);       
            goals2 = allResults(i, 5);
            result =  allResults(i, 6);

            
%             if params.maxGoals > 1
%                 S2 = registerResult( S{gameDay-1}, team1Ix, team2Ix, params.maxGoals+2, params.maxGoals+2, 1, params );
%                 pi2 = PageRank( S2 );
%                 normFactor = computeDelta( pi, pi2 );
%             else
                normFactor = 1;
%             end
            
            for g2 = 0:params.maxGoals
                for g1 = 0:params.maxGoals
                    if params.maxGoals<=1 && g1==1 && g2==1
                        continue
                    end
                    
                    S2 = registerResult( S{gameDay-1}, team1Ix, team2Ix, g1, g2, 1, params );

                    pi2 = PageRank( S2 );
                    
                    delta = computeDelta( pi, pi2 ) / normFactor;
                    
                    distances(g1+1, g2+1) = delta;
                    
                    
                    if params.maxGoals <= 1
                        hit = (goals1>goals2 && g1>g2) || (goals1<goals2 && g1<g2) || (goals1==goals2 && g1==g2);
                    else
                        hit = goals1 == g1 && goals2 == g2;
                    end
                    
                    hits(g1+1, g2+1) = hit;
                    
                    if ~hit
                        negDeltaTable{ 1+g1, 1+g2 } = [negDeltaTable{ 1+g1, 1+g2 }; delta];
                    end
                end
            end
            
            distances = distances / sum(distances(:));
            
            distanceList = [distanceList; distances];
            hitList = [hitList; hits];

        end
    end
    
%     figure; plot( conv( deltaList(hits==1), ones(11,1)/11, 'valid' ) );
%     pause
    
    D1 = computeDistribution( distanceList(hitList==1), 0 );
    D2 = computeDistribution( distanceList(hitList~=1), 0 );
%         pause
    
    negDists = cell( params.maxGoals+1, params.maxGoals+1 );
    
%     for g2 = 0:params.maxGoals
%         for g1 = 0:params.maxGoals
% %             if g2 == 2 && g1 == 2
% %                 negDists{ 1+g1, 1+g2 } = computeDistribution( negDeltaTable{ 1+g1, 1+g2 }, true );
% %                 pause
% %             end
%             negDists{ 1+g1, 1+g2 } = computeDistribution( negDeltaTable{ 1+g1, 1+g2 }, false );
% %             negDeltaTable{ 1+g1, 1+g2 }
% % 
% %             plot(  -0:0.0001:0.2, gampdf( -0:0.0001:0.2, negDists{g1+1, g2+1}.G(1), negDists{g1+1, g2+1}.G(2) ) );
% %             pause
%         end
%     end
%     pause
    negDists = [];
end


function D = computeDistribution( deltaList, print )
        
    if ~exist('print', 'var')
        print = false;
    end
        
    deltaList = sort(deltaList);
    
    D.lambda = 1 / mean( deltaList );
	D.G = gamfit( deltaList );%, 0.001 );
    
    if print
%         figure; plot( deltaList, linspace(0,1,length(deltaList) ) ); hold on;
%         Y = 1 - exp(-D.lambda* deltaList );
%         plot( deltaList, Y) ;
        
%        Y = gamcdf( deltaList, D.G(1), D.G(2) );
%        figure; plot( deltaList, linspace(0,1,length(deltaList) ), 'r' ); hold on;
%        plot( deltaList, Y, 'b');
    end
end