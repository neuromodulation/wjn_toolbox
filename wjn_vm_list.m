function [output,p]=wjn_vm_list(n,input,options,name)
%% continuous motor error options
fs = 25;
timewindow = [-5 5];
freqwindow = 1:100;
robust = 1;
fsmooth = 3;
tsmooth = 100;
artefact_threshold = 200;
try
    eegfolder = fullfile(mdf,'vm_eeg');
    megfolder = fullfile(mdf,'vm_meg');
catch
    eegfolder = 'E:\CHARITE EEG'; %'D:\Users\bpostigo\Documents\CHARITE EEG\'
    megfolder = 'E:\CHARITE EEG'; %'D:\Users\bpostigo\Documents\CHARITE EEG\'
end
drug = {'off','on'};
stim = {'off','on'};
%%

p{1}.n = 0;
p{1}.id = 'HC01BA01-1-07-06-2017';
p{1}.group = 'HC_EEG_64';
p{1}.rest_eeg = 'N01HC_BA07062017_rest.eeg'; %it was like 'N01HC_BA07062017_rest2.eeg' but since I did again the BA_exported the name is the former 
p{1}.task_eeg = 'N01HC_BA07062017vm_tablet.eeg';
p{1}.task_data = 'HC01BA01-1-07-06-2017_HC.mat';
p{1}.root = eegfolder;
p{1}.age = 35;
p{1}.artefact = [7 8; 300 350];
p{1}.movement_time = [30 60; 120 180];
p{1}.rest_time = [0 30;60 90];
p{1}.MoCA = 28;
p{1}.block_order = 1;
p{1}.hand = 'right';
p{1}.warning_cue = 1;
p{1}.debrief_difficulty = [1 3]; %1st automatic & 2nd controlled condition
p{1}.debrief_attention = [3 5];
p{1}.debrief_focus = [6 6];

p{2}.n = 1;
p{2}.id = 'HC02NL02-2-13-06-2017';
p{2}.group = 'HC_EEG_64';
p{2}.rest_eeg = 'N02HC_NL13062017_rest_tablet.eeg';
p{2}.task_eeg = 'N02HC_NL13062017_vm_tablet.eeg';
p{2}.task_data = 'HC02NL02-2-13-06-2017_HC.mat';
p{2}.age = 30;
p{2}.block_order = 2;
p{1}.MoCA = 26;
p{2}.hand = 'right';
p{2}.warning_cue = 0;
p{2}.root = eegfolder;
p{2}.debrief_difficulty = [0 0]; %1st automatic & 2nd controlled condition
p{2}.debrief_attention = [0 1];
p{2}.debrief_focus = [2 4];
%badchannel_vm NONE
%badchannel_rest NONE

p{3}.n = 2;
p{3}.id = 'HC03RL03-1-14-06-2017';
p{3}.group = 'HC_EEG_64';
p{3}.rest_eeg = 'N03HC_RL14062017_rest_tablet.eeg';
p{3}.task_eeg = 'N03HC_RL14062017_vm_tablet.eeg';
p{3}.task_data = 'HC03RL03-1-14-06-2017_HC.mat';
p{3}.age = 29;
p{3}.block_order = 1;
p{3}.MoCA = 29;
p{3}.hand = 'right';
p{3}.warning_cue = 0;
p{3}.root = eegfolder;
p{3}.debrief_difficulty = [2 4]; %1st automatic & 2nd controlled condition
p{3}.debrief_attention = [2 4];
p{3}.debrief_focus = [1 3];
%badchannel_vm NONE
%badchannel_rest NONE

