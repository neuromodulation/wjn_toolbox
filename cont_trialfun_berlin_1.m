%function [onsets, names, durations, pmod, eventdesign] = cont_trialfun_berlin_1(S, subject)
function [eventdesign] = cont_trialfun_berlin_1(S)

% datadir=[]; datadir='C:\Users\Ashwani\Dropbox\Shared\Data';
% subject='aBPLFP11_off';
% restable=[];
dopa={'off';'on'};
% cd(datadir);
% D=spm_eeg_load(subject);
WGflag=0;
D=S.D;
%% check triggers
subject = D.initials;
event = D.events;
ind = strmatch('EEG', {event.type}); 
event = event(ind);

trigind  = find(strcmp('EEG157', {event.type}));
Rrespind  = find(strcmp('EEG159', {event.type}));
Lrespind  = find(strcmp('EEG160', {event.type}));
if isempty(trigind)
    error('no valid triggers');
end

Larrow=60; Lstop=70; Rarrow=80; Rstop=90;
arrowind = trigind(ismember([event(trigind).value], [Larrow Rarrow Lstop Rstop]));
if isempty(arrowind)
    error('no valid triggers');
end
stopind = trigind(ismember([event(trigind).value], [Lstop Rstop]));
Lstopind = trigind(ismember([event(trigind).value], [Lstop]));
Rstopind = trigind(ismember([event(trigind).value], [Rstop]));

%% Check buttons aren't swapped
temp={};
temp.arrowind = trigind(ismember([event(trigind).value], [Rarrow]));
respcol=zeros(length(arrowind),2); %first col is correct right response, second is incorrect resposne
for e=[temp.arrowind]
temp.Rresp=[]; temp.Rresp=Rrespind(  find( ([event(Rrespind).time] > [event((e)).time]) .* ([event(Rrespind).time] < ([event((e)).time]+1) ) ));
temp.Lresp=[]; temp.Lresp=Lrespind(  find( ([event(Lrespind).time] > [event((e)).time]) .* ([event(Lrespind).time] < ([event((e)).time]+1) ) ));
if ~isempty(temp.Rresp)
    respcol(e,1)=1;
end
if ~isempty(temp.Lresp)
    respcol(e,2)=1;
end
end
if sum(respcol(:,2))> sum(respcol(:,1)) % button presses wrong way round
Lrespind  = find(strcmp('EEG159', {event.type}));
Rrespind  = find(strcmp('EEG160', {event.type}));
WGflag=1;
end

