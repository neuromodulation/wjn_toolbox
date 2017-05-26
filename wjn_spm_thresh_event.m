function D=wjn_spm_thresh_event(filename,timewindow,event,channel,threshold,interval)
% function D=wjn_spm_thresh_event(filename,timewindow,event,channel,threshold,interval)
% in ms
D=spm_eeg_load(filename);
try
    d = D(D.indchannel(channel),:,1);
catch
    d=D(channel,:,1);
end
fs = D.fsample;
i = mythresh(d,threshold,interval/1000*fs);
it = i/fs;


D=wjn_epoch(D.fullfile,timewindow,event,it);

