[b,ind]= sort(a,'descend');
ret=zeros(size(a));

for i=1:length(a)

    for j=1:length(b)
   
        if a(i)== b(j)
        ret(i)=j;
        break;
        end
        
    end
    
end
disp(ret)