p{4}.n = 3;
p{4}.id = 'HC04CT04-2-16-06-2017';
p{4}.group = 'HC_EEG_64';
p{4}.rest_eeg = 'N04HC_CT16062017_rest_tablet.eeg';
p{4}.task_eeg = 'N04HC_CT16062017_vm_tablet.eeg';
p{4}.task_data = 'HC04CT04-2-16-06-2017_tablet_HC.mat';
p{4}.age = 22;
p{4}.block_order = 2;
p{4}.MoCA = 27;
p{4}.hand = 'right';
p{4}.warning_cue = 0;
p{4}.root = eegfolder;
p{4}.debrief_difficulty = [1 0]; %1st automatic & 2nd controlled condition
p{4}.debrief_attention = [4 3];
p{4}.debrief_focus = [6 6];
%badchannel_vm NONE
%badchannel_rest NONE

p{5}.n = 0;
p{5}.id = 'HC05SR05-1-20-06-2017';
p{5}.group = 'HC_EEG_64';
p{5}.rest_eeg = 'N05HC_SR2062017_rest_tablet.eeg';
p{5}.task_eeg = 'N05HC_SR20062017_vm_tablet.eeg';
p{5}.task_data = 'HC05SR05-1-20-06-2017_tablet_HC.mat';
p{5}.age = 21;
p{5}.block_order = 1;
p{5}.MoCA = 27;
p{5}.hand = 'left';
p{5}.warning_cue = 0;
p{5}.root = eegfolder;
p{5}.debrief_difficulty = [2 4]; %1st automatic & 2nd controlled condition
p{5}.debrief_attention = [3 5];
p{5}.debrief_focus = [6 6];
%badchannel_vm NONE
%badchannel_rest NONE

p{6}.n = 4;
p{6}.id = 'HC06DK06-1-21-06-2017';
p{6}.group = 'HC_EEG_64';
p{6}.rest_eeg = 'N06HC_DK21062017_rest_tablet.eeg';  
p{6}.task_eeg = 'N06HC_DK21062017_vm_tablet.eeg';
p{6}.task_data = 'HC06DK06-1-21-06-2017_HC.mat';
p{6}.root = eegfolder;
p{6}.age = 30;
p{6}.MoCA = 28;
p{6}.block_order = 1;
p{6}.hand = 'right';
p{6}.warning_cue = 0;
p{6}.debrief_difficulty = [0 0]; %1st automatic & 2nd controlled condition
p{6}.debrief_attention = [2 3];
p{6}.debrief_focus = [2 3];
%badchannel_vm NONE
%badchannel_rest NONE

p{7}.n = 5;
p{7}.id = 'HC07FB07-2-23-06-2017';
p{7}.group = 'HC_EEG_64';
p{7}.rest_eeg = 'N07HC_FB23062017_rest_tablet.eeg';  
p{7}.task_eeg = 'N07HC_FB23062017_vm_tablet.eeg';
p{7}.task_data = 'HC07FB07-2-23-06-2017_HC.mat';
p{7}.root = eegfolder;
p{7}.age = 28;
p{7}.MoCA = 29;
p{7}.block_order = 2;
p{7}.hand = 'right';
p{7}.warning_cue = 0;
p{7}.debrief_difficulty = [1 1]; %1st automatic & 2nd controlled condition
p{7}.debrief_attention = [2 1];
p{7}.debrief_focus = [3 5];
%badchannel_vm NONE
%badchannel_rest NONE

p{8}.n = 6;
p{8}.id = 'HC08CM08-1-26-06-2017';
p{8}.group = 'HC_EEG_64';
p{8}.rest_eeg = 'N08HC_CM26062017_rest_tablet.eeg';  
p{8}.task_eeg = 'N08HC_CM26062017_vm_tablet.eeg';
p{8}.task_data = 'HC08CM08-1-26-06-2017_HC.mat';
p{8}.root = eegfolder;
p{8}.age = 21;
p{8}.MoCA = 29;
p{8}.block_order = 1;
p{8}.hand = 'right';
p{8}.warning_cue = 0;
p{8}.debrief_difficulty = [2 2]; %1st automatic & 2nd controlled condition
p{8}.debrief_attention = [3 4];
p{8}.debrief_focus = [1 1];
%badchannel_vm T8
%badchannel_rest T8 P8 P07 

