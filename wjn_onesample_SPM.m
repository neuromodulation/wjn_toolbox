
function [mcon,mers,merd]=wjn_onesample_SPM(files,name,channels,conds,timewin,freqwin,mc,thresh,ext)

spm('eeg','defaults')
D=spm_eeg_load(files{1});

root = cd;
if ~exist('timewin','var') || isempty(timewin)
    timewin = [-Inf Inf];
elseif sum(abs(timewin))<500
    timewin = timewin*1000;
end

if ~exist('freqwin','var') || isempty(freqwin)
    freqwin = [-Inf Inf];
end


for a = 1:length(files)
    wjn_convert2images(fullfile(root,files{a}),conds,channels,timewin,freqwin);
end
%%
clear mers merd mcon
for a = 1:length(conds)

 
imagefolder = fullfile(root,['images_' conds{a}]);
    cd(imagefolder);
    for b = 1:length(channels)
        modelfolder = fullfile(root,name,conds{a},channels{b});
    

        images = ffind([channels{b} '_' conds{a} '*.nii']);
        matlabbatch = [];
        matlabbatch{1}.spm.stats.factorial_design.dir = {modelfolder};
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = images;
        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
        spm_jobman('run',matlabbatch)
        matlabbatch=[];
        matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(modelfolder,'SPM.mat')};
        matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
        matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'ERS';
        matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = 1;
        matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = 'ERD';
        matlabbatch{2}.spm.stats.con.consess{2}.tcon.weights = -1;
        matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        matlabbatch{2}.spm.stats.con.consess{3}.fcon.name = 'ERS-ERD';
        matlabbatch{2}.spm.stats.con.consess{3}.fcon.weights = [1
                                                                -1];
        matlabbatch{2}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
        matlabbatch{2}.spm.stats.con.delete = 1;
        spm_jobman('run',matlabbatch)
        

        for c = 1:3;
        matlabbatch=[];
        matlabbatch{1}.spm.stats.results.spmmat(1) =  {fullfile(modelfolder,'SPM.mat')};
        matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
        matlabbatch{1}.spm.stats.results.conspec.contrasts = c;
        matlabbatch{1}.spm.stats.results.conspec.threshdesc = mc;
        matlabbatch{1}.spm.stats.results.conspec.thresh = thresh;
        matlabbatch{1}.spm.stats.results.conspec.extent = ext;
        matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
        matlabbatch{1}.spm.stats.results.units = 4;
        matlabbatch{1}.spm.stats.results.print = false;
        matlabbatch{1}.spm.stats.results.write.tspm.basename = 'filter';
        spm_jobman('run',matlabbatch)
        end
        
        ers = fullfile(modelfolder,['spmT_0001_filter.nii']);
        ers = spm_vol_nifti(ers);
        ers= spm_read_vols(ers);
        mers(a,b,:,:) = ers;
        erd = fullfile(modelfolder,['spmT_0002_filter.nii']);
        erd = spm_vol_nifti(erd);
        erd= spm_read_vols(erd);
        merd(a,b,:,:) = erd;
        
        cd(imagefolder)
        grandmean = fullfile(imagefolder,['grandmean_' channels{b} '_' conds{a} '.nii']);
        wjn_image_averager(images,grandmean)
        con = grandmean;
        con = spm_vol_nifti(con);
        mcon(a,b,:,:)= spm_read_vols(con);
        
        
    
    end
end

%%
% keyboard
t=D.time(sc(D.time,timewin(1)/1000):sc(D.time,timewin(2)/1000));
f = D.frequencies(sc(D.frequencies,freqwin(1)):sc(D.frequencies,freqwin(2)));

cd(root)
figure
n=0;
cmax = squeeze(max(max(max(prctile(mcon,50)))));
cmin = squeeze(min(min(min(prctile(mcon,50)))));
for a = 1:length(conds)
    for b = 1:length(channels)
n=n+1;
           subplot(length(channels),length(conds),n)   
imagesc(t,f,squeeze(mcon(a,b,:,:)));
        hold on
        axis xy
        contour(t,f,squeeze(mers(a,b,:,:))>1,1,'color','k')
        contour(t,f,squeeze(merd(a,b,:,:))>1,1,'color','k')
        
        title([conds{a} ' ' channels{b}])
        xlabel('Time [s]')
        ylabel('Frequency [Hz]')
        colorbar
        caxis([cmin cmax])
    end
end
figone(7*length(channels),10*length(conds))
% myprint(fullfile(modelfolder,['TF_contour_' name '.png']))

%%
cd(root)
figure
n=0;

for a = 1:length(conds)
    for b = 1:length(channels)
n=n+1;
           subplot(length(channels),length(conds),n)   
imagesc(t,f,squeeze(mcon(a,b,:,:)));
        hold on
        axis xy
%         contour(t,f,squeeze(mers(a,b,:,:))>1,1,'color','k')
%         contour(t,f,squeeze(merd(a,b,:,:))>1,1,'color','k')
        
        title([conds{a} ' ' channels{b}])
        xlabel('Time [s]')
        ylabel('Frequency [Hz]')
        colorbar
        caxis([cmin cmax])
    end
end
figone(7*length(channels),10*length(conds))
myprint(fullfile(modelfolder,['TF_' name '.png']))
%%
cd(root)
figure
n=0;
cmax = squeeze(max(max(prctile(mcon,95))));
cmin = squeeze(min(min(prctile(mcon,95))));
cc = colorlover(6);
cc = [cc(5,:);1,1,1;cc(4,:)];
colormap('default')
for a = 1:length(conds)
    for b = 1:length(channels)
n=n+1;
           subplot(length(channels),length(conds),n)   

        hold on
        axis xy
        cont = zeros(size(squeeze(mers(a,b,:,:))));
        cont(squeeze(mers(a,b,:,:))>1)=1;
        cont(squeeze(merd(a,b,:,:))>1)=-1;
        imagesc(t,f,cont)
        xlim([t(1) t(end)])
        ylim([f(1) f(end)])
        
        title([conds{a} ' ' channels{b}])
        xlabel('Time [s]')
        ylabel('Frequency [Hz]')
        colorbar
        caxis([-1 1])
    end
end
figone(7*length(channels),10*length(conds))
myprint(fullfile(modelfolder,['TF_' name '.png']))

%%

save(fullfile(root,name,[name '.mat']))



