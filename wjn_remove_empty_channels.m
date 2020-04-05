function [D,emptychannels]=wjn_remove_empty_channels(filename)
disp('REMOVE EMPTY CHANNELS.')
D=spm_eeg_load(filename);

emptychannels = D.chanlabels(find(nansum(D(:,:),2)==0));
if ~isempty(emptychannels)
    D=wjn_remove_channels(D.fullfile,emptychannels);
else
    D=D;
end