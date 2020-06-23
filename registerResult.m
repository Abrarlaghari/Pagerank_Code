function S = registerResult( S, teamIx1, teamIx2, goals1, goals2, coef, params )
    if params.maxGoals < 2
        if goals1 > goals2
            S( teamIx1, teamIx2 ) = S( teamIx1, teamIx2 ) + 1*coef;
        elseif goals1 < goals2
            S( teamIx2, teamIx1 ) = S( teamIx2, teamIx1 ) + 1*coef;
        else
            S( teamIx1, teamIx2 ) = S( teamIx1, teamIx2 ) + 0.5*coef;
            S( teamIx2, teamIx1 ) = S( teamIx2, teamIx1 ) + 0.5*coef;
        end
    else
        if goals1 + goals2 > 0
            S( teamIx1, teamIx2 ) = S( teamIx1, teamIx2 ) + goals1*coef;
            S( teamIx2, teamIx1 ) = S( teamIx2, teamIx1 ) + goals2*coef;
        else
            S( teamIx1, teamIx2 ) = S( teamIx1, teamIx2 ) + 0.5*coef;
            S( teamIx2, teamIx1 ) = S( teamIx2, teamIx1 ) + 0.5*coef;
        end
    end

    % Connecting home and away entries of the same teams
%     nTeams = size(S,1) / 2;
%     for i = [teamIx1 (teamIx2-nTeams)]
%         S( i, i+nTeams ) = 0;
%         S( i+nTeams, i ) = 0;
%         H1 = sum(S( :, i )) + sum(S( i+nTeams, : ));
%         H2 = sum(S( :, i+nTeams )) + sum(S( i, : ));
%         S( i, i+nTeams ) = H2;
%         S( i+nTeams, i ) = H1;
%     end

end