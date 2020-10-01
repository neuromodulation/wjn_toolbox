function cname=wjn_spherical_roi(fname,mni,r,template)

if ~exist('template','var')
    
    Vol=ea_load_nii(fullfile(spm('dir'),'canonical','single_subj_T1.nii'));
    nii=Vol.img;
    nii(:)=nan;
    voxmm = Vol.voxsize;
    for a=1:size(mni,1)
        X= mni(a,1); Y = mni(a,2); Z = mni(a,3);
        XYZ=[X,Y,Z,ones(length(X),1)]';
        XYZ=Vol.mat\XYZ; % to voxel space.
        XYZ=(XYZ(1:3,:)');
        
        xe = XYZ(1)-round(2*r/voxmm(1)):XYZ(1)+round(2*r/voxmm(1));
        ye = XYZ(2)-round(2*r/voxmm(2)):XYZ(2)+round(2*r/voxmm(2));
        ze = XYZ(3)-round(2*r/voxmm(3)):XYZ(3)+round(2*r/voxmm(3));
        
        
        [xx yy zz] = meshgrid(1:length(xe),1:length(ye),1:length(ze));
        S = round(sqrt((xx-2*r/voxmm(1)).^2+(yy-2*r/voxmm(2)).^2+(zz-2*r/voxmm(3)).^2)<=r/voxmm(1));
        xix=squeeze(xx(1,:,1)+round(XYZ(1)-2*r/voxmm(1)));
        yiy=squeeze(yy(:,1,1)+round(XYZ(2)-2*r/voxmm(1)));
        ziz=squeeze(zz(1,1,:)+round(XYZ(3)-2*r/voxmm(1)));
        nii(xix,yiy,ziz)=S;
    end
    nii(nii~=1)=0;
    nii=nii(1:Vol.dim(1),1:Vol.dim(2),1:Vol.dim(3));
    Vol.dt =[16,0];
    [fdir,fname]=fileparts(fname);
    Vol.fname=fullfile(fdir,[fname '.nii']);
    spm_write_vol(Vol,nii);
    


else
    Vol=ea_load_nii(template);
    nii=Vol.img;
    nii(:)=nan;
    voxmm = Vol.voxsize;
    for a=1:size(mni,1)
        X= mni(a,1); Y = mni(a,2); Z = mni(a,3);
        XYZ=[X,Y,Z,ones(length(X),1)]';
        XYZ=Vol.mat\XYZ; % to voxel space.
        XYZ=(XYZ(1:3,:)');
        
        xe = XYZ(1)-round(2*r/voxmm(1)):XYZ(1)+round(2*r/voxmm(1));
        ye = XYZ(2)-round(2*r/voxmm(2)):XYZ(2)+round(2*r/voxmm(2));
        ze = XYZ(3)-round(2*r/voxmm(3)):XYZ(3)+round(2*r/voxmm(3));
        
        
        [xx yy zz] = meshgrid(1:length(xe),1:length(ye),1:length(ze));
        S = round(sqrt((xx-2*r/voxmm(1)).^2+(yy-2*r/voxmm(2)).^2+(zz-2*r/voxmm(3)).^2)<=r/voxmm(1));
        xix=squeeze(xx(1,:,1)+round(XYZ(1)-2*r/voxmm(1)));
        yiy=squeeze(yy(:,1,1)+round(XYZ(2)-2*r/voxmm(1)));
        ziz=squeeze(zz(1,1,:)+round(XYZ(3)-2*r/voxmm(1)));
        try
            nii(xix,yiy,ziz)=S;
        catch
            nii(xix(2:end),yiy,ziz)=S(2:end,:,:);
        end
    end
    nii(isnan(nii))=0;
    nii(nii<0.01)=0;
    Vol.dt =[16,0];
    [fdir,fname]=fileparts(fname);
    Vol.fname=fullfile(fdir,[fname '.nii']);
    spm_write_vol(Vol,nii(1:Vol.dim(1),1:Vol.dim(2),1:Vol.dim(3)));
end



% keyboard




% matlabbatch{1}.spm.spatial.smooth.data = {Vol.fname};
% matlabbatch{1}.spm.spatial.smooth.fwhm = [1 1 1];
% matlabbatch{1}.spm.spatial.smooth.dtype = 0;
% matlabbatch{1}.spm.spatial.smooth.im = 1;
% matlabbatch{1}.spm.spatial.smooth.prefix = 's';
% jobs{1}=matlabbatch;
% spm_jobman('run',jobs);
% clear jobs matlabbatch
%
% delete(Vol.fname)

%
% cname=wjn_convert2mni_voxel_space(fullfile(fdir,['s' fname '.nii']));
% spm_imcalc(cname,cname,'i1>0.0001')
cname=fullfile(fdir,[fname '.nii'])
% ea_crop_nii(cname)
%
% delete(fullfile(fdir,['s' fname '.nii']))
% delete(fullfile(fdir,[fname '.nii']));

% cfile = cname;
% if exist('mask','var')
%     if strcmp(mask,'GPi')
%         mask = fullfile(leadt,'cmni_GPi.nii');
%             elseif strcmp(mask,'GPe')
%         mask = fullfile(leadt,'cmni_GPe.nii');
%     elseif strcmp(mask,'GP')
%         mask = fullfile(leadt,'cmni_GP.nii');
%     elseif strcmp(mask,'STN')
%         mask = fullfile(leadt,'cmni_STN.nii');
%     end
% [maskdir,maskfile,ext]=fileparts(mask);
% spm_imcalc({cname,fullfile(maskdir,[maskfile,ext])},['m_' cname],'(i2>0).*i1');
% cfile = ['m_' cname];
% end
% wjn_extract_surface(cname);

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