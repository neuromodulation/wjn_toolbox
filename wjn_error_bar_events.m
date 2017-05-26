function D=wjn_error_bar_events(filename,dsample)
%%
keep filename dsample
load(filename,'pen','target','turn','boundary','priority')
%
timewin = [-1 1];

it = mythresh(turn.values,1);
ib = mythresh(boundary.values,1);
fsample = 1/turn.interval;
t=turn.times;
p = pen.values;
ta = target.values;
er = pen.values-target.values;
% be = C3_beta.values;
% 



for a=1:length(ib);
    itb(a)=sc(it,ib(a));
end
nitb=zeros(size(it));
nitb(itb)=1;


et = linspace(-.5*fsample,.5*fsample,fsample);
iet = 1*fsample;
%
close all
nn=0;nb=0;nt=0;
for a = 1:length(it)
    
    iiet = [it(a)-iet:it(a)+iet];
    tit=linspace(-iet,iet,numel(iiet));
% %     rp=smooth(p(iiet),.05*fsample);
    mp=abs(smooth(p(iiet),.05*fsample));
    mmp=mp-mean(mp);
    if max(mmp(iet+1:iet+.1*fsample))<0
        mmp=mmp*-1;
    end
% %     rt=smooth(ta(iiet),.05*fsample);
%     mt=abs(smooth(ta(iiet),.05*fsample));
    me=abs(smooth(er(iiet),.05*fsample));
%     mb=(abs(smooth(be(iiet),.05*fsample))-mean(abs(smooth(be(iiet),.05*fsample))))./mean(abs(smooth(be(iiet),.05*fsample)));
 
    [maxmp,i]=max(mmp);
    [maxme,ie]=max(me);
    imov(a)=iiet(i);
    ime(a) = iiet(ie);
    err_imove(a) = me(i);
%     beta_imove(a) = mb(i);
    nt=nt+1;
    itrl(nt) = imov(a);
    clabel{nt} = 'turn';
    error(nt) = err_imove(a);
    
    if nitb(a)
        nb=nb+1;
        nt=nt+1;
        itrl(nt) = imov(a);
        clabel{nt} = 'bturn';
        error(nt)=err_imove(a);
        boundary_imov(nb) = imov(a);
    else
        nt=nt+1;
        itrl(nt)=imov(a);
        clabel{nt}='nturn';
        error(nt)=err_imove(a);
        nn=nn+1;
        no_boundary_imov(nn)=imov(a);
    end
%        plot(tit,rp)
%     hold on
%     plot(tit,rt,'color','g')
%     plot(tit,me,'color','r')
%     plot(tit,mb,'color','m')
%     scatter(tit(i),rp(i));
%     scatter(tit(ie),maxme,'r+');
%     hold off;
%     pause
end
   %
    n=0;

        for b  =1:length(itrl);
            
            if itrl(b)+timewin(2)*fsample <= length(t)
                n=n+1;
        trl(n,1:3) = [itrl(b)+timewin(1)*fsample itrl(b)+timewin(2)*fsample timewin(1)*fsample];
        conditionlabels{n} = clabel{n};
        ttrl(n,1:3) = [t(trl(n,1)) t(trl(n,2)) timewin(1)];
            end
        end
%%

D=wjn_spikeconvert(filename);


D.conditionlabels= conditionlabels;
D.trl = trl;
D.error  =error;
D.ttrl=ttrl;
save(D)

S=[];
S.D =D.fullfile;
S.fsample_new=dsample;
D=spm_eeg_downsample(S);
Draw=D;
D=wjn_tf_wavelet(D.fullfile,[1:dsample/2]);
D=wjn_tf_baseline(D.fullfile);

S.D = D.fullfile;    
S.trl = round(D.ttrl*dsample);
S.conditionlabels = D.conditionlabels;
D=spm_eeg_epochs(S);
S.D = Draw.fullfile;
Draw=spm_eeg_epochs(S);
D.errortrials = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)-Draw(Draw.indchannel('target'),:,:)));
D.target = squeeze(abs(Draw(Draw.indchannel('target'),:,:)));
D.pen = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)));
for a = 1:size(D.pen,2);
D.speed(:,a) = smooth(abs(mydiff(D.pen(:,a))),.05*D.fsample);
D.derror(:,a) = smooth(abs(mydiff(D.errortrials(:,a))),.05*D.fsample);
end
save(D);

