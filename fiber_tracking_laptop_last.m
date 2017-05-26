clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)

load ../results.mat res
connectome = wjn_load_connectome('ppmi');

for a=1:length(res.PD.n)
    
    mni = [res.PD.mni_coords(a,1:3);res.PD.mni_coords(a,4:6);...
        res.PD.mni_coords(a,7:9);res.PD.mni_coords(a,10:12)];
    mni(isnan(mni(:,1)),:)=[];
    if nansum(nansum(mni))
        fname = ['fibers_' num2str(a)];
        wjn_searchfibers(fname,mni,connectome);
    end
end


%% create ROI niftis

clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)

load results.mat res
for a=1:length(res.PD.n)
    if a~=11
        mni = [res.PD.mni_coords(a,1:3);res.PD.mni_coords(a,4:6);...
            res.PD.mni_coords(a,7:9);res.PD.mni_coords(a,10:12)];
        mni(isnan(mni(:,1)),:)=[];
        wjn_spherical_roi(['ROI_' num2str(a) '.nii'],mni,1);
    end
end

%% create stimulation heatmap

clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
cd(root)

load results.mat res
mni = [];
dbs = [];
for a=1:length(res.PD.n)
        mni = [mni;res.PD.mni_coords(a,1:3);...
            res.PD.mni_coords(a,7)*-1,res.PD.mni_coords(a,8:9)];
        dbs = [dbs;res.PD.dbs_amp(a,1);res.PD.dbs_amp(a,2)];
        dbs(isnan(mni(:,1)),:)=[];
        mni(isnan(mni(:,1)),:)=[];
        
end

wjn_heatmap('dbs_amp_heatmap.nii',mni,dbs,'STN')



%% plot locations
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
cd(root)

load results.mat res

mmni = nanmean(res.PD.mni_coords);
mni= res.PD.mni_coords;
rm = nanmean([mmni(1:3);mmni(4:6)]);
lm = nanmean([mmni(7:9);mmni(10:12)]);
n=0;
for a = res.PD.images
    n=n+1;
    r(n,:) = nanmean([mni(a,1:3);mni(a,4:6)]);
    l(n,:) = nanmean([mni(a,7:9);mni(a,10:12)]);
end

figure
wjn_plot_surface('STN.nii.surf.gii')
hold on
for a =13:19
    title(num2str(a))
    plot3(r(a,1),r(a,2),r(a,3),'Marker','o','MarkerSize',15,'Markerfacecolor','r','markeredgecolor','k','linestyle','none')
    hold on
    plot3(l(a,1),l(a,2),l(a,3),'Marker','o','MarkerSize',15,'Markerfacecolor','r','markeredgecolor','k','linestyle','none')
    drawnow
    pause
end
    figure
% wjn_plot_surface('dbs_amp_heatmap.surf.gii')
wjn_plot_surface('STN.nii.surf.gii')
hold on
plot3(rm(1),rm(2),rm(3),'Marker','o','MarkerSize',15,'Markerfacecolor','r','markeredgecolor','k','linestyle','none')
plot3(lm(1),lm(2),lm(3),'Marker','o','MarkerSize',15,'Markerfacecolor','r','markeredgecolor','k','linestyle','none')


%% correlate contact pair location
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
cd(root)

load results
n=0
clear rc lc drt
for a = res.PD.images
    n=n+1;
    rc(n,:) = nanmean([res.PD.mni_coords(a,1:3) ; res.PD.mni_coords(a,4:6)]);
    lc(n,:) =  nanmean([res.PD.mni_coords(a,7:9) ; res.PD.mni_coords(a,10:12)]);
    c(n,:) = nanmean([rc(n,:);abs(lc(n,1)) lc(n,2:3)]);
    drt(n,:) = wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
    ddrt(n,:) = res.PD.drt(a,1,1)-res.PD.drt(a,1,2);
end

[r,p]=wjn_permcorr([c rc lc],drt);

