function r = calcResultChances( leagueData, lastGameDay )
    teamList = leagueData.teamList;
    gameDays = leagueData.gameDays;
    allResults = leagueData.allResults;
    dateNums = leagueData.dateNums;
    
    r = zeros(7,7);
    for i = 1:size(allResults, 1)
        if lastGameDay < allResults(i, 1)
            break;
        end
        
        goals1 = allResults(i, 4);       
        goals2 = allResults(i, 5);
            
        if goals1 > 5 ||goals2 > 5
            continue
        end
        
        r( 1+goals1, 1+goals2 ) = 1 + r( 1+goals1, 1+goals2 );
    end
    r = r + 0.001*sum(r(:));
    
    r = r / sum(r(:));
end