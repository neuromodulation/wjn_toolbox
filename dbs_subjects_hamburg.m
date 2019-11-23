function [files, sequence, root, details] =dbs_subjects_hamburg(initials, on)


dbsroot = '/Users/vlitvak/DBS-MEG';
outroot = '/Users/vlitvak/DBS-MEG';


details = struct(...
    'cont_head_loc', 1,...
    'brainamp', 1,...
    'bipolar', 0,...
    'badchanthresh', 0.2, ...
    'hamburg', 1,...
    'berlin', 0,...
    'oxford',0,...
    'mridir', fullfile(dbsroot, initials, 'MRI'));

chan = {'LFP_R12', 'LFP_R23', 'LFP_R34', 'LFP_R45', 'LFP_R56', 'LFP_R67', 'LFP_R78',...
    'LFP_L12', 'LFP_L23', 'LFP_L34', 'LFP_L45', 'LFP_L56', 'LFP_L67', 'LFP_L78'};
        
details.lfptocheck = chan;


if details.hamburg
    details.chanset      = fullfile(dbsroot, 'SPM','dbs_meg_channels_hamburg.mat');
    details.eventtype    = 'UPPT001_up';
    details.eventchannel = 'SCLK01';
    details.lfpthresh = 20;
    montage = load(fullfile(dbsroot, 'SPM','hamburg_montage.mat'));
end

details.chanset = getfield(load(details.chanset), 'label');

name = fieldnames(montage);
montage = getfield(montage, name{1});


details.fiducials = fullfile(dbsroot, initials, 'MRI', [initials '_smri_fid.txt']);

switch initials
    case 'HB00'
        if on
            files = {
                '/HB00/Raw/test_BrainampDBS_20140609_01.ds',...
                };
            root = '/HB00/';
            sequence = {'R'};
        else
        end
end

for f=1:length(files)
    files{f} = fullfile(dbsroot, files{f});
end

root = fullfile(outroot, root);

details.chan = chan;
details.montage = montage;


