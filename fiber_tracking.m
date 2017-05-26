clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)

load ../final_results_16-03-2017.mat res
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

load final_results_16-03-2017.mat res
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

load final_results_16-03-2017.mat res
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




%% fiber counts
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
files = ffind('new_fibers_*.mat');
for a  =1:length(files)
    wjn_fiber_parcellation(files{a})
end

%% resting state connectivity
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
%% plot parcellated fibers separately for one patient

clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
cc=colorlover(5);

c=load('count_fibers_19.mat');
f=load('fibers_19.mat');
% ls = {'--','-.','-','--','-.'};
labels = {'motor'};
close all
figure
for a = 1:length(labels)
    i=c.(labels{a}).id;
    for b=1:length(i)
            h(a)=plot3(f.fc{i(b)}(:,1),f.fc{i(b)}(:,2),f.fc{i(b)}(:,3),'color',cc(a,:));
        hold on
    end
end

legend([h(1),h(2),h(3),h(4),h(5)],labels)


%% correlate number of premotor fibers with behavioral results
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../final_results_16-03-2017.mat res
s = [1:10,12:20];
%
close all
clear dv drt rt fs
n=0;
for a=s
    n=n+1;
    de(n,1)=wjn_pct_change(res.PD.dMERR(a,1,1),res.PD.dMERR(a,1,2))
   rt(n,1)=wjn_pct_change(res.PD.rt(a,2,1),res.PD.rt(a,2,2))
   drt(n,1)=wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
   dv(n,1)=wjn_pct_change(res.PD.dv(a,1,1),res.PD.dv(a,1,2));
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,1)),mean(res.PD.dmv(a,1:2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   fm=load(['motor_fibers_' num2str(a)]);
   fp=load(['premotor_fibers_' num2str(a)]);
%    sp(n,1) = numel(find(~ismember(fp.premotor.id,fm.motor.id)));
   fs(n,1)=fm.motor.n%+fp.premotor.n;
%     fs(n,1)=fp.premotor.n;
   
end
%
figure
wjn_corr_plot(fs,drt,[.5 .5 .5])
xlim([0 2500])
ylim([-100 300])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')

figure
wjn_corr_plot(fs,de,[.5 .5 .5])
xlim([0 2500])
% ylim([-50 200])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')

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
    pm = load(['premotor_fibers_' num2str(a)]);
    m = load(['motor_fibers_' num2str(a)]);
    n = pm.premotor.n+m.motor.n;
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
%% parcellate with these niftis

files = ffind('fibers_*.mat');
for a = 1:length(files),wjn_fiber_parcellation(files{a},'new_motor'),end
for a = 1:length(files),wjn_fiber_parcellation(files{a},'new_premotor'),end

files = ffind('fibers_*.mat');
for a = 1:length(files),wjn_fiber_parcellation(files{a},'SMA'),end
for a = 1:length(files),wjn_fiber_parcellation(files{a},'M1'),end

files = ffind('new_fibers_*.mat');
for a = 1:length(files),wjn_fiber_parcellation(files{a},'holomotor'),end

%% new parcellation correlate number of premotor fibers with behavioral results
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../final_results_16-03-2017.mat res  
close all
s = [1:10,12:20];
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
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,1)),mean(res.PD.dmv(a,1:2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   fm=load(['new_new_fibers_' num2str(a)]);
%    fp=load(['motor_fibers_' num2str(a)]);
%    sp(n,1) = numel(find(~ismember(fp.premotor.id,fm.motor.id)));
%    fs(n,1)=fm.premotor.n+fm.motor.n;
    fs(n,1)=fm.motor.n;
    
%     fs(n,1) = fm.holomotor.n;
   
end
%
figure
% subplot(1,3,1)
cc=colorlover(5);
wjn_corr_plot(fs,drt,cc(1,:))
for a =1:length(fs)
    text(fs(a),drt(a),num2str(a));
end
xlim([0 3500])
ylim([-150 300])
xlabel('Number of connecting fibers to motor and premotor regions')
ylabel('\Delta CON-AUT ON and OFF difference [%]')
% myprint('RT_FIBER_CORRELATION')


%% 
subplot(1,3,2)
wjn_corr_plot(fs,de,[.5 .5 .5])
xlim([0 2500])
% ylim([-50 200])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')


subplot(1,3,3)
wjn_corr_plot(fs,dv,[.5 .5 .5])
xlim([0 2500])
% ylim([-50 200])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')

%% new parcellation correlate resting state connectivity
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../final_results_16-03-2017.mat res  
%%
close all
s = [1:10,12:20];
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
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,1)),mean(res.PD.dmv(a,1:2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));
   fm=load(['parc_rs_' num2str(a)]);
%    fp=load(['motor_fibers_' num2str(a)]);
%    sp(n,1) = numel(find(~ismember(fp.premotor.id,fm.motor.id)));
%    fs(n,1)=fm.premotor.n+fm.motor.n;
    fs(n,1)=fm.SMA;
    
%     fs(n,1) = fm.holomotor.n;
   
end
%
figure
% subplot(1,3,1)
cc=colorlover(5);
wjn_corr_plot(fs,ddrt,cc(1,:))
for a =1:length(fs)
    text(fs(a),dv(a),num2str(a));
end
xlim([0 .5])
ylim([-150 300])
xlabel('Functional connectivity')
ylabel('\Delta CON-AUT ON and OFF difference [%]')
% myprint('RT_FIBER_CORRELATION')


%% 
subplot(1,3,2)
wjn_corr_plot(fs,de,[.5 .5 .5])
xlim([0 2500])
% ylim([-50 200])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')


subplot(1,3,3)
wjn_corr_plot(fs,dv,[.5 .5 .5])
xlim([0 2500])
% ylim([-50 200])
xlabel('Number of connecting fibers to premotor region')
ylabel('Percentage ON and OFF difference')


%% show examples
[~,i]=sort(drt);
ns = [i(1) i(end)];

%% run spm correlation
clear 
lead16
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export','fiber_tracking');
cd(root)
load ../final_results_16-03-2017.mat res 

close all
s = [1:10,12:20];
clear dv drt rt fs matlabbatch
n=0;
for a=s
    n=n+1;
    de(n,1)=wjn_pct_change(res.PD.dMERR(a,1,1),res.PD.dMERR(a,1,2));
   rt(n,1)=wjn_pct_change(mean(res.PD.rt(a,2,1)),mean(res.PD.rt(a,2,2)));
   drt(n,1)=wjn_pct_change(res.PD.drt(a,1,1),res.PD.drt(a,1,2));
   ddrt(n,1) = res.PD.drt(a,1,1)-res.PD.drt(a,1,2);
   dv(n,1)=wjn_pct_change(res.PD.dv(a,1,1),res.PD.dv(a,1,2));
   dmv(n,1)=wjn_pct_change(res.PD.dmv(a,1,1),res.PD.dmv(a,1,2));
   sv(n,1)=wjn_pct_change(mean(res.PD.v(a,1:2,1)),mean(res.PD.dmv(a,1:2,2)));
   du(n,1)=wjn_pct_change(res.PD.updrs(a,1),res.PD.updrs(a,2));  
   matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans{n,1} = ['nmni_sROI_' num2str(a) '_struc_seed.nii'] ;
end

matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\Users\User\Dropbox\Motorneuroscience\visuomotor_tracking_ANA\MatLab Export\fiber_tracking\structural_spm'};
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.c = drt;
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'drt';
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat = {'C:\Users\User\Dropbox\Motorneuroscience\visuomotor_tracking_ANA\MatLab Export\fiber_tracking\structural_spm\SPM.mat'};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch)