ml = nanmean(lc);
mr = nanmean(rc);

rd = wjn_distance(rc,mr);
ld = wjn_distance(lc,ml);
md = nanmean(nanmean([rd ld],2));
[r,p]=wjn_permcorr([nanmean([rd,ld],2) rd ld],drt);


wjn_spherical_roi('group_location.nii',[mr;ml],md)

%% fiber counts
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
files = ffind('ffibers_*.mat');
for a  =1:length(files)
    wjn_fiber_parcellation(files{a},'nparc')
end

%% fiber counts ending only
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
files = ffind('ffibers_*.mat');
for a  =1:length(files)
    wjn_fiber_parcellation(files{a},'ncon',0)
end

%% DO AGAIN resting state connectivity
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
s = [1:10,12:20];

for a=s
    
    wjn_rs_parcellation(['nmni_sROI_' num2str(a) '_func_seed_AvgR.nii'],[],['parc_rs_' num2str(a)])
end

%%
clear
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../results.mat res

%%
load ../results.mat res
close all
clear dv drt rt fs
n=0;
for a=res.PD.images
    n=n+1;
    pb(n,1) = res.PD.pbupdrs(a);
    de(n,1)=wjn_pct_change(nanmean(res.PD.hMERR(a,1:4,1),2),nanmean(res.PD.hMERR(a,1:4,2),2));
   rt(n,1)=wjn_pct_change(nanmean(res.PD.phrt(a,2:4,1),2),nanmean(res.PD.phrt(a,2:4,2),2));
%    rt(n,1) = res.PD.phdrt(a,2,1)-res.PD.phdrt(a,2,2);
    pupdrs(n,1) = wjn_pct_change(res.PD.updrs_off(a),res.PD.updrs_on(a))
    dupdrs(n,1) = res.PD.updrs_off(a)-res.PD.updrs_on(a);
   prt(n,1)=wjn_pct_change(wjn_pct_change(res.PD.hrt(a,2,1),res.PD.hrt(a,1,1)),wjn_pct_change(res.PD.hrt(a,2,2),res.PD.hrt(a,1,2)))
%    drt(n,1)=wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
   drt(n,1) = wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
   phdrt(n,1)=wjn_pct_change(res.PD.hdrt(a,1,1),res.PD.hdrt(a,1,2));
   lrt(n,1)=wjn_pct_change(nanmean([res.PD.rgrt(a,1),res.PD.rrrt(a,1)],2),nanmean([res.PD.rgrt(a,2),res.PD.rrrt(a,2)],2))
   lmv(n,1)=wjn_pct_change(nanmean([res.PD.rgmv(a,1),res.PD.rrmv(a,1)],2),nanmean([res.PD.rgmv(a,2),res.PD.rrmv(a,2)],2))
   lpt(n,1)=wjn_pct_change(nanmean([res.PD.rgpt(a,1),res.PD.rrpt(a,1)],2),nanmean([res.PD.rgpt(a,2),res.PD.rrpt(a,2)],2))
   lgrt(n,1)=wjn_pct_change(nanmean([res.PD.rgrt(a,1)],2),nanmean([res.PD.rgrt(a,2)],2))
   lgmv(n,1)=wjn_pct_change(nanmean([res.PD.rgmv(a,1)],2),nanmean([res.PD.rgmv(a,2)],2))
   lgpt(n,1)=wjn_pct_change(nanmean([res.PD.rgpt(a,1)],2),nanmean([res.PD.rgpt(a,2)],2))
   lrrt(n,1)=wjn_pct_change(nanmean([res.PD.rrrt(a,1)],2),nanmean([res.PD.rrrt(a,2)],2))
   lrmv(n,1)=wjn_pct_change(nanmean([res.PD.rrmv(a,1)],2),nanmean([res.PD.rrmv(a,2)],2))
   lrpt(n,1)=wjn_pct_change(nanmean([res.PD.rrpt(a,1)],2),nanmean([res.PD.rrpt(a,2)],2))
   lrt(n,1)=wjn_pct_change(nanmean([res.PD.rgrt(a,1),res.PD.rrrt(a,1)],2),nanmean([res.PD.rgrt(a,2),res.PD.rrrt(a,2)],2))
   dlmv(n,1)=diff([nanmean([res.PD.rgmv(a,1),res.PD.rrmv(a,1)],2),nanmean([res.PD.rgmv(a,2),res.PD.rrmv(a,2)],2)])
   dlpt(n,1)=diff([nanmean([res.PD.rgpt(a,1),res.PD.rrpt(a,1)],2),nanmean([res.PD.rgpt(a,2),res.PD.rrpt(a,2)],2)])
   dlrt(n,1)=diff([nanmean([res.PD.rgrt(a,1),res.PD.rrrt(a,1)],2),nanmean([res.PD.rgrt(a,2),res.PD.rrrt(a,2)],2)])

   %    dlgrt(n,1)=diff(nanmean([res.PD.rgrt(a,1)],2),nanmean([res.PD.rgrt(a,2)],2))
