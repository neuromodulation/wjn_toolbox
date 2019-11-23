function Dtf=wjn_ecog_ah_pb_burst_preprocessing(filename,step,db)

if ~exist('step','var')
    step = 1;
end
if ~exist('db','var')
    db=0;
end
if step <= 1
[folder,file,ext]= fileparts(filename);
root = cd;
% cd(folder)

filename = [file ext];


id = filename(3:6);
% hemisphere = filename(end-5);;

load(fullfile(root,filename),'signal','CueStimulusTimes','CommandStimulusTimes','LeftResponseTimes','RightResponseTimes','FeedbackStimulusTimes','Force','time1kHz','labels');
str = stringsplit(filename,'_');
if strcmp(str{2}(1:2),'MM')
    Force = Force(:,[2,1]);
end

if strcmp(id,'SE11')
    i1 = 198221:200125;
    i2 = 1177967:1179682;
    x1 = i1(1)-length(i1):i1(1)-1;
    x2 = i2(1)-length(i2):i2(1)-1;
    signal([i1 i2],:) = signal([x1 x2],:);
end

if strcmp(id,'WO05')
    Force(1:642415,1) = Force(1:642415,1)-23;
    Force(1:642462,2) = Force(1:642462,2)-20.14;
end

if strcmp(id,'VK12')
    i = ci('STN',labels);
    for a = 1:length(i)
        labels{i(a)} = ['STN' num2str(a)];
    end
    labels = labels([i 1:i(1)-1]);
    signal = signal(:,[i 1:i(1)-1]);
end

if strcmp(id,'VK12') || strcmp(id,'WO05')
    s4 = ci({'STN3','STN4'},labels);
    signal(:,s4) = [];
    labels(s4)=[];
    s4 =[];
else
s4 = ci('STN4',labels);
end

