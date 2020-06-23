% Author: Tim Chartier
% Title:  ColleyRanking.m

%%
function [r] = MasseyRanking(gameFilename, teamFilename, weighting, k)
%% EXAMPLE: INPUT:
%% r=MasseyRanking('2014games.txt','2014teams.txt', 0, 20);
%% 
%% weighting = 
%%      0 means no (or uniform)
%%      1 means linear time
%% k = scalar for number of top ranked teams to list 
%% OUTPUT: r = Masseyrating vector

% Load the team names into an array
fid = fopen(teamFilename);
counter = 0; 
teamname = fgetl(fid);
while (ischar(teamname))
    counter = counter + 1;
    [token, remain] = strtok(teamname); teamname = strtok(remain); 
    teamname=cellstr(teamname);
    teamNames(counter) = teamname;
    teamname = fgetl(fid);
end
fclose(fid);
numTeams = counter;

%% Load the games
games=load(gameFilename);
% columns of games are: 
%	column 1 = days since 1/1/0000
%	column 2 = date in YYYYMMDD format
%	column 3 = team1 index 
%	column 4 = team1 homefield (1 = home, -1 = away, 0 = neutral) 
%	column 5 = team1 score 
%	column 6 = team2 index 
%	column 7 = team2 homefield (1 = home, -1 = away, 0 = neutral) 
%	column 8 = team2 score 
numGames = size(games, 1);

%% Calculate the weights

% Pull off just the days
days=games(:,1);
%create weight vector w 
w=zeros(numGames, 1); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set weights for home, away and neutral wins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
weightHomeWin = 1; 
weightAwayWin = 1;
weightNeutralWin = 1; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxScore = 15; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if weighting==0
    % No Weighting
    w=ones(numGames, 1); 
elseif weighting==1
    % for linear weighted time
    for i=1:numGames
        w(i)=(days(i)-days(1))/(days(numGames)-days(1)); 
    end
elseif weighting==2   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % INSERT YOUR WEIGHTING HERE
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    fprintf('\nPerforming my personal weighting.\n'); 
    segmentWeighting = [.3 .8 1.2 1.5]; 
    w=ones(numGames, 1); 
    for i=1:numGames
        weightIndex = ceil((days(i)-days(1)+1)/(days(numGames)-days(1)+1)*length(segmentWeighting)); 
        w(i) = segmentWeighting(weightIndex);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % EDIT BELOW THIS LINE AT YOUR OWN RISK! :-) 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
else
   fprintf('No weighting indicated so default of uniform weighting will be assumed.\n'); 
   % No Weighting
    w=ones(numGames, 1); 
end

teamTeam = zeros(counter, counter);
b = zeros(numTeams,1); 
for i=1:numGames
%   daysAfter2000 = games(i, 1);
    team1ID = games(i, 3);
    team1Score = games(i, 5);
    team1Loc = games(i, 4);
    team2ID = games(i, 6);
    team2Score = games(i, 8);
    team2Loc = games(i, 7);
    
    pointDifferential = abs(team2Score - team1Score); 
    if (pointDifferential > maxScore)
        pointDifferential = maxScore; 
    end
    
    if team1Score > team2Score
        % Team 1 won
        if (team1Loc == 1)       % Home win
            teamTeam(team2ID, team1ID) = teamTeam(team2ID, team1ID) + weightHomeWin*w(i);
            b(team2ID) = b(team2ID) + weightHomeWin*w(i)*(-pointDifferential);
            b(team1ID) = b(team1ID) + weightHomeWin*w(i)*( pointDifferential);
        elseif (team1Loc == -1)  % Away win            
            teamTeam(team2ID, team1ID) = teamTeam(team2ID, team1ID) + weightAwayWin*w(i);
            b(team2ID) = b(team2ID) + weightAwayWin*w(i)*(-pointDifferential);
            b(team1ID) = b(team1ID) + weightAwayWin*w(i)*( pointDifferential);
        else                       % Neutral court win
            teamTeam(team2ID, team1ID) = teamTeam(team2ID, team1ID) + weightNeutralWin*w(i);
            b(team2ID) = b(team2ID) + weightNeutralWin*w(i)*(-pointDifferential);
            b(team1ID) = b(team1ID) + weightNeutralWin*w(i)*( pointDifferential);
        end
    else
        % Team 2 Won
        if (team2Loc == 1)       % Home win
            teamTeam(team1ID, team2ID) = teamTeam(team1ID, team2ID) + weightHomeWin*w(i);
            b(team2ID) = b(team2ID) + weightHomeWin*w(i)*(-pointDifferential);
            b(team1ID) = b(team1ID) + weightHomeWin*w(i)*( pointDifferential);
        elseif (team2Loc == -1)  % Away win            
            teamTeam(team1ID, team2ID) = teamTeam(team1ID, team2ID) + weightAwayWin*w(i);
            b(team2ID) = b(team2ID) + weightAwayWin*w(i)*(-pointDifferential);
            b(team1ID) = b(team1ID) + weightAwayWin*w(i)*( pointDifferential);
        else                       % Neutral court win
            teamTeam(team1ID, team2ID) = teamTeam(team1ID, team2ID) + weightNeutralWin*w(i);
            b(team2ID) = b(team2ID) + weightNeutralWin*w(i)*(-pointDifferential);
            b(team1ID) = b(team1ID) + weightNeutralWin*w(i)*( pointDifferential);
        end
    end
end

%% Calculate linear system
weightedLosses = teamTeam * ones(numTeams,1); 
weightedWins = (ones(1,numTeams) * teamTeam)';
weightedC = -teamTeam -teamTeam';
diagWeightedC = weightedWins + weightedLosses;
weightedC = weightedC + diag(diagWeightedC);

% Replace last row by ones and RHS by 0
weightedC(end,:) = ones(numTeams,1); b(end) = 0; 

r = weightedC\b; 
[sortedr,index]=sort(r,'descend');


fid2 = fopen("MasseyRanks.txt", "w");

%% Statistics to Output to Screen 
fprintf('\n\n************** MASSEY Rating Method **************\n\n');
fprintf('===========================\n');
fprintf('Results for Top %d Teams\n',k);
fprintf('===========================\n');
fprintf('Rank   Rating    Team   \n');
fprintf('===========================\n');
for i=1:k
    fprintf('%4d  %8.5f  %s\n',i,sortedr(i),cell2mat(teamNames(index(i))));
    fdisp(fid2, cell2mat(teamNames(index(i))));
end
fclose(fid2);

fprintf('\n');   % extra carriage return
