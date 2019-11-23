clear all;
addpath('C:\spm12\');spm('eeg','defaults');close all;
addpath('C:\matlab\meg_toolbox\');

ID = 'LN19';

root = fullfile('C:\Vim_meg\',ID);
cd(root);%load meg_prep.mat
conditions = {'R','RT','RTL'}; % rest + Tremor both hands + Tremor left hand
original_file = fullfile(root,[ID '.mat']);
working_file = fullfile(root,[ID '.mat']);
freqranges = [7 13;15 30;55 70;70 95];
lfpchans= {'LFP_R01';'LFP_R12';'LFP_R23'};
emgchans = {'EMG_L','EMG_L_FA'};%,'EMG_R','EMG_R_FA'};
target_name = 'VIM';
file = fullfile(root,'dataset',['cm' ID '.mat']);
hfile = fullfile(root,'dataset',['rhcm' ID '.mat']);
save(['meg_prep_' ID]);
% D=spm_eeg_load(file);
%%
D=spm_eeg_load(original_file);
fsample = D.fsample;
S.D = D;
S.outfile = working_file;
D=spm_eeg_copy(S);
%% MRI
D=spm_eeg_load(working_file);
c_mri = fullfile(root,'correct_mri','SPM',['r' ID 'cortex_8196.surf.gii']); %cortex
is_mri = fullfile(root,'correct_mri','SPM',['r' ID 'iskull_2562.surf.gii']); %iskull
os_mri = fullfile(root,'correct_mri','SPM',['r' ID 'oskull_2562.surf.gii']); %oskull
sc_mri = fullfile(root,'correct_mri','SPM',['r' ID 'scalp_2562.surf.gii']); %scalp
D=correct_mri(D.fname,c_mri,is_mri,os_mri,sc_mri);
mfile = D.fname; % mfile = 'cmLN04.mat'

mkdir(fullfile(root,'dataset'));
S.outfile = fullfile(root,'dataset',mfile);
S.D = mfile;
D=spm_eeg_copy(S);

%% Head location
% D=spm_eeg_load(fullfile(root,'dataset','cmLN19.mat'));
file = fullfile(D.path,D.fname);
[Dh,hr]=headloc(file);
hfile = fullfile(Dh.path,Dh.fname);

% save meg_prep

%% Plot continuous EMG
cd(root);
spm_plot_continuous(file,emgchans)
myprint('continuous_EMG')

%% Count trials
D=spm_eeg_load(file);
Dh=spm_eeg_load(hfile);
for a = 1:length(conditions);
    ctrials{a,1} = conditions{a};
    ctrials{a,2} = numel(D.indtrial(conditions{a}));
    ctrials{a,3} = ctrials{a,2} - numel(Dh.indtrial(conditions{a}));
end
save ctrials ctrials

%% Sensor Level
% load meg_prep.mat
% file = fullfile(root,'dataset','cmLN04.mat');
% hfile = fullfile(root,'dataset','rhcmLN04.mat');
for a = 1:length(conditions);
    cd(root);
    global xSPM
    mkdir(fullfile(root,conditions{a}));
    mkdir(fullfile(root,conditions{a},'sensor_level'));
    sensorfolder = fullfile(root,conditions{a},'sensor_level','native');
    mkdir(sensorfolder);
    
    sensor_level(sensorfolder,file,conditions{a},lfpchans);
    cd(root);
    hsensorfolder = fullfile(root,conditions{a},'sensor_level','headloc');
    mkdir(hsensorfolder);
    sensor_level(hsensorfolder,hfile,conditions{a},lfpchans);
    cd(root)
end
%% Plot power spectra and coherence

for a = 1:length(conditions);
    cd(root);
    D=spm_eeg_load(file);
    mkdir(fullfile(root,conditions{a},'power_spectrum'));
    powerfolder = fullfile(root,conditions{a},'power_spectrum','native');
    mkdir(powerfolder);cd(powerfolder);
    S=[];
    S.D = file;
    S.condition = conditions{a};
    S.freq = [1 100];
    S.channels = lfpchans;
    S.freqd = D.fsample;
    S.timewin = 3.41;
    C = spm_eeg_fft(S)

    figure;
    plot(C.f,C.rpow,'LineWidth',3,'LineSmoothing','on');
    myfont(gca);figone(7);l = legend(strrep(C.channels,'_',' '));
    set(l,'FontSize',8);
    xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]');
    xlim([3 35]);ylim([0 2]);
    myprint(['Vim_Power_Spectrum_' conditions{a} '_native']);
    
    x=load(fullfile(sensorfolder,['cohfile_' lfpchans{1} '_low.mat']));

    d.coh = x.coh.cohspctrm;
    d.mcoh = mean(d.coh,1);
    d.f = x.coh.freq;
    d.scoh = std(d.coh,1);
    
    figure;
    area(d.f,d.mcoh+d.scoh,'FaceColor',[0.9 0.9 0.9],'Edgecolor','None')
    myfont(gca);figone(7);
    hold on;
    plot(d.f,d.mcoh,'LineSmoothing','on','color','k','LineWidth',3);
    hold on;
    area(d.f,d.mcoh-d.scoh,'FaceColor','w','EdgeColor','none');
    xlabel('Frequency [Hz]');ylabel('Coherence');
    xlim([5 35]);ylim([0 0.1]);
    myprint([lfpchans{1} '_to_MEG_coherence_' conditions{a} '_native'])
    
    clear d x
    
    cd(root);
    hpowerfolder = fullfile(root,conditions{a},'power_spectrum','headloc');
    mkdir(hpowerfolder);cd(hpowerfolder);
    S=[];
    S.D = hfile;
    S.condition = conditions{a};
    S.freq = [1 100];
    S.channels = lfpchans;
    S.freqd = D.fsample;
    S.timewin = 3.41;
    C = spm_eeg_fft(S)

    figure;
    plot(C.f,C.rpow,'LineWidth',2,'LineSmoothing','on');
    myfont(gca);figone(7);l = legend(strrep(C.channels,'_',' '));
    set(l,'FontSize',8);
    xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]');
    xlim([3 35]);ylim([0 2]);
    myprint(['Vim_Power_Spectrum_' conditions{a} '_headloc']);
    
    x=load(fullfile(hsensorfolder,['cohfile_' lfpchans{1} '_low.mat']));

    d.coh = x.coh.cohspctrm;
    d.mcoh = mean(d.coh,1);
    d.f = x.coh.freq;
    d.scoh = std(d.coh,1);
    
    figure;
    area(d.f,d.mcoh+d.scoh,'FaceColor',[0.9 0.9 0.9],'Edgecolor','None')
    myfont(gca);figone(7);
    hold on;
    plot(d.f,d.mcoh,'LineSmoothing','on','color','k','LineWidth',2);
    hold on;
    area(d.f,d.mcoh-d.scoh,'FaceColor','w','EdgeColor','none');
    xlabel('Frequency [Hz]');ylabel('Coherence');
    xlim([5 35]);ylim([0 0.1]);
    myprint([lfpchans{1} '_to_MEG_coherence_' conditions{a} '_headloc'])

    cd(root)
    clear d x
