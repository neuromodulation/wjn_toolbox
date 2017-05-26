function [chntitle]=makeeventchannel(data,title,Fs)

         chntitle.title = title;
         chntitle.comment = 'eventchannelmaker';
         chntitle.interval = 1/Fs;
         chntitle.start = 0;
         chntitle.length = length(data);
         chntitle.values = data;
         chntitle.times(:,1) = linspace(0,length(data)/Fs,length(data));