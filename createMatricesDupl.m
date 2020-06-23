function S = createMatricesDupl( leagueData, startGameDay, lastGameDay, params )
    dataDir = 'data';
    
    teamList = leagueData.teamList;
    gameDays = leagueData.gameDays;
    allResults = leagueData.allResults;
    dateNums = leagueData.dateNums;

    nTeams = length( teamList );
    
    S = {};

    for gd = startGameDay:lastGameDay
        S{gd} = 1*eye( nTeams, nTeams );  % nTeams*2
      for i = 1:nTeams
       %    S{gd}(i, i) = 2;%5;
           S{gd}(i, i) = 1;%3;
        end
        for i = 1:nTeams
%             for j = 1:nTeams
%                 if i==j; continue; end
%                 S{gd}(i, j+nTeams) = 10;
%                 S{gd}(i+nTeams, j) = 10;
%             end
        end
    end
    
    for i = 1:size(allResults, 1)
        if lastGameDay < allResults(i, 1)
            break;
        end
        
        gameDay = allResults(i, 1);
        
        teamIx1 = allResults(i, 2);
    %    teamIx2 = allResults(i, 3)+nTeams; % away team
        teamIx2 = allResults(i, 3);
        goals1 = allResults(i, 4);
        goals2 = allResults(i, 5);

        gdStart = max(gameDay,startGameDay);
        gdEnd = lastGameDay;
        
        for gd = gdStart:gdEnd
%             daysElapsed = dateNums( gd )-dateNums( gameDay );
            
            timeCoef = params.timeCoef^(gdEnd-gd);
            S{gd} = registerResult( S{gd}, teamIx1, teamIx2, goals1, goals2, timeCoef, params );
        end
    end
    
    % Connecting home and away entries of the same teams
%     for gd = startGameDay:lastGameDay
%         for i = 1:nTeams
%             H1 = sum(S{gd}( :, i )) + sum(S{gd}( i+nTeams, : ));
%             H2 = sum(S{gd}( :, i+nTeams )) + sum(S{gd}( i, : ));
%             S{gd}( i, i+nTeams ) = H2;
%             S{gd}( i+nTeams, i ) = H1;
%         end
%     end

%     S{gd}
%     pause
end

function ix = findTeam( teamList, teamName )
    for i = 1:length(teamList)
        if strcmp( teamList{i}, teamName )
            ix = i;
            return
        end
    end
    e = Exception('VerifyOutput:OutOfBounds', 'ismeretlen csapat');
    throw(e);
end

function teams = collectTeams( data )
    column = data{3};
    teams = cell(0);
    N = 0;
    for i = 1:length(column)
        newTeam = true;
        for j = 1:length(teams)
            if strcmp(teams{j}, column{i})
                newTeam = false;
                break;
            end
        end
        if newTeam
            N = N + 1;
            teams{N} = column{i};
        end
    end
end