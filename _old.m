function [files, sequence, root, details] =dbs_subjects_berlin(initials, on)

if exist('/auge22/', 'dir') %PTB
    dbsroot = '/auge22/plfp1_spm';
    outroot = '/auge22/plfp1_spm_out';
elseif exist('\\underworld\vlad_shared', 'dir') %UCL
    dbsroot = '\\underworld\vlad_shared';
    outroot = 'C:\home\Data\DBS-MEG';
elseif exist('D:\MEG', 'dir')
    dbsroot = 'D:\MEG\plfp1_spm';
    outroot = 'D:\MEG\plfp1_spm_out';
end

details = struct(...
    'cont_head_loc', 1,...
    'brainamp', 0,...
    'bipolar', 0,...
    'badchanthresh', 0.2, ...
    'berlin', 0,...
    'mridir', fullfile(dbsroot, initials, 'MRI'));

chan = {'LFP_R01', 'LFP_R12', 'LFP_R23', 'LFP_L01', 'LFP_L12', 'LFP_L23'};

details.lfptocheck = chan;

details.oxford = isequal(initials(1:2), 'OX');

details.berlin = isequal(initials(1:4), 'PLFP');

if details.oxford
    details.chanset      = fullfile(dbsroot, 'SPM', 'ox_meg_chan.mat');
    montage              = load(fullfile(dbsroot, 'SPM','ox_meg_montage.mat'));
    details.cont_head_loc = 0;
    details.eventchannel = 'STI101';
    details.eventtype    = 'STI101_up';
    details.lfpthresh = 2e6;
elseif details.berlin
    details.chanset      = fullfile(dbsroot, 'SPM','berlin_channels.mat');
    details.eventchannel = 'EEG145'; % define the empty channel from lfp for later purposes
    montage              = load(fullfile(dbsroot, 'SPM','berlin_montage.mat'));
    details.cont_head_loc = 0;
    if strcmp(initials,'PLFP03') || strcmp(initials,'PLFP04') || strcmp(initials,'PLFP05')...
            || strcmp(initials,'PLFP06') || strcmp(initials,'PLFP07')
        details.chanset      = fullfile(dbsroot, 'SPM','berlin_channels_alt.mat');
        montage              = load(fullfile(dbsroot, 'SPM','berlin_montage_alt.mat'));
        details.eventchannel = 'EEG129'; % define the empty channel from lfp for later purposes
    end
    details.eventchannels = {'EEG157', 'EEG159', 'EEG160'};
    details.eventtype = 'EEG';
    details.flatthresh = 5;
else
    details.chanset      = fullfile(dbsroot, 'SPM','dbs_meg_chan.mat');
    details.eventtype    = 'UPPT001_up';
    details.eventchannel = 'SCLK01';
    details.lfpthresh = 20;
    montage = load(fullfile(dbsroot, 'SPM','dbs_meg_montage.mat'));
end

details.chanset = getfield(load(details.chanset), 'label');

name = fieldnames(montage);
montage = getfield(montage, name{1});


details.fiducials = fullfile(dbsroot, initials, 'MRI', [initials '_smri_fid.txt']);

