function source_extraction_gpi(folder,file,condition,lfpchans,position,freqrange,target_name,source_name)
% source_extraction(folder,file,condition,emgchans,lfpchans,position,freqra
% nge,target_name,source_name);
root = cd;
cd(folder);
D=spm_eeg_load(file);


if ~iscell(lfpchans);
    lfpchans=cellstr(lfpchans);
end
if numel(lfpchans) >=2;
    subfolder = [source_name '-' target_name];
else

    subfolder = [lfpchans{1} '_' source_name '-' target_name];
end
mkdir(subfolder);

matlabbatch{1}.spm.tools.beamforming.data.dir = {fullfile(folder,subfolder)};
matlabbatch{1}.spm.tools.beamforming.data.D = {file};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'sensors';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef.label = source_name;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef.pos = position;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef.ori = [0 0 0];
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.radius = 0;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.resolution = 5;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = {condition};
matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.foi = freqrange;
matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.taper = 'hanning';
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv = struct([]);
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.woi = [-Inf Inf];
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.method = 'max';
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'write';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'MEG';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{1}.type = 'EMG';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{2}.type = 'LFP';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';
spm_jobman('run',matlabbatch);

%%
[ffolder,ffile,fext] = fileparts(file);
S = [];
S.outfile = fullfile(folder,subfolder,['B' ffile fext]);
S.D = fullfile(ffolder,['B' ffile fext]);
D=spm_eeg_copy(S);
delete(fullfile(ffolder,['B' ffile '.*']));
if ~isempty(emgchans);
%     D=spm_eeg_load(['B' D.fname]);
    %%
    S=[];
    S.D = D.fname;
    S.condition = condition;
    S.channels = {source_name,lfpchans{1:length(lfpchans)},emgchans{1:length(emgchans)}};
    S.freq = [1 100];
    S.freqd = 300;
    S.timewin = 3.41;
    C=spm_eeg_fft(S);

    %%
    epow = mean(C.rpow(channel_indicator(emgchans,C.channels),:),1)
    lpow = mean(C.rpow(channel_indicator(lfpchans,C.channels),:),1);
    spow = C.rpow(channel_indicator(source_name,C.channels),:);

    figure;
    myline(C.f,lpow,'LineWidth',2);hold on;
    myline(C.f,spow,'color','r','LineWidth',2);myfont(gca);
    myline(C.f,epow,'color','g','LineWidth',1);
    ylabel('Relative spectral power [%]');
    xlabel('Frequency [Hz]')
    legend(target_name,source_name,'EMG');
    xlim([3 40]);ylim([0 12]);
    figone(7);
    myprint(['Mean_' condition '_' source_name '_and_' target_name '_PowerSpectrum'])

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(lfpchans);
        combinations = {source_name,lfpchans{a}};
        S.combinations = [S.combinations;combinations];
    end
    S.mcombinations = {source_name,target_name};
    spm_eeg_coh_combinations(S);

    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    myprint(['Mean_' condition '_' source_name '_to_' target_name '_Coherence']);

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(emgchans);
        combinations = {source_name,emgchans{a}};
        S.combinations = [S.combinations;combinations];
    end
    S.mcombinations = {source_name,'EMG'};
    spm_eeg_coh_combinations(S);

    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    myprint(['Mean_' condition '_' source_name '_to_EMG_Coherence']);

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(emgchans);
        for b = 1:numel(lfpchans);
        combinations = {lfpchans{b},emgchans{a}};
        S.combinations = [S.combinations;combinations];
        end
    end
    S.mcombinations = {target_name,'EMG'};
    spm_eeg_coh_combinations(S);

    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    myprint(['Mean_' condition '_' target_name '_to_EMG_Coherence']);

    cd(root);
    
else
%     D=spm_eeg_load(['B' D.fname]);
    %%
    S=[];
    S.D = D.fname;
    S.condition = condition;
    S.channels = {source_name,lfpchans{1:length(lfpchans)}};
    S.freq = [1 100];
    S.freqd = 300;
    S.timewin = 3.41;
    C=spm_eeg_fft(S);

    %%
%     epow = mean(C.rpow(channel_indicator(emgchans,C.channels),:),1)
    lpow = mean(C.rpow(channel_indicator(lfpchans,C.channels),:),1);
    spow = C.rpow(channel_indicator(source_name,C.channels),:);

    figure;
    myline(C.f,lpow,'LineWidth',2);hold on;
    myline(C.f,spow,'color','r','LineWidth',2);myfont(gca);
%     myline(C.f,epow,'color','g','LineWidth',1);
    ylabel('Relative spectral power [%]');
    xlabel('Frequency [Hz]')
    legend(target_name,source_name);
    xlim([3 40]);ylim([0 12]);
    figone(7);
    myprint(['Mean_' condition '_' source_name '_and_' target_name '_PowerSpectrum'])

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(lfpchans);
        combinations = {source_name,lfpchans{a}};
        S.combinations = [S.combinations;combinations];
    end
    S.mcombinations = {source_name,target_name};
    spm_eeg_coh_combinations(S);

    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    myprint(['Mean_' condition '_' source_name '_to_' target_name '_Coherence']);
end
