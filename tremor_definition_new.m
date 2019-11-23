function [Dr,tfreq,nrtrials,nttrials,nbtrials]=tremor_definition_new(file,emgchans)

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

%% get change of condition

d=[];dt=[];cn=D.time(1);nn=D.conditions(1);tn =1;
for a=1:D.ntrials;
      if a>=2 && ~isequal(D.conditions{a},D.conditions{a-1})
        cn = [cn max(D.time)*a-max(D.time)];
        tn = [tn a];
        nn = [nn D.conditions(a)];
    end
end

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
        dtfreq(a) = C.f(tf(a)) * 2;
        tfpads(a,1:2) = [sc(C.f,tfreq(a)-1) sc(C.f,tfreq(a)+1)];
        dtfpads(a,1:2) = [sc(C.f,dtfreq(a)-1) sc(C.f,dtfreq(a)+1)];
    else
        tf(a,:) = nan;
        tfreq(a,1:2) = nan;
        tfpads(a,1:2) = nan;
        dtfpads(a,1:2) = nan;
    end
end

if ~nansum(tf);
    mode = 'median + standard deviation';
    for a = 1:nchans;
    [pks,ttf] = findpeaks(srpow(a,flow:fhigh),'minpeakheight',median(srpow(a,:))+std(srpow(a,:)))
        if ~isempty(ttf);
           [junk,ittf]=max(pks);
            tf(a) = ttf(ittf)+flow-1;
            tfreq(a) = C.f(tf(a));
            dtfreq(a) = C.f(tf(a)) * 2;
            tfpads(a,1:2) = [sc(C.f,tfreq(a)-1) sc(C.f,tfreq(a)+1)];
            dtfpads(a,1:2) = [sc(C.f,dtfreq(a)-1) sc(C.f,dtfreq(a)+1)];
        else
            tf(a) = nan;
            tfreq(a) = nan;
            tfpads(a,1:2) = nan;
            dtfpads(a,1:2) = nan;
        end
    end    
else
    mode = 'median + 2 * Standard Deviation';
end
%% plot power spectrum
figure;cl={[0 0 0],[0.3 0.3 0.3],[0.5 0.5 0.5],[0.8 0.8 0.8]};leg={};
for a = 1:nchans;
    plot(C.f,srpow(a,:),'LineSmoothing','on','LineWidth',2,'color',cl{a});myfont(gca);
    hold on;
    if ~isnan(tf(a))
        s=scatter(tfreq(a),srpow(a,tf(a)),'v','filled','MarkerFaceColor','r');hold on;
    leg=[leg strrep(C.channels{a},'_',' ') [num2str(tfreq(a),2) 'Hz']];%set(s,'MarkerSize',12)
    else
        leg = [leg strrep(C.channels{a},'_',' ')];
    end
end
t= title([ID ' ' mode]);set(t,'FontSize',10);
xlim([1 40]);figone(7);xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]')
l=legend(leg);set(l,'FontSize',7)
myprint([ID '_EMG_power_spectrum']);


%% get Tremor frequency and double tremor frequency data
t = linspace(0,C.nseg*C.tseg,C.nseg);
tfpads(find(tfpads<=0))=1;dtfpads(find(dtfpads<=0)) = 1;
tchans = ~isnan(tf);lp=[];
for b = 1:length(tchans);
    junk=[];junk1=[];junk2=[];
    if tchans(b)
        for c = 1:C.nseg;
            junk1 = [junk1 mean(spow(c,b,tfpads(b,1):tfpads(b,2)),3)];
            junk2 = [junk2 mean(spow(c,b,dtfpads(b,1):dtfpads(b,2)),3)];
            junk = sum([junk1;junk2],1);
        end
        lp(b,:) = junk;
    end
end


