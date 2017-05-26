function [events,number]=mygeteventsMEG(filename);

% filename = 'PLFP04_off_STOP1.mat'

load(filename)
n=0;
for a=1:length(D.trials.events);
    events{a,1} = D.trials.events(a).type;
    events{a,2} = D.trials.events(a).value;
    time(a,1) = D.trials.events(a).time;
    
    if isnumeric(D.trials.events(a).value)
        n=n+1;
        nevents{n,1} = events{a,1};
        values(n,1) = events{a,2};
        time(n,1) = D.trials.events(a).time;
    end
end



alleventnames = {'MOTOR_RIGHT_GO_RIGHT' 
'MOTOR_RIGHT_NO_GO_RIGHT'
'MOTOR_RIGHT_GO_LEFT'
'MOTOR_RIGHT_NO_GO_LEFT'

'MOTOR_LEFT_GO_RIGHT' 
'MOTOR_LEFT_NO_GO_RIGHT' 
'MOTOR_LEFT_GO_LEFT'
'MOTOR_LEFT_NO_GO_LEFT'

'GO_RIGHT_CORRECT'
'NO_GO_RIGHT_FALSE_RIGHT'
'GO_LEFT_FALSE_RIGHT' 
'NO_GO_LEFT_FALSE_RIGHT'

'GO_RIGHT_FALSE_LEFT' 
'NO_GO_RIGHT_FALSE_LEFT' 
'GO_LEFT_CORRECT' 
'NO_GO_LEFT_FALSE_LEFT'
};

n=0;
for a = 1:length(alleventnames)
    numevent(a) = numel(values(ci(alleventnames{a},nevents)));
    if numevent(a)
        n=n+1;
        eventnames{n} = alleventnames{a};
        eventvalues(n) = unique(values(ci(alleventnames{a},nevents)));
    end
    output(a,:) = {alleventnames{a},num2str(numevent(a))};
end

epochevent = {'GO_RIGHT_CORRECT','MOTOR_RIGHT_GO_RIGHT','GO_LEFT_CORRECT','MOTOR_LEFT_GO_LEFT'};
conds = {'right-go','right-bp','left-go','left-bp'};

rt_right = time(ci(epochevent{2},events))-time(ci(epochevent{1},events));
rt_left = time(ci(epochevent{4},events))-time(ci(epochevent{3},events));

mean_reaction_time = mean([rt_left;rt_right]);

Dtf = spm_eeg_load(filename);
Dtf.trialinfo = output;
Dtf.mean_reaction_time = mean_reaction_time;
Dtf.rt_right = rt_right;
Dtf.rt_left = rt_left;
save(Dtf)

clear matlabbatch
matlabbatch{1}.spm.meeg.preproc.epoch.D = {Dtf.fullfile};
matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.timewin = [-4000 2000];
for a = 1:length(conds)
matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).conditionlabel = conds{a};
matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).eventtype = epochevent{a};
matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).eventvalue = eventvalues(ci(epochevent{a},eventnames));
matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(a).trlshift = 0;
end
matlabbatch{1}.spm.meeg.preproc.epoch.bc = 1;
matlabbatch{1}.spm.meeg.preproc.epoch.eventpadding = 0;
matlabbatch{1}.spm.meeg.preproc.epoch.prefix = 'e';

spm_jobman('run',matlabbatch)
matlabbatch{1}.spm.meeg.preproc.epoch.D = {pt(ip,'outfile')};
spm_jobman('run',matlabbatch)
eDtf = spm_eeg_load(['e' Dtf.fname]);