%%
close all
D=spm_eeg_load('ertf_dspmeeg_wjn_error_c3s');
iturn = D.indtrial('turn');
turn = iturn;
nturn = D.indtrial('nturn');
bturn = D.indtrial('bturn');
ic = D.indchannel('C3');
conds = {'turn','nturn','bturn'};
cc=colorlover(6);
figure
for a = 1:length(conds);
subplot(2,3,a)
itrial = D.indtrial(conds{a});
imagesc(D.time,D.frequencies,squeeze(mean(D(ic,:,:,itrial),4)))
title({conds{a},['N = ' num2str(numel(itrial))]})
axis xy
caxis([-50 50])
subplot(2,3,a+3)
he=mypower(D.time,D.errortrials(:,itrial)',cc(1,:));
hold on
ht=mypower(D.time,D.target(:,itrial)'./4,cc(2,:));
hp=mypower(D.time,D.pen(:,itrial)'./4,cc(3,:));
hs=mypower(D.time,D.speed(:,itrial)'*40,cc(4,:))
ylim([0 4]);
xlim(timewin);
legend([hp,ht,he,hs],{'pen','target','error','speed'})
end

% clear r p
% for a = 1:length(D.frequencies);
%     for b = 1:length(D.time);
%         [r(a,b),p(a,b)]=corr(squeeze(D(ic,a,b,iturn)),D.error(iturn)','type','spearman');
%     end
% end
% 
% figure
% imagesc(D.time,D.frequencies,r)
% caxis([-1 1])
% axis xy
% hold on
% contour(D.time,D.frequencies,p<=0.05,1,'color','k','linewidth',3)
% 
%

clear r p rp rt rs pe pp pt ps
iturn = nturn;
for a = 1:length(D.frequencies)
    
    [re(a),pe(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.errortrials(:,iturn),2),'type','spearman');
    [rp(a),pp(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.pen(:,iturn),2),'type','spearman');
    [rt(a),pt(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.target(:,iturn),2),'type','spearman');
    [rs(a),ps(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.speed(:,iturn),2),'type','spearman');
end
%
figure
subplot(4,1,1)
myline(D.frequencies,re,'color',cc(1,:))
ylabel('ERROR \rho')
xlabel('FREQUENCY')
hold on
sigbar(D.frequencies,pe<=fdr_bh(pe,.05))

subplot(4,1,2)
myline(D.frequencies,rt,'color',cc(2,:))
ylabel('TARGET \rho')
xlabel('FREQUENCY')
hold on
sigbar(D.frequencies,pt<=fdr_bh(pt,.05));
subplot(4,1,3)
myline(D.frequencies,rp,'color',cc(3,:))
ylabel('PEN \rho')
xlabel('FREQUENCY')
hold on 
sigbar(D.frequencies,pp<=fdr_bh(pp,.05))
subplot(4,1,4)
myline(D.frequencies,rs,'color',cc(4,:))
ylabel('SPEED \rho')
xlabel('FREQUENCY')
hold on
sigbar(D.frequencies,ps<=fdr_bh(ps,.05))
%
close all
f = D.frequencies;
freqrange = {'theta','alpha','low beta','high beta','low gamma','broadband gamma'};
behav = {'errortrials','target','pen','speed'};
fr = [4 8;8 12; 12 20;21 30; 30 45; 55 90; 45 140];
iturn = nturn;
for a = 1:numel(freqrange)
    figure
    m(:,a) = squeeze(mean(mean(D(ic,sc(f,fr(a,1)):sc(f,fr(a,2)),:,:),2),4));
    for c=1:numel(behav);
    b = mean(D.(behav{c})(:,iturn),2);
    [r,p]=corr(m(:,a),b);
    subplot(1,4,c)
    scatter(m(:,a),b,'k+')
    [x,y]=mycorrline(m(:,a),b,min(m(:,a)),max(m(:,a)));
    hold on
    plot(x,y,'color',[.5 .5 .5],'linewidth',2)
    title([freqrange{a} ' \rho = ' num2str(r,3) ' P = ' num2str(p,3)])
    xlabel([freqrange{a} ' activity'])
    ylabel([behav{c}])
    end
    figone(7,30);
end

%%
f=D.frequencies;
for a = 1:D.nsamples;
    for b=1:length(f);
    [r(a,b),p(a,b)]=corr(squeeze(D(ic,b,a,nturn)),D.errortrials(a,nturn)');
    end
end

figure
imagesc(D.time,f,r'),axis xy
hold on
contour(D.time,f,p'<=.05,1,'color','k','linewidth',2)

%% 
close all
D=spm_eeg_load('rtf_dspmeeg_wjn_error_c3s.mat');
Draw=spm_eeg_load('dspmeeg_wjn_error_c3s.mat');


D.errortrials = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)-Draw(Draw.indchannel('target'),:,:)));
D.derror = abs(mydiff(D.errortrials));
D.target = squeeze(abs(Draw(Draw.indchannel('target'),:,:)));
D.pen = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)));
% D.speed = smooth(abs(mydiff(D.pen)),.05*D.fsample);
D.rspeed = abs(mydiff(mydiff(D.pen)));
save(D);
clear r p
f=D.frequencies;
for a = 1:length(f);
    [r(a),p(a)]=corr(squeeze(D(ic,a,:,1)),D.rspeed','rows','pairwise');
end

figure,
plot(f,r)
hold on
sigbar(f,p<=fdr_bh(p))

theta = squeeze(mean(D(ic,4:8,:,1),2));
alpha = squeeze(mean(D(ic,8:12,:,1),2));
beta = squeeze(mean(D(ic,16:30,:,1),2));
gamma = squeeze(mean(D(ic,30:45,:,1),2));
% 
% [e,i]=sort(D.errortrials);
% 
% figure
% scatter(theta,D.errortrials)
%%
figure,imagesc(D.time,f,squeeze(D(2,:,:,1)))
axis xy
caxis([-500 500])
hold on
plot(D.time,D.errortrials*100)
