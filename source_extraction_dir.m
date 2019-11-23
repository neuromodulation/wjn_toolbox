function source_extraction_dir(folder,file,condition,emgchans,lfpchans,position,freqrange,target_name,source_name,radius,side)
% source_extraction(folder,file,condition,emgchans,lfpchans,position,freqra
% nge,target_name,source_name,freqd [Hz],timewin [s]);
if ~exist('freqd','var')
    freqd = 300;timewin=3.41;
end

if ~exist('radius','var')
    radius = 15;
end

if ~exist(folder,'dir')
    mkdir(folder)
end
root = cd;
cd(folder);
D=spm_eeg_load(file);
[~,ID,~]=fileparts(file);
if ~iscell(lfpchans);
    lfpchans=cellstr(lfpchans);
end
% if numel(lfpchans) >=2;
%     subfolder = [source_name '-' target_name];
% else
% 
%     subfolder = [lfpchans{1} '_' source_name '-' target_name];
% end
% subfolder = ['source_extraction_' side];
imfolder = fullfile(folder,'images')
% mkdir(subfolder);
mkdir(imfolder)

[~,name,~]=fileparts(file);
matlabbatch{1}.spm.tools.beamforming.data.dir = {fullfile(folder)};
matlabbatch{1}.spm.tools.beamforming.data.D = {file};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'sensors';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
for a = 1:size(position,1);
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(a).label = source_name{a} ;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(a).pos = position(a,:);
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(a).ori = [0 0 0];
end
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.radius = radius;
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
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{1}.all = 'all';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{1}.type = 'EMG';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{2}.type = 'LFP';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{2}.type = 'MEG';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';
spm_jobman('run',matlabbatch);

%%

[ffolder,ffile,fext] = fileparts(file);
S = [];
S.outfile = fullfile(folder,['B' ffile fext]);
S.D = fullfile(ffolder,['B' ffile fext]);
D=spm_eeg_copy(S);
delete(fullfile(ffolder,['B' ffile '.*']));
snames = source_name;

for a = 1:length(snames);
    source_name = snames{a};
if ~isempty(emgchans);
%     D=spm_eeg_load(['B' D.fname]);
    %%
    S=[];
    S.D = D.fname;
    S.condition = condition;
    S.channels = {source_name,lfpchans{1:length(lfpchans)},emgchans{1:length(emgchans)}};
    S.freq = freqrange;
    S.freqd = freqd;
    S.timewin = timewin;
    C=spm_eeg_fft_dir(S);

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
    legend(strrep(target_name,'_',' '),strrep(source_name,'_',' '),'EMG');
    xlim(freqrange);ylim([0 12]);
    figone(7);
    title(strrep(ID,'_',' '));
    myprint(['Mean_' num2str(freqrange(1)) '_' num2str(freqrange(2)) 'Hz_' name '_' condition '_' source_name '_and_' target_name '_PowerSpectrum'])

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(lfpchans);
        combinations = {source_name,lfpchans{a}};
        S.combinations = [S.combinations;combinations];
    end
    S.mcombinations = {source_name,target_name};
    close
    spm_eeg_coh_combinations(S);
    hold on;
    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    legend(strrep(ID,'_',' '));
    myprint(fullfile(imfolder,['Mean_' num2str(freqrange(1)) '_' num2str(freqrange(2)) 'Hz_' name  '_' condition '_' source_name '_to_' target_name '_Coherence']));

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(emgchans);
        combinations = {source_name,emgchans{a}};
        S.combinations = [S.combinations;combinations];
    end
    S.mcombinations = {source_name,'EMG'};
    spm_eeg_coh_combinations(S);
    title(strrep(ID,'_',' '));
    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    myprint(fullfile(imfolder,['Mean_'  num2str(freqrange(1)) '_' num2str(freqrange(2)) 'Hz_' name '_'  condition '_' source_name '_to_EMG_Coherence']));

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
    title(strrep(ID,'_',' '));
    ylim([0 0.3]);
    myfont(gca);
    figone(7);
    myprint(fullfile(imfolder,['Mean_'  num2str(freqrange(1)) '_' num2str(freqrange(2)) 'Hz_' name '_'  condition '_' target_name '_to_EMG_Coherence']));

%     cd(root);
    
else
%     D=spm_eeg_load(['B' D.fname]);
    %%
    S=[];
    S.D = D.fullfile;
    S.condition = condition;
    S.channels = {source_name,lfpchans{1:length(lfpchans)}};
    S.freq = freqrange;
    S.freqd = freqd;
    S.timewin = timewin;
    C=spm_eeg_fft_dir(S);

    %%
%     epow = mean(C.rpow(channel_indicator(emgchans,C.channels),:),1)
if isfield(C,'rpow')
      lpow = mean(C.rpow(channel_indicator(lfpchans,C.channels),:),1);
    spow = C.rpow(channel_indicator(source_name,C.channels),:);
else
    lpow = mean(C.mpow(channel_indicator(lfpchans,C.channels),:),1);
    spow = C.mpow(channel_indicator(source_name,C.channels),:);
end
%     figure;
%     plot(C.f,lpow,'LineWidth',2,'color','k');hold on;
%     plot(C.f,spow,'color','r','LineWidth',2);myfont(gca);
% %     myline(C.f,epow,'color','g','LineWidth',1);
%     ylabel('Relative spectral power [%]');
%     xlabel('Frequency [Hz]')
%     legend(strrep(target_name,'_',' '),strrep(source_name,'_',' '));
%     xlim(freqrange);ylim([0 12]);xlim(freqrange)
%     figone(7);
%     title(strrep(ID,'_',' '));
%     myprint(fullfile(imfolder,['Mean_'  num2str(freqrange(1)) '_' num2str(freqrange(2)) 'Hz_' name '_'  condition '_' source_name '_and_' target_name '_PowerSpectrum']))

    S=[];
    S.D = C.fname;combinations =[];S.combinations = [];
    for a = 1:numel(lfpchans);
        combinations = {source_name,lfpchans{a}};
        S.combinations = [S.combinations;combinations];
    end
    S.type = 'coh';
    S.mcombinations = {source_name,target_name};
    close
    spm_eeg_coh_combinations(S);
%     hold on
%     legend(strrep(ID,'_',' '));
%     ylim([0 0.3]);xlim(freqrange);
%     myfont(gca);
%     figone(7);
%     myprint(fullfile(imfolder,['Mean_'  num2str(freqrange(1)) '_' num2str(freqrange(2)) 'Hz_' name '_'  condition '_' source_name '_to_' target_name '_Coherence']));
%     
end
end
cd(root);