%    dlgmv(n,1)=diff(nanmean([res.PD.rgmv(a,1)],2),nanmean([res.PD.rgmv(a,2)],2))
%    dlgpt(n,1)=diff(nanmean([res.PD.rgpt(a,1)],2),nanmean([res.PD.rgpt(a,2)],2))
%    dlrrt(n,1)=diff(nanmean([res.PD.rrrt(a,1)],2),nanmean([res.PD.rrrt(a,2)],2))
%    dlrmv(n,1)=diff(nanmean([res.PD.rrmv(a,1)],2),nanmean([res.PD.rrmv(a,2)],2))
%    dlrpt(n,1)=diff(nanmean([res.PD.rrpt(a,1)],2),nanmean([res.PD.rrpt(a,2)],2))
%      
      
   
   dv(n,1)=wjn_pct_change(res.PD.dv(a,1,1),res.PD.dv(a,1,2));
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,1)),mean(res.PD.v(a,1:2,2)));
   phsv(n,1)=wjn_pct_change(mean(res.PD.phv(a,1:2,2)),mean(res.PD.phv(a,1:2,1)));
   smv(n,1)=wjn_pct_change(mean(res.PD.mv(a,1:2,2)),mean(res.PD.mv(a,1:2,1)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   fm=load(['ncon_ffibers_' num2str(a)]);
%    sp(n,1) = numel(find(~ismember(fp.premotor.id,fm.motor.id)));
   fsma(n,1) =sum(ismember([fm.premotor.id],fm.STN.id))/fm.STN.n;
   fm1(n,1) =sum(ismember([fm.motor.id],fm.STN.id))/fm.STN.n;
   fsm(n,1)=fm.holomotor.n+fm.sensory.n;
%    fm1(n,1)=fm.M1.n
%    fsma(n,1) =sum(ismember([fm.motor.id],fm.STN.id))/fm.STN.n;
   fsa(n,1)=fm.associative.n;
   fsgi(n,1)=fm.GPi.n;
   sm(n,1) = sum(ismember([fm.M1.id;fm.SMA.id],fm.STN.id));%/fm.STN.n;
   
   pctsm(n,1) = sum(ismember([fm.M1.id;fm.SMA.id],fm.STN.id))/fm.STN.n;
%    cer(n,1) = fm.Cerebellum.n;
%    fcerstn(n,1) = sum(ismember(fm.Cerebellum.id,fm.STN.id))/fm.STN.n;
   fsmstn(n,1) = sum(ismember(fm.sensorimotor.id,fm.STN.id));
   fgpistn(n,1) = sum(ismember(fm.GPi.id,fm.STN.id))/fm.STN.n;%+sum(ismember(fm.GPi.id,fm.STN.id));
   fgpestn(n,1) = sum(ismember(fm.GPe.id,fm.STN.id))/fm.STN.n;
   fstn(n,1) = fm.STN.n;
%    f=load(['ffibers_' num2str(a)],'ids')
%    fsm(n,1)=numel(f.ids);
   
end
%
%
% drt(drt<20)=nan;
% prt(prt<20)=nan;
figure
vars={'fsm','fsmstn','fstn'};

for a = 1:length(vars)
    
    subplot(2,length(vars),a)
    wjn_corr_plot(eval(vars{a}),drt,[.5 .5 .5])
    title(vars{a})
    % xlim([0 2500])
    % ylim([-100 300])
    xlabel('Number of connecting fibers to premotor region')
    ylabel('Percentage ON and OFF difference')

    % figure
    subplot(2,length(vars),a+length(vars))
    wjn_corr_plot(eval(vars{a}),pb,[.5 .5 .5])
    % xlim([0 2500])
    % ylim([-50 200])
    xlabel('Number of connecting fibers to premotor region')
    ylabel('Percentage ON and OFF difference')
end

%%
cc=colorlover(5);

drtoff= wjn_pct_change(res.PD.phv(:,1,1),res.PD.phv(:,2,1));
drton= wjn_pct_change(res.PD.phv(:,1,2),res.PD.phv(:,2,2));

pv = wjn_pct_change(nanmean(res.PD.v(:,1,2),2),nanmean(res.PD.v(:,2,2),2));
dvon = res.PD.dv(:,1,2);
dvoff = res.PD.dv(:,1,1);
uoff = res.PD.updrs_off;
uon = res.PD.updrs_on;


pdrt = wjn_pct_change(drtoff,drton);
pu = res.PD.pupdrs;
figure
% scatter([uoff;uon],[res.PD.v(:,2,1);res.PD.v(:,2,1)],'ro','filled')
hold on
% scatter(uon,drton,'bo','filled')

wjn_corr_plot(pu,pdrt)
wjn_corr_plot(pu,pv)
wjn_corr_plot(uon,pv)
wjn_corr_plot([uoff;uon],[dvoff;dvon])
wjn_corr_plot(uon,drton)


%% generate exlclusive motor/premotor niftis
spm_imcalc({'premotor.nii','motor.nii'},'new_premotor.nii','i1>i2');
spm_imcalc({'premotor.nii','motor.nii'},'new_motor.nii','i2>i1')

%% generate SMA and M1 from AAL
spm_imcalc({'Automated Anatomical Labeling 2 (Tzourio-Mazoyer 2002).nii'},'SMA.nii','i1>=15&i1<=16')
wjn_convert2mni_voxel_space('SMA.nii')

spm_imcalc({'Automated Anatomical Labeling 2 (Tzourio-Mazoyer 2002).nii'},'M1.nii','i1>=1&i1<=2')
wjn_convert2mni_voxel_space('M1.nii')
%% print all fibers
close all

s = [1:10,12:20];
for a = s
    load(['fibers_' num2str(a)],'fc');
    pm = load(['parc_ffibers_' num2str(a)]);
    
    n = pm.sensory.n+pm.holomotor.n;
    figure
    for b = 1:length(fc)
        plot3(fc{b}(:,1),fc{b}(:,2),fc{b}(:,3))
        hold on
        title(['\DeltaRT: ' num2str(wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2))) ' N fibers: ' num2str(n)])
    end
    myprint(['fiber_plot_' num2str(a)])
    pause(1)
    close