Lrespind = Lrespind(ismember([event(Lrespind).value], [10]));
Rrespind = Rrespind(ismember([event(Rrespind).value], [10]));
%% Begin trial classification
eventdesign={};
alltrials={};
SOA=0.2;
inc=0.05;
for i = 1:(numel(arrowind))
   K={}; K.responsetypeind=NaN; K.signal=NaN; K.trialtypeind = NaN; K.soa=NaN; K.rt=NaN; K.resptype=NaN; K.trialside=NaN; K.trialcode=NaN; 
   K.errortrial=0;
    K.arrowind= arrowind(i);
    if event(K.arrowind).value==Rarrow
      K.respind=Rrespind(  find( ([event(Rrespind).time] > [event(arrowind(i)).time]) .* ([event(Rrespind).time] < ([event(arrowind(i)).time]+1) ) )); %[event(Rrespind).time] < [event(arrowind(i+1)).time]
        if ~isempty(K.respind)
             if numel(K.respind)==1 %more than 1 button press
            K.trialtype='RGR'; K.rt= event(K.respind).time-event(K.arrowind).time; K.trialside=1; K.trialcode=0;
            else
            K.respind = NaN; K.trialtype='ERROR_RGwbp';
            end
        else K.respind = NaN; K.trialtype='ERROR_RGwbp';
        end
    elseif event(K.arrowind).value==Larrow
      K.respind=Lrespind(  find( ([event(Lrespind).time] > [event(arrowind(i)).time]) .* ([event(Lrespind).time] < ([event(arrowind(i)).time]+1) ) ));
        if ~isempty(K.respind)
            if numel(K.respind)==1 %more than 1 button press
            K.trialtype='LGL'; K.rt= event(K.respind).time-event(K.arrowind).time; K.trialside=2; K.trialcode=0;
            else
            K.respind = NaN; K.trialtype='ERROR_LGwbp';
            end
        else K.respind = NaN; K.trialtype='ERROR_LGwbp';
        end
      
    elseif event(K.arrowind).value==Rstop
        K.respind=Rrespind(  find( ([event(Rrespind).time] > [event(arrowind(i)).time]) .* ([event(Rrespind).time] < ([event(arrowind(i)).time]+1) ) ));
        K.respindE_ws=Lrespind(  find( ([event(Lrespind).time] > [event(arrowind(i)).time]) .* ([event(Lrespind).time] < ([event(arrowind(i)).time]+1) ) ));
        if isempty(K.respind) && isempty(K.respindE_ws) %correctly stopped trial
            K.soa=SOA; SOA=SOA+inc;  K.trialtype='RSC';  K.respind = NaN; K.trialside=1; K.trialcode=1;
        elseif ~isempty(K.respind) && isempty(K.respindE_ws) %incorrect stop trial
            if numel(K.respind)==1
            K.soa=SOA; SOA=SOA-inc; K.trialtype='RSI';  K.rt= event(K.respind).time-event(K.arrowind).time; K.trialside=1; K.trialcode=-1;
            else
            K.soa=SOA; SOA=SOA-inc; K.trialtype='RSI'; K.respind = K.respind(1); K.rt= event(K.respind).time-event(K.arrowind).time; K.trialside=1; K.trialcode=-1;%still changes SOA
            end
        elseif isempty(K.respind) && ~isempty(K.respindE_ws) %incorrect stop trial/ wrong button
            K.soa=NaN; K.trialtype='ERROR_RSWS'; K.respind = NaN; %no change to SOA
        elseif ~isempty(K.respind) && ~isempty(K.respindE_ws) %double press, any order
            K.soa=NaN;  K.trialtype='ERROR_RS2bp'; K.respind = NaN;
            if K.respind(1) < K.respindE_ws(1)
                SOA=SOA-inc; %still changes SOA if first press is correct side
            else
            end
        end
        
     elseif event(K.arrowind).value==Lstop
        K.respindE_ws=Rrespind(  find( ([event(Rrespind).time] > [event(arrowind(i)).time]) .* ([event(Rrespind).time] < ([event(arrowind(i)).time]+1) ) ));
        K.respind=Lrespind(  find( ([event(Lrespind).time] > [event(arrowind(i)).time]) .* ([event(Lrespind).time] < ([event(arrowind(i)).time]+1) ) ));
        if isempty(K.respind) && isempty(K.respindE_ws) %correctly stopped trial
            K.soa=SOA; SOA=SOA+inc;  K.trialtype='LSC'; K.respind = NaN; K.trialside=2; K.trialcode=1;
        elseif ~isempty(K.respind) && isempty(K.respindE_ws) %incorrect stop trial
            if numel(K.respind)==1
            K.soa=SOA; SOA=SOA-inc; K.trialtype='LSI';  K.rt= event(K.respind).time-event(K.arrowind).time; K.trialside=2; K.trialcode=-1;
            else
            K.soa=NaN; SOA=SOA-inc; K.trialtype='LSI';  K.respind = K.respind(1); K.rt= event(K.respind).time-event(K.arrowind).time; K.trialside=2; K.trialcode=-1; %still changes SOA
            end
        elseif isempty(K.respind) && ~isempty(K.respindE_ws) %incorrect stop trial/ wrong button
            K.soa=NaN; K.trialtype='ERROR_LSWS'; K.respind = NaN; %no changes SOA
        elseif ~isempty(K.respind) && ~isempty(K.respindE_ws) %double press, any order
            K.soa=NaN; K.trialtype='ERROR_LS2bp'; K.respind = NaN; %still changes SOA
            if K.respind(1) < K.respindE_ws(1)
                SOA=SOA-inc; %still changes SOA if first press is correct side
            else
            end
        end
        
    end
    
    if ~isnan(K.respind)
    if strmatch(event(K.respind).type,'EEG159')
        K.resptype=1; %R
    elseif strmatch(event(K.respind).type,'EEG160')
        K.resptype=2; %L
    end
    end
    
    if SOA>0.9
       SOA=0.9;
    elseif SOA<0.001
       SOA=0;
    end
    
    if strmatch('ERROR',K.trialtype)
       K.errortrial=1;
    else
       K.errortrial=0;
    end
    
