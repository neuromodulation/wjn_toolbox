function D=rox_ecog_convert(filename,timewindow)

D=spm_eeg_convert(filename);
ofname = D.fullfile;
D=wjn_downsample(D.fullfile,200,150);
delete([ofname(1:end-4) '.*']);
D=chantype(D,':','Other');

ch = numel(D.chanlabels);
for a = 1:ch
    if sum(strncmpi(D.chanlabels{a},{'ECOG','STN','LFP','GPi','VIM','CMPf','rLFP','rSTN','ECOG'},3))   
        D=chantype(D,a,'LFP');
    elseif sum(strncmpi(D.chanlabels{a},{'EMG','FDI','SCM'},3))
        D=chantype(D,a,'EMG');
    elseif sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4','Pz'},3)) || sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4'},2)) 
        D=chantype(D,a,'EEG');
    end
end

save(D)

% D=wjn_ecog_rereference(D.fullfile);
% D=wjn_linefilter(D.fullfile);

if exist('timewindow','var')
    D=wjn_eeg_auto_epoch(D.fullfile,timewindow);
end

