function [Dnew,tfreq]=tremor_definition(file,emgchans)

%% load file
clear conditions
D=spm_eeg_load(file);

[path,ID,junk]=fileparts(file);
%% do fft unrectified and rectified

S=[];
S.D = fullfile(D.path,D.fname);
S.condition = 'all';
S.channels = emgchans
S.freq = [1 40];
S.freqd = 300;
S.timewin = 3.341;
S.normfreq = [5 40];
S.rectify = 1;
C = spm_eeg_fft(S);

%% get rid of unrectified channels
ic = match_str(C.channels,emgchans);
C.channels = C.channels(ic);
C.rpow = C.rpow(ic,:);
C.pow = C.pow(:,ic,:);
nchans = numel(C.channels);
%% generate normalized power for each trial
flow = sc(C.f,5);
fhigh = sc(C.f,35);
for a=1:nchans;
    for b = 1:C.nseg;
        spow(b,a,:) = C.pow(b,a,:)./sum(C.pow(b,a,flow:fhigh))*100;
    end
end
srpow = squeeze(mean(spow,1));      
%% get tremor frequency
tfreq =[];tf=[];
flow = sc(C.f,3);
fhigh = sc(C.f,20);

for a = 1:nchans;
    [pks,ttf] = findpeaks(srpow(a,flow:fhigh),'minpeakheight',median(srpow(a,:))+2*std(srpow(a,:)))
    if ~isempty(ttf);
       [junk,ittf]=max(pks);
        tf(a) = ttf(ittf)+flow-1;
        tfreq(a) = C.f(tf(a));
        tfpads(a,:) = [sc(C.f,tfreq(a)-5) sc(C.f,tfreq(a)+5)];
    else
        tf(a) = nan;
        tfreq(a) = nan;
        tfpads(a) = nan;
    end
end

if ~nansum(tf);
    
    for a = 1:nchans;
        [pks,ttf] = findpeaks(srpow(a,flow:fhigh),'minpeakheight',median(srpow(a,:))+std(srpow(a,:)))
        if ~isempty(ttf);
           [junk,ittf]=max(pks);
            tf(a) = ttf(ittf)+flow-1;
            tfreq(a) = C.f(tf(a));
            tfpads(a,:) = [sc(C.f,tfreq(a)-5) sc(C.f,tfreq(a)+5)];
        else
            tf(a) = nan;
            tfreq(a) = nan;
            tfpads(a) = nan;
        end
    end
end

%% plot power spectrum
figure;cl={[0 0 0],[0.3 0.3 0.3],[0.5 0.5 0.5],[0.8 0.8 0.8]};leg={};
for a = 1:nchans;
    plot(C.f,srpow(a,:),'LineSmoothing','on','LineWidth',2,'color',cl{a});myfont(gca);
    hold on;
    if ~isnan(tf(a))
        s=scatter(tfreq(a),srpow(a,tf(a)),'v','filled','MarkerFaceColor','r');hold on;
    leg=[leg strrep(C.channels{a},'_',' ') 'peak'];%set(s,'MarkerSize',12)
    else
        leg = [leg strrep(C.channels{a},'_',' ')];
    end
end
xlim([1 40]);figone(7);xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]')
l=legend(leg);set(l,'FontSize',7)
myprint([ID '_EMG_power_spectrum']);

%% get change of condition

d=[];dt=[];cn=D.time(1);nn=D.conditions(1);tn =1;
for a=1:D.ntrials;
      if a>=2 && ~isequal(D.conditions{a},D.conditions{a-1})
        cn = [cn max(D.time)*a-max(D.time)];
        tn = [tn a];
        nn = [nn D.conditions(a)];
    end
end

%% get Tremor frequency data
t = linspace(0,C.nseg*C.tseg,C.nseg);
tchans = ~isnan(tf);lp=[];
for b = 1:length(tchans);
    junk=[];
    if tchans(b)
        for c = 1:C.nseg;
            junk = [junk mean(spow(c,b,tfpads(b,1):tfpads(b,2)),3)];
        end
        lp(b,:) = junk;
    end