alltrials=[alltrials; {i K.arrowind event(K.arrowind).value event(K.arrowind).time K.soa K.rt K.respind K.resptype K.trialtype K.errortrial K.trialside K.trialcode}];

end

%% set-up eventdesign

eventdesign.subject=subject;
eventdesign.dopa=dopa{S.dopastat};
alltrials=[alltrials [NaN; alltrials(1:end-1,12)] [alltrials(2:end,12); NaN]]; %columns are trialdefs, current trial, previous trial, next trial(all coded as go=0 fail=-1 succ=1)
eventdesign.alltrials=alltrials;
alltrials(find([alltrials{:,10}]),:)=[];
trialcodes=[]; trialcodes=cell2mat(alltrials(:,12));
%eventdesign.pstopfreq =sum(alltrials(:,3)>12) /  (sum(alltrials(:,3)<13)  + sum(alltrials(:,3)>12));% %percentage of stop trials presented
eventdesign.stopfreq =(sum(abs(trialcodes)==1)) /  (sum(abs(trialcodes)==1) + (sum(trialcodes==0))) ;  %percentage of stop trials (responsed to)
eventdesign.PercErrors = (sum((trialcodes==-1))) /  (sum(abs(trialcodes)==1));

%% remember eventdesign.alltrials includes error trials, whereas all below don't
eventdesign.goALL=cell2mat(alltrials(:,4)); %.* (1000/hdr.Fs);
eventdesign.goALL_prevtrial=cell2mat(alltrials(:,13)); %prevtrial;
eventdesign.goALL_currtrial=cell2mat(alltrials(:,12)); %currtrial';
eventdesign.goALL_side=cell2mat(alltrials(:,11)); %1=R, 2=L
%eventdesign.cross_respside=alltrials(:,11);
eventdesign.goALL_rt=cell2mat(alltrials(:,6)) ;
eventdesign.goALL_soa=cell2mat(alltrials(:,5)); %soa ;
eventdesign.goR=cell2mat(alltrials(find(eventdesign.goALL_side==1),4));
eventdesign.goL=cell2mat(alltrials(find(eventdesign.goALL_side==2),4));
eventdesign.resR=[event(cell2mat(alltrials(find(cell2mat(alltrials(:,8))==1),7))).time]';
eventdesign.resL=[event(cell2mat(alltrials(find(cell2mat(alltrials(:,8))==2),7))).time]';
TOTsoa=eventdesign.goALL+eventdesign.goALL_soa;
eventdesign.ST_succ=TOTsoa(find(eventdesign.goALL_currtrial==1));
eventdesign.ST_fail=TOTsoa(find(eventdesign.goALL_currtrial==-1));
eventdesign.ST_Lsucc=TOTsoa(find ((eventdesign.goALL_currtrial==1) .* (eventdesign.goALL_side==2)) );
eventdesign.ST_Rsucc=TOTsoa(find ((eventdesign.goALL_currtrial==1) .* (eventdesign.goALL_side==1)) );
eventdesign.ST_Lfail=TOTsoa(find ((eventdesign.goALL_currtrial==-1) .* (eventdesign.goALL_side==2)) );
eventdesign.ST_Rfail=TOTsoa(find ((eventdesign.goALL_currtrial==-1) .* (eventdesign.goALL_side==1)) );
%% splines
tempdata=cell2mat(alltrials(:,[1 5 6 11 12]));
seq=tempdata(:,1);
grtind=find(tempdata(:,5)==0); %index for go trials
crtind=find(abs(tempdata(:,5))==1); %index for change trials
scrtind=find(tempdata(:,5)==1);
ucrtind=find(tempdata(:,5)==-1);
allrt=tempdata(:,3); %rt ALL trials
allsoa=tempdata(:,2); %soa ALL trials

