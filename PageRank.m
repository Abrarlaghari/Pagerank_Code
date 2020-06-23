function pi = PageRank(Z)
    k = 20;
    M = Z(1:k, 1:k);
    N = size( M, 1 );
    U = sum( M, 1 );
    lambda = 0.999999;
%     P = lambda * M * (1./diag(U)) + (1-lambda)/N*ones(size(M));
%     [V D] = eig( P );
    pi =  ( eye(N) - (lambda)* (M * diag(1./U)) ) \ (((1-lambda)/N) *ones(N,1));
end
% % 
% 
% 
% 
% function [ MasseyRating ] = Massey(M)
%Function to determine winner using Colley Matrix
%   Y = Candidate Matrix, input as {'A','B',...'Z'}
%   Z = Rating Matrix, m-by-n where m is # of voters and m is # of
%   candidates

% Find the dimensions of the data matrix

% % Z = M;
% [m,n] = size(Z);
% 
% %Begin to create Massey matrix
% M = -m*ones(n); 
% 
% % Adjust the main diagonal of Massey's matrix
% for i = 1:n
%    M(i,i) = (n-1)*m; 
% end
% 
% %Preallocate data for score differentials
% D = zeros(n,1);
% 
% %Preallocate data to count ties
% Ties = zeros(n);
% 
% %Determine score differentials usin win/loss data, count ties.
% for i = 1:m    
%     for j = 1:n
%         for k = j:n                     
%             if(Z(i,j) > Z(i,k))
%                 s = Z(i,j) - Z(i,k);
%                 D(j,1) = D(j,1) + s ;      
%                 D(k,1) = D(k,1) - s;
%                 
%             elseif (Z(i,j) < Z(i,k))  
%                 s = Z(i,j) - Z(i,k);
%                 D(j,1) = D(j,1) + s;      
%                 D(k,1) = D(k,1) - s;                         
%                 
%             elseif (Z(i,j) == Z(i,k) && j ~= k)
%               Ties(j,k) = Ties(j,k) + 2;
%               Ties(k,j) = Ties(k,j) + 2;  
%             end
%         end
%     end
% end
% 
% %Add Ties to Massey matrix
% M = M + Ties;
% 
% %Replace the last row of M by ones and last element in B by 0
% M(n,:) = ones(1,n);
% D(n,1) = 0;
% 
% %Solve the system of equations to compute the rating
% MasseyRating = linsolve(M,D);
% pi = MasseyRating ; % pi is rating
% %The following line produces the entire rating of candidates.
% [~,r] = sort(MasseyRating, 'descend'); % r= ranking ; for geeting rating and ranking
% % debug till this point
% 
% %Determine the maximum rating
% [~,win] = max(MasseyRating);
% 
% % Print out winning candidate
% % MasseyWinner = fprintf('The winner is %s. \n',Y{1,win});
% % 
% % % The following outputs the entire rank vector
% % fprintf('Ranking: \n');
% %  
% % MasseyWinner = fprintf('%d \n', r);
% 
% end


%Santiago Rodriguez
%University of Califonia, Davis
%Last Modified: September 16, 2016

% function [ ColleyWinner ] = Colley(Y,Z)
% Function to determine winner using Colley Matrix
%   Y = Candidate Matrix, input as {'A','B',...'Z'}
%   Z = Rating Matrix, m-by-n where m is # of voters and m is # of
%   candidates

%Find the dimensions of the data matrix
% % Z = M;
% [m,n] = size(Z);
% 
% % Begin to create Colley Matrix
% C = m*ones(n); 
% 
% % Convert Massey Matrix into Colley Matrix
% for i = 1:n
%    C(i,i) = (n-1)*m + 2; 
% end
% 
% % Preallocate memory for win/loss of ratings
% TotalWins = zeros(1,n);
% TotalLoss = zeros(1,n);
% 
% % Set matrix to count ties
% Ties = zeros(n);
% 
% % Count wins,losses,ties
% for i = 1:m    
%     for j = 1:n
%         for k = j:n         
%             
%             if(Z(i,j) > Z(i,k))                
%                 TotalWins(:,j) = TotalWins(:,j) + 1;
%                 TotalLoss(:,k) = TotalLoss(:,k) + 1;         
%                 
%             elseif (Z(i,j) < Z(i,k))                
%                 TotalLoss(:,j) = TotalLoss(:,j) + 1;
%                 TotalWins(:,k) = TotalWins(:,k) + 1;               
%                 
%             elseif (Z(i,j) == Z(i,k) && j ~= k)
%               Ties(j,k) = Ties(j,k) + 2;
%               Ties(k,j) = Ties(k,j) + 2;  
%             end
%         end
%     end
% end
% 
% % Add ties to Colley Matrix
% C = C + Ties;
% 
% % Allocate memory for b vector
% b = zeros(n,1);
% 
% % Generate vector b
% for j = 1:n
%     b(j,:) = 1 + .5*(TotalWins(:,j) - TotalLoss(:,j));
% end
% 
% % Solve the system of equations to compute the ratings.
% ColleyRating = linsolve(C,b); 
% pi = ColleyRating; % pi is rating
% % The following line produces the entire rating of candidates.
% [~,r] = sort(ColleyRating, 'descend'); % r= ranking ; for geeting rating and ranking
% % debug till this point
% 
% % Determine the maximum rating
% [~,win] = max(ColleyRating);
% 
% % Print out winning candidate
% %  ColleyWinner = fprintf('The winner is %s. \n',r);
% 
% end


% Keener Start here


% % Data;
% % S;
% % Creating K matrix
% S = Z;
% [m,n] = size(S);
% 
% K = zeros(m,n);
% 
% for i= 1:m
%     for j=1:n
%         
%         if(S(i,j)==0)
%             K(i,j)=0;
%         else 
%         x = (S(i,j) + 1)/ (S(i,j)+ S(j,i)+2);  
%         K(i,j)= 0.5 + (0.5* sign(x-0.5)* sqrt(abs(2*x -1))); 
%         end
%     end
% end
% 
% % [S, V, D] = svd(K);
% % K = Z;
% [r, va] = eig(K);
% 
% [v12, loc]=max(max(va));
% 
% % disp('Team rating is');
% [b, c]=sort(abs(r(:,loc)),1,'descend'); % for geeting rating and ranking
% % debug till this point
% % fprintf('%d: %d',b,c)
% %  disp(c);
% pi = b;
% end 

