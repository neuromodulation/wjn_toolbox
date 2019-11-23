% lead16
close all
spm eeg
clear

root = wjn_rsmeg_list('root');
cd(root)

fmrilist = [ 5, 17, 29, 35, 36, 40, 42, 43, 44]-2;
meglist =43;% [25 26 33 34 37 38 40 41 42 43];% 30 35 

runlist = [meglist fmrilist];


runmeg = [ones(size(meglist)) zeros(size(fmrilist))];
runfmri = ~runmeg;

p = wjn_rsmeg_list;
runmeg = 0;
runfmri = 1;
n=0;
for a = runlist
    n=n+1;
    if runmeg(n)
%     try  
        chk(n)=wjn_rsmeg_prepare_megfile(p(a));
        if chk(n)
            wjn_rsmeg_create_coh_map(p(a));
            wjn_rsmeg_create_average_cohmaps(p(a))
            chk=wjn_rsmeg_extract_lfp_source_activity(p(a));
        end
        disp(chk)
%     catch
%         warning(['N ' num2str(a) ' MEG module crashed!'])
%         keyboard
        cd(root)
%         notrun(n) = 1;
%         save notrun_wjn notrun
%     end
    end
    if runfmri(n)
        if ~isempty([p{a}.coords_right ; p{a}.coords_left])
            wjn_rsmeg_create_rois(p(a));
%             wjn_rsmeg_create_fmri_map(p(a));
            wjn_rsmeg_create_mri_map(p(a));
        end
    end
end
%
%     try
%         wjn_rsmeg_create_rscoh_maps(p(a))
%         nrun(a,6) =1;
%     catch
%         warning(['N ' num2str(a) ' MEGxfMRI module crashed!'])
%     end


% 
% beta = ea_load_nii('con_0003.nii');
% rs = ea_load_nii('STN_func_seed_AvgR.nii');
% 
% 
% wjn_mask_nii(beta.fname,'gm.nii',0.001)
% 
% wjn_mask_nii(rs.fname,'gm.nii',0.001)
% 
% 
% beta = ea_load_nii('mcon_0003.nii');
% rs = ea_load_nii('mSTN_func_seed_AvgR.nii');
% b= beta.img(:);
% r = rs.img(:);
% inan = unique([find(b==0);find(r==0)]);
% 
% b(inan) = [];
% r(inan) = [];
% 
% % b=wjn_gaussianize(b);
% % r=wjn_gaussianize(r);
% figure
% scatter(b,r)
% 
% spm_imcalc({'con_0003.nii','STN_func_seed_AvgR.nii'},'multiplied.nii','i1.*i2')