% go only spline
epsilon = max(diff([0 seq(grtind)' max(seq)]))^1/0.06; %smoothing factor
prt = 1/(1+epsilon);
grtspline=csaps(seq(grtind),allrt(grtind),prt,1:max(seq));%eventdesign.cross,1)); %

% change only soa spline
epsilon = max(diff([0 seq(crtind)' max(seq)]))^1/6; %smoothing factor
prt = 1/(1+epsilon);
if numel(crtind)>2
    crtspline=csaps(seq(crtind),allsoa(crtind),prt,1:max(seq)) ; %eventdesign.cross,1));
else
    errorr
    %crtspline = repmat(allsoa(crtind), size(allsoa))' ;
end

SSRT=grtspline-crtspline;
figure ;%(subject+20);
hold on
    subplot(1,2,1); plot(1:max(seq), grtspline, 'g',...
    seq(grtind), allrt(grtind), 'go',...
    1:max(seq), crtspline, 'r',...
    seq(crtind), allsoa(crtind), 'ro',...
    seq(crtind), allrt(crtind), 'bo',...
    1:max(seq), SSRT, 'm');
    xlabel('Trial Number'); ylabel(' Time (s)'); title([subject ' ' dopa{S.dopastat}]);
    legend('Go rt Spline', 'Go rt', 'SOA spline', 'SOA', 'Fail RT', 'SSRT');
    set(gcf, 'Position',[100 100 1200 600]);
    xupperlim=max(allrt)+0.1;
    subplot(5,4,3); hist(allrt(grtind)); xlim([0 xupperlim]); ylim([0 20]); text(0.8,15,'Go RT (s)');
    subplot(5,4,7); hist(allrt(crtind)); xlim([0 xupperlim]); ylim([0 20]); text(0.8,15,'Stop RT (s)');
    subplot(5,4,11); hist(allsoa(ucrtind)); xlim([0 xupperlim]); ylim([0 20]); text(0.8,15,'FailStop SOA (s)');
    subplot(5,4,15); hist(allsoa(crtind)); xlim([0 xupperlim]); ylim([0 20]); text(0.8,15,'AllStop SOA (s)');
    subplot(5,4,19); hist(allsoa(scrtind)); xlim([0 xupperlim]); ylim([0 20]); text(0.8,15,'SuccStop SOA (s)');
    %hgsave(gcf, 'RTplots.fig');
    %close(gcf)

%% SSRT estimates
%1) Mean of last 40 trials in staircase
ntrials=numel(allrt)-40;
SSRTobs=(mean(allrt(grtind(grtind>ntrials)))) - (mean(allsoa(crtind(crtind>ntrials))));

%2) integration method (boehler 2012)
PercErrors=numel(ucrtind)/numel(crtind);
Rankofinterest= round((numel(grtind) * PercErrors));
sortallrt= sort(allrt(grtind));
SSRTint=[]; SSRTint=sortallrt(Rankofinterest) - nanmean(allsoa);
    
