function [COH]=wjn_recon_peakpower(filename,measures,freqbands,bandfreqs)
disp('IDENTIFY POWER SPECTRAL PEAKS.')
try
    D=spm_eeg_load(filename);
    COH=D.COH;
catch
    D=filename;
    try
        COH=D.COH;
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
bandpeaks.channels = COH.channels;
bandpeaks.freqbands=freqbands;
bandpeaks.bandfreqs = bandfreqs;
bandpeaks.measures = measures;
pre={'npeaks','freq','amp','width'};
for a = 1:length(measures)
    for b = 1:length(pre)
         bandpeaks.(measures{a}).(pre{b})=nan(length(COH.channels),length(freqbands));
    end
end
for a = 1:length(measures)
    for b = 1:length(COH.channels)
        for c = 1:length(freqbands)
         [m,i,w]=findpeaks(COH.(measures{a})(b,:),'Minpeakdistance',wjn_sc(COH.f,3)-wjn_sc(COH.f,1));
          irm=[find(COH.f(i)<bandfreqs(c,1)) find(COH.f(i)>bandfreqs(c,2))];
         i(irm)=[];m(irm)=[];w(irm)=[];
         if ~isempty(m)
            [mm,mi]=nanmax(m);
            bandpeaks.(measures{a}).npeaks(b,c) = length(i);
            bandpeaks.(measures{a}).allfreqs{b,c} = COH.f(i);
            bandpeaks.(measures{a}).allamps{b,c} = m;
            bandpeaks.(measures{a}).allwidths{b,c} = COH.f(round(w));
            bandpeaks.(measures{a}).freq(b,c) = COH.f(i(mi));
            bandpeaks.(measures{a}).amp(b,c) = mm;
            bandpeaks.(measures{a}).width(b,c) = w(mi);
         else
            bandpeaks.(measures{a}).npeaks(b,c) = nan;
            bandpeaks.(measures{a}).allfreqs{b,c} = nan;
            bandpeaks.(measures{a}).allamps{b,c} = nan;
            bandpeaks.(measures{a}).allwidths{b,c} = nan;
            bandpeaks.(measures{a}).freq(b,c) = nan;
            bandpeaks.(measures{a}).amp(b,c) = nan;
            bandpeaks.(measures{a}).width(b,c) = nan;
         end
        end
    end
end
COH.bandpeaks = bandpeaks;
try
    D.COH=COH;
    save(D)
end