for i= 1 : size(Y,2)
result(i)=corr(X,Y(:,i),'Type','pearson','rows','complete');
end 