switch initials
    case 'PLFP03'
        if ~on
            files = {
                'PLFP03/061009off/Raw/plfp03.0200.con',...
                'PLFP03/061009off/Raw/plfp03.0300.con',...
                'PLFP03/061009off/Raw/plfp03.0400.con'
                };
            root = 'PLFP03/061009off/';
            sequence = {'R','TEST','STOP'};
            details.berlin = 1;
            details.badchanthresh = 0.02;
            details.markers(1).files = {'plfp03.after1-coregis.txt','plfp03.after2-coregis.txt'};
            details.markers(2).files = {'plfp03.after2-coregis.txt'};
            details.markers(3).files = {'plfp03.after2-coregis.txt'};
        else
            files = {
                'PLFP03/061009on/Raw/plfp03.0500.con',...
                'PLFP03/061009on/Raw/plfp03.0600.con'
                };
            root = 'PLFP03/061009on/';
            sequence = {'R','STOP'};
            details.berlin = 1;
            details.badchanthresh = 0.05;
            details.markers(1).files = {'plfp03.before6-coregis.txt','plfp03.after6-coregis.txt'};
            details.markers(2).files = {'plfp03.before6-coregis.txt','plfp03.after6-coregis.txt'};
        end
        details.lfpthresh = 0.3;
    case 'PLFP04'
        if on
        else
            files = {
                'PLFP04/101209/Raw/plfp04.0100.con',...
                'PLFP04/101209/Raw/plfp04.0200.con',...
                'PLFP04/101209/Raw/plfp04.0300.con'
                };
            root = 'PLFP04/101209/';
            sequence = {'R','STOP','MV'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp04.before1b-coregis.txt','plfp04.after1-coregis.txt'};
            details.markers(2).files = {'plfp04.before2-coregis.txt'};
            details.markers(3).files = {'plfp04.before3-coregis.txt'};
            details.flatthresh = 25;
        end
    case 'PLFP05'
        if ~on
            files = {
                'PLFP05/171209off/Raw/plfp05.0100.con',...
                'PLFP05/171209off/Raw/plfp05.0200.con'
                };
            root = 'PLFP05/171209off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp05.before1-coregis.txt','plfp05.after1-coregis.txt'};
            details.markers(2).files = {'plfp05.after1-coregis.txt','plfp05.before2-coregis.txt'};
        else
            files = {
                'PLFP05/171209on/Raw/plfp05.0300.con',...
                'PLFP05/171209on/Raw/plfp05.0400.con'
                };
            root = 'PLFP05/171209on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp05.before3-coregis.txt'};
            details.markers(2).files = {'plfp05.before4-coregis.txt'};
        end
    case 'PLFP06'
        if ~on
            files = {
                'PLFP06/140110off/Raw/plfp06.0100.con',...
                'PLFP06/140110off/Raw/plfp06.0200.con'
                };
            root = 'PLFP06/140110off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp06.before4-coregis.txt'};
            details.markers(2).files = {'plfp06.before4-coregis.txt'};
        else
            files = {
                'PLFP06/140110on/Raw/plfp06.0300.con',...
                'PLFP06/140110on/Raw/plfp06.0400.con'
                };
            root = 'PLFP06/140110on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp06.before4-coregis.txt'};
            details.markers(2).files = {'plfp06.before4-coregis.txt'};
        end
        details.eventchannels = {'EEG157', 'EEG160'}; %severe tremor on EEG159
                    %might be possible to clean manually but leaving out
                    %for now
    case 'PLFP07'
        if on
        else
            files = {
                'PLFP07/250210/Raw/plfp07.0100.con',...
                'PLFP07/250210/Raw/plfp07.0200.con',...
                'PLFP07/250210/Raw/plfp07.0300.con'
                };
            root = 'PLFP07/250210/';
            sequence = {'R','STOP','MV'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp07.before1-coregis.txt','plfp07.after1-coregis.txt'};
            details.markers(2).files = {'plfp07.before2-coregis.txt'};
            details.markers(3).files = {'plfp07.before2-coregis.txt'};
        end
    case 'PLFP08'
        if on
        else
            files = {
                'PLFP08/250610/Raw/plfp08.0100.con',...
                'PLFP08/250610/Raw/plfp08.0200.con',...
                'PLFP08/250610/Raw/plfp08.0300.con',...
                'PLFP08/250610/Raw/plfp08.0400.con'
                };
            root = 'PLFP08/250610/';
            sequence = {'TEST','R','R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp08.before3-coregis.txt'};
            details.markers(2).files = {'plfp08.before3-coregis.txt'};
            details.markers(3).files = {'plfp08.before3-coregis.txt'};
            details.markers(4).files = {'plfp08.before3-coregis.txt'};
        end
    case 'PLFP09'
        if on
        else
            files = {
                'PLFP09/160710/Raw/plfp09.0100.con',...
                'PLFP09/160710/Raw/plfp09.0200.con',...
                'PLFP09/160710/Raw/plfp09.0300.con',...
                'PLFP09/160710/Raw/plfp09.0400.con'
                };
            root = 'PLFP09/160710/';
            sequence = {'AUDIO','R','STOP','MV'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp09.before2-coregis.txt'};
            details.markers(2).files = {'plfp09.before2-coregis.txt'};
            details.markers(3).files = {'plfp09.before3-coregis.txt'};
            details.markers(4).files = {'plfp09.after4-coregis.txt'};
        end
    case 'PLFP10'
        if on
        else
            files = {
                'PLFP10/230710/Raw/plfp10.0100.con',...
                'PLFP10/230710/Raw/plfp10.0200.con',...
                'PLFP10/230710/Raw/plfp10.0300.con',...
                'PLFP10/230710/Raw/plfp10.0400.con'
                };
            root = 'PLFP10/230710/';
            sequence = {'R', 'AUDIO', 'STOP', 'MV'};
            
            details.lfpthresh = 0.3;
            
            details.berlin = 1;
            
            details.markers(1).files = {'plfp10.before1-coregis.txt'};
            details.markers(2).files = {'plfp10.before2-coregis.txt'};
            details.markers(3).files = {'plfp10.before3-coregis.txt'};
            details.markers(4).files = {'plfp10.before4-coregis.txt'};
        end
    case 'PLFP11'
        if on
        else
            files = {
                'PLFP11/290710/Raw/plfp11.0100.con',...
                'PLFP11/290710/Raw/plfp11.0200.con',...
                'PLFP11/290710/Raw/plfp11.0300.con',...
                'PLFP11/290710/Raw/plfp11.0400.con'
                };
            root = 'PLFP11/290710/';
            sequence = {'TEST', 'R', 'STOP', 'MV'};
            
            details.lfpthresh = 0.3;
            
            details.berlin = 1;
            
            details.markers(1).files = {};
            details.markers(2).files = {'plfp11.before2-coregis.txt', 'plfp11.after2-coregis.txt'};
            details.markers(3).files = {'plfp11.before3-coregis.txt'};
            details.markers(4).files = {'plfp11.before4-coregis.txt'};
        end
    case 'PLFP12'
        if on
        else
            files = {
                'PLFP12/170910/Raw/plfp12.0100.con',...
                'PLFP12/170910/Raw/plfp12.0200.con',...
                'PLFP12/170910/Raw/plfp12.0300.con'
                };
            root = 'PLFP12/170910/';
            sequence = {'R','STOP','MV'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp12.before2-coregis.txt'};
            details.markers(2).files = {'plfp12.before2-coregis.txt'};
            details.markers(3).files = {'plfp12.before2-coregis.txt'};
        end
    case 'PLFP13'
        if ~on
            files = {
                'PLFP13/151010off/Raw/plfp13.0100.con',...
                'PLFP13/151010off/Raw/plfp13.0200.con'
                };
            root = 'PLFP13/151010off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp13.before1-coregis.txt'};
            details.markers(2).files = {'plfp13.after2-coregis.txt'};
        else
            files = {
                'PLFP13/151010on/Raw/plfp13.0300.con',...
                'PLFP13/151010on/Raw/plfp13.0400.con'
                };
            root = 'PLFP13/151010on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp13.before3-coregis.txt'};
            details.markers(2).files = {'plfp13.after4-coregis.txt'};
        end
    case 'PLFP14'
        if ~on
            files = {
                'PLFP14/121110off/Raw/plfp14.0100.con',...
                'PLFP14/121110off/Raw/plfp14.0200.con'
                };
            root = 'PLFP14/121110off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp14.before2-coregis.txt'};
            details.markers(2).files = {'plfp14.before2-coregis.txt'};
        else
            files = {
                'PLFP14/121110on/Raw/plfp14.0300.con',...
                'PLFP14/121110on/Raw/plfp14.0400.con'
                };
            root = 'PLFP14/121110on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp14.before3-coregis.txt'};
            details.markers(2).files = {'plfp14.before3-coregis.txt'};
        end
    case 'PLFP15' %PD with only OFF
        if on
        else
            files = {
                'PLFP15/131210/Raw/plfp15.0100.con',...
                'PLFP15/131210/Raw/plfp15.0200.con'
                };
            root = 'PLFP15/131210/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp15.before1-coregis.txt'};
            details.markers(2).files = {'plfp15.after2-coregis.txt'};
        end
    case 'PLFP16'
        if ~on
            files = {
                'PLFP16/110311off/Raw/plfp16.0100.con',...
                'PLFP16/110311off/Raw/plfp16.0200.con'
                };
            root = 'PLFP16/110311off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp16.before1-coregis.txt'};
            details.markers(2).files = {'plfp16.before1-coregis.txt'};
        else
            files = {
                'PLFP16/110311on/Raw/plfp16.0300.con',...
                'PLFP16/110311on/Raw/plfp16.0400.con'
                };
            root = 'PLFP16/110311on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp16.before4-coregis.txt'};
            details.markers(2).files = {'plfp16.before4-coregis.txt'};
        end
    case 'PLFP17'
        if ~on
            files = {
                'PLFP17/240311off/Raw/plfp17.0100.con',...
                'PLFP17/240311off/Raw/plfp17.0200.con'
                };
            root = 'PLFP17/240311off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp17.before2-coregis.txt'};
            details.markers(2).files = {'plfp17.after2-coregis.txt'};
        else
            files = {
                'PLFP17/240311on/Raw/plfp17.0300.con',...
                'PLFP17/240311on/Raw/plfp17.0400.con'
                };
            root = 'PLFP17/240311on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp17.before3-coregis.txt'};
            details.markers(2).files = {'plfp17.before3-coregis.txt'};
        end
    case 'PLFP18'
        if on
        else
            files = {
                'PLFP18/290311/Raw/plfp18.0100.con',...
                'PLFP18/290311/Raw/plfp18.0200.con',...
                'PLFP18/290311/Raw/plfp18.0300.con'
                };
            root = 'PLFP18/290311/';
            sequence = {'R','STOP','MV'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp18.after1b-coregis.txt'};
            details.markers(2).files = {'plfp18.before2-coregis.txt'};
            details.markers(3).files = {'plfp18.before2-coregis.txt'};
        end
    case 'PLFP19'
        if ~on
            files = {
                'PLFP19/290411off/Raw/plfp19.0100.con',...
                'PLFP19/290411off/Raw/plfp19.0200.con'
                };
            root = 'PLFP19/290411off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp19.before1-coregis.txt'};
            details.markers(2).files = {'plfp19.after1-coregis.txt'};
        else
            files = {
                'PLFP19/290411on/Raw/plfp19.0300.con',...
                'PLFP19/290411on/Raw/plfp19.0400.con'
                };
            root = 'PLFP19/290411on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp19.after3-coregis.txt'};
            details.markers(2).files = {'plfp19.after4-coregis.txt'};
        end
    case 'PLFP20'
        if on
        else
            files = {
                'PLFP20/050711/Raw/plfp20.0100.con',...
                'PLFP20/050711/Raw/plfp20.0200.con'
                };
            root = 'PLFP20/050711/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp20.before1-coregis.txt'};
            details.markers(2).files = {'plfp20.before2-coregis.txt', 'plfp20.after2-coregis.txt'};
        end
    case 'PLFP21'
        if ~on
            files = {
                'PLFP21/150711off/Raw/plfp21.0100.con',...
                'PLFP21/150711off/Raw/plfp21.0200.con'
                };
            root = 'PLFP21/150711off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp21.after1-coregis.txt'};
            details.markers(2).files = {'plfp21.before1-coregis.txt', 'plfp21.after2-coregis.txt'};
        else
            files = {
                'PLFP21/150711on/Raw/plfp21.0300.con',...
                'PLFP21/150711on/Raw/plfp21.0400.con'
                };
            root = 'PLFP21/150711on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp21.before3-coregis.txt'};
            details.markers(2).files = {'plfp21.before4-coregis.txt'};
        end
    case 'PLFP22'
        if on
        else
            files = {
                'PLFP22/111011/Raw/plfp22.0100.con',...
                'PLFP22/111011/Raw/plfp22.0200.con'
                };
            root = 'PLFP22/111011/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp22.before1-coregis.txt'};
            details.markers(2).files = {'plfp22.before1-coregis.txt'};
        end
    case 'PLFP23'
        if ~on
            files = {
                'PLFP23/170112off/Raw/plfp23.0100.con',...
                'PLFP23/170112off/Raw/plfp23.0200.con'
                };
            root = 'PLFP23/170112off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp23.before1-coregis.txt'};
            details.markers(2).files = {'plfp23.before2-coregis.txt'};
        else
            files = {
                'PLFP23/170112on/Raw/plfp23.0300.con',...
                'PLFP23/170112on/Raw/plfp23.0400.con'
                };
            root = 'PLFP23/170112on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp23.before3-coregis.txt', 'plfp23.after3-coregis.txt'};
            details.markers(2).files = {'plfp23.after4a-coregis.txt'};
        end
    case 'PLFP24'
        if ~on
            files = {
                'PLFP24/280212off/Raw/plfp24.0100.con',...
                'PLFP24/280212off/Raw/plfp24.0200.con'
                };
            root = 'PLFP24/280212off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp24.before1-coregis.txt'};
            details.markers(2).files = {'plfp24.before2-coregis.txt'};
        else
            files = {
                'PLFP24/280212on/Raw/plfp24.0300.con',...
                'PLFP24/280212on/Raw/plfp24.0400.con'
                };
            root = 'PLFP24/280212on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp24.before3-coregis.txt','plfp24.after3-coregis.txt'};
            details.markers(2).files = {'plfp24.after4-coregis.txt'};
        end
    case 'PLFP25'
        if on
        else
            files = {
                'PLFP25/220312/Raw/plfp25.0100.con',...
                'PLFP25/220312/Raw/plfp25.0200.con'
                };
            root = 'PLFP25/220312/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp25.before2-coregis.txt'};
            details.markers(2).files = {'plfp25.before2-coregis.txt'};
        end
    case 'PLFP26'
        if ~on
            files = {
                'PLFP26/310512off/Raw/plfp26.0100.con',...
                'PLFP26/310512off/Raw/plfp26.0200.con'
                };
            root = 'PLFP26/310512off/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp26.before1-coregis.txt'};
            details.markers(2).files = {'plfp26.after2-coregis.txt'};
        else
            files = {
                'PLFP26/310512on/Raw/plfp26.0300.con',...
                'PLFP26/310512on/Raw/plfp26.0400.con'
                };
            root = 'PLFP26/310512on/';
            sequence = {'R','STOP'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp26.before3-coregis.txt'};
            details.markers(2).files = {'plfp26.after4-coregis.txt'};
        end
        
    case 'PLFP37'
        if on
        
            files = {
                'PLFP37/plfp37.0100.con',...
                'PLFP37/plfp25.0200.con',...
                'PLFP37/plfp25.0300.con'
                };
            root = 'PLFP25/220312/';
            sequence = {'R','EMOTION1','EMOTION2'};
            details.lfpthresh = 0.3;
            details.berlin = 1;
            details.markers(1).files = {'plfp37.0200.pfp5_emot5.log'};
            details.markers(2).files = {'plfp37.0300.pfp5_emot5.log'};
        end
end

for f=1:length(files)
    files{f} = fullfile(dbsroot, files{f});
end

root = fullfile(outroot, root);

details.chan = chan;
details.montage = montage;


