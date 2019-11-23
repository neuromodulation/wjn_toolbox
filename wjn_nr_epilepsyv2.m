
folder = 'E:\Dropbox (Personal)\Neuroradiology\Epilepsy\pipeline\';
fname='mprage.nii';
tpm = fullfile(spm('dir'),'\tpm\TPM.nii');
dtpm = fullfile(spm('dir'),'toolbox\cat12\templates_1.50mm\Template_1_IXI555_MNI152.nii');
stpm = fullfile(spm('dir'),'toolbox\cat12\templates_1.50mm\Template_0_IXI555_MNI152_GS.nii');
matlabbatch{1}.spm.tools.cat.estwrite.data = {fullfile(folder,fname)};
matlabbatch{1}.spm.tools.cat.estwrite.nproc = 4;
matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {tpm};
matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.cleanupstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.darteltpm = {dtpm};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shootingtpm = {stpm};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.regstr = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROI = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.jacobian.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [0 0];

% om = fullfile(folder,fname);
gm = fullfile(folder,'mri',['p1' fname]);
wm = fullfile(folder,'mri',['p2' fname]);
% mgm = fullfile(folder,'mri',['wm' fname]);


sk=10;

spm_smooth(fullfile(folder,'mri',['mwp1' fname]),fullfile(folder,'mri',['smwp1' fname]),[sk sk sk]);
spm_smooth(fullfile(folder,'mri',['mwp2' fname]),fullfile(folder,'mri',['smwp2' fname]),[sk sk sk]);

mgm = fullfile(folder,'mri',['smwp1' fname]);
mwm = fullfile(folder,'mri',['smwp2' fname]);

% mgm = ea_load_nii(mgm);
% oom = ea_load_nii(om);
mgm = ea_load_nii(mgm);
mwm = ea_load_nii(mwm);
dim = mgm;
dim.img = zeros(size(dim.img));
dzim = dim;
% sdim = dim;

tic
for a = 1:size(mgm.img,1)/2
    for b = 1:size(mgm.img,2)
        for c = 1:size(mgm.img,3)
            i = [a b c]';
            mni = round(wjn_cor2mni(i',mgm.mat));
            nmni = [-mni(1) mni(2:3)];
            vi = wjn_mni2cor(nmni,mgm.mat);          

                vx = [vi(1)];
                vy = [vi(2)];
                vz = [vi(3)];      
  
       
            dg1=mgm.img(a,b,c);
            dg2=mgm.img(vi(1),vi(2),vi(3));
            dw1=mwm.img(a,b,c);
            dw2=mwm.img(vi(1),vi(2),vi(3));
            dim.img(i(1),i(2),i(3))=(dg1-dg2);% +(dw2-dw1);
            dim.img(vi(1),vi(2),vi(3))=(dg2-dg1);%+ (dw1-dg2);

        end
    end
    disp(a)
end

dim.img(dim.img<0.05) = 0;

dim.dim = mgm.dim;
dim.fname = fullfile(folder,['nd' fname]);
ea_write_nii(dim)

toc
    

% 
% im = om.img;
% wm = nwm.img;
% gm = ngm.img;
% 
% 
% nim=om;
% nim.fname = fullfile(folder,['n' fname]);
% nim.img = gm.*im;
% nim.img(~isnan(nim.img))=wjn_zscore(nim.img(~isnan(nim.img)));
% ea_write_nii(nim)

