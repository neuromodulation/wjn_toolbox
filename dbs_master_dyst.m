% dystonia patients and controls w/o DBS
% T. Sander, PTB, 6 / 2015
% updated versions needed for: berlin_correct_eventdata.m,
% dbs_meg_extraction_prepare_spm12.m, dbs_subjects_berlin.m, dbs_subjects.m
% spm('defaults', 'eeg');

for s = [1:5]
    ind = num2str(s);
    if length(ind) == 1
        ind = ['0' ind];
    end
    initials = ['DYST' ind];
    on = 0;
    
    D=dbs_meg_rest_prepare_spm12(initials,1);
%     
%     if s == 1
%         D = dbs_meg_extraction_prepare_spm12(initials, on, 'MV');
%     else
%         D = dbs_meg_extraction_prepare_spm12(initials, on, 'MVR');
%         D = dbs_meg_extraction_prepare_spm12(initials, on, 'MVL');
%     end
            
end


%% epoch task files

p = p_dc;

for a = 1:length(p)
    files = p_dc(a,'otaskfile');
    for b = 1:length(files);
    D=spm_eeg_load(files{b})
    S.D = D.fullfile;
    S.fsample_new = 300;
    D=spm_eeg_downsample(S)
    events = D.events;
    trigger = {p_dc(a,'mvl_trigger') p_dc(a,'mvr_trigger')};
    conds = {'MVL','MVR'};
    S.D = D.fullfile;
    S.bc = 0;
    S.timewin = [-3000 3000]
    for c = 1:length(trigger);
        S.trialdef(c).conditionlabel = conds{c};
        S.trialdef(c).eventtype = trigger{c};
        S.trialdef(c).eventvalue = [];
    end
    D=spm_eeg_epochs(S)
    efiles{b}=D.fullfile;
    end
    if numel(efiles)>1
        S.D = efiles;
        S.recode = 'same';
        D=spm_eeg_merge(S)
    end
    
    C.D = D.fullfile;
    C.outfile = [p{a}.id '_move.mat'];
    spm_eeg_copy(C);
    delete(C.D);
end
            
        