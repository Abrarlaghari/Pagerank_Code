function [BT_W, BT_L, BT_T]= doit( league, year)
%     pkg load statistics
%     pkg load optim

    addpath( '../BayesBT' );

    dataDir = 'data';

    load( [dataDir '/' league '/' year] );

    leagueData.teamList = teamList;
    leagueData.gameDays = gameDays;
    leagueData.dateNums = dateNums;
    leagueData.allResults = allResults;
%     leagueData.allResults = R;
% Changed teams    
    
%     for i=1:380
%     r1(i)= ceil(rand(1)*20);
%     r2(i)= ceil(rand(1)*20);
%     r3(i)= ceil(rand(1)*20);
%     r4(i)= ceil(rand(1)*20);
%     end
%     
%     leagueData.allResults(:,2)= r1';
%     leagueData.allResults(:,3)= r2';
%     leagueData.allResults(:,2)= r3';
%     leagueData.allResults(:,3)= r4';
%     
%     
    params.dupl = true;
    params.learnGameDays = 10;
    params.maxGoals = 5;         % Without considering goals if <= 1
    params.timeCoef = 0.98;

    numGameDays = length(gameDays);


    startGameDay = 20;
    lastGameDay = numGameDays;


    fprintf('Create matrices...' ); 
%     fflush( stdout );
    drawnow('limitrate');
    if params.dupl
        [S] = createMatricesDupl( leagueData, startGameDay-params.learnGameDays-1, lastGameDay-1, params );
    else
        [S] = createMatrices( leagueData, startGameDay-params.learnGameDays-1, lastGameDay-1, params );
    end
    fprintf( 'rdy\n' );
%     fflush( stdout );
    drawnow('limitrate');
    
    fprintf( 'Create BT matrices...' ); 
%     fflush( stdout );
    drawnow('limitrate');
%    [BT_W, BT_T] = createMatricesBTtie( leagueData, startGameDay-params.learnGameDays-1, lastGameDay-1, params );
    [BT_W, BT_L, BT_T] = createMatricesBThometie( leagueData, startGameDay-1, lastGameDay-1, params );
    fprintf( 'rdy\n' ); 
%     fflush( stdout );
    drawnow('limitrate');

    fprintf('Create BT scores...' ); 
%     fflush( stdout );
    drawnow('limitrate');
    for gd = startGameDay:lastGameDay
%      [BT.pi{gd-1}, BT.theta{gd-1}, pi_st, theta_st, ell] = btemties(BT_W{gd-1}, BT_T{gd-1}, 1);
      [BT.pi{gd-1}, BT.theta{gd-1}, BT.alpha{gd-1}, pi_st, theta_st, alpha_st, ell] = btemhometies(BT_W{gd-1}, BT_L{gd-1}, BT_T{gd-1}, 1);
    end
    fprintf(  'rdy\n' ); 
%     fflush( stdout );
    drawnow('limitrate');


%     PR = PageRank( W{lastGameDay-1} + 0.5*D{lastGameDay-1});
%     PRd = PageRank( Wd{lastGameDay-1} + 0.5*Dd{lastGameDay-1} );
% %     PR = PageRank( S{lastGameDay-1} );
% %     PRd = PageRank( Sd{lastGameDay-1} );
%
%     nTeams = length( teamList );
%
%     [ PR (PRd(1:nTeams) + PRd(nTeams+1:end)) PRd(1:nTeams) PRd(nTeams+1:end)]
%
%     sum(PRd(1:nTeams))
%     sum(PRd(nTeams+1:end))
%
%     pause

%     [lambda1 lambda2 lambda3] = learnDeltaDistributions( leagueData, matrices, startGameDay-learnGameDays, startGameDay-1, params )
%     [lambda1 lambda2 lambda3] = learnDeltaDistributions( leagueData, matrices, startGameDay-20, lastGameDay-1, params )
%     [lambda1 lambda2 lambda3] = learnDeltaDistributions( leagueData, matrices,  startGameDay, startGameDay+20, params )
%     [lambda1 lambda2 lambda3] = learnDeltaDistributions( leagueData, matrices,  startGameDay-10, startGameDay+30, params )


    params.betThreshold = 0.20;
    params.minChance = 0.25;
    params.print = true;

    [betError, ourError, btError ,money, betCount] = measure( leagueData, S, startGameDay, lastGameDay, params, BT );

end
