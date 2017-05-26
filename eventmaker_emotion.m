function eventmaker_emotion(S)

SVNrev = ' Julian ';
%--------------------------------------------------------------------------
spm('FnBanner', mfilename, SVNrev);
spm('FigName','M/EEG baseline statistics'); spm('Pointer','Watch');


try
    matname = S.D;
catch
    [S.D, sts] = spm_select(1, 'mat', 'Select M/EEG mat files');
    if ~sts, D = []; return; end 
end

if ~isfield(S,'eventchannel');
    pc = who('-file',S.D);
    ec = listdlg('ListString',pc,'PromptString','Choose event channel: ','SelectionMode','single');
    S.eventchannel = pc{ec};
end

if ~isfield(S,'channels');
    wc = listdlg('ListString',pc,'PromptString','Choose waveform channels: ');
    S.channels = pc(wc);
end

data = load(S.D,S.eventchannel);
Fs = 1/data.(S.eventchannel).interval;
data = data.(S.eventchannel).values;

[negCUE,neuCUE,posCUE,bepCUE] = cuefinder_emotion(data,Fs);
[negCUE]=makeeventchannel(negCUE,'negCUE',Fs);
[neuCUE]=makeeventchannel(neuCUE,'neuCUE',Fs);
[posCUE]=makeeventchannel(posCUE,'posCUE',Fs);
[bepCUE]=makeeventchannel(bepCUE,'bepCUE',Fs);

save(S.D,'negCUE','neuCUE','posCUE','bepCUE','-append')

C = [];
C.D = S.D;
C.channels = S.channels;
C.eventname = {'negCUE','posCUE','neuCUE'};
C.time = [-4000 8000];
[D] = spm_eeg_spikeconvert(C);

function [negCUE,neuCUE,posCUE,bepCUE] = cuefinder_emotion(data,Fs)


rd=data/prctile(data,99);
rd = round(rd.*100)./100;
dd=zeros(size(data));
dd(2:length(dd),1)=diff(round(data));
rdd=dd/max(dd);

% [pks,locs]=findpeaks(rdd,'minpeakheight',0.1);

lall = find(rdd>0.1);
li = find(rd(lall-1)<0.1);
locs = lall(li);


inegCUE=locs(rd(locs+250) < 0.35 & rd(locs+0.1*Fs)>0.15);
ineuCUE=locs(rd(locs+250) < 0.65 & rd(locs+0.1*Fs)>0.35);
iposCUE=locs(rd(locs+250) < 0.85 & rd(locs+0.1*Fs)>0.65);
ibepCUE=locs(rd(locs+250) < 1.2 & rd(locs+0.1*Fs)>0.85);

negCUE=zeros(size(rd));
neuCUE=zeros(size(rd));
posCUE=zeros(size(rd));
bepCUE=zeros(size(rd));

negCUE(inegCUE)=1;
neuCUE(ineuCUE)=1;
posCUE(iposCUE)=1;
bepCUE(ibepCUE)=1;

x=1:length(data);

figure;
plot(x,rd,'k');
hold on;
plot(x,rdd,'color','r');
plot(x(inegCUE),rd(inegCUE+0.1*Fs),'b+');
plot(x(ineuCUE),rd(ineuCUE+0.1*Fs),'g+');
plot(x(iposCUE),rd(iposCUE+0.1*Fs),'r+');
plot(x(ibepCUE),rd(ibepCUE+0.1*Fs),'y+');

title([num2str(numel(inegCUE)) ' negative, ' num2str(numel(ineuCUE)) ' neutral ' num2str(numel(iposCUE)) ' positive, and ' num2str(numel(ibepCUE))  ' button press events found.']);    
pause(2);