end


%% get TF
for pctiles = [50];
figure;
n=0;sp=0;
for b=1:length(C.channels);
%  rd=[];   d=[];
    for a=1:C.nseg;
%             rd = [rd squeeze(D(D.indchannel(C.channels{b}),:,a))];
            d = [d squeeze(spow(a,b,:))];       
    end
    slp = zeros(size(lp(b,:)));
%     slp(lp(b,:)>median(lp(b,:))+sem(lp(b,:))) = 1;
    slp(lp(b,:)>prctile(lp(b,:),pctiles))=1;
    H(b,:) = slp;
    t = linspace(0,C.nseg*C.tseg,length(d));
%     rt = linspace(0,C.nseg*C.tseg,length(rd));
    sp = sp+1;
    subplot(length(C.channels)*3,1,sp);
    sp = sp+1; title(strrep(C.channels{b},'_',' '));
    plot(t,lp(b,:),'Color',[0.5 0.5 0.5],'LineStyle','-');set(gca,'XTick',[],'YTick',[]);hold on;
%      plot(rt,rd./median(rd)*100,'color','k');
    plot(t,ones(size(lp(b,:))).*median(lp(b,:)),'LineStyle','--','color',[0.3 0.3 0.3])
%     y=prctile(abs(rd./median(rd)*100),95)*4;if ~y;y=max(abs(rd));end
    y=prctile(lp(b,:),95)*2;
    ylim([0 y]);xlim([0 max(t)]);    sigbar(t,slp);
    for c = 1:numel(nn);
        te=text(cn(c),y*0.75,nn{c});myfont(te);set(te,'FontSize',8);
    end
    myfont(gca);set(gca,'FontSize',8);hold on;ylabel(strrep(C.channels{b},'_',' '))

    subplot(length(C.channels)*3,1,sp:sp+1)
    imagesc(t,C.f,log(d));%set(gca,'XTick',[],'YTick',[]);
     for c = 1:numel(nn);
        te=text(cn(c),30,nn{c});myfont(te);set(te,'FontSize',16,'Color','k');
    end
    axis xy;myfont(gca);set(gca,'FontSize',8);
    ylabel('Frequency [Hz]');xlim([0 max(t)]);
    sp = sp+1;
end
figtwo(14);
xlabel('Time [s]')
set(gca,'XtickMode', 'auto')
myprint([ID '_tremor_definition_prep_' num2str(pctiles)])
end
%% compare results
figure;n=0;
for a = 1:nchans;
    if tchans(a)
        n=n+1;
        tremor=lp(a,find(H(a,:)));rest = lp(a,find(~H(a,:)));
        p(a) = ranksum(tremor,rest);
        subplot(1,sum(tchans),n);
        bar(1:2,[median(rest),median(tremor)],'FaceColor',[0.5 0.5 0.5]);
        myfont(gca);set(gca,'FontSize',10);ylabel(strrep(C.channels{a},'_',' '));hold on;
%         eb=errorbar(1:2,[median(rest),median(tremor)],nan(1,2),[sem(rest),sem(tremor)]);
%         set(eb,'LineStyle','none','color','k','LineWidth',2);figtwo(7);
        set(gca,'XTickLabel',{'Rest','Tremor'});xlabel(['Ranksum p < ' num2str(p(a),4)]);
    end
end
    
%% sum all channel results
sH=sum(H,1);sH(sH>1) = 1;
%% find single trials
nH = zeros(size(sH));
[cl,n]=bwlabeln(sH);
for a = 1:n;
    i=find(cl==a);
    if numel(i)>3
        nH(i) = 1;
    end
end

%% find single rest epochs
for a = 2:length(nH)-1;
    if ~nH(a) && nH(a-1) && nH(a+1)
        nH(a) = 1;
    end
