function [event,eventdata] = wjn_meg_read_events(D,eventchannels)
keep D eventchannels
n=0;
cs = [0    0.6275    0.6902; 0.8000    0.2000    0.2471; 0.9294    0.7882    0.3176];
cs = [cs;cs;cs;cs;cs];
event = struct('type',[],'value',[],'time',[],'sample',[],'offset',[],'duration',[]);
eventdata = zeros(1, D.nsamples);
figure 
for a = 1:length(eventchannels)
    d = D(D.indchannel(eventchannels{a}),:,1);
    if nanmean(d(d>0))<10
        d = d.*10;
    end
    d = round(d);
    i = 1+find(diff(abs(d))>5);
    for b  =1:2:length(i)-1
        n=n+1;
        event(n).type = eventchannels{a};
        event(n).value = d(i(b));
        eventdata(i(b)) = d(i(b));
        event(n).time = i(b)/D.fsample;
        event(n).sample = i(b);
        event(n).offset = 0;
        event(n).duration = 1-i(b+1)/D.fsample-i(b)/D.fsample;
    end  
    dd.(eventchannels{a}) = D(D.indchannel(eventchannels{a}),:,1);
    dd.t = D.time;
    h(a)=plot(dd.t,d,'color',cs(a,:));
    hold on
    scatter(dd.t(i(1:2:end)),d(i(1:2:end)),10,'filled','MarkerFaceColor','k');
    scatter(dd.t(i(2:2:end)-2),d(i(2:2:end)-2),'r.');
    l{a}=[eventchannels{a} ' N = ' num2str(numel(i)/2)];
end
% keyboard
title(['N = ' num2str(length(event))]);
legend(h,l);
figone(7,35)
pos = get(gca,'position')
set(gca,'position',[0.05 pos(2) 0.92 pos(4)]);
fname = D.fname;
myprint(['events_' fname(1:end-4) ])
dd.event = event;
dd.eventdata = eventdata;
dd.eventchannels = eventchannels;
save(['eventchannels_' D.fname],'-struct','dd');