%% psignifit and SSRT estimate 3 - average of inhibition function
if 0%S.mcmc
%addpath('C:\Users\ajha\Documents\MATLAB\reciprobit') % for ALLpresma
cd('C:\Users\Ashwani\Documents\MATLAB\Psignifit\mpsignifit_Nov11_cli2012');
% time=[0:100:xupperlim*1000];
% correctedsoa=[]; correctedsoa=  grtspline(seq)'-allsoa; %here input is predicted go (removing unc errors) - actual SOA
% correctedsoa=correctedsoa*1000; %change to ms for priors to work properly
% callsoa=[]; callsoa=(median(allrt(grtind))-allsoa)*1000; % if use RT - SOA (rather than SOA - RTchange) , then translates abiscca into SSRT which is more stable across subjects and therefore can use same priors for all subjects
%             n_elements_succ=hist(callsoa(scrtind),time);
%             n_elements_stop=hist(callsoa(crtind),time);
%             ndat=[time; n_elements_succ; n_elements_stop]';
%                 c_elements_succ=hist(correctedsoa(scrtind),time);
%                 c_elements_stop=hist(correctedsoa(crtind),time);
%                 cdat=[time; c_elements_succ; c_elements_stop]';
%             priors.m_or_a= 'Gamma(2, 400)';% 'None'; treshold, try 4,100
%             priors.w_or_b= 'Gamma(2, 400)'; %'None'; slope try 2,100 used 4,100 for sub 3exp3, sub6exp4
%             priors.lambda= 'Beta(1.5,10)'; %'Uniform(0,.1)';lapse (upper) try 1,20
%             priors.gamma= 'Beta(1.5,10)'; %'Uniform(0,.1)'; guessing (lower)try 1,20
%             
%             nresults = BayesInference (ndat, priors, 'nafc', 1, 'sigmoid', 'logistic', 'samples', S.burn); %,'pilot', pilot.mcestimates, 'generic')
%             cresults = BayesInference (cdat, priors, 'nafc', 1, 'sigmoid', 'logistic', 'samples', S.burn); %,'pilot', pilot.mcestimates, 'generic')
%             
%             subplot(2,4,4);
%             [naxhandle, ndeviance, npval]=plotPMF_ashweighted (nresults , 'xlabel', 'medianRT - SOA (ms)')
%             xlim([0 800]); ylim([0 1]);
%             title(subject)
%             set(gca,'ytick',[0 0.5 1]);
%             set(gca,'xtick',[0 250 500 750]);
%             set(gca,'fontsize',[12])
%             
%             subplot(2,4,8);
%             [caxhandle, cdeviance, cpval]=plotPMF_ashweighted (cresults , 'xlabel', 'splineRT - SOA (ms)')
%             xlim([0 800]); ylim([0 1]);
%             title(subject)
%             set(gca,'ytick',[0 0.5 1]);
%             set(gca,'xtick',[0 250 500 750]);
%             set(gca,'fontsize',[12]);

time=[-800:100:800];
correctedsoa=[]; correctedsoa=  grtspline(seq)'-allsoa-SSRTint; %here input is predicted go (removing unc errors) - actual SOA - SSRTint (so that SSRT is zeroed and priors stable).
correctedsoa=correctedsoa*1000; %change to ms for priors to work properly
callsoa=[]; callsoa=(median(allrt(grtind))-allsoa-SSRTint)*1000; % if use RT - SOA (rather than SOA - RTchange) , then translates abiscca into SSRT which is more stable across subjects and therefore can use same priors for all subjects
            n_elements_succ=hist(callsoa(scrtind),time);
            n_elements_stop=hist(callsoa(crtind),time);
            ndat=[time; n_elements_succ; n_elements_stop]';
                c_elements_succ=hist(correctedsoa(scrtind),time);
                c_elements_stop=hist(correctedsoa(crtind),time);
                cdat=[time; c_elements_succ; c_elements_stop]'; %'Gauss(0,40)'
            priors.m_or_a= 'Gauss(0, 50)';% 'None'; treshold, try 4,100
            priors.w_or_b= 'Gamma(2, 400)'; %'None'; slope try 2,100 used 4,100 for sub 3exp3, sub6exp4
            priors.lambda= 'Beta(1,10)'; %'Uniform(0,.1)';lapse (upper) try 1,20
            priors.gamma= 'Beta(1,10)'; %'Uniform(0,.1)'; guessing (lower)try 1,20
            
            nresults = BayesInference (ndat, priors, 'nafc', 1, 'sigmoid', 'logistic', 'samples', S.burn); %,'pilot', pilot.mcestimates, 'generic')
            cresults = BayesInference (cdat, priors, 'nafc', 1, 'sigmoid', 'logistic', 'samples', S.burn); %,'pilot', pilot.mcestimates, 'generic')
            
            subplot(2,4,4);
            [naxhandle, ndeviance, npval]=plotPMF_ashweighted (nresults , 'xlabel', 'medianRT - SOA - SSRTint (ms)')
            xlim([-800 800]); ylim([0 1]);
            title(subject)
            set(gca,'ytick',[0 0.5 1]);
            set(gca,'xtick',[-500 -250 0 250 500]);
            set(gca,'fontsize',[12]);
            
            subplot(2,4,8);
            [caxhandle, cdeviance, cpval]=plotPMF_ashweighted (cresults , 'xlabel', 'splineRT - SOA - SSRTint (ms)')
            xlim([-600 600]); ylim([0 1]);
            title(subject)
            set(gca,'ytick',[0 0.5 1]);
            set(gca,'xtick',[-500 -250 0 250 500]);
            set(gca,'fontsize',[12]);
