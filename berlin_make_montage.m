% THIS IS FIRST MEASUREMENTS
% set correct directory for file before
if 1 == 1
    % set correct directory for file before
    cd /auge22/plfp1/con_files/
    hdr = ft_read_header('plfp03.0200.con');
    label =hdr.label 

    label{126}='EEG129';
    label{127}='EEG130';
    label{128}='EEG131';
    label{129}='EEG132';
    label{130}='EEG133';
    label{131}='EEG134';
    label{132}='EEG135';
    label{133}='EEG136';
    label{134}='EEG137';
    label{135}='EEG138';
    label{136}='EEG139';
    label{137}='EEG140';
    label{138}='EEG141';
    label{139}='EEG142';
    label{140}='EEG157';
    label{141}='EEG159';
    label{142}='EEG160';
    label = label(1:142);
    % save('/auge22/plfp1_spm/SPM/berlin_channels_alt_test.mat','label');
    save('/auge22/plfp1_spm/SPM/berlin_channels_alt.mat','label');

    montage = [];
    montage.labelorg = label;
    montage.labelnew = label(1:125);
    montage.labelnew = [montage.labelnew;{...
        'LFP_R01',...
        'LFP_R12',...
        'LFP_R23',...
        'LFP_L01',...
        'LFP_L12',...
        'LFP_L23',...
        'EMG_R',...
        'EMG_L',...
        'ECG'
        }'];


    montage.tra = eye(125);
    montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

    montage.tra(strmatch('LFP_R01', montage.labelnew), strmatch('EEG133', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R01', montage.labelnew), strmatch('EEG134', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_R12', montage.labelnew), strmatch('EEG134', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R12', montage.labelnew), strmatch('EEG135', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_R23', montage.labelnew), strmatch('EEG135', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R23', montage.labelnew), strmatch('EEG136', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_L01', montage.labelnew), strmatch('EEG130', montage.labelorg)) = 1;

    montage.tra(strmatch('LFP_L12', montage.labelnew), strmatch('EEG130', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_L12', montage.labelnew), strmatch('EEG131', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_L23', montage.labelnew), strmatch('EEG131', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_L23', montage.labelnew), strmatch('EEG132', montage.labelorg)) = -1;
%  
%     montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG137', montage.labelorg)) = 1;
%     montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG138', montage.labelorg)) = -1;
% 
%     montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG139', montage.labelorg)) = 1;
%     montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG140', montage.labelorg)) = -1;
%      

    % hardware wrong
    montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG139', montage.labelorg)) = 1;
    montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG140', montage.labelorg)) = -1;

    montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG137', montage.labelorg)) = 1;
    montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG138', montage.labelorg)) = -1;
   
    % save('/auge22/plfp1_spm/SPM/berlin_montage_alt_test','montage');
    save('/auge22/plfp1_spm/SPM/berlin_montage_alt','montage');
end


% THIS IS AFTER PLUG EXCHANGE
% set correct directory for file before
if 1 == 1
    cd /auge22/plfp1/con_files/
    hdr = ft_read_header('plfp11.0200.con');
    label =hdr.label

    label{126}='EEG143';
    label{127}='EEG144';
    label{128}='EEG145';
    label{129}='EEG146';
    label{130}='EEG147';
    label{131}='EEG148';
    label{132}='EEG149';
    label{133}='EEG150';
    label{134}='EEG151';
    label{135}='EEG152';
    label{136}='EEG153';
    label{137}='EEG154';
    label{138}='EEG155';
    label{139}='EEG156';
    label{140}='EEG157';
    label{141}='EEG159';
    label{142}='EEG160';
    label = label(1:142);
    save('/auge22/plfp1_spm/SPM/berlin_channels.mat','label');

    montage = [];
    montage.labelorg = label;
    montage.labelnew = label(1:125);
    montage.labelnew = [montage.labelnew;{...
        'LFP_R01',...
        'LFP_R12',...
        'LFP_R23',...
        'LFP_L01',...
        'LFP_L12',...
        'LFP_L23',...
        'EMG_R',...
        'EMG_L',...
        'ECG'
        }'];


    montage.tra = eye(125);
    montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

    montage.tra(strmatch('LFP_R01', montage.labelnew), strmatch('EEG149', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R01', montage.labelnew), strmatch('EEG150', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_R12', montage.labelnew), strmatch('EEG150', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R12', montage.labelnew), strmatch('EEG151', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_R23', montage.labelnew), strmatch('EEG151', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R23', montage.labelnew), strmatch('EEG152', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_L01', montage.labelnew), strmatch('EEG146', montage.labelorg)) = 1;

    montage.tra(strmatch('LFP_L12', montage.labelnew), strmatch('EEG146', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_L12', montage.labelnew), strmatch('EEG147', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_L23', montage.labelnew), strmatch('EEG147', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_L23', montage.labelnew), strmatch('EEG148', montage.labelorg)) = -1;
 
    % montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG143', montage.labelorg)) = 1;
    % montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG144', montage.labelorg)) = 1;
    % hardware wrong
    montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG144', montage.labelorg)) = 1;
    montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG143', montage.labelorg)) = 1;

    save('/auge22/plfp1_spm/SPM/berlin_montage','montage');
end


% THIS IS FOR DYST PATIENTS w/o DBS
% set correct directory for file before
if 1 == 0
    cd /auge22/dyst/DYST01/
    hdr = ft_read_header('dyst01.0200.con');
    label =hdr.label

    label{126}='EEG143';
    label{127}='EEG144';
    label{128}='EEG145';
    label{129}='EEG146';
    label{130}='EEG147';
    label{131}='EEG148';
    label{132}='EEG149';
    label{133}='EEG150';
    label{134}='EEG151';
    label{135}='EEG152';
    label{136}='EEG153';
    label{137}='EEG154';
    label{138}='EEG155';
    label{139}='EEG156';
    label{140}='EEG157';
    label{141}='EEG159';
    label{142}='EEG160';
    label = label(1:142);
    save('/auge22/dyst/SPM/berlin_channels_dyst.mat','label');

    montage = [];
    montage.labelorg = label;
    montage.labelnew = label(1:125);
    montage.labelnew = [montage.labelnew;{...
        'LFP_R01',...
        'LFP_R12',...
        'LFP_R23',...
        'LFP_L01',...
        'LFP_L12',...
        'LFP_L23',...
        'EMG_R',...
        'EMG_L',...
        'ECG'
        }'];


    montage.tra = eye(125);
    montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

    montage.tra(strmatch('LFP_R01', montage.labelnew), strmatch('EEG149', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R01', montage.labelnew), strmatch('EEG150', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_R12', montage.labelnew), strmatch('EEG150', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R12', montage.labelnew), strmatch('EEG151', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_R23', montage.labelnew), strmatch('EEG151', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_R23', montage.labelnew), strmatch('EEG152', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_L01', montage.labelnew), strmatch('EEG146', montage.labelorg)) = 1;

    montage.tra(strmatch('LFP_L12', montage.labelnew), strmatch('EEG146', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_L12', montage.labelnew), strmatch('EEG147', montage.labelorg)) = -1;

    montage.tra(strmatch('LFP_L23', montage.labelnew), strmatch('EEG147', montage.labelorg)) = 1;
    montage.tra(strmatch('LFP_L23', montage.labelnew), strmatch('EEG148', montage.labelorg)) = -1;

    montage.tra(strmatch('EMG_L', montage.labelnew), strmatch('EEG143', montage.labelorg)) = 1;
    montage.tra(strmatch('EMG_R', montage.labelnew), strmatch('EEG144', montage.labelorg)) = 1;
    montage.tra(strmatch('ECG', montage.labelnew), strmatch('EEG145', montage.labelorg)) = 1;

    save('/auge22/dyst/SPM/berlin_montage_dyst','montage');
end