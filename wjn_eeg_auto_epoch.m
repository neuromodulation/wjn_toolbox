function D = wjn_eeg_auto_epoch(filename,timewindow)

D=spm_eeg_load(filename);

if sum(abs(timewindow))<50
    timewindow = timewindow.*1000;
end



matlabbatch{1}.spm.meeg.preproc.epoch.D = {D.fullfile};

if length(timewindow)==2
    matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.timewin = timewindow;

 
    ev = D.events(:);
    i = ci('Stimulus',{ev(:).type});
    conds = unique({ev(i).value});

    for  a = 1:length(conds)
        matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).conditionlabel = conds{a};
        matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).eventtype = 'Stimulus';
        matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).eventvalue = conds{a};
        matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).trlshift = 0;
    end
elseif length(timewindow)==1
    matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.arbitrary.trialength = timewindow;
    matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.arbitrary.conditionlabel = 'rest';
else
    
end
matlabbatch{1}.spm.meeg.preproc.epoch.bc = 0;
matlabbatch{1}.spm.meeg.preproc.epoch.eventpadding = 1;
matlabbatch{1}.spm.meeg.preproc.epoch.prefix = 'e';

spm_jobman('run',matlabbatch)
D=spm_eeg_load(fullfile(D.path,['e' D.fname]));

