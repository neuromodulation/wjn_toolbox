TFfiles = cellstr(ls('TF*.mat'));

for a = 1:length(TFfiles);
    clear S
    S.D = TFfiles{a};
    S.method = 'additive';
    S.robust = 0;
    S.baseline = [-2000 -500];
    spm_eeg_grandchamp(S);
end
keep TFfiles
disp('Gma done');
for a = 1:length(TFfiles);
    clear S
    S.D = TFfiles{a};
    S.method = 'gain';
    S.robust = 0;
    S.baseline = [-5000 -3000];
    spm_eeg_grandchamp(S);
end
close all;
keep TFfiles
disp('Gmg done');

keep TFfiles
for a = 1:length(TFfiles);
    clear S
    S.D = TFfiles{a};
    S.method = 'gain';
    S.robust = 1;
    S.baseline = [-5000 -3000];
    spm_eeg_grandchamp(S);
end
disp('Grg done');
keep TFfiles
for a = 1:length(TFfiles);
    clear S
    O.D = TFfiles{a};
    S.D = O.D;
    S.robust.savew = 0;
    S.robust.bycondition = 1;
    S.robust.ks = 3;
    S.review = 0;
    spm_eeg_average(S);
    S.D = ['m' O.D];
    S.tf.method = 'LogR';
    S.tf.Sbaseline = [-5 -3];
    spm_eeg_tf_rescale(S);
    S.D = ['rm' O.D];
    S.newname = ['Lr' O.D];
    spm_eeg_copy(S);
    S.D = ['m' O.D];
    S.tf.method = 'Rel';
    S.tf.Sbaseline = [-5 -3];
    spm_eeg_tf_rescale(S);
    S.D = ['rm' O.D];
    S.newname = ['Rr' O.D];
    spm_eeg_copy(S);
end
keep TFfiles
for a = 1:length(TFfiles);
    clear S
    S.D = TFfiles{a};
    S.method = 'additive';
    S.robust = 1;
    S.baseline = [-5000 -3000];
    spm_eeg_grandchamp(S);
end
disp('Gra done');
keep TFfiles
disp('Lr done');
for a = 1:length(TFfiles);
    clear S
    O.D = TFfiles{a};
    S.D = O.D;
    S.robust = 0;
    S.review = 0;
    spm_eeg_average(S);
    S.D = ['m' O.D];
    S.tf.method = 'LogR';
    S.tf.Sbaseline = [-5 -3];
    spm_eeg_tf_rescale(S);
    S.D = ['rm' O.D];
    S.newname = ['Lm' O.D];
    spm_eeg_copy(S);
    S.D = ['m' O.D];
    S.tf.method = 'Rel';
    S.tf.Sbaseline = [-5 -3];
    spm_eeg_tf_rescale(S);
    S.D = ['rm' O.D];
    S.newname = ['Rme' O.D];
    spm_eeg_copy(S);
    
end


disp('Rm done');
keep TFfiles
chans = {'GPiR','GPiL','CMPfL','CMPfR','GPi','CMPf'};
filestrings = {'bGma*.mat','bGra*.mat','bGmg*.mat','bGrg*.mat','RmeT*.mat','RrTF*.mat','LmTF*.mat','LrTF*.mat'};
for c = 1:length(filestrings);
    files = cellstr(ls(filestrings{c}));

    for a = 1:length(files);
        for b = 1:length(chans);
        S.D = files{a};
        S.chanstring = chans{b};   
        spm_eeg_chan_average(S);
        end
    end
end
disp('Channels averaged');

%% stats

keep filestrings
conditions = {'leftGO','rightGO';'leftNOGO','rightNOGO';'leftBP','rightBP'};
for c = 1:length(filestrings);
    clear S;
    S.D = cellstr(ls(['GPi*_' filestrings{c}]));
    S.D = S.D(1:10);
  
    
    savename = {['GPiLR_GO_' filestrings{c}(1:4)],['GPiLR_NOGO_' filestrings{c}(1:4)],['GPiLR_BP_' filestrings{c}(1:4)]};

    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end

    S.D = cellstr(ls(['GPi_' filestrings{c}]));
    savename = {['GPi_GO_' filestrings{c}(1:4)],['GPi_NOGO_' filestrings{c}(1:4)],['GPi_BP_' filestrings{c}(1:4)]};
    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end
