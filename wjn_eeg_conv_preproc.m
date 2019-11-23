function D=wjn_eeg_conv_preproc(filename,timerange)

% if ~exist('timerange','var')
%     timerange = [-Inf Inf];
% end

D=wjn_eeg_convert(filename);
% S = [];
% S.D = D;
% S.type = 'butterworth';
% S.band = 'high';
% S.freq = .5;
% S.dir = 'twopass';
% S.order = 5;
% D = spm_eeg_filter(S);
% 
% S = [];
% S.D = D;
% S.type = 'butterworth';
% S.band = 'low';
% S.freq = 125;
% S.dir = 'twopass';
% S.order = 5;
% D = spm_eeg_filter(S);
% 
% S = [];
% S.D = D;
% S.type = 'butterworth';
% S.band = 'stop';
% S.freq = [48 52];
% S.dir = 'twopass';
% S.order = 5;
% D = spm_eeg_filter(S);
D=wjn_eeg_auto_headmodel(D.fullfile);

if exist('timerange','var')
    if numel(timerange)==1
        D=wjn_eeg_auto_epoch(D.fullfile,timerange(1));
    elseif numel(timerange)==2
        D=wjn_eeg_vm_fix_triggers(D.fullfile);
        D=wjn_eeg_auto_epoch(D.fullfile,[timerange(1) timerange(2)]);
    end
end
D=wjn_eeg_auto_artefacts(D.fullfile);