f=resample(Force,time1kHz,1200);
signal = [signal f(1:size(signal,1),:)];
labels(end+1:end+2)  = {'force_left','force_right'};
if ~isempty(s4)
    D=wjn_import_rawdata(['s_' filename],signal(:,1:end ~= s4)',labels(1:end ~= s4),1200);
else
    D=wjn_import_rawdata(['s_' filename],signal(:,1:end)',labels(1:end),1200);
end
D.id = id;
D=chantype(D,':','LFP');
D=chantype(D,ci('force',D.chanlabels),'Other');
D.trialtimes.LeftResponseTimes = time1kHz(LeftResponseTimes);
D.trialtimes.RightResponseTimes = time1kHz(RightResponseTimes);
D.trialtimes.FeedbackStimulusTimes = FeedbackStimulusTimes;
D.trialtimes.CueStimulusTimes = CueStimulusTimes;
D.trialtimes.CommandStimulusTimes = CommandStimulusTimes;
% D.trialtimes.baseline = baseline;
D.hemisphere = str{3}(1);
if strcmp(str{2}(1),'R')
    D.con = 'Left';
    D.ips = 'Right';
    fi = length(labels)-1;
else
    D.con = 'Right';
    D.ips = 'Left';
    fi = length(labels);
end
save(D)
irest = wjn_sc(D.time,CueStimulusTimes);
iirest = [];
for a = 1:length(irest)
    iirest =[iirest irest(a)-D.fsample:irest(a)];
end
D.iirest = iirest;
D = chantype(D,D.nchannels-1:D.nchannels,'Other');
save(D)
D=wjn_filter(D.fullfile,[58 62],'stop');
D=wjn_filter(D.fullfile,[118 122],'stop');
D=wjn_filter(D.fullfile,[178 182],'stop');
D.movetimes = [D.trialtimes.([D.con 'ResponseTimes']) D.trialtimes.([D.ips 'ResponseTimes'])];

clear conditionlabels
conditionlabels(1:length(D.trialtimes.([D.con 'ResponseTimes']))) = deal({'con_move'});
conditionlabels(length(conditionlabels):length(conditionlabels)+length(D.trialtimes.([D.ips 'ResponseTimes']))) = deal({'ips_move'});
D.conditionlabels = conditionlabels;
wjn_import_rawdata(['baselines_' filename],squeeze(D(1:D.nchannels-2,iirest)),D.chanlabels(D.indchantype('LFP')),D.fsample);
wjn_epoch(D.fullfile,[-3 3],D.conditionlabels,D.movetimes','move');
Dcont = wjn_import_rawdata(['cont_' filename],squeeze(D(:,iirest(1)-D.fsample:wjn_sc(D.time,FeedbackStimulusTimes(end)))),D.chanlabels,D.fsample);
Dcont = chantype(Dcont,Dcont.nchannels-1:Dcont.nchannels,'Other');
Dcont.trialtimecorrection = D.time(iirest(1)-D.fsample);
Dcont.con = D.con;
Dcont.ips = D.ips;
Dcont.hemisphere = D.hemisphere;
Dcont.trialtimes=D.trialtimes;
Dcont.id = id;
save(Dcont)
D = wjn_downsample(Dcont.fullfile,400,200,'d');
Dtf= wjn_tf_wavelet(D.fullfile,1:200,400);
end
%%

if step <=2
    if step ==2
        
        Dtf = wjn_sl(['tf*' filename]);
        D=wjn_sl(['dcont*' Dtf.id '*.mat']);
    end
Dtf.force = squeeze(D(ci('force',D.chanlabels),:,1));
if db
keyboard
end
%%
for a = 1:2
    Dtf.force(a,1:100) = median(Dtf.force(a,:));
    Dtf.nforce(a,:) = (Dtf.force(a,:)-min(Dtf.force(a,:)))./max(Dtf.force(a,:));
    Dtf.snforce(a,:) = smooth(Dtf.nforce(a,:),200);
    Dtf.dforce(a,:) = mydiff(Dtf.snforce(a,:));
    Dtf.dforce(a,:) = Dtf.dforce(a,:)./max(Dtf.dforce(a,:));
    Dtf.dforce(a,1:100) = 0;
    Dtf.dforce(a,end-100:end) = 0;
end
save(Dtf)

if strcmp(Dtf.hemisphere,'R')
    Dtf.ficon = 1;
    Dtf.fiips = 2;
else
    Dtf.ficon = 2;
    Dtf.fiips = 1;
end


figure
h=plot(Dtf.nforce');
legend('left','right')
hold on
imoveR = mythresh(Dtf.dforce(2,:),.1,Dtf.fsample);
istopR = mythresh(Dtf.dforce(2,:),-.1,Dtf.fsample);
imoveL = mythresh(Dtf.dforce(1,:),.1,Dtf.fsample);
istopL = mythresh(Dtf.dforce(1,:),-.1,Dtf.fsample);
% xlim([0 8000])
figone(4,80)
%
myprint([Dtf.id '_move_def'],1)


if strcmp(Dtf.id,'SE11')
   istopL(15) =       51041;
elseif  strcmp(Dtf.id,'SE08')
    istopL(8) = 28814;
    istopL(4) = 20536;
    istopL(23) = 88446;
    istopL(25) = 92984;
    istopL(31) = 115873;
elseif  strcmp(Dtf.id,'RS05')
imoveL([11 26])=[];
istopL(10)=[];
imoveR(20) = [];
istopR([19 29])=[];
elseif  strcmp(Dtf.id,'MK02')
istopL([1])=[];
elseif  strcmp(Dtf.id,'JM08')
imoveL([42])=[];
elseif  strcmp(Dtf.id,'JM04')
imoveL([13])=[];
elseif  strcmp(Dtf.id,'JD05')
imoveR([20])=[];
elseif  strcmp(Dtf.id,'RT06')
imoveL([18])=[];
elseif  strcmp(Dtf.id,'BJ08')
    istopL(10) = 47428;
    istopR(16) = 67367;
    istopR(21) = 92021;
    istopR(3) = 8573;
    imoveL([4 12 9 18 21 30])=[];
    imoveR([15 19]) = [];
end


move_con = zeros(size(Dtf.time));
postmove_con = move_con;
cmove = eval(['imove' D.con(1)]);
cstop = eval(['istop' D.con(1)]);
n=0;
for a = 1:length(cmove)
    i = find(cstop>cmove(a) & cstop<cmove(a)+5*Dtf.fsample,1);
    if ~isempty(i)
        n=n+1;
        moveC(n,:) = [cmove(a) cstop(i)];
        move_con(1,moveC(n,1):moveC(n,2)) = 1;
        postmove_con(1,1+cstop(i):1+cstop(i)+Dtf.fsample)=1;
    end
end
cmove = eval(['imove' D.ips(1)]);
cstop = eval(['istop' D.ips(1)]);
move_ips = zeros(size(Dtf.time));
postmove_ips = move_ips;
n=0;
for a = 1:length(cmove)
    i = find(cstop>cmove(a) & cstop<cmove(a)+5*Dtf.fsample,1);
    if ~isempty(i)
        n=n+1;
        moveI(n,:) = [cmove(a) cstop(i)];
        move_ips(1,moveI(n,1):moveI(n,2)) = 1;
        postmove_ips(1,cstop(i)+1:1+cstop(i)+Dtf.fsample)=1;
    end
end
Dtf.timeind.move_con = logical(move_con);
Dtf.timeind.postmove_con = logical(postmove_con);
Dtf.timeind.move_ips = logical(move_ips);
Dtf.timeind.postmove_ips = logical(postmove_ips);
Dtf.timeind.move_both = logical(move_con+move_ips);
Dtf.timeind.postmove_both = logical(postmove_con+postmove_ips);
Dtf.timeind.baseline = logical(~(Dtf.timeind.move_both+Dtf.timeind.postmove_both));
Dtf.timeind.full= 1:Dtf.nsamples;
Dtf.timeind.no_move = logical(~Dtf.timeind.move_both);
Dtf.force = Dtf.force-nanmean(Dtf.force(:,~Dtf.timeind.move_both),2)./1000*392.8; %% ADD NEWTON CONVERSION

figure
subplot(2,1,1)
plot(Dtf.time(Dtf.timeind.no_move),Dtf.force(:,Dtf.timeind.no_move))
subplot(2,1,2)
plot(Dtf.time(Dtf.timeind.move_both),Dtf.force(:,Dtf.timeind.move_both))

%%
save(Dtf)
end

if step <=3

    if step == 3
        try
            Dtf = wjn_sl(filename);
        catch
            Dtf = wjn_sl(['tf_dcont_' filename]);
        end
    end

for a = 1:Dtf.nchannels
    Dtf.pow_rest(a,:) = squeeze(nanmean(Dtf(a,:,find(Dtf.timeind.no_move),1),3));
    Dtf.pow_baseline(a,:) = squeeze(nanmean(Dtf(a,:,find(Dtf.timeind.no_move),1),3));
    Dtf.pow_move(a,:) = squeeze(nanmean(Dtf(a,:,find(Dtf.timeind.move_both),1),3));
    Dtf.pow_dmr(a,:) =wjn_pct_change(Dtf.pow_rest(a,:),Dtf.pow_move(a,:));
    [Dtf.spow_rest(a,:), Dtf.rpow_rest(a,:)] = wjn_raw_power_normalization(Dtf.pow_rest(a,:),Dtf.frequencies);
    [Dtf.spow_move(a,:),Dtf.rpow_move(a,:)] = wjn_raw_power_normalization(Dtf.pow_move(a,:),Dtf.frequencies);
    [Dtf.spow_baseline(a,:),Dtf.rpow_baseline(a,:)] = wjn_raw_power_normalization(Dtf.pow_baseline(a,:),Dtf.frequencies);
end
save(Dtf)



Dtf.istn = ci('STN',Dtf.chanlabels);

pkfreq = [13:35];

if strcmp(Dtf.id,'WO05') || strcmp(Dtf.id,'RS05') || strcmp(Dtf.id,'SE08') 
    i = 1;
else
[~,i]=max(abs(nanmean(Dtf.pow_dmr(Dtf.istn,pkfreq),2)+abs(nanmean(Dtf.pow_dmr(Dtf.istn,60:185),2))));
end


Dtf.sSTN = Dtf.istn(i);
[Dtf.mbSTN,Dtf.fbSTN] = max(Dtf.pow_dmr(Dtf.sSTN,pkfreq));
Dtf.fbSTN = Dtf.fbSTN +pkfreq(1)-1;
[Dtf.mgSTN,Dtf.fgSTN] = max(-1.*Dtf.pow_dmr(Dtf.sSTN,45:185));
Dtf.fgSTN = Dtf.fgSTN +pkfreq(1)-1;
[Dtf.mpkSTN,Dtf.fpkSTN] = findpeaks(Dtf.spow_rest(Dtf.sSTN,pkfreq),'npeaks',1,'SortStr','descend');
Dtf.fpkSTN = Dtf.fpkSTN+pkfreq(1)-1;

figure
plot(Dtf.frequencies,Dtf.spow_rest(Dtf.sSTN,:),'linewidth',2')
hold on
plot(Dtf.fpkSTN,Dtf.mpkSTN,'vr')
figone(4,4)
myprint(fullfile(cd,'power_spectra',[Dtf.id '_' Dtf.hemisphere '_BETA_PEAK_' Dtf.chanlabels{Dtf.sSTN} ]),1)


if isempty(Dtf.fpkSTN) && strcmp(Dtf.id,'BJ08')
     
    Dtf.fpkSTN = Dtf.fbSTN;
      Dtf.mpkSTN = Dtf.mbSTN;
elseif strcmp(Dtf.id,'SE11') || strcmp(Dtf.id,'MK02')
    Dtf.fpkSTN = 10;
end


Dtf.istrip = ci('Strip',Dtf.chanlabels);

if strcmp(Dtf.id,'SE11')
    i = 3;
else
    [~,i]=max(abs(nanmean(Dtf.pow_dmr(Dtf.istrip,pkfreq),2)+abs(nanmean(Dtf.pow_dmr(Dtf.istrip,60:185),2))));
end

Dtf.sECOG = Dtf.istrip(i);
[Dtf.mbECOG,Dtf.fbECOG] = max(Dtf.pow_dmr(Dtf.sECOG,pkfreq));
Dtf.fbECOG = Dtf.fbECOG+11;
[Dtf.mgECOG,Dtf.fgECOG] = max(-1.*Dtf.pow_dmr(Dtf.sECOG,45:185));
Dtf.fgECOG = Dtf.fgECOG +45;
save(Dtf)

% Dtf = wjn_sl('tf_dcont*.mat');
cc = colorlover(6);
figure
for a = 1:length(Dtf.istn)
    subplot(1,length(Dtf.istn),a)
    mypower(Dtf.frequencies,Dtf.pow_rest(Dtf.istn(a),:),cc(4,:))
    hold on
    mypower(Dtf.frequencies,Dtf.pow_move(Dtf.istn(a),:),cc(5,:))
    if Dtf.istn(a) == Dtf.sSTN
    title([Dtf.chanlabels{Dtf.istn(a)} ' selected'])
    else
        title([Dtf.chanlabels{Dtf.istn(a)} ])
    end
    xlabel('Frequency [Hz]')
    ylabel('Relative spectral power [a.u.]')
    xlim([1 185])
% ylim([0 25])
end
figone(7,30)
myprint(fullfile(cd,'power_spectra',[Dtf.id '_' Dtf.hemisphere '_STN_power_spectra' ]),1)


figure
for a = 1:length(Dtf.istrip)
    subplot(1,length(Dtf.istrip),a)
mypower(Dtf.frequencies,Dtf.pow_rest(Dtf.istrip(a),:),cc(4,:));
hold on
mypower(Dtf.frequencies,Dtf.pow_move(Dtf.istrip(a),:),cc(5,:));
    if Dtf.istrip(a) == Dtf.sECOG
    title([Dtf.chanlabels{Dtf.istrip(a)} ' selected'])
    else
        title([Dtf.chanlabels{Dtf.istrip(a)} ])
    end
xlabel('Frequency [Hz]')
ylabel('Relative spectral power [a.u.]')
xlim([1 185])
% ylim([0 25])
end
figone(7,40)
myprint(fullfile(cd,'power_spectra',[Dtf.id '_' Dtf.hemisphere '_Strip_power_spectra']),1)


end

if step<=4


% burst analysis
if isfield(Dtf,'bursts')
Dtf = rmfield(Dtf,'bursts');
end
timeranges = fieldnames(Dtf.timeind);
for a = 1:Dtf.nchannels
    for b = 1:length(timeranges)
        Dtf.bursts.(timeranges{b}).bdata(a,:) = smooth(squeeze(nanmean(Dtf(a,pkfreq,find(Dtf.timeind.(timeranges{b})),1),2)),.2*Dtf.fsample);
        Dtf.bursts.(timeranges{b}).bthresh(a) = prctile(Dtf.bursts.(timeranges{b}).bdata(a,:),50);
        [Dtf.bursts.(timeranges{b}).bdur{a},Dtf.bursts.(timeranges{b}).bamp{a},...
        Dtf.bursts.(timeranges{b}).nb(a),Dtf.bursts.(timeranges{b}).btime(a,:),Dtf.bursts.(timeranges{b}).bpeak{a},...
        Dtf.bursts.(timeranges{b}).bibi(a),Dtf.bursts.(timeranges{b}).bregularity(a),...
        Dtf.bursts.(timeranges{b}).basym(a)]=wjn_burst_duration(Dtf.bursts.(timeranges{b}).bdata(a,:),Dtf.bursts.(timeranges{b}).bthresh(a),Dtf.fsample,100,'brown');
        Dtf.bursts.(timeranges{b}).mbdur(a) = nanmean(Dtf.bursts.(timeranges{b}).bdur{a});
        Dtf.bursts.(timeranges{b}).mbamp(a) = nanmean(Dtf.bursts.(timeranges{b}).bamp{a});
        Dtf.bursts.(timeranges{b}).hbdur(a,:) = hist(Dtf.bursts.(timeranges{b}).bdur{a},100:100:1000);
        Dtf.bursts.(timeranges{b}).hbtimes =100:100:1000;
       Dtf.bursts.(timeranges{b}).phbdur(a,:) = Dtf.bursts.(timeranges{b}).hbdur(a,:)./nansum(Dtf.bursts.(timeranges{b}).hbdur(a,:)).*100;
       
        
             Dtf.bursts.(timeranges{b}).pkdata(a,:) = smooth(squeeze(nanmean(Dtf(a,Dtf.fpkSTN,find(Dtf.timeind.(timeranges{b})),1),2)),.2*Dtf.fsample);
        Dtf.bursts.(timeranges{b}).pkthresh(a) = prctile(Dtf.bursts.(timeranges{b}).pkdata(a,:),50);
        [Dtf.bursts.(timeranges{b}).pkdur{a},Dtf.bursts.(timeranges{b}).pkamp{a},...
        Dtf.bursts.(timeranges{b}).npk(a),Dtf.bursts.(timeranges{b}).pktime(a,:),Dtf.bursts.(timeranges{b}).pkpeak{a},...
        Dtf.bursts.(timeranges{b}).pkibi(a),Dtf.bursts.(timeranges{b}).pkregularity(a),...
        Dtf.bursts.(timeranges{b}).pkasym(a)]=wjn_burst_duration(Dtf.bursts.(timeranges{b}).pkdata(a,:),Dtf.bursts.(timeranges{b}).pkthresh(a),Dtf.fsample,100,'brown');
        Dtf.bursts.(timeranges{b}).mpkdur(a) = nanmean(Dtf.bursts.(timeranges{b}).pkdur{a});
        Dtf.bursts.(timeranges{b}).mpkamp(a) = nanmean(Dtf.bursts.(timeranges{b}).pkamp{a});
        Dtf.bursts.(timeranges{b}).hpkdur(a,:) = hist(Dtf.bursts.(timeranges{b}).pkdur{a},100:100:1000);
        Dtf.bursts.(timeranges{b}).hpktimes =100:100:1000;
       Dtf.bursts.(timeranges{b}).phpkdur(a,:) = Dtf.bursts.(timeranges{b}).hpkdur(a,:)./nansum(Dtf.bursts.(timeranges{b}).hpkdur(a,:)).*100;
       
        
       
        Dtf.bursts.(timeranges{b}).gdata(a,:) = smooth(squeeze(nanmean(Dtf(a,45:185,find(Dtf.timeind.(timeranges{b})),1),2)),.06*Dtf.fsample);
        Dtf.bursts.(timeranges{b}).gthresh(a) = prctile(Dtf.bursts.(timeranges{b}).gdata(a,:),50);
        [Dtf.bursts.(timeranges{b}).gdur{a},Dtf.bursts.(timeranges{b}).gamp{a},Dtf.bursts.(timeranges{b}).ng(a),Dtf.bursts.(timeranges{b}).gtime(a,:),Dtf.bursts.(timeranges{b}).gpeak{a},Dtf.bursts.(timeranges{b}).gibi(a),Dtf.bursts.(timeranges{b}).gregularity(a),Dtf.bursts.(timeranges{b}).gasym(a)]=wjn_burst_duration(Dtf.bursts.(timeranges{b}).gdata(a,:),Dtf.bursts.(timeranges{b}).gthresh(a),Dtf.fsample,33,'brown');
        Dtf.bursts.(timeranges{b}).mgdur(a) = nanmean(Dtf.bursts.(timeranges{b}).gdur{a});
        Dtf.bursts.(timeranges{b}).mgamp(a) = nanmean(Dtf.bursts.(timeranges{b}).gamp{a}); 
         Dtf.bursts.(timeranges{b}).hgdur(a,:) = hist(Dtf.bursts.(timeranges{b}).gdur{a},50:50:500);  
        Dtf.bursts.(timeranges{b}).hgtimes =50:50:500;
        Dtf.bursts.(timeranges{b}).phgdur(a,:) = Dtf.bursts.(timeranges{b}).hgdur(a,:)./nansum(Dtf.bursts.(timeranges{b}).hgdur(a,:)).*100;       
    end
end
save(Dtf);
try
delete(['s_*' filename(1:end-4) '.*'])
delete(['fs_*' filename(1:end-4) '.*'])
delete(['ffs_*' filename(1:end-4) '.*'])
D=wjn_sl(['fffs_' filename]);
D.move(['raw_' filename])
catch
    disp('no files moved')
end
end