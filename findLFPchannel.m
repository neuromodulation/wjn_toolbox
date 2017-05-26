function [channels]=findLFPchannel(filename)

close all;
display('Finding LFP channels');
chnnames = {'STNL01','STNL12','STNL23','STNR01','STNR12','STNR23','GPL01','GPL12','GPL23','GPR01','GPR12','GPR23','lGP01','lGP12','lGP23','rGP01','rGP12','rGP23','CMPfR01','CMPfR12','CMPfR23','CMPfR03','CMPfL01','CMPfL12','CMPfL23','CMPfL03','VPLR01','VPLR12','VPLR23','VPLR03','VPLL01','VPLL12','VPLL23','VPLL03','PPNR01','PPNR12','PPNR23','PPNL01','PPNL12','PPNL23','VIMR01','VIMR12','VIMR23','VIML01','VIML12','VIML23'};
chn=who('-file',filename);
n=0;
for a = 1:length(chnnames);
    findn=find(strcmpi(chnnames{a},chn));
    if find(findn) > 0;
        n=n+1;
        channels{n} = chn{findn};
        
    end
end
display(filename);
display(channels);