p{9}.n = 0; %NOT VALID--COULD NOT PERFORM THE VM TASK
p{9}.id = 'HC09CM09-2-29-06-2017';
p{9}.group = 'HC_EEG_64';

p{10}.n = 7;
p{10}.id = 'HC10MU10-2-30-06-2017';
p{10}.group = 'HC_EEG_64';
p{10}.rest_eeg = 'N10HC_MU30062017_rest_tablet.eeg';  
p{10}.task_eeg = 'N10HC_MU30062017_vm_tablet.eeg';
p{10}.task_data = 'HC10CM10-2-30-06-2017_HC.mat';
p{10}.root = eegfolder;
p{10}.age = 21;
p{10}.MoCA = 30;
p{10}.block_order = 2;
p{10}.hand = 'right';
p{10}.warning_cue = 0;
p{10}.debrief_difficulty = [3 4]; %1st automatic & 2nd controlled condition
p{10}.debrief_attention = [2 3];
p{10}.debrief_focus = [1 2];
%badchannel_vm NONE
%badchannel_rest NONE

p{11}.n = 8; 
p{11}.id = 'HC11LG11-1-03-07-2017';
p{11}.group = 'HC_EEG_64';
p{11}.rest_eeg = 'N11HC_LG03062017_rest_tablet.eeg';  %Wrong date in datafile 
p{11}.task_eeg = 'N11HC_LG03062017_vm_tablet.eeg';
p{11}.task_data = 'HC11LG11-1-03-07-2017_HC.mat';
p{11}.root = eegfolder;
p{11}.age = 21;
p{11}.MoCA = 29;
p{11}.block_order = 1;
p{11}.hand = 'right';
p{11}.warning_cue = 0;
p{11}.debrief_difficulty = [1 2]; %1st automatic & 2nd controlled condition
p{11}.debrief_attention = [1 4];
p{11}.debrief_focus = [3 4];
%badchannel_vm T7
%totalbadtrials_vm 36
%badchannel_rest T7
%totalbadtrials_rest 4

p{12}.n = 9; 
p{12}.id = 'HC12KB12-1-07-07-2017';
p{12}.group = 'HC_EEG_64';
p{12}.rest_eeg = 'N12HC_KB07072017_rest_tablet.eeg';  
p{12}.task_eeg = 'N12HC_KB07072017_vm_tablet.eeg';
p{12}.task_data = 'HC12KB12-1-07-07-2017_HC.mat';
p{12}.root = eegfolder;
p{12}.age = 21;
p{12}.MoCA = 29;
p{12}.block_order = 1;
p{12}.hand = 'right';
p{12}.warning_cue = 0;
p{12}.debrief_difficulty = [1 1]; %1st automatic & 2nd controlled condition
p{12}.debrief_attention = [3 3];
p{12}.debrief_focus = [5 5];
%badchannel_vm none
%totalbadtrials_vm 93
%badchannel_rest none
%totalbadtrials_rest 1

p{13}.n = 10; 
p{13}.id = 'HC13SS13-1-12-07-2017';
p{13}.group = 'HC_EEG_64';
p{13}.rest_eeg = 'N13HC_SS12072017_rest_tablet.eeg';  
p{13}.task_eeg = 'N13HC_SS12072017_vm_tablet.eeg';
p{13}.task_data = 'HC13SS13-1-12-07-2017_HC.mat';
p{13}.root = eegfolder;
p{13}.age = 22;
p{13}.MoCA = 27;
p{13}.block_order = 1;
p{13}.hand = 'right';
p{13}.warning_cue = 0;
p{13}.debrief_difficulty = [0 3]; %1st automatic & 2nd controlled condition
p{13}.debrief_attention = [2 3];
p{13}.debrief_focus = [3 4];
%badchannel_vm 
%totalbadtrials_vm 
%badchannel_rest 
%totalbadtrials_rest 

