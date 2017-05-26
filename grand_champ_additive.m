%% AVERAGE CHANNELS
files = cellstr(ls('bgmaTF*.mat'));
channels = {'GPiL','GPiR','CMPfL','CMPfR'};

for a = 1:length(files);
    for b = 1:length(channels);
        S.chanstring = channels{b};
        S.D = files{a};
        spm_eeg_chan_average(S);
    end
end


%% general stats

target = {'GPi','CMPf'};
conditions = {'leftGO','rightGO';'leftNOGO','rightNOGO';'leftBP','rightBP'};
savecondition = {'GO','NOGO','BP'};  
for a =1:length(target);
    clear S
    for b = 1:length(conditions);
        targetfiles = cellstr(ls([target{a} '*.mat']));
        S.D = targetfiles
        S.freq = [2 90];
        S.time = [-3000 3000];
        S.condition = conditions(b,:)
        S.savename = [target{a} '_' savecondition{b}]
        S.distribution = 'mean';
        S.method = 'permTest';
        spm_eeg_baseline_stats(S); 
    end
    S.condition = conditions(1,:);
    S.pcondition = conditions(2,:);
    S.savename = [target{a} '_GOvsNOGO'];
    spm_eeg_baseline_stats(S);
    rmfield(S,'pcondition');
    close all
end

%% contralateral sides only

for a = 1:length(target);
    clear S
    for b = 1:length(conditions);
        contralateral(1:5) = conditions(b,2);
        contralateral(6:10) = conditions(b,1);
        ipsilateral(1:5) = conditions(b,1);
        ipsilateral(6:10) = conditions(b,2);
        
        targetfiles = cellstr(ls([target{a} '*.mat']));
        S.D = targetfiles
        S.freq = [2 90];
        S.time = [-3000 3000];
        S.condition = contralateral
        S.savename = [target{a} '_contralateral_' savecondition{b}]
        S.distribution = 'mean';
        S.method = 'permTest';
        spm_eeg_baseline_stats(S); 
    end
    S.pcondition = ipsilateral;
    S.savename = [target{a} '_contra_ipsi_' savecondition{b}]
    spm_eeg_baseline_stats(S);
    close all
end
    
%%% SPM

mkdir SPM/
copyfile m*.* SPM/
cd SPM/

for c = 1:length(target);
    meanfiles = cellstr(ls(['m' target{c} '*.mat']));

    for a = 1:length(meanfiles);
        for b = 1:size(conditions,1);
            S.D = meanfiles{a};
            S.condition = conditions(b,:);
            spm_eeg_chan_average(S);
            for i = 1:size(conditions,2);
                S.D = meanfiles{a};
                S.condition = conditions(b,i);
                spm_eeg_chan_average(S);
            end

                
        end
     
    end
end
    
    

%% mkdirs images and smoothing
for a = 1:length(target);
    mkdir(target{a});
    copyfile(['m*' target{a} '*'],target{a});
    cd(target{a});
    S.D = cellstr(ls('m*.mat'));
    S.smooth = 1;
    S.images.elecs = 1;
    S.images.t_win = [-5 3];
    S.n = 64;
    spm_eeg_convert2images_filenames(S);
    cd ..    
end

for a = 1:length(target);
    cd(target{a});
    mkdir GO
    mkdir NOGO
    mkdir BP
    mkdir GOvsNOGO
    mkdir BPcontraVSipsi
    cd ..
end

cd(target{a})

spm eeg


