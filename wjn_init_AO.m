function [chanlabels,fs]=wjn_init_AO(fname,startstop,chans)
if ~exist('startstop','var') || startstop == 1
    
    
    addpath('C:\Program Files (x86)\AlphaOmega\Neuro Omega System SDK\MATLAB_SDK')
    DspMac  = 'F4:5E:AB:6B:6D:A1';value = AO_DefaultStartConnection(DspMac);
    for j=1:100;pause(1);ret = AO_IsConnected;if ret ==1;fprintf('Laptop connected to Alphaomega');break;end;end
    chans = 10015+[1:16];
    buffersize = 10000;
    if exist('chans','var')
     
        if chans(1) < 10000
            chans = chans+10015;
        end
        
        info=AO_GetChannelsInformation;
       
        for a = 1:length(chans)
            i = find([info(:).channelID]==chans(a));
            chanlabels{a} = strrep(strrep(info(i).channelName,' ','_'),'/','_');
        end
        fs=1375;

        for i=1:length(chans)
            AO_AddBufferingChannel(chans(i),buffersize)
        end
    else
        chanlabels=[];
        fs=[];
    end
    AO_SetSaveFileName(fname);AO_StartSave();
    
else
    AO_StopSave()
    AO_CloseConnection()
end