p{14}.n = 0; 
p{14}.id = 'HC14JB14-1-17-07-2017';
p{14}.group = 'HC_EEG_64';
p{14}.rest_eeg = 'N14HC_JB17072017_rest_tablet.eeg';  
p{14}.task_eeg = 'N14HC_JB17072017_vm_tablet.eeg';
p{14}.task_data = 'HC14JB14-1-17-07-2017_HC.mat';
p{14}.root = eegfolder;
p{14}.age = 17;
p{14}.MoCA = 27;
p{14}.block_order = 1;
p{14}.hand = 'right';
p{14}.warning_cue = 0;
p{14}.debrief_difficulty = [1 2]; %1st automatic & 2nd controlled condition
p{14}.debrief_attention = [1 2];
p{14}.debrief_focus = [2 3];
%badchannel_vm none
%totalbadtrials_vm 111
%badchannel_rest none
%totalbadtrials_rest 1

p{15}.n = 11;
p{15}.id = 'HC15CB15-1-20-07-2017';
p{15}.group = 'HC_EEG_64';
p{15}.rest_eeg = 'N15HC_CB20072017_rest_tablet.eeg';
p{15}.task_eeg = 'N15HC_CB20072017_vm_tablet.eeg';
p{15}.task_data = 'HC15CB15-1-20-07-2017_HC.mat';
p{15}.age = 21;
p{15}.block_order = 1;
p{15}.MoCA = 28;
p{15}.hand = 'right';
p{15}.warning_cue = 0;
p{15}.root = eegfolder;
p{15}.debrief_difficulty = [0 1]; %1st automatic & 2nd controlled condition
p{15}.debrief_attention = [2 3];
p{15}.debrief_focus = [4 4];
%badchannel_vm 
%totalbadtrials_vm 
%badchannel_rest 
%totalbadtrials_rest 

p{16}.n = 12;
p{16}.id = 'HC16LB16-1-21-07-2017';
p{16}.group = 'HC_EEG_64';
p{16}.rest_eeg = 'N16HC_LB21072017_rest_tablet.eeg';
p{16}.task_eeg = 'N16HC_LB21072017_vm_tablet.eeg';
p{16}.task_data = 'HC16LB16-1-21-07-2017_HC.mat';
p{16}.age = 22;
p{16}.block_order = 1;
p{16}.MoCA = 27;
p{16}.hand = 'right';
p{16}.warning_cue = 0;
p{16}.root = eegfolder;
p{16}.debrief_difficulty = [1 1]; %1st automatic & 2nd controlled condition
p{16}.debrief_attention = [3 4];
p{16}.debrief_focus = [5 5];
%badchannel_vm none
%totalbadtrials_vm 87
%badchannel_rest none
%totalbadtrials_rest 3

p{17}.n = 0;
p{17}.id = 'HC17CA17-1-25-07-2017';
p{17}.group = 'HC_EEG_64';
p{17}.rest_eeg = 'N17HC_CA25072017_rest_tablet.eeg';
p{17}.task_eeg = 'N17HC_CA25072017_vm_tablet.eeg';
p{17}.task_data = 'HC17CA17-1-25-07-2017_HC.mat';
p{17}.age = 22;
p{17}.block_order = 1;
p{17}.MoCA = 30;
p{17}.hand = 'left';
p{17}.warning_cue = 0;
p{17}.root = eegfolder;
p{17}.debrief_difficulty = [1 3]; %1st automatic & 2nd controlled condition
p{17}.debrief_attention = [3 4];
p{17}.debrief_focus = [1 3];
%badchannel_vm none
%totalbadtrials_vm 64
%badchannel_rest 
%totalbadtrials_rest 

p{18}.n = 13;
p{18}.id = 'HC18SS18-1-26-07-2017';
p{18}.group = 'HC_EEG_64';
p{18}.rest_eeg = 'N18HC_SS26072017_rest_tablet.eeg';
p{18}.task_eeg = 'N18HC_SS26072017_vm_tablet.eeg';
p{18}.task_data = 'HC18SS18-1-26-07-2017_HC.mat';
p{18}.age = 21;
p{18}.block_order = 1;
p{18}.MoCA = 30;
p{18}.hand = 'right';
p{18}.warning_cue = 0;
p{18}.root = eegfolder;
p{18}.debrief_difficulty = [1 2]; %1st automatic & 2nd controlled condition
p{18}.debrief_attention = [2 3];
p{18}.debrief_focus = [2 3];
%badchannel_vm 
%totalbadtrials_vm 
%badchannel_rest 
%totalbadtrials_rest 

