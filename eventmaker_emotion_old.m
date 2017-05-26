
[filename,pathname,filter] = uigetfile({'*.smr','spike file (*.smr)';'*.mat','spike Matlab file (*.mat)'})
Fs = 1000
eventchannel = 'analog2'
startpoint = -3000;
endpoint = 7000;

if ~strcmp([cd '\'],pathname);
    cd(pathname);
end

matname = filename(1:length(filename)-4);

if filter ==1;
    son2spikematlab(filename);
end


load(matname,eventchannel);

data = eval([eventchannel '.values']);

[channels]=findLFPchannel(matname);

[negCUE,neuCUE,posCUE,bepCUE] = cuefinder_emotion(data);
[negCUE]=makeeventchannel(negCUE,'negCUE',Fs);
[neuCUE]=makeeventchannel(neuCUE,'neuCUE',Fs);
[posCUE]=makeeventchannel(posCUE,'posCUE',Fs);
[bepCUE]=makeeventchannel(bepCUE,'bepCUE',Fs);

save(matname,'negCUE','neuCUE','posCUE','bepCUE','-append')
eventname = {'negCUE','neuCUE','posCUE','bepCUE'};
spm_eeg_spikematconvert_cmd(matname,channels,eventname,startpoint,endpoint)