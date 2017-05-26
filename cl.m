function c = cl(data)
% function c = cl(data); columns = samples ; rows = repeats;
% size(c) will be [2,size(data,2)]

for a = 1:size(data,2);
    c(1,a) = mean(data(:,a))-(1.96*(std(data(:,a))/sqrt(size(data,1))));
    c(2,a) = mean(data(:,a))+(1.96*(std(data(:,a))/sqrt(size(data,1))));
end
