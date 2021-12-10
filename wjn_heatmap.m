function wjn_heatmap(fname,mni,v,template,smoothingkernel)
%% function wjn_heatmap(fname,mni,v,template)

%[~,leadt]=leadf;

inan = [find(isnan(v));find(isnan(mni(:,1)))];
if ~isempty(inan)
    mni(inan,:) = [];
    v(inan) = [];
end

side = 1;
X{1} = mni(:,1); Y{1} = mni(:,2); Z{1} = mni(:,3); V{1} = v;
XYZ=[X{side},Y{side},Z{side},ones(length(X{side}),1)]';
% Vol=spm_vol(fullfile(leadt,'bb.nii')); %% Was ist bb.nii
% if ~exist('template','var')
% Vol=spm_vol(fullfile(,'t2.nii')); %% Was ist bb.nii
% else
    Vol=spm_vol(template);
% end
nii{side}=spm_read_vols(Vol);
nii{side}(:)=nan;
XYZ=[X{side},Y{side},Z{side},ones(length(X{side}),1)]';
XYZ=Vol.mat\XYZ; % to voxel space.
XYZ=(XYZ(1:3,:)');
clear bb
increase_size=0;
bb(1,:)=[round(min(XYZ(:,1)))-round(increase_size/2),round(max(XYZ(:,1)))+round(increase_size/2)];
bb(2,:)=[round(min(XYZ(:,2)))-round(increase_size*2),round(max(XYZ(:,2)))+round(increase_size*2)];
bb(3,:)=[round(min(XYZ(:,3)))-increase_size,round(max(XYZ(:,3)))+increase_size];

InterpolationMethod = 'linear'; % linear is default, but nearest or natural neighbour maybe better non-linear alternatives
ExtrapolationMethod = 'none'; % only turn on if you know why
F = scatteredInterpolant(XYZ(:,1),XYZ(:,2),XYZ(:,3),double(V{side}),InterpolationMethod,ExtrapolationMethod);
xix{side}=bb(1,1):bb(1,2); yix{side}=bb(2,1):bb(2,2); zix{side}=bb(3,1):bb(3,2);
nii{side}(xix{side},yix{side},zix{side})=F({xix{side},yix{side},zix{side}});


Vol.dt =[16,0];
Vol.fname=fname;
spm_write_vol(Vol,nii{1});

% wjn_crop_nii(fname);

if ~exist('smoothingkernel','var')
    smoothingkernel=[6 6 6];
end
matlabbatch{1}.spm.spatial.smooth.data = {Vol.fname};
matlabbatch{1}.spm.spatial.smooth.fwhm = smoothingkernel;
matlabbatch{1}.spm.spatial.smooth.dtype = 16;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
jobs{1}=matlabbatch;
spm_jobman('run',jobs);
clear jobs matlabbatch

% cname=wjn_convert2mni_voxel_space(['s' Vol.fname]);
% cfile = cname;
cfile = ['s' fname];
cname = cfile;


nii = wjn_read_nii(cfile);
nii.fname = ['z_' nii.fname];
nii.img(isnan(nii.img))=0;
ea_write_nii(nii)

% wjn_extract_surface(cfile);

% % Beta
% clear
% load mni mni v
% 
% v= v(:,2);
% v(v>100)=[];
% inan = isnan(v);
% mni(inan,:) = [];
% mni(:,1) = -1.*mni(:,1);
% v(inan) = [];
% side = 1;
% X{1} = mni(:,1); Y{1} = mni(:,2); Z{1} = mni(:,3); V{1} = v;
% XYZ=[X{side},Y{side},Z{side},ones(length(X{side}),1)]';
% Vol=spm_vol(['E:\Dropbox\lead\','templates',filesep,'bb.nii']); %% Was ist bb.nii
% nii{side}=spm_read_vols(Vol);
% nii{side}(:)=nan;
% XYZ=[X{side},Y{side},Z{side},ones(length(X{side}),1)]';
% XYZ=Vol.mat\XYZ; % to voxel space.
% XYZ=(XYZ(1:3,:)');
% clear bb
% increase_size=0;
% bb(1,:)=[round(min(XYZ(:,1)))-round(increase_size/2),round(max(XYZ(:,1)))+round(increase_size/2)];
% bb(2,:)=[round(min(XYZ(:,2)))-round(increase_size*2),round(max(XYZ(:,2)))+round(increase_size*2)];
% bb(3,:)=[round(min(XYZ(:,3)))-increase_size,round(max(XYZ(:,3)))+increase_size];
% 
% F = scatteredInterpolant(XYZ(:,1),XYZ(:,2),XYZ(:,3),double(V{side}));
% 
% F.ExtrapolationMethod='none';
% xix{side}=bb(1,1):bb(1,2); yix{side}=bb(2,1):bb(2,2); zix{side}=bb(3,1):bb(3,2);
% nii{side}(xix{side},yix{side},zix{side})=F({xix{side},yix{side},zix{side}});
% 
% 
% Vol.fname=['beta.nii'];
% spm_write_vol(Vol,nii{1});
% matlabbatch{1}.spm.spatial.smooth.data = {Vol.fname};
% matlabbatch{1}.spm.spatial.smooth.fwhm = [1.3 1.3 1.3];
% matlabbatch{1}.spm.spatial.smooth.dtype = 0;
% matlabbatch{1}.spm.spatial.smooth.im = 1;
% matlabbatch{1}.spm.spatial.smooth.prefix = 's';
% jobs{1}=matlabbatch;
% spm_jobman('run',jobs);
% clear jobs matlabbatch
% [mask,maskdir]=ffind(fullfile(mdf(2),'lead','templates','*gpi*.nii'),0);
% spm_imcalc({['s' Vol.fname],fullfile(maskdir,mask)},'beta_masked.nii','(i2>0).*i1');
% %
% [mni_i,mni_dir]=ffind(fullfile(mdf(2),'lead','templates','mni_hires_t1.nii'),0)
% global st
% % spm_check_registration('new_gpi_mask.nii',fullfile(maskdir,mask));
% spm_check_registration(fullfile(mni_dir,mni_i),'sbeta.nii');
% 
% %%
% cc=colorlover(7,0);
% cc(1,:) = cc(1,:);
% cc(2,:) = cc(4,:);
% load mni
% t_mni_max = [21.80 -6.46 -4.10];
% b_mni_max = [20.00 -7.78 -8.72];
% clear bd td tv d
% for a = 1:length(mni);
%     tv(a,1) = v(a,1);
%     bv(a,1) = v(a,2);
%     td(a,1) = wjn_distance(mni(a,:),t_mni_max);
%     bd(a,1) = wjn_distance(mni(a,:),b_mni_max);
% end
% 
% 
% figure
% subplot(1,2,1);
% title('theta')
% [br,bp]=wjn_corr_plot(tv,td,cc(1,:));
% 
% subplot(1,2,2);
% title('beta')
% [tr,tp]=wjn_corr_plot(bv,bd,cc(2,:));
% 
% [r,p]=corr(bv,bd,'type','spearman','rows','pairwise')
% [r,p]=corr(tv,td,'type','spearman','rows','pairwise')
% 
% 
% 
%         