else
nresults.params_estimate(1)=NaN; cresults.params_estimate(1)=NaN; ndeviance=NaN; cdeviance=NaN;
end

% restablei=[];
% restablei=[{subject S.dis S.target eventdesign.dopa max(seq) numel(grtind) numel(ucrtind) numel(scrtind) eventdesign.stopfreq eventdesign.PercErrors,...    
% median(allrt(grtind)) median(allrt(ucrtind)) median(allsoa(scrtind)) median(allsoa(ucrtind)),...
% SSRTobs SSRTint nresults.params_estimate(1) cresults.params_estimate(1) ndeviance cdeviance WGflag}];
%%
% if S.stopper
% stopper
% end

cd(D.path);
% if S.savefig
% hgsave(gcf, 'RTplots.fig');
% end
close(gcf)

return
%%*** stopped here
splines=[rejectind(seq) (grtspline(seq)') [diff(grtspline(seq)) NaN]' (crtspline(seq)') (SSRT(seq)')];
splines(find(splines(:,1)),:)=[]; % get rid of trials with no clear preceeding event...
eventdesign.grtspline=splines(:,2);
eventdesign.diffgrtspline=splines(:,3);
eventdesign.crtspline=splines(:,4);
eventdesign.SSRT=splines(:,5);
eventdesign.splines=splines;
eventdesign.allgo=[event(alltrials(:,5)).time]';
eventdesign.allchange=[event(alltrials(find(abs(eventdesign.cross_currtrial)==1),6)).time]';
%% design 1st level SPM

names={};
onsets={};
onsetssamples={};
durations={};
allnames=fieldnames(eventdesign);
selectXind=[7 29 16:17 20:23]; % if including buttom presses, go l / r = 14 and 15

factgolabels={}; factcodes=[];
mlabel={'goL_'; 'goR_'};
nlabel={'prevfail'; 'prevgo'; 'prevsucc'};

for m=1:2
    for n=[1:3]
    factgolabels=[factgolabels; [mlabel{m} nlabel{n}]];
    factcodes= [factcodes (eventdesign.cross_goside==m) .* (eventdesign.cross_prevtrial==n-2)];
    end
end

%turn factorial conditions into mean-centred regressors
factcodes(factcodes==0)=-1;
factcodes = factcodes - (repmat(mean(factcodes),size(factcodes,1),1));

for i=1:size(selectXind,2)
    names{i}=allnames{selectXind(i)};
    onsets{i}=getfield(eventdesign ,allnames{selectXind(i)})';
    durations{i}=zeros(size(onsets{i}));
end
% 
% for i=size(selectXind,2)+1:size(selectXind,2)+size(factcodes,2)
%     names{i}=factgolabels{i-size(selectXind,2)};
%     onsets{i}=eventdesign.allgo(find(factcodes(:,i-size(selectXind,2))))';
%     durations{i}=zeros(size(onsets{i}));
% end

namelist=names;
for i = 1:numel(names)
    names{i} = repmat(names(i), length(onsets{i}), 1);
end
% prepare regressors
pmod=struct('name',{},'param',{},'poly',{});
pmod(1).namelist=namelist; % for use in Vlad GLM


leftind=eventdesign.cross_goside==1;
rightind=eventdesign.cross_goside==2;

%B1) Go cues with spline RT
np=2;
pmod(np).name{1}=[namelist{np} '_splineRT'];
pmod(np).param{1}=(eventdesign.grtspline- mean(eventdesign.grtspline)) ./ std(eventdesign.grtspline);
pmod(np).poly{1}=1;