end
%% crop all mni files
files = ffind('mni_*.nii');
for a =1:length(files)
    ea_crop_nii(files{a})
end


%% new parcellation correlate number of premotor fibers with behavioral results
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../results.mat res  
close all
% s = [1 2 3:10,12:20];

% s = [1 3 4 5 7 8 10 12 15 16 17 18 19]
s = res.PD.images
n=0;
for a=s
    n=n+1;
    de(n,1)=wjn_pct_change(nanmean(res.PD.MERR(a,1:2,2)),nanmean(res.PD.MERR(a,1:2,1)));
   rt(n,1)=wjn_pct_change(mean(res.PD.rt(a,2,1)),mean(res.PD.rt(a,2,2)));
   drt(n,1)=wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
%     drt(n,1) = wjn_pct_change(res.PD.rt(a,3,1)-res.PD.rt(a,1,1),res.PD.rt(a,3,2)-res.PD.rt(a,1,2))
   ddrt(n,1) = res.PD.drt(a,1,1)-res.PD.drt(a,1,2);
   dv(n,1)=wjn_pct_change(res.PD.dv(a,1,1),res.PD.dv(a,1,2));
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,2)),mean(res.PD.v(a,1:2,1)));
   
   cv(n,1)=wjn_pct_change(mean(res.PD.v(a,2,1)),mean(res.PD.v(a,2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   
   dlmv(n,1) = wjn_pct_change(res.PD.rgmv(a,2)-res.PD.rrmv(a,2),res.PD.rgmv(a,1)-res.PD.rrmv(a,1));
%    dlmt(n,1) = wjn_pct_change(res.PD.rgpt(a,2),res.PD.rgpt(a,1));
  
   fm=load(['ncon_ffibers_' num2str(a)]);
%    fp=load(['motor_fibers_' num2str(a)]);
%    sp(n,1) = numel(find(~ismember(fp.premotor.id,fm.motor.id)));
%    fs(n,1)=fm.premotor.n+fm.motor.n;
%     fs(n,1)=fm.GPe.n;
    o(n,1) = res.PD.order(a);
    fs(n,1) = fm.lh_holomotor.n+fm.lh_sensory.n;
    lsm(n,1) = fm.lh_holomotor.n+fm.lh_sensory.n;
    rsm(n,1) = fm.rh_holomotor.n+fm.rh_sensory.n;
    sm(n,1) = fm.lh_holomotor.n+fm.rh_holomotor.n+fm.lh_sensory.n+fm.rh_sensory.n;
end

%

% both hemispheres
figure
cc=colorlover(5);
cc=cc([1,5],:);
wjn_corr_plot(sm,drt,cc(1,:))
hold on
for a =1:length(sm)
    scatter(sm(a),drt(a),90,'MarkerFaceColor',cc(o(a),:),'MarkerEdgeColor','w');
end
xlim([0 5000])
ylim([-150 300])
xlabel('Fibers connecting to sensorimotor cortex')
ylabel('\Delta RT CON-AUT OFF/ON [%]')
figone(9,8)
% myprint('RT_FIBER_CORRELATION_SENSORIMOTOR')

% left hemisphere
figure
cc=colorlover(5);
cc=cc([1,5],:);
wjn_corr_plot(lsm,drt,cc(1,:))
hold on
for a =1:length(fs)
    scatter(lsm(a),drt(a),90,'MarkerFaceColor',cc(res.PD.order(s(a),1),:),'MarkerEdgeColor','w');
end
xlim([0 3750])
ylim([-150 300])
xlabel('Fibers connecting to sensorimotor cortex')
ylabel('\Delta RT CON-AUT OFF/ON [%]')
figone(9,8)
% myprint('RT_FIBER_CORRELATION_SENSORIMOTOR_LH')


% orderwise both hemispheres
figure
cc=colorlover(5);
cc=cc([1,5],:);
[r(1),p(1)]=wjn_corr_plot(sm(res.PD.order(s)==1),drt(res.PD.order(s)==1),cc(1,:));
hold on
[r(2),p(2)]=wjn_corr_plot(sm(res.PD.order(s)==2),drt(res.PD.order(s)==2),cc(2,:));
for a =1:length(lsm)
    h(res.PD.order(s(a)))=scatter(sm(a),drt(a),40,'MarkerFaceColor',cc(res.PD.order(s(a),1),:),'MarkerEdgeColor','w');
end
legend([h(1) h(2)],['Intuitive first: \rho = ' num2str(r(1),2) ' P = ' num2str(p(1))],['Counterintuitive first \rho = ' num2str(r(2),2) ' P = ' num2str(p(2))])
xlim([0 5000])
ylim([-150 300])
xlabel('Fibers connecting to sensorimotor cortex')
ylabel('\Delta RT CON-AUT OFF/ON [%]')
figone(9,8)
% myprint('RT_FIBER_CORRELATION_SENSORIMOTOR_ORDERED')

% orderwise both hemispheres
figure
cc=colorlover(5);
cc=cc([1,5],:);
[r(1),p(1)]=wjn_corr_plot(lsm(res.PD.order(s)==1),drt(res.PD.order(s)==1),cc(1,:));
hold on
[r(2),p(2)]=wjn_corr_plot(lsm(res.PD.order(s)==2),drt(res.PD.order(s)==2),cc(2,:));
for a =1:length(lsm)
    h(res.PD.order(s(a)))=scatter(lsm(a),drt(a),40,'MarkerFaceColor',cc(res.PD.order(s(a),1),:),'MarkerEdgeColor','w');
end
legend([h(1) h(2)],['Intuitive first: \rho = ' num2str(r(1),2) ' P = ' num2str(p(1))],['Counterintuitive first \rho = ' num2str(r(2),2) ' P = ' num2str(p(2))])
xlim([0 3750])
ylim([-150 300])
xlabel('Fibers connecting to sensorimotor cortex')
ylabel('\Delta RT CON-AUT OFF/ON [%]')
figone(9,8)
% myprint('RT_FIBER_CORRELATION_SENSORIMOTOR_LH_ORDERED')

res.PD.sm=sm;
res.PD.lsm=lsm;
res.PD.rsm=rsm;

% save ../results res

% 
% 
% subplot(1,2,2)
% wjn_corr_plot(fs,ddrt,[.5 .5 .5])
% % xlim([0 2500])
% % ylim([-50 200])
% xlabel('Number of connecting fibers to premotor region')
% ylabel('Percentage ON and OFF difference')

  

%% new parcellation correlate resting state connectivity
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../results.mat res  

close all
s = [2:10,12:20];
clear dv drt rt fs
n=0;
for a=s
    n=n+1;
    de(n,1)=wjn_pct_change(res.PD.dMERR(a,1,1),res.PD.dMERR(a,1,2));
   rt(n,1)=wjn_pct_change(mean(res.PD.rt(a,2,1)),mean(res.PD.rt(a,2,2)));
   drt(n,1)=wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
   ddrt(n,1) = res.PD.drt(a,1,1)-res.PD.drt(a,1,2);
   dv(n,1)=wjn_pct_change(res.PD.dv(a,1,1),res.PD.dv(a,1,2));
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   sv(n,1)=wjn_pct_change(nanmean(res.PD.v(a,1:2,1),2),nanmean(res.PD.v(a,1:2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   fm=load(['parc_rs_' num2str(a)]);
%    fp=load(['motor_fibers_' num2str(a)]);
%    sp(n,1) = numel(find(~ismember(fp.premotor.id,fm.motor.id)));
   fs(n,1)=fm.lh_SMA;
%     fs(n,1)=fm.GPe;
    
%     fs(n,1) = fm.holomotor.n;
   
end
%
figure
subplot(1,3,1)
cc=colorlover(5);
wjn_corr_plot(fs,drt,cc(1,:))
for a =1:length(fs)
    text(fs(a),drt(a),num2str(a));
end
% xlim([0 .5])
% ylim([-150 300])
xlabel('Functional connectivity')
ylabel('\Delta CON-AUT ON and OFF difference [%]')
% myprint('RT_FIBER_CORRELATION')


subplot(1,2,2)
wjn_corr_plot(fs,sv,[.5 .5 .5])
% xlim([0 2500])
% ylim([-50 200])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')


%% show examples
[~,i]=sort(drt);
ns = [i(1) i(end)];

%% smooth fiber images

files = ffind('mni*struc*.nii');
for a = 1:length(files)
    spm_smooth(files{a},['s' files{a}],[2 2 2])
end

%% fiber tracking whole brain correlations

clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../results.mat res  
close all
s = [1:10,12:20];
clear dv drt rt fs
n=0;
for a=s
    n=n+1;
    de(n,1)=wjn_pct_change(res.PD.dMERR(a,1,1),res.PD.dMERR(a,1,2));
   ddrt(n,1) = res.PD.drt(a,1,1)-res.PD.drt(a,1,2);
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   av(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,1)),mean(res.PD.v(a,1:2,2)));
   cv(n,1)=wjn_pct_change(mean(res.PD.v(a,2,1)),mean(res.PD.v(a,2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   dlmv(n,1) = wjn_pct_change(res.PD.rgmv(a,2)-res.PD.rrmv(a,2),res.PD.rgmv(a,1)-res.PD.rrmv(a,1));
      rt(n,1)=wjn_pct_change(res.PD.rt(a,2,1),res.PD.rt(a,2,2));
   drt(n,1)=wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
   dv(n,1)=wjn_pct_change(res.PD.dv(a,1,1),res.PD.dv(a,1,2));
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,2)),mean(res.PD.v(a,1:2,1)));
   sfiles{n,1} = ['smni_sROI_' num2str(a) '_struc_seed.nii'];
   ffiles{n,1} = ['nmni_sROI_' num2str(a) '_func_seed_AvgR.nii'];
end

% wjn_nii_corr(ffiles,[drt,sv,du],{'drt','sv','du'})
% wjn_nii_corr_loom(ffiles,'r_drt.nii',drt)
% p=wjn_nii_corr_cluster_correction(sfiles,drt,'csdrt',1000);
tic
% wjn_nii_corr(sfiles,drt,'nnndrt',1,1,0)
wjn_nii_corr(sfiles,sv,'nnnsv',1,1,0)
toc
%% parcellate correlation outcome
% m=wjn_mask_nii('r_sdrt.nii',fullfile(leadp,'sensorimotor.nii'));
% p=wjn_mask_nii('p_sdrt.nii',fullfile(leadp,'sensorimotor.nii'));
m = wjn_read_nii('r_nndrt.nii');
p = wjn_read_nii('p_nndrt.nii');
ps = p.img(:);
ps(ps==0) = nan;
p.img(:) = ps;
ea_write_nii(p)
[L,num]=bwlabeln(p.img<=.05,26);

p.img(:)=L;
p.fname =['clusters_' p.fname];
ea_write_nii(p)

for a = 1:num
    cs(a) = numel(find(L==a));
end

[~,i]=max(cs);

p.img(:) = nan;
p.img(L==i)=1;
p.fname = ['max_' p.fname];
ea_write_nii(p)




%% smooth correlation heatmap
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../results.mat res  
close all
;
%%

sfiles =ffind('rp_sdrt_*.nii');
ow = wjn_nii_cluster_weight('rp_odrt.nii');
for a = 1:length(sfiles)
    w(a) = wjn_nii_cluster_weight(sfiles{a});
    if w(a)>1000
        disp(a)
    end
end
%%
wjn_nii_cluster_threshold('rp_prt.nii',0,100)
% spm_smooth(fullfile(leadp,'sensorimotor.nii'),'sroi.nii',[16 16 16])
spm_imcalc(fullfile(leadp,'sensorimotor.nii'),'roi_sm.nii','i1>0.2',o)
spm_imcalc(fullfile(leadp,'sensorimotor.nii'),'eroi_sm.nii','i1>0.22',o)
spm_imcalc('eroi_sm.nii','nroi_sm.nii','i1.*-1',o);
% spm_imcalc({'p_cdrt.nii','roi_sm.nii'},'mp_cdrt.nii','(i1<=0.05).*(i2<0.001)')
% spm_smooth('r_nndrt.nii','sr_nndrt.nii',[2 2 2])
% spm_imcalc('p_nndrt.nii','mp_nndrt.nii','i1<=.05')
wjn_mask_nii('cr_nndrt.nii','eroi_sm.nii',0)
% wjn_nii_overlay('roi_sm.nii')
% wjn_mask_nii('mr_cdrt.nii','')
%% create patient connectome

root = fullfile(mdf,'visuomotor_tracking_ANA','Matlab Export','fiber_tracking');
cd(root);
lead16
load ../results.mat
ids = [];
fibers = [];
idx = [];
fc={};
for a = res.images
    f=load(['ffibers_' num2str(a) '.mat']);
    ids=[ids;f.ids];
    idx = [idx,f.idx];
    fibers = [fibers;f.fibers];
    fc = [fc;f.fc];
end

f.fc=fc;
f.fibers = fibers;
f.ids = ids;
f.idx = idx;
save('patient_connectome','-struct','f')
wjn_ftr2trk('patient_connectome')



%% cluster permutation

clear 
load ../results res
files = res.PD.sfiles;
v = res.PD.prt(res.PD.images);
vname = 'test.nii';

tic
    [p,L,csize,n]=wjn_nii_corr_cluster_correction(files,v,vname,5000,'s');
toc

save cluster_permutation_localisation

%% mask the structural images
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)

load ../results.mat res
    
for a = 1:length(res.PD.sfiles)
    sresfiles{a} = ['s' res.PD.sfiles{a}];
    
    spm_smooth(res.PD.sfiles{a},sresfiles{a},[2 2 2],16);
    
    msresfiles{a} = ['ms' res.PD.sfiles{a}];
    
    spm_imcalc({sresfiles{a},fullfile(leadp,'sensorimotor.nii')},msresfiles{a},'i1.*(i2>0.001)');
    
    mresfiles{a} = ['m' res.PD.sfiles{a}];
    
    spm_imcalc({res.PD.sfiles{a},fullfile(leadp,'sensorimotor.nii')},mresfiles{a},'i1.*(i2>0.001)');
end
res.PD.sresfiles = sresfiles;
res.PD.msresfiles = msresfiles;
res.PD.mresfiles = mresfiles';
save ../results.mat res
%% spatial correlation with strongest response or correlation matrix

clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)

load ../results.mat res
    
prt = res.PD.prt(res.PD.images);
[m,i] = max(prt);
files = res.PD.msresfiles;
% m = wjn_read_nii(fullfile(leadp,'sensorimotor.nii'));
% mi = find(m.img(:));
o = wjn_read_nii(files{i});
o = o.img(:);
rm = [];
for a = 1:length(prt)
    nii=wjn_read_nii(files{a});
    rm(a,:) = double(nii.img(:));
end
 rs = corr(rm,prt,'rows','pairwise','type','spearman');

 nii.img(:) = rs;
 nii.fname = 'sensorimotor_pearson_r_values.nii';
 ea_write_nii(nii)
for a = 1:length(prt)
    nii=wjn_read_nii(files{a});
    [rim(a,1),p(a)] = corr(double(o),double(nii.img(:)),'rows','pairwise','type','spearman');
    [ris(a,1),p(a)] = corr(rs,double(nii.img(:)),'rows','pairwise','type','spearman');
end
figure
subplot(2,1,1)
[r,p]=wjn_corr_plot(rim,prt,'r','pearson');
subplot(2,1,2)
[r,p]=wjn_corr_plot(ris,prt,'r','pearson')


res.PD.ris =ris;
res.PD.rim = rim;
% save ../results.mat res
% res.PD.correlations.spatial.r = r;
% res.PD.correlations.spatial.p = p;