p{19}.n = 14;
p{19}.id = 'HC19SM19-1-04-08-2017';
p{19}.group = 'HC_EEG_64';
p{19}.rest_eeg = 'N19HC_SM04082017_rest_tablet.eeg';
p{19}.task_eeg = 'N19HC_SM04082017_vm_tablet.eeg';
p{19}.task_data = 'HC19SM19-1-04-08-2017_HC.mat';
p{19}.age = 22;
p{19}.block_order = 1;
p{19}.MoCA = 29;
p{19}.hand = 'right';
p{19}.warning_cue = 0;
p{19}.root = eegfolder;
p{19}.debrief_difficulty = [0 0]; %1st automatic & 2nd controlled condition
p{19}.debrief_attention = [2 1];
p{19}.debrief_focus = [3 1];
%badchannel_vm 
%totalbadtrials_vm 
%badchannel_rest 
%totalbadtrials_rest 

p{20}.n = 0;
p{20}.id = 'HC20VL20-1-07-08-2017';
%badchannel_vm 14 [Fp1 F4 FC5 FC2 FC6 T7 TP9 P7 P3 Pz P4 O1 Oz O2]
%totalbadtrials_vm 276
%badchannel_rest 2 [FC6 TP9]
%totalbadtrials_rest 8

p{21}.n = 0;
p{21}.id = 'HC21US21-1-08-08-2017';
%badchannel_vm 25 [[Fp1 Fp2 F3 F4 FC5 FC2 FC6 T7 Cz C4 T8 TP9 CP1 CP2 P7 P3 P4 O1 Oz O2 PO10 AF7 AF3 AF4 AF8 ]]
%totalbadtrials_vm 210 
%badchannel_rest 18 [Fp1 Fp2 F4 FC5 T7 Cz C4 T8 TP9 CP1 P7 P3 Pz P4 O1 Oz O2]
%totalbadtrials_rest 10

p{22}.n = 15;
p{22}.id = 'HC22SP22-1-29-08-2017';
p{22}.group = 'HC_EEG_64';
p{22}.rest_eeg = 'N22HC_SP29082017_rest_tablet.eeg';
p{22}.task_eeg = 'N22HC_SP29082017_vm_tablet.eeg';
p{22}.task_data = 'HC22SP22-1-29-08-2017_HC.mat';
p{22}.age = 39;
p{22}.block_order = 1;
p{22}.MoCA = 26;
p{22}.hand = 'right';
p{22}.warning_cue = 0;
p{22}.root = eegfolder;
p{22}.debrief_difficulty = [2 4]; %1st automatic & 2nd controlled condition
p{22}.debrief_attention = [2 6];
p{22}.debrief_focus = [4 5];

p{23}.n = 16;
p{23}.id = 'HC23SE23-1-11-09-2017';
p{23}.group = 'HC_EEG_64';
p{23}.rest_eeg = 'N23HC_SE11092017_rest_tablet.eeg';
p{23}.task_eeg = 'N23HC_SE11092017_vm_tablet.eeg';
p{23}.task_data = 'HC23SE23-1-11-09-2017_HC.mat';
p{23}.age = 32;
p{23}.block_order = 1;
p{23}.MoCA = 29;
p{23}.hand = 'right';
p{23}.warning_cue = 0;
p{23}.root = eegfolder;
p{23}.debrief_difficulty = [1 1]; %1st automatic & 2nd controlled condition
p{23}.debrief_attention = [5 6];
p{23}.debrief_focus = [5 6];
%badchannel_vm 1 [AF7]
%totalbadtrials_vm 116
%badchannel_rest 

