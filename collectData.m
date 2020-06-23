function collectData( league, year )
    dataDir = 'data';
    
    fp = fopen( [dataDir '/' league '/' year '.csv'], 'rt' );
    
    formatString = ['%s %s %s %f %f %s %f %f %s ' repmat('%f ', 1, 6) ];
    data = textscan( fp, formatString, 'Delimiter', ',', 'HeaderLines', 1);
   
    
    N = length( data{1} );
    
    teamList = collectTeams(data );
    
    
    allResults = double(zeros(N, 9));
    gameDays = cell(0);
    dateNums = [];
    
    lastDate = '';
    for i = 1:N
        
        date = data{1}{i};
        if ~strcmp( date, lastDate )
            gameDays{1+length(gameDays)} = date; 
            dateNums = [dateNums; datenum( date, 'dd/mm/yyyy' )];
        end
        lastDate = date;
        gameDay = length(gameDays);


        team1Ix = findTeam( teamList, data{2}{i} );
        team2Ix = findTeam( teamList, data{3}{i} );
        homeGoals = data{4}(i);
        awayGoals = data{5}(i);
        
        result = data{6}{i};
        
        switch result
            case 'H'
                result = 1; 
            case 'D'
                result = 2; 
            case 'A'
                result = 3; 
        end
        allResults(i,:) = [gameDay team1Ix team2Ix homeGoals awayGoals result data{10}(i) data{11}(i) data{12}(i)];
    end
   
%     allResults
%     gameDays
    
    save( '-mat7-binary', [dataDir '/' league '/' year '.mat'], 'teamList', 'gameDays', 'dateNums', 'allResults');
    
    fp = fclose( fp );
    
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
    column = data{2};
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