end

%% source coherence
% file = fullfile(root,'dataset','cmLN04.mat');
% hfile = fullfile(root,'dataset','rhcmLN04.mat');
% lfpchan = {'LFP_R01','LFP_R12','LFP_R23'};
% freqrange = [7 13;15 30];
cd(root);
for a = 1:length(conditions);
      mkdir(fullfile(root,conditions{a},'source_coherence'));
      mkdir(fullfile(root,conditions{a},'source_coherence'));
      mkdir(fullfile(root,conditions{a},'source_coherence','native'));
      sourcefolder = fullfile(root,conditions{a},'source_coherence','native');
      source_coherence(sourcefolder,file,lfpchans,freqranges)
      cd(root);
      mkdir(fullfile(root,conditions{a},'source_coherence','headloc'));   
      hsourcefolder = fullfile(root,conditions{a},'source_coherence','headloc');
      source_coherence(hsourcefolder,hfile,lfpchans,freqranges);
      cd(root);
end

%% source coherence simulation

% file = fullfile(root,'dataset','cmLN04.mat');
% hfile = fullfile(root,'dataset','rhcmLN04.mat');
simlfpchan = {'LFP_R01','LFP_R12','LFP_R23'};
simfreqrange = [7 13;15 30];
cd(root);
for a = 1:length(conditions);
      mkdir(fullfile(root,conditions{a},'source_coherence'));
      mkdir(fullfile(root,conditions{a},'source_coherence','simulation'));
      mkdir(fullfile(root,conditions{a},'source_coherence','simulation','native'));
      simsourcefolder = fullfile(root,conditions{a},'source_coherence','simulation','native');
      S=[];
      S.D = file;
      S.condition = conditions{a};
      S.folder = simsourcefolder;
      S.refchan = simlfpchan;
      S.freqrange = simfreqrange;
      simulate_source_coherence(S);
      cd(root);
      mkdir(fullfile(root,conditions{a},'source_coherence','simulation','headloc'));   
      hsimsourcefolder = fullfile(root,conditions{a},'source_coherence','simulation','headloc');
      S.folder = hsimsourcefolder;
      S.D = hfile;
      simulate_source_coherence(S);
      cd(root);