p{24}.n = 17;
p{24}.id = 'HC24FS24-1-21-09-2017';
p{24}.group = 'HC_EEG_64';
p{24}.rest_eeg = 'N24HC_FS21092017_rest_tablet.eeg';
p{24}.task_eeg = 'N24HC_FS21092017_vm_tablet.eeg';
p{24}.task_data = 'HC24SE24-1-21-09-2017_HC.mat';
p{24}.age = 31;
p{24}.block_order = 1;
p{24}.MoCA = 26;
p{24}.hand = 'right';
p{24}.warning_cue = 0;
p{24}.root = eegfolder;
p{24}.debrief_difficulty = [1 4]; %1st automatic & 2nd controlled condition
p{24}.debrief_attention = [2 7];
p{24}.debrief_focus = [7 7];


p{25}.n = 18;
p{25}.id = 'HC25PH25-1-22-09-2017';
p{25}.group = 'HC_EEG_64';
p{25}.rest_eeg = 'N25HC_PH22092017_rest_tablet.eeg';
p{25}.task_eeg = 'N25HC_PH22092017_vm_tablet.eeg';
p{25}.task_data = 'HC25PH25-1-22-09-2017_HC.mat';
p{25}.age = 32;
p{25}.block_order = 1;
p{25}.MoCA = 28;
p{25}.hand = 'right';
p{25}.warning_cue = 0;
p{25}.root = eegfolder;
p{25}.debrief_difficulty = [5 7]; %1st automatic & 2nd controlled condition
p{25}.debrief_attention = [4 7];
p{25}.debrief_focus = [3 5];


p{26}.n = 19;
p{26}.id = 'HC26BP26-1-25-09-2017';
p{26}.group = 'HC_EEG_64';
p{26}.rest_eeg = 'N26HC_BP25092017_rest_tablet.eeg';
p{26}.task_eeg = 'N26HC_BP25092017_vm_tablet.eeg';
p{26}.task_data = 'HC26BP26-1-25-09-2017_HC.mat';
p{26}.age = 27;
p{26}.block_order = 1;
p{26}.MoCA = 26; %NOT REAL SCORE! [NOT ASSESSED]
p{26}.hand = 'right';
p{26}.warning_cue = 0;
p{26}.root = eegfolder;
p{26}.debrief_difficulty = [1 5]; %1st automatic & 2nd controlled condition
p{26}.debrief_attention = [2 6];
p{26}.debrief_focus = [4 6];

p{27}.n = 20;
p{27}.id = 'HC27BW27-1-28-09-2017';
p{27}.group = 'HC_EEG_64';
p{27}.rest_eeg = 'N27HC_BW28092017_rest_tablet.eeg';
p{27}.task_eeg = 'N27HC_BW28092017_vm_tablet.eeg';
p{27}.task_data = 'HC27BW27-1-28-09-2017_HC.mat';
p{27}.age = 32;
p{27}.block_order = 1;
p{27}.MoCA = 29;
p{27}.hand = 'right';
p{27}.warning_cue = 0;
p{27}.root = eegfolder;
p{27}.debrief_difficulty = [1 2]; 
p{27}.debrief_attention = [5 6];
p{27}.debrief_focus = [5 5];
%badchannel_vm 1 [T8]
%totalbadtrials_vm 195

for a =1:length(p)
    ids{a} = p{a}.id;
end

if exist('n','var') && ischar(n)
    i = ci(n,ids);
    if ~isempty(i)
        output = i;
        return
    end
end



pfields={};
for a =1:length(p)
    pfields = [pfields;fieldnames(p{a})];
end


