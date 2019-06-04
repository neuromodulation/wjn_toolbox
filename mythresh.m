function x = mythresh(data,threshold,interval)
%function x = mythresh(data,threshold);
% find threshold crossings

if size(data,1)>size(data,2)
    data = data';
end

if size(data,1)>1
    odata = data;
    data = data';
    data = data(:);
    ix = [1:size(odata,2) 1:size(odata,2)];
end

x=find(data(1:end-1) < threshold & data(2:end) > threshold);



if exist('interval','var')
    di=mydiff(x,1);
%     keyboard
    x(find(di<interval)) =[];
    x(x<interval | x > length(data)-interval) = []; 
end



xaxis = 1:length(data);

% figure
% plot(xaxis,data)
% hold on
% plot(xaxis(x),data(x),'r+')
% hold on
% for a = 1:length(x)
%     text(xaxis(x(a)),data(x(a)),num2str(a),'FontSize',8)
% end
% keyboard
if exist('ix','var')
    x = ix(x);
end

