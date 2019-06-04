function [d]=wjn_distance(x,y)

if ~exist('y','var')
    y = [0 0 0];
end

for a=1:size(x,1)
    if size(x,2)==3
        d(a,1) = sqrt((y(1)-x(a,1))^2+(y(2)-x(a,2))^2+(y(3)-x(a,3))^2);
    elseif size(x,2)==2
        d(a,1) = sqrt((y(1)-x(a,1))^2+(y(2)-x(a,2))^2);
    end
end