% keyboard
allfields = unique(pfields);
if exist('n','var') 
    if isnumeric(n) && ~exist('input','var') && n >=1
        output = p{n};
        return
    elseif isnumeric(n) && n >=1 && ismember(input,fieldnames(p{n}))
        output = p{n}.(input);
        return
    elseif isnumeric(n) && n >=1 && isfield(p{n},'drug') && ismember(input,fieldnames(p{n}.('drug')))
        output = p{n}.(drug).(input);
        return
    elseif isnumeric(n) && n >=1 && ismember(input,allfields) && ~ismember(input,fieldnames(p{n}))
        output = 0;
        return
    elseif isstruct(n) && exist('input','var')
        n = ci(n.id,ids);
    elseif ~isnumeric(n)
        input = n;
    end
        switch input
           case 'nn'
                nn=0;
                for a=1:length(p)
                    if p{a}.n>0
                        nn=nn+1;
                        output(nn) = a;
                    end
                end
            case 'list'
                nn=0;
                for a=1:length(p)
                    if p{a}.n>0
                        nn=nn+1;
                        output{nn,3} = p{a}.id;
                        output{nn,1} = a;
                        output{nn,2} = nn;
                    end
                end
            case 'eegroot'
                output = eegfolder;         
            case 'dataroot'
                output = fullfile(p{n}.root,p{n}.id,'data');
            case 'savefile'
%                 output = fullfile(mdf,folder,'options',[p{n}.id '_' drug '_options.mat']);
            case 'addscript'
%                 edit(fullfile(mdf,folder,'scripts',options));
            case 'save'
                eval([name '=options'])
                save(bi(n,'savefile'),name,'-append')
            case 'load'
                load(bi(n,'savefile'),options)  
            case 'raw'
%                 output = ['r_' p{n}.id '_' drug '_cme.mat'];
            case 'folder'
                output = fullfile(mdf,folder);
            case 'figures'
                output = fullfile(mdf,folder,'figures');
            case 'options'
                output = fullfile(mdf,folder,'options');
            case 'fs'
                output = fs;
            case 'timewindow'
                output = timewindow;
            case 'freqwindow'
                output = freqwindow;
            case 'spmfile'
                    output = ['rraespmeeg_' p{n}.task_eeg(1:end-4) '.mat'];
            case 'fullspmfile'
                
                output = fullfile(p{n}.root,p{n}.id,'Preprocessed',['rraespmeeg_' p{n}.task_eeg(1:end-4) '.mat']);
            case 'fullfile'
                if ~exist('options','var')
                    options = [];
                end
%                 keyboard
                     output = fullfile(p{n}.root,p{n}.id,'data',[options wjn_vm_list(n,'spmfile')]);
            case 'fullid'
                output = [p{n}.id];
            case 'group_figure_folder'
                output = fullfile(eegfolder,'group_figures');
            case 'artefact_threshold'
                    output = artefact_threshold;
            case 'fsmooth'
                output = fsmooth;
            case 'tsmooth'
                output = tsmooth;
            case 'robust'
                output = robust;      
            case 'baseline_method'
                output = 'mean';
            case 'update'
                copyfile(fullfile(getsystem,'wjn_vm_list.m'),fullfile(getsystem,'wjn_toolbox'),'f');
                disp('copied to wjn_toolbox')
        end
        if ~exist('output','var')
            output = [];
            warning('output not assigned')
        end
else
    output = p;
end



%% prepare 
% root = bi('root')
% cd(root)
% mkdir ../options
% 

% folder = 'vm_eeg';
% ffolder = fullfile(mdf,folder);
% 
% if ~any(strcmpi(fullfile(mdf,folder,'scripts'), regexp(path, pathsep, 'split')))
%     addpath(fullfile(mdf,folder,'scripts'))
%     addpath(fullfile(mf,'fastica'))
% end
% 
% subfolders = {'options','data','scripts','raw','figures'};
% for a = 1:length(subfolders)
%     if ~exist(fullfile(ffolder,subfolders{a}),'dir')
%         mkdir(fullfile(ffolder,subfolders{a}));
%     end
% end
% 
% if exist('options','var') 
%     if (isnumeric(options) && ~options) || strcmp(options,'off')
%         drug = 'off';
%     elseif  ~isnumeric(options) || options == 1
%         drug = 'on';
%     end
% elseif ~exist('options','var') 
%     drug = 'on';
% end
% 
