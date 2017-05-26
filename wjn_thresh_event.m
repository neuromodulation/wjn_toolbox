function wjn_thresh_event(filename,channel,threshold,interval,rectify,smoothing,eventname)
% wjn_thresh_event(filename,channel,threshold,interval,rectify,smoothing,eventname)

if ~exist('interval','var')
    interval = 1; % seconds minimum distance of two events;
end

if ~exist('smoothing','var')
    smoothing = 0;
elseif smoothing == 1
    smoothing = 50;
end

if ~exist('rectify','var')
    rectify = 0; % seconds minimum distance of two events;
end

x=load(filename,channel)
fs = 1/x.(channel).interval;
if ~exist('eventname','var')
    ec = ['e' channel];
else
    ec = eventname;
end
x.(ec) = x.(channel);
x.(ec).title = ec;
x.(ec).values = zeros(size(x.(ec).times));
x.(ec) = rmfield(x.(ec),'scale');

if smoothing
    x.(channel).values = smooth(x.(channel).values,round(smoothing/1000*fs));
end

if rectify == 1
    
data = abs(x.(channel).values);
elseif rectify == -1
data = x.(channel).values.*-1;
else
    
data = x.(channel).values;
end
    i = mythresh(data,threshold);



di = mydiff(i)/fs;
ni = i;
ni(find(di<interval)) =[];

x.(ec).values(ni) = 1;
% 
figure
plot(x.(channel).times,data)
hold on
plot(x.(ec).times,x.(ec).values)
plot(x.(channel).times,ones(size(x.(channel).values))*threshold);

eval([ec '= x.(ec)'])
save(filename,'-append',ec)
