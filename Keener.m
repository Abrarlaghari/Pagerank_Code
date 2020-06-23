function Keener( league, year)

addpath( '../BayesBT' );

dataDir = 'data';

load( [dataDir '/' league '/' year] );

leagueData.teamList = teamList;
leagueData.gameDays = gameDays;
leagueData.dateNums = dateNums;
leagueData.allResults = allResults;
% allResults = R;

    for i=1:380
    r1(i)= ceil(rand(1)*20);
    r2(i)= ceil(rand(1)*20);
    end
%     
    leagueData.allResults(:,3)= r1';
    leagueData.allResults(:,2)= r2';
    allResults = leagueData.allResults;
    
%%
 Data = allResults(:,2:5);
% D1=Data;
% Data = [1 16 4 13
% 2 38 5 17
% 2 28 6 23
% 3 34 1 21
% 3 23 4 10
% 4 31 1 6
% 5 33 6 25
% 5 38 4 23
% 6 27 2 6
% 6 20 5 12];

no_teams=20;

% [m,n]= size(D);
% Creating Score matric
% 
% S = [0 0 21 22 0 0
%     0 0 0 0 38 34
%     34 0 0 23 0 0
%     44 0 10 0 23 0
%     0 17 0 38 0 45
%     0 50 0 0 45 0];

S= zeros(no_teams,no_teams);

for i=1:no_teams 
    for j=1:no_teams
        C=[];
        K=[];
        
        C = Data((Data(:,1)==i),:); 
        K = C((C(:,2)==j),:);
        
        if ~(isempty(K))
            for m=1:size(K,1)
            S(i,j)= S(i,j)+ K(m,3);
            end
        end
        
        C=[];
        K=[];
        
        C = Data((Data(:,2)==i),:); 
        K = C((C(:,1)==j),:);
        
        if ~(isempty(K))
            for m=1:size(K,1)
            S(i,j)= S(i,j)+ K(m,4);
            end
        end
        
   end 
end
% Data;
% S;
% Creating K matrix
[m,n] = size(S);

K = zeros(m,n);

for i= 1:m
    for j=1:n
        
        if(S(i,j)==0)
            K(i,j)=0;
        else 
        x = (S(i,j) + 1)/ (S(i,j)+ S(j,i)+2);  
        K(i,j)= 0.5 + (0.5* sign(x-0.5)* sqrt(abs(2*x -1))); 
        end
    end
end

% [S, V, D] = svd(K);
[r, va] = eig(K);

[v12, loc]=max(max(va));

disp('Team rating is');
[b,c]=sort(abs(r(:,loc)),1,'descend');
% fprintf('%d: %d',b,c)
 disp(c);

