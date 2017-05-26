function [out,intersects]=wjn_range_intersection(testrange,trainrange)

d=trainrange;
out = nan(size(testrange,1),1);
for a = 1:size(testrange,1)
    t = testrange(a,:);
    if length(t)==1
        t(1,2) = t(1);
    end
    
    x=(t(1)>=d(:,1)&t(1)<=d(:,2))... % d t1 d
        | (t(2)>=d(:,1)&t(2)<=d(:,2))... % d t2 d
        | (t(1)<=d(:,1)&t(2)>=d(:,2));
    if sum(x)
        out(a) = 1;
    else
        out(a) = 0;
    end
end
   
    
intersects = testrange(find(out));