end

%% source extraction single channels
cd(root);
positions = [0 -78 -24;-10 22 46];
source_names = {'Cerebellum','Motor_Cortex'};
freqrange = [7 13;15 30];
lfpchan = {'LFP_R01';'LFP_R23'};

for a = 1:length(conditions);
    for b = 1:length(source_names);
        mkdir(fullfile(root,conditions{a},'source_extraction'));
        extfolder = fullfile(root,conditions{a},'source_extraction','native');
        mkdir(extfolder);
        source_extraction(extfolder,file,conditions{a},emgchans,lfpchan{b,:},positions(b,:),freqrange(b,:),target_name,source_names{b})
        hextfolder = fullfile(root,conditions{a},'source_extraction','headloc');
        mkdir(hextfolder);
        source_extraction(hextfolder,hfile,conditions{a},emgchans,lfpchan{b,:},positions(b,:),freqrange(b,:),target_name,source_names{b})
        close all
        
    end

end

%% source extraction all LFP channels
cd(root);
positions = [0 -78 -24;-10 22 46];
source_names = {'Cerebellum','Motor_Cortex'};
freqrange = [7 13;15 30];
lfpchan = lfpchans;

for a = 1:length(conditions);
    for b = 1:length(source_names);
        mkdir(fullfile(root,conditions{a},'source_extraction'));
        extfolder = fullfile(root,conditions{a},'source_extraction','native');
        mkdir(extfolder);
        source_extraction(extfolder,file,conditions{a},emgchans,lfpchan,positions(b,:),freqrange(b,:),target_name,source_names{b})
        hextfolder = fullfile(root,conditions{a},'source_extraction','headloc');
        mkdir(hextfolder);
        source_extraction(hextfolder,hfile,conditions{a},emgchans,lfpchan,positions(b,:),freqrange(b,:),target_name,source_names{b})
        close all
    end

end


%% Source coherence EMG
% file = fullfile(root,'dataset','cmLN04.mat');
% hfile = fullfile(root,'dataset','rhcmLN04.mat');
sefreqrange = [2 6]

for a = 1:length(conditions);
      mkdir(fullfile(root,conditions{a},'source_coherence'));
      mkdir(fullfile(root,conditions{a},'source_coherence','native'));
      sourcefolder = fullfile(root,conditions{a},'source_coherence','native');
      source_coherence(sourcefolder,file,lfpchans,freqranges)
      cd(root);
      mkdir(fullfile(root,conditions{a},'source_coherence','headloc'));   
      hsourcefolder = fullfile(root,conditions{a},'source_coherence','headloc');
      source_coherence(hsourcefolder,hfile,lfpchans,freqranges)
      cd(root);
end