%% get TF
for pctiles = [50];
figure;
n=0;sp=0;
for b=1:length(C.channels);
    
     rd=[];   d=[];    slp = zeros(size(lp(1,:)));
    %% get normalized TF data
    for a=1:C.nseg;
            d = [d squeeze(spow(a,b,:))];       
    end
    %% define threshold for each channel as frequency power > median for
    %% more than 10 seconds (3 fft windows)
    if tchans(b);
        threshold(b) = prctile(lp(b,:),pctiles);
        slp(lp(b,:)>threshold(b))=1;
        H(b,:) = slp;
        [cl,ncl]=bwlabeln(H(b,:));
            for a = 1:ncl;
                i=find(cl==a);
                if numel(i)>3
                    H(b,i) = 1;
                else
                    H(b,i) = 0;
                end
            end
        %% Generate times     
        t = linspace(0,C.nseg*C.tseg,length(d));

        sp = sp+1;y=prctile(lp(b,:),95)*2;
        subplot(length(C.channels)*3,1,sp);
        sp = sp+1; title(strrep(C.channels{b},'_',' '));
        %% plot tremor frequency power over time
         plot(t,ones(size(lp(b,:))).*threshold(b),'LineStyle','--','color',[0.3 0.3 0.3]);hold on;
        %% plot tremor frequency threshold
        ylim([0 y]);
        b1=sigbar(t,slp);b2=sigbar(t,H(b,:));set(b2,'FaceColor',[0.5 0.5 0.5]);
        plot(t,lp(b,:),'Color',[0.1 0.1 0.1],'LineStyle','-');
    else
        rd=[];
        for a=1:C.nseg;
            rd = [rd squeeze(D(D.indchannel(emgchans{b}),:,a))];
        end
        rt = linspace(0,C.tseg*C.nseg,length(rd));
        sp = sp+1;y=prctile(rd,95)*2;
        subplot(length(C.channels)*3,1,sp);
        sp = sp+1; title(strrep(C.channels{b},'_',' '));
        plot(rt,abs(rd),'color','k');ylim([0 y]);
    end
    xlim([0 max(t)]);  set(gca,'XTick',[],'YTick',[]);  
    %% plot chosen trials
    
    %% plot condition names
    for c = 1:numel(nn);
        te=text(cn(c),y*0.75,strrep(nn{c},'_',' '));myfont(te);set(te,'FontSize',8);
    end
    myfont(gca);set(gca,'FontSize',8);hold on;ylabel(strrep(C.channels{b},'_',' '))
    
   
    %% plot log normalized TF power
    subplot(length(C.channels)*3,1,sp:sp+1)
    imagesc(t,C.f,log(d));%set(gca,'XTick',[],'YTick',[]);
     for c = 1:numel(nn);
        te=text(cn(c),30,strrep(nn{c},'_',' '));myfont(te);set(te,'FontSize',16,'Color','k');
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
% figure;n=0;
% for a = 1:nchans;
%     if tchans(a)
%         n=n+1;
%         tremor=lp(a,find(H(a,:)));rest = lp(a,find(~H(a,:)));
%         p(a) = ranksum(tremor,rest);
%         subplot(1,sum(tchans),n);
%         bar(1:2,[median(rest),median(tremor)],'FaceColor',[0.5 0.5 0.5]);
%         myfont(gca);set(gca,'FontSize',10);ylabel(strrep(C.channels{a},'_',' '));hold on;
% %         eb=errorbar(1:2,[median(rest),median(tremor)],nan(1,2),[sem(rest),sem(tremor)]);
% %         set(eb,'LineStyle','none','color','k','LineWidth',2);figtwo(7);
%         set(gca,'XTickLabel',{'Rest','Tremor'});xlabel(['Ranksum p < ' num2str(p(a),4)]);
%     end
% end
    
%% sum all channel results
sH=sum(H,1);sH(find(sH>1)) = 1;
%% Create new file for Vs method
S=[];
S.outfile = ['t' D.fname];
S.D = file;
Dnew=spm_eeg_copy(S),

