function [COH,bandaverage]=wjn_recon_bandaverage(filename,measures,freqbands,bandfreqs)
disp('COMPUTE BAND AVERAGES.')
try
    D=spm_eeg_load(filename);
    try
        COH=D.COH;
    catch
        [~,COH]=wjn_recon_power(D.fullfile);
    end
catch
    D=filename;
    try
        try
            COH=D.COH;
        catch
            [~,COH]=wjn_recon_power(D.fullfile);
        end
    catch
        COH=D;
    end
end

if ~exist('freqbands','var')
    freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};
    bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];
end
if ~exist('measures','var')
    measures = {'mpow','rpow','logfit'};
end

if isfield(COH,'bandaverage')
    bandaverage = COH.bandaverage;
else
    bandaverage.measures =[];
end

for b = 1:length(measures)
    nchans = size(COH.(measures{b}),1);
    if nchans == length(COH.channels)
        chans = COH.channels;
    else
        chans = COH.cchannels;
    end
    for a = 1:length(chans)
  
        for c = 1:length(freqbands)
            
           bandaverage.(measures{b})(a,c) = nanmean(COH.(measures{b})(a,wjn_sc(COH.f,bandfreqs(c,1):bandfreqs(c,2))),2);
        end
    end
end
bandaverage.freqbands = freqbands;
bandaverage.bandfreqs = bandfreqs;
bandaverage.measures = unique([measures,bandaverage.measures]);
bandaverage.channels = COH.channels;
if isfield(COH,'cchannels')
    bandaverage.cchannels = COH.cchannels;
end
COH.bandaverage = bandaverage;
try
    save(D)
end