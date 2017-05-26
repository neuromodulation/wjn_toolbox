function channels = lfpfinder(filename,lfponly)
%lfponly 1 = only lfp 2 = lfp + eeg 3 = lfp + emg 4 = lfp + emg + eeg
n=0;
% matname = [filename '.mat'];
close all;
display('Finding LFP channels');
if ~exist('lfponly','var');
    lfponly = 0;
end

lfpnames = {'STNL01','STNL12','STNL23','STNR01','STNR12','STNR23',...
            'GPL01','GPL12','GPL23','GPR01','GPR12','GPR23','lGP01',...
            'lGP12','lGP23','rGP01','rGP12','rGP23',...
            'CMPfR01','CMPfR12','CMPfR23','CMPfR03','CMPfL01','CMPfL12','CMPfL23','CMPfL03',...
            'VPLR01','VPLR12','VPLR23','VPLR03','VPLL01','VPLL12','VPLL23','VPLL03',...
            'PPNR01','PPNR12','PPNR23','PPNL01','PPNL12','PPNL23',...
            'VIMR01','VIMR12','VIMR23','VIML01','VIML12','VIML23',...
            'GPiR01','GPiR12','GPiR23','GPiL01','GPiL12','GPiL23'};
eegnames = {'C3','C4','Cz','Fz','Pz'};
emgnames = {'EGM1','EMG1','EMG','EGM2','EMG2','ECU','FCR'};

if lfponly == 1
       chnnames = lfpnames;
elseif lfponly == 2
    chnnames = [lfpnames,eegnames];
elseif lfponly == 3
    chnnames = [lfpnames,emgnames];
elseif lfponly == 4
    chnnames = [lfpnames,emgnames,eegnames];
end

    chn=who('-file',filename);
for a = 1:length(chnnames);
    findn=find(strcmpi(chnnames{a},chn));
    if find(findn) > 0;
        n=n+1;
        channels{n} = chn{findn};
        
    end
end
clear chn chnnames findn n
display(filename);
display(channels);