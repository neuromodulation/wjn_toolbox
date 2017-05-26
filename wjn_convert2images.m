function [img,mimg,folder] = wjn_convert2images(file,conditions,channels,timewin,freqwin)
% [img,ming] = wjn_convert2images(file,conditions,channels,timewin,freqwin);

    D=spm_eeg_load(file);
if ~exist('timewin','var') || isempty(timewin)
    timewin = [-Inf Inf];
end

if ~exist('freqwin','var') || isempty(freqwin)
    freqwin = [-Inf Inf];
end
ichannels = channels;
channels = channel_finder(channels,D.chanlabels);
conditions = channel_finder(conditions,D.condlist);


clear matlabbatch
for a = 1:length(channels);
matlabbatch{1}.spm.meeg.images.convert2images.D = {file};
matlabbatch{1}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{1}.spm.meeg.images.convert2images.conditions = conditions;
matlabbatch{1}.spm.meeg.images.convert2images.channels{1}.chan = channels{a};
matlabbatch{1}.spm.meeg.images.convert2images.timewin = timewin;
matlabbatch{1}.spm.meeg.images.convert2images.freqwin = freqwin;
matlabbatch{1}.spm.meeg.images.convert2images.prefix = '';
spm_jobman('run',matlabbatch);
[cdir,fname] = fileparts(file);
if isempty(cdir)
    cdir = cd;
end
for b = 1:length(conditions);
    img{a,b} = fullfile(cdir,fname,[channels{a} '_' conditions{b} '_' fname '.nii']);
    movefile(fullfile(cdir,fname,['condition_' conditions{b} '.nii']),img{a,b},'f')
end
end

matlabbatch{1}.spm.meeg.images.convert2images.D = {file};
matlabbatch{1}.spm.meeg.images.convert2images.mode = 'time x frequency';
matlabbatch{1}.spm.meeg.images.convert2images.conditions = conditions;
matlabbatch{1}.spm.meeg.images.convert2images.channels{1}.all = 'all';
matlabbatch{1}.spm.meeg.images.convert2images.timewin = timewin;
matlabbatch{1}.spm.meeg.images.convert2images.freqwin = freqwin;
matlabbatch{1}.spm.meeg.images.convert2images.prefix = '';
spm_jobman('run',matlabbatch);
cd(fullfile(cdir,fname));
for b = 1:length(conditions);
    mimg{b} = fullfile(cdir,fname,['mean_' conditions{b} '_' fname '.nii']);
    movefile(fullfile(cdir,fname,['condition_' conditions{b} '.nii']),mimg{b},'f')

    if numel(ichannels) <= numel(channels);
        mkdir(fullfile(cdir,['images_' conditions{b}]))
        for c = 1:length(ichannels);
            [images,folder]=ffind(fullfile(cdir,fname,[ichannels{c} '*' conditions{b} '*.nii']));
            wjn_image_averager(images,[ichannels{c} '_' conditions{b} '_' fname '.nii'])
            copyfile(fullfile(cdir,fname,[ichannels{c} '_' conditions{b} '_' fname '.nii']),fullfile(cdir,['images_' conditions{b}],[ichannels{c} '_' conditions{b} '_' fname '.nii']))
            
        end
    end
end
cd(cdir)
folder = fullfile(cdir,fname);
    

    