end
 
%% final TF
D=spm_eeg_load(file)
figure;
n=0;sp=0;
for b=1:length(C.channels);
 rd=[];   d=[];
    for a=1:C.nseg;
            rd = [rd squeeze(D(D.indchannel(C.channels{b}),:,a))];
            d = [d squeeze(C.pow(a,b,:))];       
    end
    slp = zeros(size(lp(b,:)));
    slp(lp(b,:)>median(lp(b,:))+sem(lp(b,:))) = 1;
    H(b,:) = slp;
    t = linspace(0,C.nseg*C.tseg,length(d));
    rt = linspace(0,C.nseg*C.tseg,length(rd));
    sp = sp+1;
    subplot(length(C.channels)*3,1,sp);
    sp = sp+1; title(strrep(C.channels{b},'_',' '));
    plot(t,lp(b,:)./median(lp(b,:))*100,'Color',[0.8 0.8 0.8],'LineStyle','--');%set(gca,'XTick',[],'YTick',[]);
    hold on; plot(rt,rd./median(rd)*100,'color','k');sigbar(t,nH);
    y=prctile(abs(rd./median(rd)*100),95)*4;if ~y;y=max(abs(rd));end
    ylim([0 y]);xlim([0 max(t)]);
    for c = 1:numel(nn);
        te=text(cn(c),y*0.75,nn{c});myfont(te);set(te,'FontSize',8);
    end
    myfont(gca);set(gca,'FontSize',8);hold on;ylabel(strrep(C.channels{b},'_',' '))

    subplot(length(C.channels)*3,1,sp:sp+1)
    imagesc(t,C.f,log(d));%set(gca,'XTick',[],'YTick',[]);
     for c = 1:numel(nn);
        te=text(cn(c),30,nn{c});myfont(te);set(te,'FontSize',16,'Color','k');
    end
    axis xy;myfont(gca);set(gca,'FontSize',8);
    ylabel('Frequency [Hz]');xlim([0 max(t)]);
    sp = sp+1;
end
figtwo(14);
xlabel('Time [s]')
set(gca,'XtickMode', 'auto')
myprint([ID '_tremor_definition_final'])

%% compare results again
figure;n=0;
for a = 1:nchans;
    if tchans(a)
        n=n+1;
        tremor=lp(a,find(nH));rest = lp(a,find(~nH));
        [p(a),junk,stats(a)] = ranksum(rest,tremor);
        subplot(1,sum(tchans),n);
        bar(1:2,[median(rest),median(tremor)],'FaceColor',[0.5 0.5 0.5]);
        myfont(gca);set(gca,'FontSize',10);ylabel(strrep(C.channels{a},'_',' '));hold on;
%         eb=errorbar(1:2,[median(rest),median(tremor)],nan(1,2),[std(rest),std(tremor)]);
%         set(eb,'LineStyle','none','color','k','LineWidth',2);figtwo(7);
        set(gca,'XTickLabel',{'Rest','Tremor'});xlabel(['Ranksum: Z = ' num2str(stats(a).zval) ' p < ' num2str(p(a),'%6.4f')]);
    end
end

myprint('Final_tremor_rest_comparison');
save([ID '_tremor_definition.mat'])

%% Create new file
S.outfile = ['t' D.fname];
S.D = file;
Dnew=spm_eeg_copy(S),

%% Change condition labels

Dnew=conditions(Dnew,find(nH),'Tremor')
Dnew=conditions(Dnew,find(~nH),'Rest')
save(Dnew);
% load(fullfile(Dnew.path,Dnew.fname));
% for a = 1:length(nH);
%     if nH(a)
%         D.trials(a).label = 'Tremor';
%     elseif ~nH(a);
%         D.trials(a).label = 'Rest';
%     end
% end
% save(fullfile(Dnew.path,Dnew.fname),'D');
% D=spm_eeg_load(fullfile(Dnew.path,Dnew.fname));
% save(D);




