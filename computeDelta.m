function d = computeDelta( pi, pi2 )
%     d = norm(pi-pi2)^2;% / norm(pi)^2;

%     d = norm(pi-pi2);% / norm(pi);

%     d = sum( pi .* log(pi./pi2) ) + sum( pi2 .* log(pi2./pi) );

    d = norm(pi-pi2);% / norm(pi);
end