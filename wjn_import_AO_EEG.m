function [D,Db] = wjn_import_AO_EEG(filename,channels)

if ~exist('channels','var')
    for a = 1:32
    channels{a} = ['LFP' num2str(a)];
    end
end
cchannels ={};
for a = 1:32
        if a <10 
            cchannels{a} = ['CECOG_LF_1___0' num2str(a)];
        elseif (a>16 && a<=25)
            cchannels{a} = ['CEEG_2___0' num2str(a-16)];
        elseif a>24
            cchannels{a} = ['CEEG_2___' num2str(a-16)];
        else
            cchannels{a} = ['CECOG_LF_1___' num2str(a)];
        end

end

d = load(filename);

fields = fieldnames(d);

for a = 1:length(cchannels)
    data(a,:,1) = d.(cchannels{a});
end

fsample = d.CECOG_LF_1___01_KHz*1000;
timewin = [d.CECOG_LF_1___01_TimeBegin d.CECOG_LF_1___01_TimeEnd];
T = linspace(timewin(1), timewin(2), size(data,2));
t = linspace(0,size(data,2)/fsample,size(data,2));


iSF = ci({'CANALOG','CStim','Ports','Channel','SF'},fields);

for a = 1:length(iSF)
    info.(fields{iSF(a)}) = d.(fields{iSF(a)});
end


D=wjn_import_rawdata(['spmeeg_' filename],data,channels, fsample);
info.T = T;
D.AO = info;
save(D)

if isfield(D.AO,'CStimMarker_1')
    S = D.AO.SF_STIM_PARAMS;
    D.AO.STIM_ONSET = S(1,2:end)/(D.AO.SF_STIM_PARAMS_KHz*1000)-D.AO.T(1);
    D.AO.STIM_OFFSET = S(10,2:end)/1000+D.AO.STIM_ONSET;
    D.AO.STIM_CHANNEL = D.chanlabels(S(2,2:end)-10015);
    D.AO.STIM_CHANLIST = unique(D.chanlabels(S(2,2:end)-10015));
    D.AO.STIM_AMP = S(5,2:end);
    D.AO.STIM_FREQ = S(11,2:end);
    D.AO.STIM_PULSEWIDTH = S(6);  
    D.AO.STIM_EVENT_ON = strrep(strcat({'STIM_ON_'},num2str(D.AO.STIM_FREQ'),{'Hz_'},D.AO.STIM_CHANNEL',{'_'},num2str(D.AO.STIM_AMP'),{'uA'}),' ','');
    D.AO.STIM_EVENT_OFF = strrep(strcat({'STIM_OFF_'},num2str(D.AO.STIM_FREQ'),{'Hz_'},D.AO.STIM_CHANNEL',{'_'},num2str(D.AO.STIM_AMP'),{'uA'}),' ','');

end

save(D);