for i=2:7
pmod(np).name{i}=[factgolabels{i-1}];
pmod(np).param{i}=factcodes(:,i-1);
pmod(np).poly{i}=1;
end
% %
% np=3;
% pmod(np).name{1}=[namelist{np} '_splineRT'];
% pmod(np).param{1}=eventdesign.grtspline(find(rightind)) - mean(eventdesign.grtspline(find(rightind)));
% pmod(np).poly{1}=1;

%C) SSRT with change trials

% changeind=find(abs(eventdesign.cross_currtrial)==1);
% np=2;
% pmod(np).name{1}=[namelist{np} '_splineSSRT'];
% pmod(np).param{1}=eventdesign.SSRT(changeind)  - mean(eventdesign.SSRT(changeind));
% pmod(np).poly{1}=1;
ri=1;
for succi=[1 -1]
    for side=1:2
    succind=find((eventdesign.cross_currtrial==succi) .* (eventdesign.cross_goside==side));
    reg=eventdesign.cross_rt(succind) - eventdesign.cross_soa(succind) 
    reg= (reg - mean(reg)) ./ std(reg);
    
pmod(ri+4).name{1}=[namelist{ri+4} '_CRT'];
pmod(ri+4).param{1}=(eventdesign.SSRT(succind) - mean(eventdesign.SSRT(succind))) ./ std(eventdesign.SSRT(succind));
pmod(ri+4).poly{1}=1;
ri=ri+1;
    end
end

%  succind=find(eventdesign.cross_currtrial==1);
% failind=find(eventdesign.cross_currtrial==-1);
% 
% np=5;
% pmod(np).name{1}=[namelist{np} '_splineSSRT'];
% pmod(np).param{1}=(eventdesign.SSRT(succind) - mean(eventdesign.SSRT(succind))) ./ std(eventdesign.SSRT(succind));
% pmod(np).poly{1}=1;
% 
% np=6;
% pmod(np).name{1}=[namelist{np} '_splineSSRT'];
% pmod(np).param{1}=(eventdesign.SSRT(failind) - mean(eventdesign.SSRT(failind))) ./ std(eventdesign.SSRT(failind));
% pmod(np).poly{1}=1;

% pmod(np).name{2}=[namelist{np} '_diffGO'];
% diffreg=eventdesign.diffgrtspline(find(eventdesign.cross_currtrial==1)) - nanmean(eventdesign.diffgrtspline(find(eventdesign.cross_currtrial==1)));
% if ~isempty(find(isnan(diffreg)))
%     diffreg((find(isnan(diffreg))))=0;
% end
% pmod(np).param{2}=diffreg;
% pmod(np).poly{2}=1;
% 
% np=7;
% pmod(np).name{1}=[namelist{np} '_splineSSRT'];
% pmod(np).param{1}=eventdesign.SSRT(find(eventdesign.cross_currtrial==-1)) - mean(eventdesign.SSRT(find(eventdesign.cross_currtrial==-1)));
% pmod(np).poly{1}=1;
% 
% pmod(np).name{2}=[namelist{np} '_diffGO'];
% diffreg=eventdesign.diffgrtspline(find(eventdesign.cross_currtrial==-1)) - nanmean(eventdesign.diffgrtspline(find(eventdesign.cross_currtrial==-1)));
% if ~isempty(find(isnan(diffreg)))
%     diffreg((find(isnan(diffreg))))=0;
% end
% pmod(np).param{2}=diffreg;
% pmod(np).poly{2}=1;

eventdesign.spm.names=names;
eventdesign.spm.onsets=onsets;

names = cat(1, names{:});
onsets = [onsets{:}];
durations = [durations{:}];

fename=[subject '_' num2str(experiment) '_eventdesign.mat'];
save(fename, 'eventdesign');

return
%% plot  priors
r=gamma(-800:10:800);
figure; plot(r, (-800:10:800));

priordist = betapdf(0:0.01:1,1,10);
figure; plot(0:0.01:1,priordist);

priordist = gampdf(0:1:1000,2,400);
figure; plot(0:1:1000,priordist);

priordist=pdf('norm',[-800:10:800], 0,50);
figure; plot([-800:10:800],priordist)