end
disp('GPi stats done');

%% CMPf
for c = 1:length(filestrings);
    clear S;
    S.D = cellstr(ls(['CMPf*_' filestrings{c}]));
    S.D = S.D(1:10);
    
    savename = {['CMPfLR_GO_' filestrings{c}(1:4)],['CMPfLR_NOGO_' filestrings{c}(1:4)],['CMPfLR_BP_' filestrings{c}(1:4)]};

    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end

    S.D = cellstr(ls(['CMPf_' filestrings{c}]));
    savename = {['CMPf_GO_' filestrings{c}(1:4)],['CMPf_NOGO_' filestrings{c}(1:4)],['CMPf_BP_' filestrings{c}(1:4)]};
    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end
end
disp('CMPf stats done');

keep filestrings
conditions = {'leftGO','rightGO';'leftNOGO','rightNOGO';'leftBP','rightBP'};
for c = 1:length(filestrings);
    clear S;
    S.D = cellstr(ls(['GPi*_' filestrings{c}]));
    S.D = S.D(1:10);
    S.D([5,10]) = [];
    
    savename = {['GPiLR_GO_noMB_' filestrings{c}(1:4)],['GPiLR_NOGO_noMB_' filestrings{c}(1:4)],['GPiLR_BP_noMB_' filestrings{c}(1:4)]};

    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end

    S.D = cellstr(ls(['GPi_' filestrings{c}]));
        S.D(5) = [];
    savename = {['GPi_GO_noMB_' filestrings{c}(1:4)],['GPi_NOGO_noMB_' filestrings{c}(1:4)],['GPi_BP_noMB_' filestrings{c}(1:4)]};
    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end
end
disp('GPi stats done');

%% CMPf
for c = 1:length(filestrings);
    clear S;
    S.D = cellstr(ls(['CMPf*_' filestrings{c}]));
    S.D = S.D(1:10);
    S.D([5,10]) = [];
    
    savename = {['CMPfLR_GO_noMB_' filestrings{c}(1:4)],['CMPfLR_NOGO_noMB_' filestrings{c}(1:4)],['CMPfLR_BP_noMB_' filestrings{c}(1:4)]};

    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end

    S.D = cellstr(ls(['CMPf_' filestrings{c}]));
    S.D(5) = [];
    savename = {['CMPf_GO_noMB_' filestrings{c}(1:4)],['CMPf_NOGO_noMB_' filestrings{c}(1:4)],['CMPf_BP_noMB_' filestrings{c}(1:4)]};
    for a = 1:length(conditions);
        S.condition = conditions(a,:);
        S.savename = savename{a};
        S.method = 'signrank';

        spm_eeg_baseline_stats(S);
        close all;
    end
end
disp('CMPf stats done');

%% average contralateral channels
TFfiles = cellstr(ls('TF*.mat'));
leftright = {'leftGO','rightGO','leftNOGO','rightNOGO','leftBP','rightBP'};


chans = {'GPiR','GPiL','CMPfL','CMPfR','GPi','CMPf'};
filestrings = {'bGma*.mat','bGra*.mat','bGmg*.mat','bGrg*.mat','RmeT*.mat','RrTF*.mat','LmTF*.mat','LrTF*.mat'};
for i = 1:length(leftright);
    for c = 1:length(filestrings);
        files = cellstr(ls(filestrings{c}));

        for a = 1:length(files);
            for b = 1:length(chans);
            S.D = files{a};
            S.condition = leftright{i};
            S.chanstring = chans{b};   
            spm_eeg_chan_average(S);
            end
        end
    end
end
disp('Channels averaged');
