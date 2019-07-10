function D=wjn_tf_wavelet(filename,f,nfsample,channels,analogchannels,timewin)
if ~exist('f','var')
    f=1:100;
end



D=spm_eeg_load(filename);
if ~exist('nfsample','var')
    subsample = 1;
else
    subsample = round(D.fsample/nfsample);
end
% spm eeg
matlabbatch = [];
matlabbatch{1}.spm.meeg.tf.tf.D = {filename};
if ~exist('channels','var')
    matlabbatch{1}.spm.meeg.tf.tf.channels{1}.type = 'EEG';
    matlabbatch{1}.spm.meeg.tf.tf.channels{2}.type = 'LFP';
else
    if isnumeric(channels)
        channels = D.chanlabels(channels);
    else
        channels = channel_finder(channels,D.chanlabels,2);
    end
    for a=1:length(channels)
        matlabbatch{1}.spm.meeg.tf.tf.channels{a}.chan =channels{a};
    end
        
end
matlabbatch{1}.spm.meeg.tf.tf.frequencies = f;
if exist('timewin','var')
    matlabbatch{1}.spm.meeg.tf.tf.timewin = timewin;
    it = D.indsample(timewin(1)/1000):D.indsample(timewin(2)/1000);
else
    matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
    it = 1:D.nsamples;
end
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.ncycles = 8;
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.timeres = 0;
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.subsample = subsample;
matlabbatch{1}.spm.meeg.tf.tf.phase = 0;
matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
spm_jobman('run',matlabbatch)
[dir,fname,~]=fileparts(filename);
% keyboard

if ~exist('analogchannels','var')
    analogchannels = {'rota','AO','force','audio','audio_env','x','y','z','maze','btn','stim','joy','emg'};
elseif isnumeric(analogchannels)
        analogchannels = D.chanlabels(analogchannels);
end

 i = unique(ci(analogchannels,D.chanlabels,1));

Dtf=spm_eeg_load(fullfile(dir,['tf_' fname '.mat']));


for a = 1:length(i)
    clear ad
    for b = 1:Dtf.ntrials
        ad(a,:,b) = resample(squeeze(D(i(a),it,b)),D.time(it),Dtf.fsample);
    end

    Dtf.analog.(strrep(D.chanlabels{i(a)},'-','_')) = ad(a,:,:);
end
        
save(Dtf)
D=Dtf;