%% Create new file for Js method
S=[];
S.outfile = ['jt' D.fname];
S.D = file;
Dj=spm_eeg_copy(S),
%% mark bad trials
cl = D.condlist;rtrials =[];ttrials=[];
n=0;rntrials=[];tntrials=[];rnontrials=[];rontrials=[];tontrials=[];tnontrials=[];
for a=1:Dnew.ntrials;
    if  (strcmp(Dnew.conditions{a},'R') || strcmp(Dnew.conditions{a},'R_OFF')) && sH(a)
        Dnew=badtrials(Dnew,a,1);
    elseif (strcmp(Dnew.conditions{a},'R') || strcmp(Dnew.conditions{a},'R_OFF')) && ~sH(a)
        n=n+1;
        rntrials=[rntrials n];
        rtrials = [rtrials a];
    elseif (strcmp(Dnew.conditions{a},'RT') || strcmp(Dnew.conditions{a},'RTL') || strcmp(Dnew.conditions{a},'RT_OFF')) && ~sH(a)
        Dnew=badtrials(Dnew,a,1);
    elseif (strcmp(Dnew.conditions{a},'RT') || strcmp(Dnew.conditions{a},'RTL') || strcmp(Dnew.conditions{a},'RT_OFF')) && sH(a)
        n=n+1;
        tntrials =[tntrials n];
        ttrials = [ttrials a];  
    elseif    strcmp(Dnew.conditions{a},'R_ON')  && sH(a)
        Dnew=badtrials(Dnew,a,1);
    elseif strcmp(Dnew.conditions{a},'R_ON') && ~sH(a)
        n=n+1;
        rnontrials=[rnontrials n];
        rontrials = [rontrials a];
    elseif    strcmp(Dnew.conditions{a},'RT_ON')  && ~sH(a)
        Dnew=badtrials(Dnew,a,1);
    elseif strcmp(Dnew.conditions{a},'RT_ON') && sH(a)
        n=n+1;
        tnontrials=[tnontrials n];
        tontrials = [tontrials a];
    end
end
Dnew.fileind(Dnew.badtrials)=[];
save(Dnew);
nbtrials = numel(Dnew.badtrials);
%%
S=[];
S.D = fullfile(Dnew.path,Dnew.fname);
Dr = spm_eeg_remove_bad_trials(S);
Dr=conditions(Dr,tntrials,'Tremor');
Dr=conditions(Dr,rntrials,'Rest');
if ~isempty(tnontrials);
    Dr=conditions(Dr,tnontrials,'Tremor_ON');
end
if ~isempty(rnontrials)
    Dr=conditions(Dr,rnontrials,'Rest_ON');
end

save(Dr)
nttrials = numel(ttrials);
nrtrials = numel(rtrials);

for a = 1:Dj.ntrials;
    if  (strcmp(Dnew.conditions{a},'R') || strcmp(Dnew.conditions{a},'R_OFF')...
        || strcmp(Dnew.conditions{a},'RT') || strcmp(Dnew.conditions{a},'RTL')...
        || strcmp(Dnew.conditions{a},'RT_OFF')) && sH(a)
        Dj = conditions(Dj,a,'jT');
    elseif (strcmp(Dnew.conditions{a},'R') || strcmp(Dnew.conditions{a},'R_OFF')...
        || strcmp(Dnew.conditions{a},'RT') || strcmp(Dnew.conditions{a},'RTL')  ||...
        strcmp(Dnew.conditions{a},'RT_OFF')) && ~sH(a)
        Dj = conditions(Dj,a,'jR');
    elseif (strcmp(Dnew.conditions{a},'R_ON') || strcmp(Dnew.conditions{a},'RT_ON')) && sH(a)
        Dj = conditions(Dj,a,'jT_ON');
    elseif (strcmp(Dnew.conditions{a},'R_ON') || strcmp(Dnew.conditions{a},'RT_ON')) && ~sH(a)
        Dj = conditions(Dj,a,'jR_ON');
    end
end
save(Dj);
save([ID '_tremor_definition.mat'])


