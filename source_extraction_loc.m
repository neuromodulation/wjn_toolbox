function source_extraction_loc(folder,file,condition,lfpchans,position,target_name,source_name,radius)
% source_extraction(folder,file,condition,emgchans,lfpchans,position,freqra
% nge,target_name,source_name);
root = cd;
cd(folder);
D=spm_eeg_load(file);

[~,fn,~]=fileparts(D.fname);
if ~iscell(lfpchans);
    lfpchans=cellstr(lfpchans);
end
% if numel(lfpchans) >=2;
    subfolder = fn;
% else
% 
%     subfolder = [lfpchans{1} '_' source_name '-' target_name];
% end
mkdir(subfolder);

matlabbatch{1}.spm.tools.beamforming.data.dir = {fullfile(folder,subfolder)};
matlabbatch{1}.spm.tools.beamforming.data.D = {file};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
for a = 1:size(position,1);
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(a).label = [source_name '_' lfpchans{a}];
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(a).pos = position(a,:);
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(a).ori = [0 0 0];
end
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.radius = radius;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.resolution = 5;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
matlabbatch{3}.spm.tools.beamforming.features.modality = {'MEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.foi = [0 Inf];
matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.taper = 'hanning';
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = false;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.woi = [-Inf Inf];
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.method = 'max';
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'write';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'MEG';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{1}.type = 'LFP';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';
spm_jobman('run',matlabbatch);

%%
[ffolder,ffile,fext] = fileparts(file);
S = [];
S.outfile = fullfile(folder,subfolder,['B' ffile fext]);
S.D = fullfile(ffolder,['B' ffile fext]);
D=spm_eeg_copy(S);
delete(fullfile(ffolder,['B' ffile '.*']));
emgchans =[];
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
    plot(C.f,lpow,'LineWidth',2);hold on;
    plot(C.f,spow,'color','r','LineWidth',2);myfont(gca);
    plot(C.f,epow,'color','g','LineWidth',1);
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
%     D=spm_eeg_load([D.fname]);
    %%
    schans = D.chanlabels(channel_indicator(source_name,D.chanlabels));
    S=[];
    S.D = D.fname;
    S.condition = condition;
    S.channels = {schans{1:length(schans)},lfpchans{1:length(lfpchans)}};
    S.freq = [1 100];
    S.freqd = 300;
    S.timewin = 3.41;
    C=spm_eeg_fft(S);

    %%
%     epow = mean(C.rpow(channel_indicator(emgchans,C.channels),:),1)
    lpow = mean(C.rpow(channel_indicator(lfpchans,C.channels),:),1);
    spow = mean(C.rpow(channel_indicator(schans,C.channels),:),1);

    figure;
    plot(C.f,lpow,'LineWidth',2);hold on;
    plot(C.f,spow,'color','r','LineWidth',2);myfont(gca);
%     plot(C.f,epow,'color','g','LineWidth',1);
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
%%
end
