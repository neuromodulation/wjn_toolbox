function wjn_ecog_ek_pb_burst_preprocessing(filename,step)

%%
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

% keep filename
load(filename)
load([filename(1:end-7) 'trial.mat'])


hemispheres = {'L','R'};
diagnoses = {'NM','PD','ET','NM'};
str = stringsplit(filename,'_');
id = str{2}(1:4);
diagnosis = diagnoses{str2num(str{3})};
hem = hemispheres{str2num(str{4})};
istn = ci('STN',labels);
raw(:,istn) = [];
labels(istn) = [];
time1kHz = linspace(0,length(Force)./fs,length(Force));
if strcmp(id(1:2),'MM')
    Force = Force(:,[2,1]);
end

raw = [raw Force];
labels(end+1:end+2)  = {'force_left','force_right'};


D=wjn_import_rawdata(['s_' filename],raw',labels,fs);


D.id = id;
D=chantype(D,':','LFP');
D=chantype(D,ci('force',D.chanlabels),'Other');
% D.trialtimes.LeftResponseTimes = time1kHz(LeftResponseTimes);
% D.trialtimes.RightResponseTimes = time1kHz(RightResponseTimes);
D.trialtimes.FeedbackStimulusTimes = FeedbackStimulusTimes;
D.trialtimes.CueStimulusTimes = CueStimulusTimes;
D.trialtimes.CommandStimulusTimes = CommandStimulusTimes;
% D.trialtimes.baseline = baseline;
D.hemisphere = hem;
if strcmp(hem,'R')
    D.con = 'L';
    D.ips = 'R';
    fi = length(labels)-1;
else
    D.con = 'R';
    D.ips = 'L';
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

wjn_import_rawdata(['baselines_' filename],squeeze(D(1:D.nchannels-2,iirest)),D.chanlabels(D.indchantype('LFP')),D.fsample);

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
        
        Dtf = wjn_sl(['tf_dcont_' filename]);
        D=wjn_sl(['dcont_' filename]);
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
subplot(3,1,1)
h=plot(Dtf.nforce');
legend('left','right')
hold on
imoveR = mythresh(Dtf.dforce(2,:),.1,Dtf.fsample*.5);
istopR = mythresh(Dtf.dforce(2,:),-.1,Dtf.fsample*.5);
imoveL = mythresh(Dtf.dforce(1,:),.1,Dtf.fsample*.5);
istopL = mythresh(Dtf.dforce(1,:),-.1,Dtf.fsample*.5);
% xlim([0 8000])
% figone(4,80)
%

% 
% 
% if strcmp(Dtf.id,'SE11')
%    istopL(15) =       51041;
% elseif  strcmp(Dtf.id,'SE08')
%     istopL(8) = 28814;
%     istopL(4) = 20536;
%     istopL(23) = 88446;
%     istopL(25) = 92984;
%     istopL(31) = 115873;
% elseif  strcmp(Dtf.id,'RS05')
% imoveL([11 26])=[];
% istopL(10)=[];
% imoveR(20) = [];
% istopR([19 29])=[];
% elseif  strcmp(Dtf.id,'MK02')
% istopL([1])=[];
% elseif  strcmp(Dtf.id,'JM08')
% imoveL([42])=[];
% elseif  strcmp(Dtf.id,'JM04')
% imoveL([13])=[];
% elseif  strcmp(Dtf.id,'JD05')
% imoveR([20])=[];
% elseif  strcmp(Dtf.id,'RT06')
% imoveL([18])=[];
% elseif  strcmp(Dtf.id,'BJ08')
%     istopL(10) = 47428;
%     istopR(16) = 67367;
%     istopR(21) = 92021;
%     istopR(3) = 8573;
%     imoveL([4 12 9 18 21 30])=[];
%     imoveR([15 19]) = [];
% end


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

% figure
subplot(3,1,2)
plot(Dtf.time(Dtf.timeind.no_move),Dtf.force(:,Dtf.timeind.no_move))
subplot(3,1,3)
plot(Dtf.time(Dtf.timeind.move_both),Dtf.force(:,Dtf.timeind.move_both))
myprint([Dtf.id '_move_def'],1)
%%
save(Dtf)


for a = 1:Dtf.nchannels
    Dtf.pow_rest(a,:) = squeeze(nanmean(Dtf(a,:,find(Dtf.timeind.no_move),1),3));
    Dtf.pow_move(a,:) = squeeze(nanmean(Dtf(a,:,find(Dtf.timeind.move_both),1),3));
    Dtf.pow_dmr(a,:) =wjn_pct_change(Dtf.pow_rest(a,:),Dtf.pow_move(a,:));
    Dtf.spow_rest(a,:) = wjn_raw_power_normalization(Dtf.pow_rest(a,:),Dtf.frequencies);
    Dtf.spow_move(a,:) = wjn_raw_power_normalization(Dtf.pow_move(a,:),Dtf.frequencies);
end
save(Dtf)


Dtf.istrip = 1:Dtf.nchannels;

% if strcmp(Dtf.id,'SE11')
%     i = 3;
% else
    [~,i]=max(abs(nanmean(Dtf.pow_dmr(Dtf.istrip,12:35),2)+abs(nanmean(Dtf.pow_dmr(Dtf.istrip,60:185),2))));
% end

Dtf.sECOG = Dtf.istrip(i);
[Dtf.mbECOG,Dtf.fbECOG] = max(Dtf.pow_dmr(Dtf.sECOG,12:35));
Dtf.fbECOG = Dtf.fbECOG+11;
[Dtf.mgECOG,Dtf.fgECOG] = max(-1.*Dtf.pow_dmr(Dtf.sECOG,45:185));
Dtf.fgECOG = Dtf.fgECOG +45;
[Dtf.mpkSTN,Dtf.fpkSTN] = findpeaks(Dtf.spow_rest(Dtf.sECOG,12:35),'npeaks',1,'SortStr','descend');
Dtf.fpkSTN = Dtf.fpkSTN+11;

save(Dtf)

if length(Dtf.istrip)<9
% Dtf = wjn_sl('tf_dcont*.mat');
cc = colorlover(6);
figure
for a = 1:length(Dtf.istrip)
    subplot(1,length(Dtf.istrip),a)
mypower(Dtf.frequencies,Dtf.pow_rest(Dtf.istrip(a),:),cc(4,:));
hold on
mypower(Dtf.frequencies,Dtf.pow_move(Dtf.istrip(a),:),cc(5,:));

    if Dtf.istrip(a) == Dtf.sECOG
    title([Dtf.chanlabels{Dtf.istrip(a)} ' selected'])
scatter(Dtf.fpkSTN,Dtf.pow_rest(Dtf.istrip(a),Dtf.fpkSTN),'rv')
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
end

if step<=3


% burst analysis
if isfield(Dtf,'bursts')
Dtf = rmfield(Dtf,'bursts');
end
timeranges = fieldnames(Dtf.timeind);
for a = 1:Dtf.nchannels
    for b = 1:length(timeranges)
        Dtf.bursts.(timeranges{b}).bdata(a,:) = smooth(squeeze(nanmean(Dtf(a,12:35,find(Dtf.timeind.(timeranges{b})),1),2)),.2*Dtf.fsample);
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
% D.move(['raw_' filename])
catch
    disp('no files moved')
end
end



